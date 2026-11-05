# Five tiles. Each tile is a query, not a picture.
# Default program filter is TS-LINE-RAMP, published, not hidden.
# It does not drop the in-transit lines. Those lines are inside the program.
# The site filter is the PO receiving site on the reconciliation tile and the
# exception tile. On the asset tile and the completeness tile it is the asset
# site. Say that before you turn the filter. Person-dependent does not listen
# to site: a site split would flag a field that the program as a whole does not.
# Schedule is not in this file. It is a delivery: Monday 07:00, to the owners
# named on the completeness tile. The alert is separate. It fires when
# reconciliation_rate is below 0.98. That 0.98 is the lab's proposed line,
# rule R4, not a number this team has adopted.

- dashboard: capex_integrity_scorecard
  title: CapEx data-integrity scorecard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "PO-line reconciliation, exception age, field completeness by owner, first-time-right, and person-dependent fields. Program TS-LINE-RAMP. As-of 2026-03-16."
  refresh: 24 hours

  filters:
  - name: Program
    title: Program
    type: field_filter
    default_value: "TS-LINE-RAMP"
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: capex_integrity
    explore: po_lines
    listens_to_filters: []
    field: dim_program.program_id
  - name: Site
    title: Site
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    model: capex_integrity
    explore: po_lines
    listens_to_filters: []
    field: dim_site.site_id

  elements:
  - title: Reconciliation
    name: reconciliation
    model: capex_integrity
    explore: po_lines
    type: single_value
    fields: [fact_po_line.reconciliation_rate]
    limit: 500
    row: 0
    col: 0
    width: 8
    height: 4
    listen:
      Program: dim_program.program_id
      Site: dim_site.site_id
    note_text: "38/40 = 95.0% on TS-LINE-RAMP. Lines with an asset, over lines."

  - title: Exception aging
    name: exception_aging
    model: capex_integrity
    explore: exceptions
    type: looker_column
    fields: [exception_aging.aging_bucket, exception_aging.open_exceptions]
    sorts: [exception_aging.aging_bucket_sort]
    limit: 500
    row: 0
    col: 8
    width: 8
    height: 4
    listen:
      Program: dim_program.program_id
      Site: dim_site.site_id
    note_text: "Open queue. 7 in 0-7, 7 in 8-30, 7 in 31+. Drill is the exception list."

  - title: First-time-right
    name: first_time_right
    model: capex_integrity
    explore: assets
    type: single_value
    fields: [fact_asset.first_time_right_rate]
    limit: 500
    row: 0
    col: 16
    width: 8
    height: 4
    listen:
      Program: dim_program.program_id
      Site: dim_site.site_id
    note_text: "21/40 = 52.5%. Includes the orphan. A later fix does not move this."

  - title: Field completeness by owner
    name: completeness_by_owner
    model: capex_integrity
    explore: completeness
    type: looker_grid
    fields: [field_completeness.field_name, dim_input_owner.person_name, dim_input_owner.role_name, field_completeness.denominator_count, field_completeness.filled_count, field_completeness.missing_count, field_completeness.completeness]
    sorts: [field_completeness.field_name]
    limit: 500
    row: 4
    col: 0
    width: 14
    height: 6
    listen:
      Program: dim_program.program_id
      Site: field_completeness.site_id
    note_text: "Placed-in-service is 28/40. Site is complete and still has three mismatches on the queue."

  - title: Person-dependent fields
    name: person_dependent
    model: capex_integrity
    explore: field_edits
    type: looker_grid
    fields: [person_dependent_fields.field_name, person_dependent_fields.only_editor, person_dependent_fields.editor_count]
    filters:
      person_dependent_fields.is_person_dependent: "yes"
    sorts: [person_dependent_fields.field_name]
    limit: 500
    row: 4
    col: 14
    width: 10
    height: 6
    listen:
      Program: dim_program.program_id
    note_text: "Three fields, one editor each, last 90 days. The site filter does not apply here."
