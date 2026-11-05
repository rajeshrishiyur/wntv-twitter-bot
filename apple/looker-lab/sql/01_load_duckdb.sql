-- Load the clean CSVs. Run from the looker-lab directory after 00_create_tables_duckdb.sql.
-- all_varchar keeps 00017 as text. Empty strings become NULL here, on purpose.

DELETE FROM dim_program;
INSERT INTO dim_program
SELECT * FROM read_csv('data/dim_program.csv', header = true, all_varchar = true);

DELETE FROM dim_site;
INSERT INTO dim_site
SELECT * FROM read_csv('data/dim_site.csv', header = true, all_varchar = true);

DELETE FROM dim_supplier;
INSERT INTO dim_supplier
SELECT * FROM read_csv('data/dim_supplier.csv', header = true, all_varchar = true);

DELETE FROM dim_input_owner;
INSERT INTO dim_input_owner
SELECT * FROM read_csv('data/dim_input_owner.csv', header = true, all_varchar = true);

DELETE FROM dim_date;
INSERT INTO dim_date
SELECT
  date_key::INTEGER,
  full_date::DATE,
  year::INTEGER,
  quarter::INTEGER,
  month::INTEGER,
  month_name,
  week_of_year::INTEGER,
  day_of_week::INTEGER,
  day_name,
  is_weekday::INTEGER
FROM read_csv('data/dim_date.csv', header = true, all_varchar = true);

DELETE FROM fact_po_line;
INSERT INTO fact_po_line
SELECT
  po_line_id,
  po_number,
  program_id,
  supplier_id,
  site_id,
  equipment_type,
  qty::INTEGER,
  unit_cost::INTEGER,
  po_date::DATE,
  NULLIF(received_date, '')::DATE
FROM read_csv('data/fact_po_line.csv', header = true, all_varchar = true);

DELETE FROM fact_asset;
INSERT INTO fact_asset
SELECT
  asset_id,
  serial_number,
  NULLIF(po_line_id, ''),
  site_id,
  NULLIF(placed_in_service_date, '')::DATE,
  cost_center,
  program_allocation,
  NULLIF(reuse_source_asset_id, ''),
  input_owner_id,
  created_by,
  created_at::TIMESTAMP,
  passed_validation_on_first_entry::INTEGER
FROM read_csv('data/fact_asset.csv', header = true, all_varchar = true);

DELETE FROM fact_exception;
INSERT INTO fact_exception
SELECT
  exception_id,
  program_id,
  NULLIF(po_line_id, ''),
  NULLIF(asset_id, ''),
  defect_type,
  field_name,
  owner_id,
  opened_date::DATE,
  NULLIF(closed_date, '')::DATE,
  site_id,
  triage_class,
  detail
FROM read_csv('data/fact_exception.csv', header = true, all_varchar = true);

DELETE FROM fact_field_edit;
INSERT INTO fact_field_edit
SELECT
  edit_id,
  asset_id,
  program_id,
  field_name,
  edited_by,
  edited_at::TIMESTAMP
FROM read_csv('data/fact_field_edit.csv', header = true, all_varchar = true);

DELETE FROM user_program_map;
INSERT INTO user_program_map
SELECT * FROM read_csv('data/user_program_map.csv', header = true, all_varchar = true);

DELETE FROM equipment_list;
INSERT INTO equipment_list
SELECT
  po_line_id,
  po_number,
  program_id,
  supplier_id,
  site_id,
  equipment_type,
  qty::INTEGER,
  unit_cost::INTEGER,
  po_date::DATE
FROM read_csv('data/equipment_list_ts_line_ramp.csv', header = true, all_varchar = true);

DELETE FROM field_owner_map;
INSERT INTO field_owner_map
SELECT * FROM read_csv('data/field_owner_map.csv', header = true, all_varchar = true);

DELETE FROM published_tolerance;
INSERT INTO published_tolerance
SELECT
  rule_id,
  published_at::DATE,
  metric,
  operator,
  threshold::DOUBLE,
  basis
FROM read_csv('data/published_tolerance.csv', header = true, all_varchar = true);

DELETE FROM lab_parameters;
INSERT INTO lab_parameters
SELECT
  as_of_date::DATE,
  window_days::INTEGER,
  alert_reconciliation_below::DOUBLE,
  program_in_focus
FROM read_csv('data/lab_parameters.csv', header = true, all_varchar = true);
