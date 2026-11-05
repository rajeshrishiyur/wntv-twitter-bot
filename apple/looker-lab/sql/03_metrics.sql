-- Certified metrics. Dialect: DuckDB, executed for the answer key.
-- BigQuery: DATE_DIFF(as_of, opened, DAY) instead of date_diff('day', opened, as_of).
--           DATE_SUB(as_of, INTERVAL window_days DAY) instead of the interval multiply.
-- One definition of reconciled lives here. A tile does not get its own formula.
-- As-of date and the alert line are read from lab_parameters, not typed into each query.

CREATE OR REPLACE VIEW metric_reconciliation_by_program AS
SELECT
  p.program_id,
  COUNT(DISTINCT p.po_line_id) AS po_lines,
  COUNT(DISTINCT CASE WHEN a.asset_id IS NOT NULL THEN p.po_line_id END) AS lines_with_an_asset,
  COUNT(DISTINCT a.asset_id) AS assets_linked_to_a_line,
  COUNT(DISTINCT CASE WHEN p.received_date IS NOT NULL THEN p.po_line_id END) AS lines_with_a_received_date,
  ROUND(
    COUNT(DISTINCT CASE WHEN a.asset_id IS NOT NULL THEN p.po_line_id END) * 1.0
    / NULLIF(COUNT(DISTINCT p.po_line_id), 0),
    4
  ) AS reconciliation_rate
FROM fact_po_line p
LEFT JOIN fact_asset a ON a.po_line_id = p.po_line_id
GROUP BY p.program_id
ORDER BY p.program_id;

-- The certified rate is lines with at least one asset / lines on the program.
-- The other rows are the ways a second definition hides the two in-transit lines.
CREATE OR REPLACE VIEW metric_reconciliation_traps AS
WITH focus AS (
  SELECT p.program_in_focus AS program_id, p.alert_reconciliation_below
  FROM lab_parameters p
),
base AS (
  SELECT
    p.po_line_id,
    p.received_date,
    a.asset_id
  FROM fact_po_line p
  LEFT JOIN fact_asset a ON a.po_line_id = p.po_line_id
  JOIN focus f ON f.program_id = p.program_id
)
SELECT * FROM (
  SELECT
    'certified_lines_with_asset_over_lines' AS definition,
    'yes' AS certified,
    COUNT(DISTINCT CASE WHEN asset_id IS NOT NULL THEN po_line_id END) AS numerator,
    COUNT(DISTINCT po_line_id) AS denominator,
    ROUND(
      COUNT(DISTINCT CASE WHEN asset_id IS NOT NULL THEN po_line_id END) * 1.0
      / COUNT(DISTINCT po_line_id),
      4
    ) AS rate,
    '38/40. The two in-transit lines stay in the denominator.' AS why
  FROM base
  UNION ALL
  SELECT
    'trap_assets_over_lines',
    'no',
    COUNT(DISTINCT asset_id),
    COUNT(DISTINCT po_line_id),
    ROUND(COUNT(DISTINCT asset_id) * 1.0 / COUNT(DISTINCT po_line_id), 4),
    '39/40. Line 00018 has two assets, so one extra asset hides one missing line.'
  FROM base
  UNION ALL
  SELECT
    'trap_received_only',
    'no',
    COUNT(DISTINCT CASE WHEN asset_id IS NOT NULL AND received_date IS NOT NULL THEN po_line_id END),
    COUNT(DISTINCT CASE WHEN received_date IS NOT NULL THEN po_line_id END),
    ROUND(
      COUNT(DISTINCT CASE WHEN asset_id IS NOT NULL AND received_date IS NOT NULL THEN po_line_id END) * 1.0
      / COUNT(DISTINCT CASE WHEN received_date IS NOT NULL THEN po_line_id END),
      4
    ),
    '38/38. A default filter of received date drops the in-transit lines and the scorecard goes green.'
  FROM base
  UNION ALL
  SELECT
    'trap_program_assets_including_orphan_over_lines',
    'no',
    (SELECT COUNT(*) FROM fact_asset a JOIN focus f ON a.program_allocation = f.program_id),
    (SELECT COUNT(*) FROM fact_po_line p JOIN focus f ON p.program_id = f.program_id),
    ROUND(
      (SELECT COUNT(*) FROM fact_asset a JOIN focus f ON a.program_allocation = f.program_id) * 1.0
      / (SELECT COUNT(*) FROM fact_po_line p JOIN focus f ON p.program_id = f.program_id),
      4
    ),
    '40/40. The orphan has no PO line and still fills the hole if you count assets on the program.'
  FROM focus
) t;

CREATE OR REPLACE VIEW metric_fanout AS
SELECT
  'TS-LINE-RAMP' AS program_id,
  COUNT(*) AS joined_rows,
  COUNT(p.po_line_id) AS plain_count_po_line_id,
  COUNT(DISTINCT p.po_line_id) AS distinct_po_lines,
  COUNT(a.asset_id) AS plain_count_asset_id,
  COUNT(DISTINCT a.asset_id) AS distinct_assets_linked
FROM fact_po_line p
LEFT JOIN fact_asset a ON a.po_line_id = p.po_line_id
WHERE p.program_id = 'TS-LINE-RAMP';

CREATE OR REPLACE VIEW metric_fanout_line_00018 AS
SELECT
  p.po_line_id,
  p.qty,
  COUNT(*) AS joined_rows,
  COUNT(p.po_line_id) AS plain_count_po_line_id,
  COUNT(DISTINCT p.po_line_id) AS distinct_po_lines,
  COUNT(a.asset_id) AS asset_rows,
  string_agg(a.asset_id, ', ' ORDER BY a.asset_id) AS asset_ids
FROM fact_po_line p
JOIN fact_asset a ON a.po_line_id = p.po_line_id
WHERE p.po_line_id = '00018'
GROUP BY p.po_line_id, p.qty;

CREATE OR REPLACE VIEW metric_missing_pis AS
SELECT
  program_allocation AS program_id,
  COUNT(*) AS assets,
  COUNT(*) FILTER (WHERE placed_in_service_date IS NULL) AS missing_pis,
  COUNT(*) FILTER (WHERE placed_in_service_date IS NOT NULL) AS pis_filled,
  ROUND(
    COUNT(*) FILTER (WHERE placed_in_service_date IS NOT NULL) * 1.0 / COUNT(*),
    4
  ) AS pis_completeness
FROM fact_asset
GROUP BY program_allocation
ORDER BY program_allocation;

-- Completeness is non-null. It is not validity. Site is 100 percent complete and still has 3 mismatches.
-- Reuse uses the reuse lines as the denominator. 12/40 is the trap, and it is not this view.
CREATE OR REPLACE VIEW metric_completeness AS
WITH focus AS (
  SELECT program_in_focus AS program_id FROM lab_parameters
),
assets AS (
  SELECT a.*, p.equipment_type
  FROM fact_asset a
  LEFT JOIN fact_po_line p ON p.po_line_id = a.po_line_id
  JOIN focus f ON f.program_id = a.program_allocation
),
long_form AS (
  SELECT 'placed_in_service_date' AS field_name, 'OWN-FIN' AS owner_id,
         1 AS in_denominator, placed_in_service_date IS NOT NULL AS filled
  FROM assets
  UNION ALL
  SELECT 'cost_center', 'OWN-GSM', 1, cost_center IS NOT NULL FROM assets
  UNION ALL
  SELECT 'program_allocation', 'OWN-TPM', 1, program_allocation IS NOT NULL FROM assets
  UNION ALL
  SELECT 'reuse_source_asset_id', 'OWN-AME',
         CASE WHEN equipment_type = 'reused_fixture' THEN 1 ELSE 0 END,
         reuse_source_asset_id IS NOT NULL
  FROM assets
  UNION ALL
  SELECT 'site_id',
         CASE created_by
           WHEN 'usr_wei_cma' THEN 'OWN-CMA'
           WHEN 'usr_jordan_cmb' THEN 'OWN-CMB'
           ELSE 'OWN-GSM'
         END,
         1,
         site_id IS NOT NULL
  FROM assets
)
SELECT
  l.field_name,
  l.owner_id,
  o.person_name,
  o.role_name,
  COUNT(*) FILTER (WHERE l.in_denominator = 1) AS denominator,
  COUNT(*) FILTER (WHERE l.in_denominator = 1 AND l.filled) AS filled,
  COUNT(*) FILTER (WHERE l.in_denominator = 1 AND NOT l.filled) AS missing,
  ROUND(
    COUNT(*) FILTER (WHERE l.in_denominator = 1 AND l.filled) * 1.0
    / NULLIF(COUNT(*) FILTER (WHERE l.in_denominator = 1), 0),
    4
  ) AS completeness
FROM long_form l
LEFT JOIN dim_input_owner o ON o.owner_id = l.owner_id
GROUP BY l.field_name, l.owner_id, o.person_name, o.role_name
HAVING COUNT(*) FILTER (WHERE l.in_denominator = 1) > 0
ORDER BY l.field_name, l.owner_id;

CREATE OR REPLACE VIEW metric_reuse_denominator_trap AS
SELECT
  SUM(CASE WHEN p.equipment_type = 'reused_fixture' AND a.reuse_source_asset_id IS NOT NULL THEN 1 ELSE 0 END) AS reuse_filled,
  SUM(CASE WHEN p.equipment_type = 'reused_fixture' THEN 1 ELSE 0 END) AS reuse_denominator,
  COUNT(*) AS all_assets_denominator,
  ROUND(
    SUM(CASE WHEN p.equipment_type = 'reused_fixture' AND a.reuse_source_asset_id IS NOT NULL THEN 1 ELSE 0 END) * 1.0
    / NULLIF(SUM(CASE WHEN p.equipment_type = 'reused_fixture' THEN 1 ELSE 0 END), 0),
    4
  ) AS certified_reuse_completeness,
  ROUND(
    SUM(CASE WHEN a.reuse_source_asset_id IS NOT NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*),
    4
  ) AS trap_rate_if_denominator_is_every_asset
FROM fact_asset a
LEFT JOIN fact_po_line p ON p.po_line_id = a.po_line_id
WHERE a.program_allocation = (SELECT program_in_focus FROM lab_parameters);

CREATE OR REPLACE VIEW metric_exception_aging AS
SELECT
  CASE
    WHEN date_diff('day', e.opened_date, p.as_of_date) <= 7 THEN '0-7'
    WHEN date_diff('day', e.opened_date, p.as_of_date) <= 30 THEN '8-30'
    ELSE '31+'
  END AS aging_bucket,
  CASE
    WHEN date_diff('day', e.opened_date, p.as_of_date) <= 7 THEN 1
    WHEN date_diff('day', e.opened_date, p.as_of_date) <= 30 THEN 2
    ELSE 3
  END AS sort_key,
  COUNT(*) AS open_exceptions
FROM fact_exception e
CROSS JOIN lab_parameters p
WHERE e.closed_date IS NULL
GROUP BY 1, 2
ORDER BY sort_key;

CREATE OR REPLACE VIEW metric_exception_open AS
SELECT
  e.exception_id,
  e.defect_type,
  e.field_name,
  e.po_line_id,
  e.asset_id,
  e.owner_id,
  o.person_name,
  o.role_name,
  e.opened_date,
  date_diff('day', e.opened_date, p.as_of_date) AS age_days,
  CASE
    WHEN date_diff('day', e.opened_date, p.as_of_date) <= 7 THEN '0-7'
    WHEN date_diff('day', e.opened_date, p.as_of_date) <= 30 THEN '8-30'
    ELSE '31+'
  END AS aging_bucket,
  e.triage_class,
  e.detail
FROM fact_exception e
CROSS JOIN lab_parameters p
LEFT JOIN dim_input_owner o ON o.owner_id = e.owner_id
WHERE e.closed_date IS NULL
ORDER BY age_days DESC, e.exception_id;

CREATE OR REPLACE VIEW metric_first_time_right AS
SELECT
  program_allocation AS program_id,
  COUNT(*) AS assets,
  SUM(passed_validation_on_first_entry) AS passed_on_first_entry,
  COUNT(*) - SUM(passed_validation_on_first_entry) AS failed_on_first_entry,
  ROUND(SUM(passed_validation_on_first_entry) * 1.0 / COUNT(*), 4) AS first_time_right_rate
FROM fact_asset
GROUP BY program_allocation
ORDER BY program_allocation;

-- Reading first-time-right off the PO explore drops the orphan, because the
-- orphan has no PO line to join to. 21/39 is not the certified rate. 21/40 is.
CREATE OR REPLACE VIEW metric_ftr_trap_excluding_orphan AS
SELECT
  COUNT(*) AS linked_assets,
  SUM(passed_validation_on_first_entry) AS passed_on_first_entry,
  ROUND(SUM(passed_validation_on_first_entry) * 1.0 / COUNT(*), 4) AS rate_if_orphan_is_dropped
FROM fact_asset
WHERE program_allocation = (SELECT program_in_focus FROM lab_parameters)
  AND po_line_id IS NOT NULL;

CREATE OR REPLACE VIEW metric_first_time_right_all AS
SELECT
  COUNT(*) AS assets,
  SUM(passed_validation_on_first_entry) AS passed_on_first_entry,
  ROUND(SUM(passed_validation_on_first_entry) * 1.0 / COUNT(*), 4) AS first_time_right_rate
FROM fact_asset;

-- Person-dependent: a field edited by exactly one user inside the published window,
-- inside the program in focus. Drop the window and the prior TPM hides the flag
-- on program_allocation. See metric_person_dependent_without_window.
CREATE OR REPLACE VIEW metric_person_dependent AS
WITH bounds AS (
  SELECT
    as_of_date,
    as_of_date - window_days * INTERVAL 1 DAY AS window_start,
    program_in_focus
  FROM lab_parameters
),
windowed AS (
  SELECT e.field_name, e.edited_by
  FROM fact_field_edit e
  CROSS JOIN bounds b
  WHERE e.program_id = b.program_in_focus
    AND CAST(e.edited_at AS DATE) >= CAST(b.window_start AS DATE)
    AND CAST(e.edited_at AS DATE) <= b.as_of_date
)
SELECT
  w.field_name,
  COUNT(DISTINCT w.edited_by) AS editor_count,
  string_agg(DISTINCT w.edited_by, ', ' ORDER BY w.edited_by) AS edited_by,
  string_agg(
    DISTINCT COALESCE(o.person_name, w.edited_by),
    ', '
    ORDER BY COALESCE(o.person_name, w.edited_by)
  ) AS editor_names,
  (COUNT(DISTINCT w.edited_by) = 1) AS is_person_dependent
FROM windowed w
LEFT JOIN dim_input_owner o ON o.user_id = w.edited_by
GROUP BY w.field_name
ORDER BY is_person_dependent DESC, w.field_name;

CREATE OR REPLACE VIEW metric_person_dependent_without_window AS
SELECT
  e.field_name,
  COUNT(DISTINCT e.edited_by) AS editor_count,
  string_agg(DISTINCT e.edited_by, ', ' ORDER BY e.edited_by) AS edited_by,
  (COUNT(DISTINCT e.edited_by) = 1) AS is_person_dependent
FROM fact_field_edit e
WHERE e.field_name = 'program_allocation'
GROUP BY e.field_name;

CREATE OR REPLACE VIEW metric_rls_by_user AS
SELECT
  u.user_id,
  COUNT(DISTINCT u.program_id) AS programs_granted,
  COUNT(DISTINCT p.po_line_id) AS po_lines_visible,
  COUNT(DISTINCT CASE WHEN a.asset_id IS NOT NULL THEN p.po_line_id END) AS lines_with_an_asset,
  ROUND(
    COUNT(DISTINCT CASE WHEN a.asset_id IS NOT NULL THEN p.po_line_id END) * 1.0
    / NULLIF(COUNT(DISTINCT p.po_line_id), 0),
    4
  ) AS reconciliation_rate
FROM user_program_map u
JOIN fact_po_line p ON p.program_id = u.program_id
LEFT JOIN fact_asset a ON a.po_line_id = p.po_line_id
GROUP BY u.user_id
ORDER BY u.user_id;

-- Jordan's attribute does not include PACK-CELL-EXP. The AND cannot be cleared by him.
CREATE OR REPLACE VIEW metric_rls_jordan_pack AS
SELECT
  COUNT(*) AS pack_lines_jordan_can_see
FROM fact_po_line p
WHERE p.program_id = 'PACK-CELL-EXP'
  AND p.program_id IN (
    SELECT program_id FROM user_program_map WHERE user_id = 'usr_jordan_cmb'
  );

CREATE OR REPLACE VIEW metric_fix_proof AS
SELECT
  a.po_line_id,
  a.asset_id,
  a.placed_in_service_date,
  p.received_date,
  a.passed_validation_on_first_entry,
  e.exception_id,
  e.closed_date
FROM fact_asset a
JOIN fact_po_line p ON p.po_line_id = a.po_line_id
LEFT JOIN fact_exception e
  ON e.po_line_id = a.po_line_id
 AND e.field_name = 'placed_in_service_date'
 AND e.defect_type = 'missing_placed_in_service'
WHERE a.po_line_id = '00017';

CREATE OR REPLACE VIEW metric_scorecard AS
SELECT
  (SELECT program_in_focus FROM lab_parameters) AS program_id,
  (SELECT as_of_date FROM lab_parameters) AS as_of_date,
  r.po_lines,
  r.lines_with_an_asset,
  r.reconciliation_rate,
  (SELECT alert_reconciliation_below FROM lab_parameters) AS alert_below,
  (r.reconciliation_rate < (SELECT alert_reconciliation_below FROM lab_parameters)) AS alert_fires,
  m.missing_pis,
  m.pis_completeness,
  f.passed_on_first_entry,
  f.assets AS ftr_assets,
  f.first_time_right_rate,
  (SELECT open_exceptions FROM metric_exception_aging WHERE aging_bucket = '0-7') AS aging_0_7,
  (SELECT open_exceptions FROM metric_exception_aging WHERE aging_bucket = '8-30') AS aging_8_30,
  (SELECT open_exceptions FROM metric_exception_aging WHERE aging_bucket = '31+') AS aging_31_plus,
  (SELECT COUNT(*) FROM metric_person_dependent WHERE is_person_dependent) AS person_dependent_fields
FROM metric_reconciliation_by_program r
JOIN metric_missing_pis m ON m.program_id = r.program_id
JOIN metric_first_time_right f ON f.program_id = r.program_id
WHERE r.program_id = (SELECT program_in_focus FROM lab_parameters);
