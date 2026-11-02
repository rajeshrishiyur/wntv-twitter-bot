-- DuckDB / SQLite-shaped variant of 00_create_tables.sql.
-- This is the file Path A runs. Types are the local equivalents of the BigQuery types.
-- Re-running this file drops the tables. Reload with 01_load_duckdb.sql.

CREATE OR REPLACE TABLE dim_program (
  program_id VARCHAR PRIMARY KEY,
  program_name VARCHAR,
  status VARCHAR,
  line_of_business VARCHAR,
  equipment_list_count INTEGER,
  notes VARCHAR
);

CREATE OR REPLACE TABLE dim_site (
  site_id VARCHAR PRIMARY KEY,
  site_name VARCHAR,
  site_type VARCHAR
);

CREATE OR REPLACE TABLE dim_supplier (
  supplier_id VARCHAR PRIMARY KEY,
  supplier_name VARCHAR
);

CREATE OR REPLACE TABLE dim_input_owner (
  owner_id VARCHAR PRIMARY KEY,
  user_id VARCHAR,
  person_name VARCHAR,
  role_code VARCHAR,
  role_name VARCHAR,
  home_site_id VARCHAR
);

CREATE OR REPLACE TABLE dim_date (
  date_key INTEGER,
  full_date DATE,
  year INTEGER,
  quarter INTEGER,
  month INTEGER,
  month_name VARCHAR,
  week_of_year INTEGER,
  day_of_week INTEGER,
  day_name VARCHAR,
  is_weekday INTEGER
);

CREATE OR REPLACE TABLE fact_po_line (
  po_line_id VARCHAR PRIMARY KEY,
  po_number VARCHAR,
  program_id VARCHAR,
  supplier_id VARCHAR,
  site_id VARCHAR,
  equipment_type VARCHAR,
  qty INTEGER,
  unit_cost INTEGER,
  po_date DATE,
  received_date DATE
);

CREATE OR REPLACE TABLE fact_asset (
  asset_id VARCHAR PRIMARY KEY,
  serial_number VARCHAR,
  po_line_id VARCHAR,
  site_id VARCHAR,
  placed_in_service_date DATE,
  cost_center VARCHAR,
  program_allocation VARCHAR,
  reuse_source_asset_id VARCHAR,
  input_owner_id VARCHAR,
  created_by VARCHAR,
  created_at TIMESTAMP,
  passed_validation_on_first_entry INTEGER
);

CREATE OR REPLACE TABLE fact_exception (
  exception_id VARCHAR PRIMARY KEY,
  program_id VARCHAR,
  po_line_id VARCHAR,
  asset_id VARCHAR,
  defect_type VARCHAR,
  field_name VARCHAR,
  owner_id VARCHAR,
  opened_date DATE,
  closed_date DATE,
  site_id VARCHAR,
  triage_class VARCHAR,
  detail VARCHAR
);

CREATE OR REPLACE TABLE fact_field_edit (
  edit_id VARCHAR PRIMARY KEY,
  asset_id VARCHAR,
  program_id VARCHAR,
  field_name VARCHAR,
  edited_by VARCHAR,
  edited_at TIMESTAMP
);

CREATE OR REPLACE TABLE user_program_map (
  user_id VARCHAR,
  person_name VARCHAR,
  role_name VARCHAR,
  program_id VARCHAR
);

CREATE OR REPLACE TABLE equipment_list (
  po_line_id VARCHAR PRIMARY KEY,
  po_number VARCHAR,
  program_id VARCHAR,
  supplier_id VARCHAR,
  site_id VARCHAR,
  equipment_type VARCHAR,
  qty INTEGER,
  unit_cost INTEGER,
  po_date DATE
);

CREATE OR REPLACE TABLE field_owner_map (
  field_name VARCHAR,
  owner_id VARCHAR,
  applies_when VARCHAR,
  why VARCHAR
);

CREATE OR REPLACE TABLE published_tolerance (
  rule_id VARCHAR,
  published_at DATE,
  metric VARCHAR,
  operator VARCHAR,
  threshold DOUBLE,
  basis VARCHAR
);

CREATE OR REPLACE TABLE lab_parameters (
  as_of_date DATE,
  window_days INTEGER,
  alert_reconciliation_below DOUBLE,
  program_in_focus VARCHAR
);
