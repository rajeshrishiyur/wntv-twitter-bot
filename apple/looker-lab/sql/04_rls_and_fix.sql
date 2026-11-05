-- Step 7 is a query, not a mutation. It is already in metric_rls_by_user
-- and metric_rls_jordan_pack. Re-run those after this file only if you want
-- to see that the fix did not change what Jordan is allowed to see.
--
-- Step 9 mutates the local database. It does not rewrite the CSVs.
-- To reset, re-run 00_create_tables_duckdb.sql and 01_load_duckdb.sql.
--
-- What this must not do: update passed_validation_on_first_entry.
-- A late date does not make the first entry right.

UPDATE fact_asset
SET placed_in_service_date = DATE '2026-02-17'
WHERE po_line_id = '00017';

UPDATE fact_exception
SET closed_date = DATE '2026-03-16'
WHERE exception_id = 'EX-PIS-00017';

INSERT INTO fact_field_edit (
  edit_id, asset_id, program_id, field_name, edited_by, edited_at
)
SELECT
  'FE-FIX-00017',
  asset_id,
  program_allocation,
  'placed_in_service_date',
  'usr_morgan_fin',
  TIMESTAMP '2026-03-16 09:30:00'
FROM fact_asset
WHERE po_line_id = '00017';
