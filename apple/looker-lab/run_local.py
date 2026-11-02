#!/usr/bin/env python3
"""Run the DuckDB path and refresh data/expected_outputs from the SQL.

The CSVs in data/ stay at the open-queue state. Step 9 is applied only
inside the database, and its results land in data/expected_outputs/after_fix.
"""

from __future__ import annotations

import shutil
from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "data" / "expected_outputs"
AFTER = OUT / "after_fix"
DB = Path("/tmp/lookerlab-scratch/lab.duckdb")


def run_file(con, name):
    sql = (ROOT / "sql" / name).read_text(encoding="utf-8")
    con.execute(sql)


def show(con, title, sql):
    print("\n==", title)
    rel = con.execute(sql)
    cols = [d[0] for d in rel.description]
    rows = rel.fetchall()
    print(" | ".join(cols))
    for row in rows:
        print(" | ".join("" if v is None else str(v) for v in row))
    return rows


def main():
    DB.parent.mkdir(parents=True, exist_ok=True)
    if DB.exists():
        DB.unlink()
    con = duckdb.connect(str(DB))
    con.execute(f"SET file_search_path = '{ROOT.as_posix()}'")
    # read_csv paths in the SQL are relative to the process cwd, not file_search_path.
    import os
    os.chdir(ROOT)

    for name in (
        "00_create_tables_duckdb.sql",
        "01_load_duckdb.sql",
        "02_quality_checks.sql",
        "03_metrics.sql",
        "05_export_expected.sql",
    ):
        print("running", name)
        run_file(con, name)

    held = Path("/tmp/lookerlab-scratch/before")
    if held.exists():
        shutil.rmtree(held)
    held.mkdir(parents=True)
    for csv in OUT.glob("*.csv"):
        shutil.copy(csv, held / csv.name)

    print("running 04_rls_and_fix.sql")
    run_file(con, "04_rls_and_fix.sql")
    run_file(con, "05_export_expected.sql")
    AFTER.mkdir(parents=True, exist_ok=True)
    for csv in OUT.glob("*.csv"):
        shutil.copy(csv, AFTER / csv.name)
    for csv in held.glob("*.csv"):
        shutil.copy(csv, OUT / csv.name)

    show(con, "GO/NO-GO", "SELECT * FROM check_go_nogo")
    show(con, "QUARANTINE", "SELECT * FROM check_quarantine_rows")
    show(con, "TRACKER VS FACT", "SELECT * FROM check_tracker_vs_fact")
    show(con, "DUP SERIALS", "SELECT * FROM check_duplicate_serials")
    show(con, "ORPHANS", "SELECT * FROM check_orphans")
    show(con, "SITE", "SELECT * FROM check_site_mismatch")
    show(con, "DATE", "SELECT * FROM check_date_logic")
    show(con, "REFERENTIAL", "SELECT * FROM check_referential")
    show(con, "RECON", "SELECT * FROM metric_reconciliation_by_program")
    show(con, "TRAPS", "SELECT definition, certified, numerator, denominator, rate FROM metric_reconciliation_traps")
    show(con, "FANOUT", "SELECT * FROM metric_fanout")
    show(con, "LINE 00018", "SELECT * FROM metric_fanout_line_00018")
    show(con, "PIS", "SELECT * FROM metric_missing_pis")
    show(con, "COMPLETENESS", "SELECT field_name, owner_id, person_name, denominator, filled, missing, completeness FROM metric_completeness")
    show(con, "REUSE TRAP", "SELECT * FROM metric_reuse_denominator_trap")
    show(con, "AGING", "SELECT * FROM metric_exception_aging")
    show(con, "FTR", "SELECT * FROM metric_first_time_right")
    show(con, "FTR ALL", "SELECT * FROM metric_first_time_right_all")
    show(con, "PERSON", "SELECT * FROM metric_person_dependent")
    show(con, "PERSON NO WINDOW", "SELECT * FROM metric_person_dependent_without_window")
    show(con, "RLS", "SELECT * FROM metric_rls_by_user")
    show(con, "JORDAN PACK", "SELECT * FROM metric_rls_jordan_pack")
    show(con, "SCORECARD before is on disk; DB is after fix", "SELECT * FROM metric_scorecard")
    show(con, "FIX PROOF", "SELECT * FROM metric_fix_proof")

    # Asserts against the BEFORE files, which were restored.
    import csv
    def load(name):
        with (OUT / name).open(encoding="utf-8") as f:
            return list(csv.DictReader(f))

    g = load("go_nogo.csv")[0]
    assert g["decision"] == "GO", g
    assert g["submitted_rows"] == "43"
    assert g["quarantined_rows"] == "2"
    assert g["distinct_po_lines_accepted"] == "40"
    assert g["missing_lines"] == "0"
    s = load("scorecard.csv")[0]
    assert s["lines_with_an_asset"] == "38"
    assert s["po_lines"] == "40"
    assert s["reconciliation_rate"] == "0.95"
    assert s["missing_pis"] == "12"
    assert s["first_time_right_rate"] == "0.525"
    assert s["aging_0_7"] == "7" and s["aging_8_30"] == "7" and s["aging_31_plus"] == "7"
    assert s["person_dependent_fields"] == "3"
    assert s["alert_fires"] in ("true", "True", "1")
    tv = load("tracker_vs_fact.csv")[0]
    assert tv["received_date_mismatches"] == "0", tv
    assert tv["linked_asset_mismatches"] == "0", tv
    assert tv["orphans_not_in_tracker"] == "1"
    after = load_path(AFTER / "scorecard.csv")
    assert after["missing_pis"] == "11", after
    assert after["reconciliation_rate"] == "0.95"
    assert after["first_time_right_rate"] == "0.525"
    assert after["aging_0_7"] == "6"
    proof = load_path(AFTER / "fix_proof_00017.csv")
    assert proof["placed_in_service_date"] == "2026-02-17"
    assert proof["passed_validation_on_first_entry"] == "0"
    assert proof["closed_date"] == "2026-03-16"
    before_proof = load("fix_proof_00017.csv")[0]
    assert before_proof["placed_in_service_date"] == ""
    assert before_proof["passed_validation_on_first_entry"] == "0"
    assert before_proof["closed_date"] == ""
    con.close()
    # Leave lab.duckdb on the open queue, matching expected_outputs, not after_fix.
    if DB.exists():
        DB.unlink()
    con = duckdb.connect(str(DB))
    for name in (
        "00_create_tables_duckdb.sql",
        "01_load_duckdb.sql",
        "02_quality_checks.sql",
        "03_metrics.sql",
    ):
        run_file(con, name)
    con.close()
    print("\nSQL asserts passed")
    print(f"open-queue database: {DB}")


def load_path(path):
    import csv
    with path.open(encoding="utf-8") as f:
        return list(csv.DictReader(f))[0]


if __name__ == "__main__":
    main()
