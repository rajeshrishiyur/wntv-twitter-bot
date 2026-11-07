#!/usr/bin/env python3
"""Deterministic CapEx data-integrity lab data.

Seeded, stdlib only. Running this file twice writes the same CSVs.
It does not apply the step-9 fix; that stays in sql/04_rls_and_fix.sql
so first-time-right can be shown not to recover.

As-of date for aging and the 90-day editor window: 2026-03-16.
"""

from __future__ import annotations

import csv
import random
from collections import defaultdict
from datetime import date, datetime, timedelta
from pathlib import Path

SEED = 20260316
AS_OF = date(2026, 3, 16)
WINDOW_DAYS = 90
random.seed(SEED)

ROOT = Path(__file__).resolve().parent
DATA = ROOT / "data"

MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

A_LINES = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
           18, 20, 22, 24, 26, 39}
MISSING_PIS = {6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17}
# Second entry of each duplicated serial. The first entry passed.
DUP_FAIL_LINES = {21, 22}
MISMATCH_LINES = {24, 25, 26}
DATE_LOGIC_LINE = 19
FANOUT_LINE = 18
IN_TRANSIT = {39, 40}
REUSE_LINES = set(range(27, 39))

PIS_OPENED = {
    17: date(2026, 3, 12),
    6: date(2026, 3, 10),
    7: date(2026, 3, 9),
    8: date(2026, 3, 1),
    9: date(2026, 2, 20),
    10: date(2026, 2, 16),
    11: date(2026, 2, 10),
    12: date(2026, 2, 5),
    13: date(2026, 1, 28),
    14: date(2026, 1, 20),
    15: date(2026, 3, 14),
    16: date(2026, 2, 25),
}

EQUIP = {
    "test_station": ("SUP-NORTH", "PO-55022", 12400, "CC-4100"),
    "handler": ("SUP-NORTH", "PO-55022", 8600, "CC-4100"),
    "instrument": ("SUP-HELIX", "PO-55023", 3100, "CC-4100"),
    "fixture": ("SUP-ATLAS", "PO-55021", 1800, "CC-4105"),
    "reused_fixture": ("SUP-ATLAS", "PO-55030", 0, "CC-4105"),
    "pack_cell": ("SUP-HELIX", "PO-56011", 15200, "CC-4200"),
}


def iso(d):
    return "" if d is None else d.isoformat()


def ts(d, hh=9, mm=0):
    return "" if d is None else f"{d.isoformat()} {hh:02d}:{mm:02d}:00"


def write_csv(path, fieldnames, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames, lineterminator="\n", extrasaction="ignore")
        w.writeheader()
        for row in rows:
            w.writerow({k: ("" if row.get(k) is None else row.get(k)) for k in fieldnames})


def fmt_date(d, style):
    if d is None:
        return ""
    if style == 0:
        return d.isoformat()
    if style == 1:
        return f"{d.month:02d}/{d.day:02d}/{d.year}"
    return f"{d.day:02d}-{MONTHS[d.month - 1]}-{d.year}"


def default_equip(n):
    return {1: "test_station", 2: "handler", 3: "instrument", 0: "fixture"}[n % 4]


def age_bucket(opened):
    age = (AS_OF - opened).days
    if age <= 7:
        return "0-7", age
    if age <= 30:
        return "8-30", age
    return "31+", age


def build_ts_lines():
    lines = []
    asset_seq = 0
    for n in range(1, 41):
        po_line_id = f"{n:05d}"
        if n in REUSE_LINES:
            equip = "reused_fixture"
        elif n == FANOUT_LINE:
            equip = "test_station"
        else:
            equip = default_equip(n)
        supplier, po_number, unit_cost, cost_center = EQUIP[equip]
        po_site = "CM-A" if n in A_LINES else "CM-B"
        qty = 2 if n == FANOUT_LINE else 1
        if n == 39:
            po_date = date(2026, 2, 20)
            received = None
        elif n == 40:
            po_date = date(2026, 2, 27)
            received = None
        elif n == 17:
            po_date = date(2026, 1, 20)
            received = date(2026, 2, 12)
        elif n == DATE_LOGIC_LINE:
            po_date = date(2026, 1, 22)
            received = date(2026, 2, 18)
        else:
            po_date = date(2026, 1, 6) + timedelta(days=(n * 2) % 21)
            received = date(2026, 2, 2) + timedelta(days=(n * 3) % 22)
        if received is not None and not (po_date < received):
            raise SystemExit(f"date order failed on {po_line_id}")

        if n == DATE_LOGIC_LINE:
            pis_default = date(2026, 2, 11)
        elif received is None or n in MISSING_PIS:
            pis_default = None
        else:
            pis_default = received + timedelta(days=5)

        n_assets = 0 if n in IN_TRANSIT else qty
        assets = []
        for k in range(n_assets):
            asset_seq += 1
            asset_id = f"AST-TS-{asset_seq:04d}"
            if n in (20, 21):
                serial = "SN-DUP-4421"
            elif n in (22, 23):
                serial = "SN-DUP-4422"
            else:
                serial = f"SN-TS-{asset_seq:04d}"
            if n == 24:
                asset_site = "CM-B"
                site_raw = "Site B"
            elif n == 25:
                asset_site = "CM-A"
                site_raw = "A"
            elif n == 26:
                asset_site = "PLANT-01"
                site_raw = "PLANT-01"
            else:
                asset_site = po_site
                site_raw = None
            reuse = f"AST-FR-{n - 26:04d}" if n in REUSE_LINES else ""
            ftr_fail = n in MISSING_PIS or n in DUP_FAIL_LINES or n in MISMATCH_LINES or n == DATE_LOGIC_LINE
            created_by = "usr_wei_cma" if n in A_LINES else "usr_jordan_cmb"
            owner = "OWN-CMA" if n in A_LINES else "OWN-CMB"
            created = (received + timedelta(days=1)) if received else po_date
            assets.append({
                "asset_id": asset_id,
                "serial_number": serial,
                "po_line_id": po_line_id,
                "site_id": asset_site,
                "site_raw_override": site_raw,
                "placed_in_service_date": pis_default,
                "cost_center": cost_center,
                "program_allocation": "TS-LINE-RAMP",
                "reuse_source_asset_id": reuse,
                "input_owner_id": owner,
                "created_by": created_by,
                "created_at": ts(created, 9, 15),
                "passed_validation_on_first_entry": 0 if ftr_fail else 1,
                "source_file": "A" if n in A_LINES else "B",
            })
        lines.append({
            "po_line_id": po_line_id,
            "po_number": po_number,
            "program_id": "TS-LINE-RAMP",
            "supplier_id": supplier,
            "site_id": po_site,
            "equipment_type": equip,
            "qty": qty,
            "unit_cost": unit_cost,
            "po_date": po_date,
            "received_date": received,
            "assets": assets,
            "source_file": "A" if n in A_LINES else "B",
        })
    asset_seq += 1
    orphan = {
        "asset_id": f"AST-TS-{asset_seq:04d}",
        "serial_number": "SN-TS-ORPHAN-9001",
        "po_line_id": "",
        "site_id": "CM-B",
        "site_raw_override": None,
        "placed_in_service_date": date(2026, 2, 20),
        "cost_center": "CC-4100",
        "program_allocation": "TS-LINE-RAMP",
        "reuse_source_asset_id": "",
        "input_owner_id": "OWN-GSM",
        "created_by": "usr_jordan_cmb",
        "created_at": ts(date(2026, 2, 21), 11, 4),
        "passed_validation_on_first_entry": 0,
        "source_file": "",
    }
    return lines, orphan


def build_other(start, count, program, site, equip, po_date, received, prefix):
    lines = []
    supplier, po_number, unit_cost, cost_center = EQUIP[equip]
    for i in range(count):
        n = start + i
        po_line_id = f"{n:05d}"
        asset_id = f"{prefix}-{i + 1:04d}"
        pis = received + timedelta(days=4)
        lines.append({
            "po_line_id": po_line_id,
            "po_number": po_number,
            "program_id": program,
            "supplier_id": supplier,
            "site_id": site,
            "equipment_type": equip,
            "qty": 1,
            "unit_cost": unit_cost,
            "po_date": po_date,
            "received_date": received,
            "assets": [{
                "asset_id": asset_id,
                "serial_number": f"SN-{prefix}-{i + 1:04d}",
                "po_line_id": po_line_id,
                "site_id": site,
                "site_raw_override": None,
                "placed_in_service_date": pis,
                "cost_center": cost_center,
                "program_allocation": program,
                "reuse_source_asset_id": "",
                "input_owner_id": "OWN-CMA" if site == "CM-A" else "OWN-AME",
                "created_by": "usr_wei_cma",
                "created_at": ts(received + timedelta(days=1), 10, 0),
                "passed_validation_on_first_entry": 1,
                "source_file": "",
            }],
            "source_file": "",
        })
    return lines


def build_exceptions(ts_lines, orphan):
    by_line = {ln["po_line_id"]: ln for ln in ts_lines}
    rows = []

    def add(**kwargs):
        bucket, age = age_bucket(kwargs["opened_date"])
        kwargs["age_days_design"] = age
        kwargs["bucket_design"] = bucket
        kwargs["closed_date"] = ""
        kwargs["triage_class"] = "go-live"
        kwargs["program_id"] = "TS-LINE-RAMP"
        rows.append(kwargs)

    for n, opened in PIS_OPENED.items():
        ln = by_line[f"{n:05d}"]
        asset = ln["assets"][0]
        add(
            exception_id=f"EX-PIS-{n:05d}",
            po_line_id=ln["po_line_id"],
            asset_id=asset["asset_id"],
            defect_type="missing_placed_in_service",
            field_name="placed_in_service_date",
            owner_id="OWN-FIN",
            opened_date=opened,
            site_id=ln["site_id"],
            detail="Tagged asset has no placed-in-service date. Depreciation cannot start. Finance owns the field.",
        )
    add(
        exception_id="EX-DUP-4421",
        po_line_id="00021",
        asset_id=by_line["00021"]["assets"][0]["asset_id"],
        defect_type="duplicate_serial",
        field_name="serial_number",
        owner_id="OWN-CMB",
        opened_date=date(2026, 3, 11),
        site_id="CM-B",
        detail="Serial SN-DUP-4421 is also on the asset for PO line 00020. The second entry failed uniqueness.",
    )
    add(
        exception_id="EX-DUP-4422",
        po_line_id="00022",
        asset_id=by_line["00022"]["assets"][0]["asset_id"],
        defect_type="duplicate_serial",
        field_name="serial_number",
        owner_id="OWN-CMA",
        opened_date=date(2026, 2, 19),
        site_id="CM-A",
        detail="Serial SN-DUP-4422 is also on the asset for PO line 00023. The second entry failed uniqueness.",
    )
    add(
        exception_id="EX-ORPHAN-0040",
        po_line_id="",
        asset_id=orphan["asset_id"],
        defect_type="orphan_asset",
        field_name="po_line_id",
        owner_id="OWN-GSM",
        opened_date=date(2026, 1, 15),
        site_id="CM-B",
        detail="Asset was keyed into the system of record with no PO line. It is not in either CM tracker. GSM owns the link.",
    )
    mismatch_owner = {24: "OWN-CMA", 25: "OWN-CMB", 26: "OWN-CMA"}
    mismatch_opened = {24: date(2026, 3, 15), 25: date(2026, 2, 28), 26: date(2026, 2, 1)}
    for n in (24, 25, 26):
        ln = by_line[f"{n:05d}"]
        asset = ln["assets"][0]
        add(
            exception_id=f"EX-SITE-{n:05d}",
            po_line_id=ln["po_line_id"],
            asset_id=asset["asset_id"],
            defect_type="site_mismatch",
            field_name="site_id",
            owner_id=mismatch_owner[n],
            opened_date=mismatch_opened[n],
            site_id=ln["site_id"],
            detail=f"PO receiving site is {ln['site_id']}; the asset was tagged {asset['site_id']}. The code is real. It is the wrong site.",
        )
    ln = by_line["00019"]
    add(
        exception_id="EX-DATE-00019",
        po_line_id="00019",
        asset_id=ln["assets"][0]["asset_id"],
        defect_type="pis_before_received",
        field_name="placed_in_service_date",
        owner_id="OWN-FIN",
        opened_date=date(2026, 3, 8),
        site_id="CM-B",
        detail="Placed-in-service 2026-02-11 is before received 2026-02-18. Depreciation would start before the tool arrived.",
    )
    for n, opened in ((39, date(2026, 3, 13)), (40, date(2026, 2, 12))):
        ln = by_line[f"{n:05d}"]
        add(
            exception_id=f"EX-TRANSIT-{n:05d}",
            po_line_id=ln["po_line_id"],
            asset_id="",
            defect_type="in_transit_no_asset",
            field_name="asset_linkage",
            owner_id="OWN-GSM",
            opened_date=opened,
            site_id=ln["site_id"],
            detail="PO line has no received date and no asset. It is in transit. It stays in the reconciliation denominator.",
        )
    return rows


def build_edits(assets_by_program_rows):
    """One row per field write. created_by is not an editor of every field."""
    edits = []
    seq = 1

    def add(asset, field, editor, when):
        nonlocal seq
        edits.append({
            "edit_id": f"FE-{seq:06d}",
            "asset_id": asset["asset_id"],
            "program_id": asset["program_allocation"],
            "field_name": field,
            "edited_by": editor,
            "edited_at": when,
        })
        seq += 1

    for asset in assets_by_program_rows:
        program = asset["program_allocation"]
        if program == "TS-LINE-RAMP":
            when = "2026-02-28 16:00:00"
            cm = asset["created_by"]
            add(asset, "serial_number", cm, when)
            add(asset, "site_id", cm, when)
            # Both Finance and the GSM write cost centers. Not person-dependent.
            editor_cc = "usr_priya_gsm" if int(asset["asset_id"][-1]) % 2 == 0 else "usr_morgan_fin"
            add(asset, "cost_center", editor_cc, when)
            add(asset, "program_allocation", "usr_david_tpm", when)
            if asset["placed_in_service_date"]:
                add(asset, "placed_in_service_date", "usr_morgan_fin", when)
            if asset["reuse_source_asset_id"]:
                add(asset, "reuse_source_asset_id", "usr_elena_ame", when)
        elif program == "PACK-CELL-EXP":
            when = "2026-01-20 10:00:00"
            add(asset, "serial_number", "usr_wei_cma", when)
            add(asset, "site_id", "usr_wei_cma", when)
            editor_cc = "usr_priya_gsm" if int(asset["asset_id"][-1]) % 2 == 0 else "usr_morgan_fin"
            add(asset, "cost_center", editor_cc, when)
            add(asset, "program_allocation", "usr_david_tpm", when)
            add(asset, "placed_in_service_date", "usr_morgan_fin", when)
        else:
            # Outside the 90-day window. A prior TPM wrote program allocation.
            when = "2025-06-15 10:00:00"
            add(asset, "serial_number", "usr_wei_cma", when)
            add(asset, "site_id", "usr_wei_cma", when)
            add(asset, "cost_center", "usr_priya_gsm", when)
            add(asset, "program_allocation", "usr_prior_tpm", when)
            add(asset, "placed_in_service_date", "usr_morgan_fin", when)
    return edits


def site_variant(po_site, n, source):
    if source == "A":
        options = ["A", "Site A", "SITE-A", "A ", "site a"]
    else:
        options = ["Site B", "SITE-B", "B", "B ", "site b"]
    return options[n % len(options)]


def tracker_rows(ts_lines):
    """Messy Excel-style rows plus two structural rejects and one blank artifact."""
    rows_a = []
    rows_b = []
    for ln in ts_lines:
        targets = ln["assets"] if ln["assets"] else [None]
        for i, asset in enumerate(targets):
            n = int(ln["po_line_id"])
            style = (n + i) % 3
            if asset is None:
                site_raw = site_variant(ln["site_id"], n, ln["source_file"])
                serial = ""
                asset_id = " " if n == 39 else ""
                pis = ""
                reuse = ""
            else:
                site_raw = asset["site_raw_override"] or site_variant(ln["site_id"], n, ln["source_file"])
                serial = asset["serial_number"] + (" " if n % 5 == 0 and n not in (20, 25) else "")
                asset_id = asset["asset_id"] + (" " if n == 5 else "")
                pis = fmt_date(asset["placed_in_service_date"], (style + 1) % 3)
                reuse = asset["reuse_source_asset_id"]
            cost = ln["unit_cost"]
            if style == 0:
                cost_raw = f"${cost:,}"
            elif style == 1:
                cost_raw = f"{cost}.00"
            else:
                cost_raw = str(cost)
            qty_raw = str(ln["qty"]) if style != 2 else f"{ln['qty']}.0"
            program_raw = ["TS-LINE-RAMP", "TS-LINE-RAMP ", "ts-line-ramp"][style]
            rec = {
                "po": ln["po_line_id"],
                "po_number": ln["po_number"] + (" " if style == 1 else ""),
                "site": site_raw,
                "equip": ln["equipment_type"].replace("_", " ").title() if style == 1 else ln["equipment_type"],
                "qty": qty_raw if not (asset is None) else "",
                "cost": cost_raw,
                "po_date": fmt_date(ln["po_date"], style),
                "recv": fmt_date(ln["received_date"], (style + 2) % 3),
                "serial": serial,
                "asset": asset_id,
                "pis": pis,
                "cc": (asset["cost_center"] if asset else "CC-4100") + (" " if style == 2 else ""),
                "program": program_raw,
                "reuse": reuse,
                "notes": "check serial" if n in (20, 22) else "",
            }
            (rows_a if ln["source_file"] == "A" else rows_b).append(rec)
    rows_a.append({
        "po": "00901",
        "po_number": "PO-99999",
        "site": "SITE-Z",
        "equip": "Mystery box",
        "qty": "1",
        "cost": "100",
        "po_date": "2026-02-02",
        "recv": "02/20/2026",
        "serial": "SN-JUNK-1",
        "asset": "AST-JUNK-1",
        "pis": "",
        "cc": "CC-4100",
        "program": "TS-LINE-RAMP",
        "reuse": "",
        "notes": "not on the equipment list",
    })
    rows_b.append({
        "po": " ",
        "po_number": "PO-88888",
        "site": "Site B",
        "equip": "widget",
        "qty": "1",
        "cost": "abc",
        "po_date": "13/32/2026",
        "recv": "",
        "serial": "SN-JUNK-2",
        "asset": "AST-JUNK-2",
        "pis": "",
        "cc": "CC-4100",
        "program": "TS-LINE-RAMP",
        "reuse": "",
        "notes": "",
    })
    # Separate the two rows of the fan-out so they are not visually adjacent.
    fan = [r for r in rows_a if r["po"] == "00018"]
    rest = [r for r in rows_a if r["po"] != "00018"]
    if len(fan) != 2:
        raise SystemExit(f"expected 2 fan-out rows, got {len(fan)}")
    rows_a = [fan[0]] + rest[:8] + [fan[1]] + rest[8:]
    return rows_a, rows_b


def write_raw(path, headers, keys, rows, blank_artifact=False):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(headers)
        for rec in rows:
            w.writerow([rec[k] for k in keys])
        if blank_artifact:
            w.writerow([""] * len(headers))


def dim_dates():
    rows = []
    d = date(2025, 6, 1)
    end = date(2026, 4, 30)
    while d <= end:
        iso_y, iso_w, iso_d = d.isocalendar()
        rows.append({
            "date_key": d.strftime("%Y%m%d"),
            "full_date": d.isoformat(),
            "year": d.year,
            "quarter": (d.month - 1) // 3 + 1,
            "month": d.month,
            "month_name": MONTHS[d.month - 1],
            "week_of_year": iso_w,
            "day_of_week": iso_d,
            "day_name": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][d.weekday()],
            "is_weekday": 1 if d.weekday() < 5 else 0,
        })
        d += timedelta(days=1)
    return rows


def assert_model(ts_lines, orphan, exceptions, edits, rows_a, rows_b):
    assets = [a for ln in ts_lines for a in ln["assets"]] + [orphan]
    assert len(ts_lines) == 40
    assert sum(1 for ln in ts_lines if ln["assets"]) == 38
    assert sum(1 for ln in ts_lines if not ln["assets"]) == 2
    assert len(assets) == 40
    assert sum(1 for a in assets if not a["placed_in_service_date"]) == 12
    assert sum(1 for a in assets if a["reuse_source_asset_id"]) == 12
    assert sum(1 for a in assets if not a["po_line_id"]) == 1
    serials = defaultdict(int)
    for a in assets:
        serials[a["serial_number"]] += 1
    assert sorted(s for s, c in serials.items() if c > 1) == ["SN-DUP-4421", "SN-DUP-4422"]
    mismatches = []
    for ln in ts_lines:
        for a in ln["assets"]:
            if a["site_id"] != ln["site_id"]:
                mismatches.append(ln["po_line_id"])
    assert mismatches == ["00024", "00025", "00026"], mismatches
    date_bad = [
        ln["po_line_id"] for ln in ts_lines for a in ln["assets"]
        if a["placed_in_service_date"] and ln["received_date"]
        and a["placed_in_service_date"] < ln["received_date"]
    ]
    assert date_bad == ["00019"], date_bad
    fan = [ln for ln in ts_lines if len(ln["assets"]) == 2]
    assert len(fan) == 1 and fan[0]["po_line_id"] == "00018" and fan[0]["qty"] == 2
    passed = sum(a["passed_validation_on_first_entry"] for a in assets)
    assert passed == 21, passed
    assert len(exceptions) == 21
    buckets = defaultdict(int)
    for e in exceptions:
        buckets[e["bucket_design"]] += 1
    assert dict(buckets) == {"0-7": 7, "8-30": 7, "31+": 7}, dict(buckets)
    assert any(e["exception_id"] == "EX-PIS-00017" and e["bucket_design"] == "0-7" for e in exceptions)
    # 22 A lines + 1 extra fan-out row + 1 junk; 18 B lines + 1 junk.
    assert len(rows_a) == 24, len(rows_a)
    assert len(rows_b) == 19, len(rows_b)
    line17 = next(ln for ln in ts_lines if ln["po_line_id"] == "00017")
    assert line17["received_date"] == date(2026, 2, 12)
    assert line17["assets"][0]["placed_in_service_date"] is None
    assert line17["assets"][0]["asset_id"] == "AST-TS-0017"
    assert line17["site_id"] == "CM-B"
    assert orphan["asset_id"] == "AST-TS-0040"
    # Person-dependent editors inside the window, TS only.
    start = AS_OF - timedelta(days=WINDOW_DAYS)
    ts_edits = [
        e for e in edits
        if e["program_id"] == "TS-LINE-RAMP"
        and date.fromisoformat(e["edited_at"][:10]) >= start
        and date.fromisoformat(e["edited_at"][:10]) <= AS_OF
    ]
    by_field = defaultdict(set)
    for e in ts_edits:
        by_field[e["field_name"]].add(e["edited_by"])
    assert by_field["placed_in_service_date"] == {"usr_morgan_fin"}
    assert by_field["program_allocation"] == {"usr_david_tpm"}
    assert by_field["reuse_source_asset_id"] == {"usr_elena_ame"}
    assert by_field["cost_center"] == {"usr_priya_gsm", "usr_morgan_fin"}
    assert by_field["site_id"] == {"usr_wei_cma", "usr_jordan_cmb"}
    assert by_field["serial_number"] == {"usr_wei_cma", "usr_jordan_cmb"}
    # Without the window, program allocation also has the prior TPM.
    all_prog = {e["edited_by"] for e in edits if e["field_name"] == "program_allocation"}
    assert all_prog == {"usr_david_tpm", "usr_prior_tpm"}
    print("model asserts passed")
    print(f"TS assets {len(assets)} FTR pass {passed} exceptions {len(exceptions)} buckets {dict(buckets)}")
    print(f"tracker rows A {len(rows_a)} B {len(rows_b)} submitted {len(rows_a)+len(rows_b)}")
    print("line 00017 asset", line17["assets"][0]["asset_id"], "orphan", orphan["asset_id"])


def main():
    ts_lines, orphan = build_ts_lines()
    pack = build_other(41, 32, "PACK-CELL-EXP", "CM-A", "pack_cell",
                       date(2026, 1, 8), date(2026, 1, 22), "AST-PK")
    fixture = build_other(73, 28, "FIXTURE-REUSE-24", "PLANT-01", "fixture",
                          date(2025, 6, 2), date(2025, 6, 20), "AST-FR")
    exceptions = build_exceptions(ts_lines, orphan)
    all_lines = ts_lines + pack + fixture
    all_assets = [a for ln in all_lines for a in ln["assets"]] + [orphan]
    edits = build_edits(all_assets)
    rows_a, rows_b = tracker_rows(ts_lines)
    assert_model(ts_lines, orphan, exceptions, edits, rows_a, rows_b)

    po_fields = ["po_line_id", "po_number", "program_id", "supplier_id", "site_id",
                 "equipment_type", "qty", "unit_cost", "po_date", "received_date"]
    po_rows = []
    for ln in all_lines:
        po_rows.append({k: (iso(ln[k]) if isinstance(ln[k], date) else ln[k]) for k in po_fields})
    write_csv(DATA / "fact_po_line.csv", po_fields, po_rows)

    asset_fields = ["asset_id", "serial_number", "po_line_id", "site_id", "placed_in_service_date",
                    "cost_center", "program_allocation", "reuse_source_asset_id", "input_owner_id",
                    "created_by", "created_at", "passed_validation_on_first_entry"]
    asset_rows = []
    for a in all_assets:
        asset_rows.append({
            **{k: a[k] for k in asset_fields if k != "placed_in_service_date"},
            "placed_in_service_date": iso(a["placed_in_service_date"]) if isinstance(a["placed_in_service_date"], date) else "",
        })
    write_csv(DATA / "fact_asset.csv", asset_fields, asset_rows)

    ex_fields = ["exception_id", "program_id", "po_line_id", "asset_id", "defect_type", "field_name",
                 "owner_id", "opened_date", "closed_date", "site_id", "triage_class", "detail"]
    write_csv(DATA / "fact_exception.csv", ex_fields, [
        {**e, "opened_date": iso(e["opened_date"])} for e in exceptions
    ])

    edit_fields = ["edit_id", "asset_id", "program_id", "field_name", "edited_by", "edited_at"]
    write_csv(DATA / "fact_field_edit.csv", edit_fields, edits)

    write_csv(DATA / "dim_program.csv",
              ["program_id", "program_name", "status", "line_of_business", "equipment_list_count", "notes"],
              [
                  {"program_id": "TS-LINE-RAMP", "program_name": "Test-station line ramp",
                   "status": "onboarding", "line_of_business": "Test", "equipment_list_count": 40,
                   "notes": "Moving off CM Excel trackers onto the system of record. This is the lab program."},
                  {"program_id": "PACK-CELL-EXP", "program_name": "Pack cell expansion",
                   "status": "sustaining", "line_of_business": "Pack", "equipment_list_count": 32,
                   "notes": "Already on the system of record. Clean on purpose, so a blended rate looks finished."},
                  {"program_id": "FIXTURE-REUSE-24", "program_name": "Fixture reuse 2024",
                   "status": "sustaining", "line_of_business": "Test", "equipment_list_count": 28,
                   "notes": "Prior program. Holds the 12 source assets the ramp reuses. Edits are outside the 90-day window."},
              ])
    write_csv(DATA / "dim_site.csv",
              ["site_id", "site_name", "site_type"],
              [
                  {"site_id": "CM-A", "site_name": "CM site A", "site_type": "contract_manufacturer"},
                  {"site_id": "CM-B", "site_name": "CM site B", "site_type": "contract_manufacturer"},
                  {"site_id": "PLANT-01", "site_name": "Internal plant", "site_type": "internal_plant"},
              ])
    write_csv(DATA / "dim_supplier.csv",
              ["supplier_id", "supplier_name"],
              [
                  {"supplier_id": "SUP-ATLAS", "supplier_name": "Atlas Fixture Co"},
                  {"supplier_id": "SUP-NORTH", "supplier_name": "Northline Test Systems"},
                  {"supplier_id": "SUP-HELIX", "supplier_name": "Helix Instruments"},
              ])
    write_csv(DATA / "dim_input_owner.csv",
              ["owner_id", "user_id", "person_name", "role_code", "role_name", "home_site_id"],
              [
                  {"owner_id": "OWN-GSM", "user_id": "usr_priya_gsm", "person_name": "Priya Raman",
                   "role_code": "GSM", "role_name": "Global Supply Manager", "home_site_id": ""},
                  {"owner_id": "OWN-TPM", "user_id": "usr_david_tpm", "person_name": "David Cho",
                   "role_code": "TPM", "role_name": "Technical Program Manager", "home_site_id": ""},
                  {"owner_id": "OWN-AME", "user_id": "usr_elena_ame", "person_name": "Elena Vasquez",
                   "role_code": "AME", "role_name": "Advanced Manufacturing Engineer", "home_site_id": ""},
                  {"owner_id": "OWN-CMA", "user_id": "usr_wei_cma", "person_name": "Wei Chen",
                   "role_code": "CM_A", "role_name": "CM site A coordinator", "home_site_id": "CM-A"},
                  {"owner_id": "OWN-CMB", "user_id": "usr_jordan_cmb", "person_name": "Jordan Hale",
                   "role_code": "CM_B", "role_name": "CM site B coordinator", "home_site_id": "CM-B"},
                  {"owner_id": "OWN-FIN", "user_id": "usr_morgan_fin", "person_name": "Morgan Ellis",
                   "role_code": "FIN", "role_name": "Finance fixed assets", "home_site_id": ""},
              ])
    write_csv(DATA / "dim_date.csv",
              ["date_key", "full_date", "year", "quarter", "month", "month_name",
               "week_of_year", "day_of_week", "day_name", "is_weekday"],
              dim_dates())
    write_csv(DATA / "user_program_map.csv",
              ["user_id", "person_name", "role_name", "program_id"],
              [
                  {"user_id": "usr_priya_gsm", "person_name": "Priya Raman", "role_name": "Global Supply Manager", "program_id": "TS-LINE-RAMP"},
                  {"user_id": "usr_priya_gsm", "person_name": "Priya Raman", "role_name": "Global Supply Manager", "program_id": "PACK-CELL-EXP"},
                  {"user_id": "usr_priya_gsm", "person_name": "Priya Raman", "role_name": "Global Supply Manager", "program_id": "FIXTURE-REUSE-24"},
                  {"user_id": "usr_jordan_cmb", "person_name": "Jordan Hale", "role_name": "CM site B coordinator", "program_id": "TS-LINE-RAMP"},
                  {"user_id": "usr_morgan_fin", "person_name": "Morgan Ellis", "role_name": "Finance fixed assets", "program_id": "TS-LINE-RAMP"},
                  {"user_id": "usr_morgan_fin", "person_name": "Morgan Ellis", "role_name": "Finance fixed assets", "program_id": "PACK-CELL-EXP"},
              ])
    write_csv(DATA / "equipment_list_ts_line_ramp.csv", po_fields, [
        row for row in po_rows if row["program_id"] == "TS-LINE-RAMP"
    ])
    # Equipment list is the authority for the PO. It has no received date.
    # Rewrite without received_date so a blank cannot be mistaken for in-transit.
    write_csv(DATA / "equipment_list_ts_line_ramp.csv",
              ["po_line_id", "po_number", "program_id", "supplier_id", "site_id",
               "equipment_type", "qty", "unit_cost", "po_date"],
              [{k: row[k] for k in ["po_line_id", "po_number", "program_id", "supplier_id", "site_id",
                                    "equipment_type", "qty", "unit_cost", "po_date"]}
               for row in po_rows if row["program_id"] == "TS-LINE-RAMP"])
    write_csv(DATA / "field_owner_map.csv",
              ["field_name", "owner_id", "applies_when", "why"],
              [
                  {"field_name": "placed_in_service_date", "owner_id": "OWN-FIN",
                   "applies_when": "every tagged asset",
                   "why": "The day depreciation starts. Not the ship date and not the day the CM unpacked the crate."},
                  {"field_name": "cost_center", "owner_id": "OWN-GSM",
                   "applies_when": "every tagged asset",
                   "why": "Which cost center carries the asset. The GSM owns the cost assignment on the buy."},
                  {"field_name": "program_allocation", "owner_id": "OWN-TPM",
                   "applies_when": "every tagged asset",
                   "why": "Which program the asset serves. Shared tools get split by memory when this field has one editor."},
                  {"field_name": "reuse_source_asset_id", "owner_id": "OWN-AME",
                   "applies_when": "only when equipment_type is reused_fixture",
                   "why": "The prior asset this fixture came from. Without it, Finance can capitalize a tool the company already owns. The denominator is the reuse lines, not every line."},
                  {"field_name": "site_id", "owner_id": "submitting CM coordinator",
                   "applies_when": "every tagged asset",
                   "why": "Where the asset physically is. A code that exists in the site list can still be the wrong site for the PO. Completeness is not validity."},
                  {"field_name": "serial_number", "owner_id": "submitting CM coordinator",
                   "applies_when": "every tagged asset",
                   "why": "Identity of the physical unit. Two assets with one serial cannot be counted."},
                  {"field_name": "po_line_id", "owner_id": "OWN-GSM",
                   "applies_when": "every tagged asset",
                   "why": "The link from the thing on the floor to the buy. An asset with no PO line is an orphan."},
                  {"field_name": "asset_linkage", "owner_id": "OWN-GSM",
                   "applies_when": "every PO line",
                   "why": "A PO line with no asset is not reconciled. In transit is a state, and it stays in the denominator until an asset is tagged."},
              ])
    write_csv(DATA / "published_tolerance.csv",
              ["rule_id", "published_at", "metric", "operator", "threshold", "basis"],
              [
                  {"rule_id": "R1", "published_at": "2026-03-01", "metric": "missing_equipment_list_lines",
                   "operator": "eq", "threshold": "0",
                   "basis": "Approved equipment list is 40 PO lines. One missing line is a no-go. Published before the trackers arrived."},
                  {"rule_id": "R2", "published_at": "2026-03-01", "metric": "duplicate_po_line_ids_in_load",
                   "operator": "eq", "threshold": "0",
                   "basis": "A second copy of a PO line id is a no-go. Two asset rows on one id are a fan-out, not a duplicate id."},
                  {"rule_id": "R3", "published_at": "2026-03-01", "metric": "quarantine_rate",
                   "operator": "lte", "threshold": "0.05",
                   "basis": "Quarantined rows divided by submitted tracker rows. Fully blank Excel artifacts are not submissions."},
                  {"rule_id": "R4", "published_at": "2026-03-01", "metric": "reconciliation_rate_alert",
                   "operator": "lt", "threshold": "0.98",
                   "basis": "Proposed lab alert only, not a company threshold. Fires when the certified rate is below 98 percent. The blend at 98 percent stays quiet. The onboarding program at 95 percent pages."},
              ])
    write_csv(DATA / "lab_parameters.csv",
              ["as_of_date", "window_days", "alert_reconciliation_below", "program_in_focus"],
              [{"as_of_date": "2026-03-16", "window_days": 90,
                "alert_reconciliation_below": "0.98", "program_in_focus": "TS-LINE-RAMP"}])

    headers_a = ["PO Line ", "PO Number", "Site ", "Equip Type", "Qty ", "Unit Cost ",
                 "PO Date", "Recv Date", "Serial", "Asset Tag", "In Svc", "Cost Ctr",
                 "Program", "Reuse From", "Notes "]
    keys = ["po", "po_number", "site", "equip", "qty", "cost", "po_date", "recv",
            "serial", "asset", "pis", "cc", "program", "reuse", "notes"]
    write_raw(DATA / "raw_cm_tracker_siteA.csv", headers_a, keys, rows_a, blank_artifact=False)
    headers_b = ["po_line", "PO#", "Location", "equipment", "quantity", "cost",
                 "order_dt", "date received", "SN", "asset", "pis", "cc", "prog", "prior_asset"]
    keys_b = ["po", "po_number", "site", "equip", "qty", "cost", "po_date", "recv",
              "serial", "asset", "pis", "cc", "program", "reuse"]
    write_raw(DATA / "raw_cm_tracker_siteB.csv", headers_b, keys_b, rows_b, blank_artifact=True)

    roster = []
    for e in exceptions:
        roster.append({
            "exception_id": e["exception_id"],
            "defect_type": e["defect_type"],
            "field_name": e["field_name"],
            "po_line_id": e["po_line_id"],
            "asset_id": e["asset_id"],
            "owner_id": e["owner_id"],
            "opened_date": iso(e["opened_date"]),
            "age_days": e["age_days_design"],
            "bucket": e["bucket_design"],
            "why_it_matters": e["detail"],
        })
    write_csv(DATA / "planted_defects.csv",
              ["exception_id", "defect_type", "field_name", "po_line_id", "asset_id",
               "owner_id", "opened_date", "age_days", "bucket", "why_it_matters"],
              roster)
    print(f"wrote CSVs under {DATA}")


if __name__ == "__main__":
    main()
