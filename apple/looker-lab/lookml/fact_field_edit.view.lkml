# Grain: one write of one field on one asset.
# This is how "person-dependent" is defined. created_by on the asset is the
# person who keyed the row, and a row has several fields with several owners.
# A field is person-dependent when exactly one user wrote it in the 90 days
# ending on the as-of date, inside the program you filtered.
# usr_prior_tpm wrote program_allocation in June 2025. That edit is outside
# the window. Drop the window and the field stops looking person-dependent,
# which hides the fact that only David has touched it since this program started.

view: fact_field_edit {
  sql_table_name: capex.fact_field_edit ;;

  dimension: edit_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.edit_id ;;
    description: "One field write. FE-FIX-00017 is the write Morgan makes in step 9. It does not exist in the starting file."
  }

  dimension: asset_id {
    type: string
    sql: ${TABLE}.asset_id ;;
    description: "The asset whose field was written."
  }

  dimension: program_id {
    type: string
    sql: ${TABLE}.program_id ;;
    description: "Program at the time of the write. The window is applied inside a program. Pack's site can look person-dependent because only Wei writes it there. Do not sum the flag across programs."
  }

  dimension: field_name {
    type: string
    sql: ${TABLE}.field_name ;;
    description: "The input that was written. Nulls have no row here. A blank placed-in-service date is the absence of an edit, which is why the twelve blanks do not add a second editor."
  }

  dimension: edited_by {
    type: string
    sql: ${TABLE}.edited_by ;;
    description: "The login that wrote the field. Distinct count of this, inside the window, is the person-dependent test."
  }

  dimension_group: edited {
    type: time
    timeframes: [raw, date, week, month]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.edited_at ;;
    description: "When the field was written. The window is edited_at on or after 2025-12-16 and on or before 2026-03-16."
  }
}

view: person_dependent_fields {
  derived_table: {
    datagroup_trigger: capex_daily
    sql:
      SELECT
        e.program_id,
        e.field_name,
        COUNT(DISTINCT e.edited_by) AS editor_count,
        IF(COUNT(DISTINCT e.edited_by) = 1, ANY_VALUE(e.edited_by), NULL) AS only_editor
      FROM capex.fact_field_edit e
      CROSS JOIN capex.lab_parameters p
      WHERE e.edited_at >= TIMESTAMP(DATE_SUB(p.as_of_date, INTERVAL p.window_days DAY))
        AND e.edited_at < TIMESTAMP(DATE_ADD(p.as_of_date, INTERVAL 1 DAY))
      GROUP BY e.program_id, e.field_name ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.program_id, '|', ${TABLE}.field_name) ;;
    description: "Program plus field. Hidden. The tile groups on field_name inside one program."
  }

  dimension: program_id {
    type: string
    sql: ${TABLE}.program_id ;;
    description: "Program the edits belong to. Filter this. Do not add the yes-flags across programs."
  }

  dimension: field_name {
    type: string
    sql: ${TABLE}.field_name ;;
    description: "The input. On TS-LINE-RAMP the person-dependent fields are placed_in_service_date, program_allocation, and reuse_source_asset_id."
  }

  dimension: editor_count {
    type: number
    sql: ${TABLE}.editor_count ;;
    description: "Distinct users who wrote the field in the window. One means person-dependent."
  }

  dimension: only_editor {
    type: string
    sql: ${TABLE}.only_editor ;;
    description: "The single user, when editor_count is 1. Null when more than one person has written the field."
  }

  dimension: is_person_dependent {
    type: yesno
    sql: ${editor_count} = 1 ;;
    description: "Yes when exactly one user wrote this field in the last 90 days on this program. The knowledge leaves with that person."
  }

  measure: person_dependent_field_count {
    type: count
    filters: [is_person_dependent: "yes"]
    description: "How many fields on the filtered program are person-dependent. TS-LINE-RAMP is 3. This count is of fields, not of edits."
    drill_fields: [field_name, only_editor, editor_count]
  }
}
