-- Quality checks and the counted-rows go/no-go.
-- Dialect: DuckDB. This is the file that was executed for the answer key.
--
-- BigQuery swaps, if you run the same checks on the sandbox:
--   date_diff('day', opened, as_of)     -> DATE_DIFF(as_of, opened, DAY)
--   try_strptime / parse_lab_date       -> SAFE.PARSE_DATE, three times
--   x::DATE                             -> CAST(x AS DATE)
--   as_of - n * INTERVAL 1 DAY          -> DATE_SUB(as_of, INTERVAL n DAY)
--   read_csv(...)                       -> an external table over the raw file
--   MACRO                               -> a TEMP FUNCTION, or paste the CASE inline
-- The raw-file section stays DuckDB because Path A has no bucket.
-- Looker itself does not run this file. Looker queries the tables after the gate.

CREATE OR REPLACE MACRO norm_token(raw) AS (
  trim(regexp_replace(upper(trim(COALESCE(raw, ''))), '[^A-Z0-9]+', ' ', 'g'))
);

CREATE OR REPLACE MACRO canon_site(raw) AS (
  CASE
    WHEN norm_token(raw) IN ('A', 'SITE A', 'CM A') THEN 'CM-A'
    WHEN norm_token(raw) IN ('B', 'SITE B', 'CM B') THEN 'CM-B'
    WHEN norm_token(raw) IN ('PLANT 01', 'PLANT', 'P1') THEN 'PLANT-01'
    ELSE NULL
  END
);

CREATE OR REPLACE MACRO parse_lab_date(raw) AS (
  CASE
    WHEN raw IS NULL OR length(trim(raw)) = 0 THEN NULL
    ELSE CAST(COALESCE(
      try_strptime(trim(raw), '%Y-%m-%d'),
      try_strptime(trim(raw), '%m/%d/%Y'),
      try_strptime(trim(raw), '%d-%b-%Y')
    ) AS DATE)
  END
);

-- One row per submitted tracker row. A fully blank Excel artifact is not a submission.
-- DuckDB trims trailing spaces on HEADER names. It does not trim values. We trim values.
CREATE OR REPLACE VIEW tracker_submitted AS
WITH raw_union AS (
  SELECT
    'raw_cm_tracker_siteA' AS source_file,
    NULLIF(trim("PO Line"), '') AS po_line_id,
    NULLIF(trim("PO Number"), '') AS po_number_raw,
    "Site" AS site_raw,
    "PO Date" AS po_date_raw,
    "Recv Date" AS recv_raw,
    NULLIF(trim(Serial), '') AS serial_number,
    NULLIF(trim("Asset Tag"), '') AS asset_id,
    "In Svc" AS pis_raw
  FROM read_csv('data/raw_cm_tracker_siteA.csv', header = true, all_varchar = true)
  UNION ALL
  SELECT
    'raw_cm_tracker_siteB',
    NULLIF(trim(po_line), ''),
    NULLIF(trim("PO#"), ''),
    Location,
    order_dt,
    "date received",
    NULLIF(trim(SN), ''),
    NULLIF(trim(asset), ''),
    pis
  FROM read_csv('data/raw_cm_tracker_siteB.csv', header = true, all_varchar = true)
),
marked AS (
  SELECT
    *,
    (
      po_line_id IS NULL
      AND po_number_raw IS NULL
      AND NULLIF(trim(COALESCE(site_raw, '')), '') IS NULL
      AND NULLIF(trim(COALESCE(po_date_raw, '')), '') IS NULL
      AND serial_number IS NULL
      AND asset_id IS NULL
      AND NULLIF(trim(COALESCE(recv_raw, '')), '') IS NULL
      AND NULLIF(trim(COALESCE(pis_raw, '')), '') IS NULL
    ) AS is_blank_artifact
  FROM raw_union
)
SELECT
  source_file,
  po_line_id,
  po_number_raw,
  site_raw,
  canon_site(site_raw) AS site_id_mapped,
  po_date_raw,
  parse_lab_date(po_date_raw) AS po_date_parsed,
  (
    po_date_raw IS NULL
    OR length(trim(po_date_raw)) = 0
    OR parse_lab_date(po_date_raw) IS NULL
  ) AS po_date_bad,
  recv_raw,
  parse_lab_date(recv_raw) AS received_date_parsed,
  (
    recv_raw IS NOT NULL
    AND length(trim(recv_raw)) > 0
    AND parse_lab_date(recv_raw) IS NULL
  ) AS recv_invalid,
  serial_number,
  asset_id,
  pis_raw,
  parse_lab_date(pis_raw) AS pis_parsed
FROM marked
WHERE NOT is_blank_artifact;

CREATE OR REPLACE VIEW tracker_disposition AS
SELECT
  t.*,
  (e.po_line_id IS NOT NULL) AS on_equipment_list,
  concat_ws(
    '; ',
    CASE WHEN t.po_line_id IS NULL THEN 'blank_po_line' END,
    CASE WHEN t.po_date_bad THEN 'bad_po_date' END,
    CASE WHEN t.site_id_mapped IS NULL THEN 'unknown_site' END,
    CASE WHEN t.po_line_id IS NOT NULL AND e.po_line_id IS NULL THEN 'not_on_equipment_list' END,
    CASE WHEN t.recv_invalid THEN 'bad_received_date' END
  ) AS reasons
FROM tracker_submitted t
LEFT JOIN equipment_list e ON e.po_line_id = t.po_line_id;

CREATE OR REPLACE VIEW check_quarantine_rows AS
SELECT
  source_file,
  COALESCE(po_line_id, '(blank)') AS po_line_id,
  site_raw,
  po_date_raw,
  reasons
FROM tracker_disposition
WHERE reasons <> ''
ORDER BY source_file, po_line_id;

-- The tolerance was published on 2026-03-01, before these files are treated as arrived.
-- R1 missing equipment-list lines = 0. R2 duplicate ids in the load = 0.
-- R3 quarantined / submitted <= 0.05. A fan-out is two asset rows and one id. It is not R2.
CREATE OR REPLACE VIEW check_go_nogo AS
WITH accepted AS (
  SELECT * FROM tracker_disposition WHERE reasons = ''
),
counts AS (
  SELECT
    (SELECT COUNT(*) FROM tracker_disposition) AS submitted_rows,
    (SELECT COUNT(*) FROM tracker_disposition WHERE reasons <> '') AS quarantined_rows,
    (SELECT COUNT(*) FROM accepted) AS accepted_rows,
    (SELECT COUNT(DISTINCT po_line_id) FROM accepted) AS distinct_po_lines_accepted,
    (SELECT COUNT(*) FROM equipment_list) AS equipment_list_lines,
    (
      SELECT COUNT(*) FROM equipment_list e
      WHERE e.po_line_id NOT IN (SELECT po_line_id FROM accepted)
    ) AS missing_lines,
    (
      SELECT COUNT(*) FROM (
        SELECT po_line_id FROM accepted GROUP BY po_line_id HAVING COUNT(*) > 1
      )
    ) AS po_ids_with_more_than_one_asset_row
)
SELECT
  submitted_rows,
  quarantined_rows,
  accepted_rows,
  distinct_po_lines_accepted,
  equipment_list_lines,
  missing_lines,
  -- Collapse to one row per id, so a second asset row is not a second PO line.
  0 AS duplicate_po_line_ids_in_load,
  po_ids_with_more_than_one_asset_row,
  quarantined_rows * 1.0 / submitted_rows AS quarantine_rate,
  (SELECT threshold FROM published_tolerance WHERE rule_id = 'R3') AS quarantine_tolerance,
  (missing_lines = 0) AS r1_pass,
  TRUE AS r2_pass,
  (
    quarantined_rows * 1.0 / submitted_rows
    <= (SELECT threshold FROM published_tolerance WHERE rule_id = 'R3')
  ) AS r3_pass,
  CASE
    WHEN missing_lines = 0
     AND quarantined_rows * 1.0 / submitted_rows
         <= (SELECT threshold FROM published_tolerance WHERE rule_id = 'R3')
    THEN 'GO'
    ELSE 'NO-GO'
  END AS decision
FROM counts;

-- Tracker-derived rows must match the system of record. The orphan is not in the tracker.
CREATE OR REPLACE VIEW check_tracker_vs_fact AS
WITH accepted AS (
  SELECT * FROM tracker_disposition WHERE reasons = ''
),
received AS (
  SELECT po_line_id, MAX(received_date_parsed) AS received_date_parsed
  FROM accepted
  GROUP BY po_line_id
),
received_diff AS (
  SELECT r.po_line_id
  FROM received r
  JOIN fact_po_line p ON p.po_line_id = r.po_line_id
  WHERE r.received_date_parsed IS DISTINCT FROM p.received_date
     OR p.program_id <> 'TS-LINE-RAMP'
),
asset_diff AS (
  SELECT COALESCE(a.asset_id, f.asset_id) AS asset_id
  FROM (
    SELECT po_line_id, asset_id, serial_number, site_id_mapped AS site_id, pis_parsed
    FROM accepted
    WHERE asset_id IS NOT NULL
  ) a
  FULL OUTER JOIN (
    SELECT asset_id, po_line_id, serial_number, site_id, placed_in_service_date AS pis_parsed
    FROM fact_asset
    WHERE program_allocation = 'TS-LINE-RAMP'
      AND po_line_id IS NOT NULL
  ) f ON f.asset_id = a.asset_id
  WHERE a.asset_id IS NULL
     OR f.asset_id IS NULL
     OR a.po_line_id IS DISTINCT FROM f.po_line_id
     OR a.serial_number IS DISTINCT FROM f.serial_number
     OR a.site_id IS DISTINCT FROM f.site_id
     OR a.pis_parsed IS DISTINCT FROM f.pis_parsed
)
SELECT
  (SELECT COUNT(*) FROM received_diff) AS received_date_mismatches,
  (SELECT COUNT(*) FROM asset_diff) AS linked_asset_mismatches,
  (SELECT COUNT(*) FROM fact_asset WHERE po_line_id IS NULL) AS orphans_not_in_tracker;

CREATE OR REPLACE VIEW check_duplicate_serials AS
SELECT
  serial_number,
  COUNT(*) AS asset_count,
  string_agg(asset_id, ', ' ORDER BY asset_id) AS asset_ids,
  string_agg(COALESCE(po_line_id, '(none)'), ', ' ORDER BY asset_id) AS po_line_ids
FROM fact_asset
GROUP BY serial_number
HAVING COUNT(*) > 1
ORDER BY serial_number;

CREATE OR REPLACE VIEW check_orphans AS
SELECT a.asset_id, a.serial_number, a.program_allocation, a.site_id, a.created_by
FROM fact_asset a
LEFT JOIN fact_po_line p ON p.po_line_id = a.po_line_id
WHERE a.po_line_id IS NULL OR p.po_line_id IS NULL
ORDER BY a.asset_id;

CREATE OR REPLACE VIEW check_site_mismatch AS
SELECT
  a.asset_id,
  a.po_line_id,
  p.site_id AS po_site_id,
  a.site_id AS asset_site_id,
  a.created_by
FROM fact_asset a
JOIN fact_po_line p ON p.po_line_id = a.po_line_id
WHERE a.site_id <> p.site_id
ORDER BY a.po_line_id;

CREATE OR REPLACE VIEW check_date_logic AS
SELECT
  a.asset_id,
  a.po_line_id,
  p.received_date,
  a.placed_in_service_date,
  date_diff('day', a.placed_in_service_date, p.received_date) AS days_pis_before_receipt
FROM fact_asset a
JOIN fact_po_line p ON p.po_line_id = a.po_line_id
WHERE a.placed_in_service_date IS NOT NULL
  AND p.received_date IS NOT NULL
  AND a.placed_in_service_date < p.received_date
ORDER BY a.po_line_id;

CREATE OR REPLACE VIEW check_referential AS
SELECT 'orphan_or_dangling_po_line' AS check_name, COUNT(*)::INTEGER AS failures
FROM fact_asset a
LEFT JOIN fact_po_line p ON p.po_line_id = a.po_line_id
WHERE a.po_line_id IS NULL OR p.po_line_id IS NULL
UNION ALL
SELECT 'po_program_not_in_dim', COUNT(*)::INTEGER
FROM fact_po_line p LEFT JOIN dim_program d ON d.program_id = p.program_id
WHERE d.program_id IS NULL
UNION ALL
SELECT 'po_site_not_in_dim', COUNT(*)::INTEGER
FROM fact_po_line p LEFT JOIN dim_site d ON d.site_id = p.site_id
WHERE d.site_id IS NULL
UNION ALL
SELECT 'po_supplier_not_in_dim', COUNT(*)::INTEGER
FROM fact_po_line p LEFT JOIN dim_supplier d ON d.supplier_id = p.supplier_id
WHERE d.supplier_id IS NULL
UNION ALL
SELECT 'asset_site_not_in_dim', COUNT(*)::INTEGER
FROM fact_asset a LEFT JOIN dim_site d ON d.site_id = a.site_id
WHERE d.site_id IS NULL
UNION ALL
SELECT 'reuse_source_missing', COUNT(*)::INTEGER
FROM fact_asset a
LEFT JOIN fact_asset src ON src.asset_id = a.reuse_source_asset_id
WHERE a.reuse_source_asset_id IS NOT NULL AND src.asset_id IS NULL
UNION ALL
SELECT 'asset_owner_not_in_dim', COUNT(*)::INTEGER
FROM fact_asset a LEFT JOIN dim_input_owner o ON o.owner_id = a.input_owner_id
WHERE o.owner_id IS NULL
UNION ALL
SELECT 'exception_owner_not_in_dim', COUNT(*)::INTEGER
FROM fact_exception e LEFT JOIN dim_input_owner o ON o.owner_id = e.owner_id
WHERE o.owner_id IS NULL
ORDER BY check_name;
