# Looker lab — CapEx data-integrity scorecard

Illustrative lab for explaining a data-integrity scorecard. Not Apple’s system. Start with `LOOKER-LAB-GUIDE.html` (or the PDF, or `LOOKER-LAB-GUIDE.md`).

Path A, on this machine:

```
python3 generate_data.py
python3 run_local.py
```

Then open `dashboard_mock.html`. The answer key is `data/expected_outputs/`. The open-queue database, after `run_local.py`, is `/tmp/lookerlab-scratch/lab.duckdb`.

`lookml/` is the Looker project. `sql/00_create_tables.sql` is BigQuery. The files that were executed are the DuckDB variants named in the guide.
