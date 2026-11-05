# CapEx data-integrity model.
# Connection name is a placeholder. Point it at the BigQuery dataset
# you loaded in Path B. Looker does not store these rows.
# It generates SQL and runs it on the warehouse.

connection: "capex_bigquery_placeholder"

include: "*.view.lkml"
include: "capex_integrity_scorecard.dashboard.lookml"

# A cache with no trigger is a stale extract. This datagroup rebuilds when a
# new asset row is keyed, and at least every 24 hours if nothing changes.
# The PDT for aging and the PDT for person-dependent fields both use it.
# The book of record stays in the warehouse. The cache holds results.

datagroup: capex_daily {
  sql_trigger: SELECT MAX(created_at) FROM capex.fact_asset ;;
  max_cache_age: "24 hours"
  label: "CapEx daily"
  description: "Refresh when an asset row is keyed, and never serve a result older than a day."
}

# Explore 1. Starts at the PO line.
# Joining assets is one-to-many. That is the fan-out on line 00018.
# Program, site, and supplier are many-to-one and are not on the fan-out path.
# The input owner is not joined here. The owner is per field. Putting the
# owner on this explore would sit on the asset join.
# There is no default filter on received date. A hidden "received only"
# default would turn 38/40 into 38/38.

explore: po_lines {
  from: fact_po_line
  view_name: fact_po_line
  label: "PO lines"
  description: "Reconciliation. One row per PO line, assets joined one-to-many, counts distinct."
  persist_with: capex_daily

  # User attribute program_ids is set on the user by an admin.
  # The user cannot remove the filter.
  # Priya: TS-LINE-RAMP,PACK-CELL-EXP,FIXTURE-REUSE-24
  # Jordan: TS-LINE-RAMP
  # Morgan: TS-LINE-RAMP,PACK-CELL-EXP
  # The values come from user_program_map. Looker does not read that table
  # until someone loads them into the attribute.
  access_filter: {
    field: dim_program.program_id
    user_attribute: program_ids
  }

  join: fact_asset {
    type: left_outer
    relationship: one_to_many
    sql_on: ${fact_po_line.po_line_id} = ${fact_asset.po_line_id} ;;
  }

  join: dim_program {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_po_line.program_id} = ${dim_program.program_id} ;;
  }

  join: dim_site {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_po_line.site_id} = ${dim_site.site_id} ;;
  }

  join: dim_supplier {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_po_line.supplier_id} = ${dim_supplier.supplier_id} ;;
  }

  join: po_date_dim {
    from: dim_date
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_po_line.po_date} = ${po_date_dim.full_date} ;;
  }

  join: received_date_dim {
    from: dim_date
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_po_line.received_date} = ${received_date_dim.full_date} ;;
  }
}

# Explore 2. The exception queue, already bucketed.
# Different grain from po_lines. Do not join it into the reconciliation tile.
# Same access filter, so Jordan cannot see another program's queue either.
# In this file every exception is on TS-LINE-RAMP, so the test that bites
# is on the PO explore, where the other programs exist.

explore: exceptions {
  from: exception_aging
  view_name: exception_aging
  label: "Exceptions"
  description: "Open defects with an age bucket. Drill lands here from the scorecard."
  persist_with: capex_daily

  access_filter: {
    field: dim_program.program_id
    user_attribute: program_ids
  }

  join: dim_program {
    type: left_outer
    relationship: many_to_one
    sql_on: ${exception_aging.program_id} = ${dim_program.program_id} ;;
  }

  join: dim_input_owner {
    type: left_outer
    relationship: many_to_one
    sql_on: ${exception_aging.owner_id} = ${dim_input_owner.owner_id} ;;
  }

  join: dim_site {
    type: left_outer
    relationship: many_to_one
    sql_on: ${exception_aging.site_id} = ${dim_site.site_id} ;;
  }
}

# Explore 3. Not a third copy of the same question.
# Completeness is one row per asset per field. Person-dependent is one row
# per program per field. Both would multiply the PO-line denominator if they
# were joins on po_lines. They get their own explores, and the dashboard
# points each tile at the explore with the right grain.

explore: completeness {
  from: field_completeness
  view_name: field_completeness
  label: "Field completeness"
  description: "One row per asset per field. Filter to one field before you read the rate."
  persist_with: capex_daily

  access_filter: {
    field: dim_program.program_id
    user_attribute: program_ids
  }

  join: dim_program {
    type: left_outer
    relationship: many_to_one
    sql_on: ${field_completeness.program_id} = ${dim_program.program_id} ;;
  }

  join: dim_input_owner {
    type: left_outer
    relationship: many_to_one
    sql_on: ${field_completeness.owner_id} = ${dim_input_owner.owner_id} ;;
  }
}

explore: field_edits {
  from: person_dependent_fields
  view_name: person_dependent_fields
  label: "Person-dependent fields"
  description: "One row per program per field. The site filter is intentionally not on this explore. Splitting by site would call a field person-dependent at one site when the program has two editors."
  persist_with: capex_daily

  access_filter: {
    field: dim_program.program_id
    user_attribute: program_ids
  }

  join: dim_program {
    type: left_outer
    relationship: many_to_one
    sql_on: ${person_dependent_fields.program_id} = ${dim_program.program_id} ;;
  }

  join: dim_input_owner {
    type: left_outer
    relationship: many_to_one
    sql_on: ${person_dependent_fields.only_editor} = ${dim_input_owner.user_id} ;;
  }
}

# First-time-right is asset grain, including the orphan.
# The PO explore cannot see the orphan, so this explore is what the tile uses.

explore: assets {
  from: fact_asset
  view_name: fact_asset
  label: "Assets"
  description: "One row per asset. First-time-right and missing placed-in-service live here so the orphan stays in the denominator."
  persist_with: capex_daily

  join: dim_program {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_asset.program_allocation} = ${dim_program.program_id} ;;
  }

  join: dim_site {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_asset.site_id} = ${dim_site.site_id} ;;
  }

  join: dim_input_owner {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fact_asset.input_owner_id} = ${dim_input_owner.owner_id} ;;
  }

  access_filter: {
    field: dim_program.program_id
    user_attribute: program_ids
  }
}
