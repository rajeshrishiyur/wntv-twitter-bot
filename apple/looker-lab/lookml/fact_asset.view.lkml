# Grain: one row per tagged asset, plus the orphan that was keyed with no PO line.
# Measures on this view are count_distinct of asset_id or of po_line_id.
# asset_po_lines is 38 on TS-LINE-RAMP, not 39: the fan-out is one line,
# and the orphan has no po_line_id so it is not counted.

view: fact_asset {
  sql_table_name: capex.fact_asset ;;

  dimension: asset_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.asset_id ;;
    description: "The tagged asset. AST-TS-0017 is the asset on PO line 00017. AST-TS-0040 is the orphan, keyed with no PO line and not present on either tracker."
    link: {
      label: "Open the asset in the system of record"
      url: "https://capex.example.internal/asset/{{ value }}"
    }
  }

  dimension: serial_number {
    type: string
    sql: ${TABLE}.serial_number ;;
    description: "Identity of the physical unit. Two assets with one serial cannot be counted. SN-DUP-4421 and SN-DUP-4422 are the planted duplicates."
  }

  dimension: po_line_id {
    type: string
    sql: ${TABLE}.po_line_id ;;
    description: "The PO line this asset was tagged against. Null on the orphan. The GSM owns this link. Reconciliation does not start here; it starts at the PO line so an untagged line is still visible."
  }

  dimension: site_id {
    type: string
    sql: ${TABLE}.site_id ;;
    description: "Site on the asset, from the tracker after the code was mapped. Compare it to the PO receiving site. A code in the site list can still be the wrong site."
  }

  dimension_group: placed_in_service {
    type: time
    timeframes: [raw, date, week, month]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.placed_in_service_date ;;
    description: "The day depreciation starts. Not the ship date and not the day the CM unpacked the crate. Null means Finance has not capitalized the asset. Twelve assets on TS-LINE-RAMP are null. A date before received_date is a different defect, on line 00019."
  }

  dimension: cost_center {
    type: string
    sql: ${TABLE}.cost_center ;;
    description: "Which cost center carries the asset. The GSM owns the assignment. In this load the field is complete. Complete is not the same word as valid."
  }

  dimension: program_allocation {
    type: string
    sql: ${TABLE}.program_allocation ;;
    description: "Which program the asset serves. The TPM owns it. One editor in the last 90 days, so the field is person-dependent: if David is out, nobody else has touched it."
  }

  dimension: reuse_source_asset_id {
    type: string
    sql: ${TABLE}.reuse_source_asset_id ;;
    description: "The prior asset a reused fixture came from. The AME owns it. Required only when the PO line is a reused fixture. Twelve of twelve are filled. Dividing 12 by all 40 assets is the wrong denominator."
  }

  dimension: input_owner_id {
    type: string
    sql: ${TABLE}.input_owner_id ;;
    description: "Who submitted the asset row. Often the CM coordinator. The exception owner can be someone else: Finance owns placed-in-service even when Wei typed the asset."
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}.created_by ;;
    description: "Login that keyed the row. Not the editor of every field on the row. Person-dependent is computed from fact_field_edit, not from this column."
  }

  dimension_group: created {
    type: time
    timeframes: [raw, date, week, month]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.created_at ;;
    description: "When the row was keyed. The datagroup trigger watches the latest value so a weekend receipt is not hidden behind Friday's cache."
  }

  dimension: passed_validation_on_first_entry {
    type: yesno
    sql: ${TABLE}.passed_validation_on_first_entry = 1 ;;
    description: "1 if the first submit passed every check that existed that day. A later correction does not flip this. PO line 00017 stays 0 after Finance enters the date."
  }

  measure: asset_count {
    type: count_distinct
    sql: ${asset_id} ;;
    description: "Distinct assets. TS-LINE-RAMP is 40, including the orphan. count_distinct so a bad join cannot count an asset twice."
    drill_fields: [asset_id, po_line_id, serial_number, placed_in_service_date, site_id]
  }

  measure: missing_pis_count {
    type: count_distinct
    sql: ${asset_id} ;;
    filters: [placed_in_service_date: "NULL"]
    description: "Tagged assets with no placed-in-service date. TS-LINE-RAMP is 12 before the fix and 11 after. In-transit lines are not in this count. They have no asset."
    drill_fields: [asset_id, po_line_id, site_id, created_by, input_owner_id]
  }

  measure: pis_completeness {
    type: number
    sql: 1.0 * (${asset_count} - ${missing_pis_count}) / NULLIF(${asset_count}, 0) ;;
    value_format_name: percent_1
    description: "Assets with a placed-in-service date, divided by assets on the program. TS-LINE-RAMP is 28/40 = 70.0% before the fix. This is completeness, not validity. Line 00019 has a date, and the date is wrong."
  }

  measure: first_time_right_count {
    type: count_distinct
    sql: ${asset_id} ;;
    filters: [passed_validation_on_first_entry: "yes"]
    description: "Assets whose first submit passed. TS-LINE-RAMP is 21. The flag is not updated when someone fills a blank later."
  }

  measure: first_time_right_rate {
    type: number
    sql: 1.0 * ${first_time_right_count} / NULLIF(${asset_count}, 0) ;;
    value_format_name: percent_1
    description: "First-time-right. Certified denominator is every asset allocated to the program, including the orphan: 21/40 = 52.5%. From the PO explore the orphan disappears and the rate becomes 21/39."
    drill_fields: [asset_id, po_line_id, passed_validation_on_first_entry, placed_in_service_date, serial_number, site_id]
  }

  measure: asset_po_lines {
    type: count_distinct
    sql: ${po_line_id} ;;
    description: "Distinct PO lines referenced by assets. TS-LINE-RAMP is 38. The two assets on 00018 are one line. The orphan adds nothing, because its po_line_id is null."
  }
}

# Completeness is a different grain: one row per asset per field that applies.
# Do not join this into the reconciliation tile. It would multiply the denominator.
view: field_completeness {
  derived_table: {
    datagroup_trigger: capex_daily
    sql:
      SELECT a.program_allocation AS program_id, a.asset_id, a.site_id,
        'placed_in_service_date' AS field_name, 'OWN-FIN' AS owner_id,
        a.placed_in_service_date IS NOT NULL AS filled
      FROM capex.fact_asset a
      UNION ALL
      SELECT a.program_allocation, a.asset_id, a.site_id,
        'cost_center', 'OWN-GSM', a.cost_center IS NOT NULL
      FROM capex.fact_asset a
      UNION ALL
      SELECT a.program_allocation, a.asset_id, a.site_id,
        'program_allocation', 'OWN-TPM', a.program_allocation IS NOT NULL
      FROM capex.fact_asset a
      UNION ALL
      SELECT a.program_allocation, a.asset_id, a.site_id,
        'reuse_source_asset_id', 'OWN-AME', a.reuse_source_asset_id IS NOT NULL
      FROM capex.fact_asset a
      JOIN capex.fact_po_line p ON p.po_line_id = a.po_line_id
      WHERE p.equipment_type = 'reused_fixture'
      UNION ALL
      SELECT a.program_allocation, a.asset_id, a.site_id,
        'site_id',
        CASE a.created_by
          WHEN 'usr_wei_cma' THEN 'OWN-CMA'
          WHEN 'usr_jordan_cmb' THEN 'OWN-CMB'
          ELSE 'OWN-GSM'
        END,
        a.site_id IS NOT NULL
      FROM capex.fact_asset a ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.asset_id, '|', ${TABLE}.field_name) ;;
    description: "Asset plus field. The grain of completeness. Hidden because nobody filters on it."
  }

  dimension: program_id {
    type: string
    sql: ${TABLE}.program_id ;;
    description: "Program the asset is allocated to. The tile filters to TS-LINE-RAMP. Blending programs hides the 12 blanks, which exist only on the ramp."
  }

  dimension: asset_id {
    type: string
    sql: ${TABLE}.asset_id ;;
    description: "The asset being scored for this field."
  }

  dimension: site_id {
    type: string
    sql: ${TABLE}.site_id ;;
    description: "Asset site. The completeness tile can filter here. It is not the PO receiving site."
  }

  dimension: field_name {
    type: string
    sql: ${TABLE}.field_name ;;
    description: "The input being scored. Each field has its own owner and its own denominator."
  }

  dimension: owner_id {
    type: string
    sql: ${TABLE}.owner_id ;;
    description: "Who must fill this field. Finance for placed-in-service, even when a CM coordinator keyed the asset."
  }

  dimension: filled {
    type: yesno
    sql: ${TABLE}.filled ;;
    description: "True when the field is non-null. A filled date can still be before the received date. That failure is an exception, not a hole in this flag."
  }

  measure: denominator_count {
    type: count_distinct
    sql: ${asset_id} ;;
    description: "Assets for which this field applies. Reuse is 12, not 40."
  }

  measure: filled_count {
    type: count_distinct
    sql: ${asset_id} ;;
    filters: [filled: "yes"]
    description: "Assets where the field is non-null."
  }

  measure: missing_count {
    type: count_distinct
    sql: ${asset_id} ;;
    filters: [filled: "no"]
    description: "Assets where the field is null. Placed-in-service on TS-LINE-RAMP is 12 before the fix."
  }

  measure: completeness {
    type: number
    sql: 1.0 * ${filled_count} / NULLIF(${denominator_count}, 0) ;;
    value_format_name: percent_1
    description: "Filled divided by the field's own denominator, inside one field. Do not add the fields together."
  }
}
