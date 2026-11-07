-- BigQuery dialect. Dataset name `capex` is a placeholder.
-- Create the dataset in the console first, or replace `capex` with project.dataset.
-- po_line_id and asset_id are STRING on purpose. A numeric load turns 00017 into 17.

CREATE SCHEMA IF NOT EXISTS capex;

CREATE OR REPLACE TABLE capex.dim_program (
  program_id STRING NOT NULL,
  program_name STRING,
  status STRING,
  line_of_business STRING,
  equipment_list_count INT64,
  notes STRING
);

CREATE OR REPLACE TABLE capex.dim_site (
  site_id STRING NOT NULL,
  site_name STRING,
  site_type STRING
);

CREATE OR REPLACE TABLE capex.dim_supplier (
  supplier_id STRING NOT NULL,
  supplier_name STRING
);

CREATE OR REPLACE TABLE capex.dim_input_owner (
  owner_id STRING NOT NULL,
  user_id STRING,
  person_name STRING,
  role_code STRING,
  role_name STRING,
  home_site_id STRING
);

CREATE OR REPLACE TABLE capex.dim_date (
  date_key INT64,
  full_date DATE,
  year INT64,
  quarter INT64,
  month INT64,
  month_name STRING,
  week_of_year INT64,
  day_of_week INT64,
  day_name STRING,
  is_weekday INT64
);

CREATE OR REPLACE TABLE capex.fact_po_line (
  po_line_id STRING NOT NULL,
  po_number STRING,
  program_id STRING,
  supplier_id STRING,
  site_id STRING,
  equipment_type STRING,
  qty INT64,
  unit_cost NUMERIC,
  po_date DATE,
  received_date DATE
);

CREATE OR REPLACE TABLE capex.fact_asset (
  asset_id STRING NOT NULL,
  serial_number STRING,
  po_line_id STRING,
  site_id STRING,
  placed_in_service_date DATE,
  cost_center STRING,
  program_allocation STRING,
  reuse_source_asset_id STRING,
  input_owner_id STRING,
  created_by STRING,
  created_at TIMESTAMP,
  passed_validation_on_first_entry INT64
);

CREATE OR REPLACE TABLE capex.fact_exception (
  exception_id STRING NOT NULL,
  program_id STRING,
  po_line_id STRING,
  asset_id STRING,
  defect_type STRING,
  field_name STRING,
  owner_id STRING,
  opened_date DATE,
  closed_date DATE,
  site_id STRING,
  triage_class STRING,
  detail STRING
);

CREATE OR REPLACE TABLE capex.fact_field_edit (
  edit_id STRING NOT NULL,
  asset_id STRING,
  program_id STRING,
  field_name STRING,
  edited_by STRING,
  edited_at TIMESTAMP
);

CREATE OR REPLACE TABLE capex.user_program_map (
  user_id STRING,
  person_name STRING,
  role_name STRING,
  program_id STRING
);

CREATE OR REPLACE TABLE capex.equipment_list (
  po_line_id STRING NOT NULL,
  po_number STRING,
  program_id STRING,
  supplier_id STRING,
  site_id STRING,
  equipment_type STRING,
  qty INT64,
  unit_cost NUMERIC,
  po_date DATE
);

CREATE OR REPLACE TABLE capex.field_owner_map (
  field_name STRING,
  owner_id STRING,
  applies_when STRING,
  why STRING
);

CREATE OR REPLACE TABLE capex.published_tolerance (
  rule_id STRING,
  published_at DATE,
  metric STRING,
  operator STRING,
  threshold NUMERIC,
  basis STRING
);

CREATE OR REPLACE TABLE capex.lab_parameters (
  as_of_date DATE,
  window_days INT64,
  alert_reconciliation_below NUMERIC,
  program_in_focus STRING
);
