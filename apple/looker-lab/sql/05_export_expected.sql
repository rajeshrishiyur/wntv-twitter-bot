-- Writes the answer key from the views in 02 and 03.
-- Run from the looker-lab directory, before 04, for the open-queue numbers.
-- run_local.py runs it again after 04 into data/expected_outputs/after_fix.

COPY check_go_nogo TO 'data/expected_outputs/go_nogo.csv' (HEADER, DELIMITER ',');
COPY check_quarantine_rows TO 'data/expected_outputs/quarantine_rows.csv' (HEADER, DELIMITER ',');
COPY check_tracker_vs_fact TO 'data/expected_outputs/tracker_vs_fact.csv' (HEADER, DELIMITER ',');
COPY check_duplicate_serials TO 'data/expected_outputs/duplicate_serials.csv' (HEADER, DELIMITER ',');
COPY check_orphans TO 'data/expected_outputs/orphans.csv' (HEADER, DELIMITER ',');
COPY check_site_mismatch TO 'data/expected_outputs/site_mismatches.csv' (HEADER, DELIMITER ',');
COPY check_date_logic TO 'data/expected_outputs/date_logic.csv' (HEADER, DELIMITER ',');
COPY check_referential TO 'data/expected_outputs/referential.csv' (HEADER, DELIMITER ',');
COPY metric_reconciliation_by_program TO 'data/expected_outputs/reconciliation_by_program.csv' (HEADER, DELIMITER ',');
COPY metric_reconciliation_traps TO 'data/expected_outputs/reconciliation_traps.csv' (HEADER, DELIMITER ',');
COPY metric_fanout TO 'data/expected_outputs/fanout_program.csv' (HEADER, DELIMITER ',');
COPY metric_fanout_line_00018 TO 'data/expected_outputs/fanout_line_00018.csv' (HEADER, DELIMITER ',');
COPY metric_missing_pis TO 'data/expected_outputs/missing_pis.csv' (HEADER, DELIMITER ',');
COPY metric_completeness TO 'data/expected_outputs/completeness_by_field_owner.csv' (HEADER, DELIMITER ',');
COPY metric_reuse_denominator_trap TO 'data/expected_outputs/reuse_denominator_trap.csv' (HEADER, DELIMITER ',');
COPY metric_exception_aging TO 'data/expected_outputs/exception_aging.csv' (HEADER, DELIMITER ',');
COPY metric_exception_open TO 'data/expected_outputs/exception_open.csv' (HEADER, DELIMITER ',');
COPY metric_first_time_right TO 'data/expected_outputs/first_time_right.csv' (HEADER, DELIMITER ',');
COPY metric_first_time_right_all TO 'data/expected_outputs/first_time_right_all.csv' (HEADER, DELIMITER ',');
COPY metric_ftr_trap_excluding_orphan TO 'data/expected_outputs/first_time_right_trap.csv' (HEADER, DELIMITER ',');
COPY metric_person_dependent TO 'data/expected_outputs/person_dependent_fields.csv' (HEADER, DELIMITER ',');
COPY metric_person_dependent_without_window TO 'data/expected_outputs/person_dependent_without_window.csv' (HEADER, DELIMITER ',');
COPY metric_rls_by_user TO 'data/expected_outputs/rls_by_user.csv' (HEADER, DELIMITER ',');
COPY metric_rls_jordan_pack TO 'data/expected_outputs/rls_jordan_pack.csv' (HEADER, DELIMITER ',');
COPY metric_fix_proof TO 'data/expected_outputs/fix_proof_00017.csv' (HEADER, DELIMITER ',');
COPY metric_scorecard TO 'data/expected_outputs/scorecard.csv' (HEADER, DELIMITER ',');
