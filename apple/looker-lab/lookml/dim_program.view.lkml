# One row per program. The access filter binds to program_id.
# TS-LINE-RAMP is the program being onboarded. The other two are already
# on the system of record, and they are why an unfiltered blend looks finished.

view: dim_program {
  sql_table_name: capex.dim_program ;;

  dimension: program_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.program_id ;;
    description: "The program key. Row-level security filters on this, so a contract manufacturer cannot clear it and see another program."
  }

  dimension: program_name {
    type: string
    sql: ${TABLE}.program_name ;;
    description: "The name a GSM or a TPM says out loud. The id is what the join uses."
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    description: "Onboarding or sustaining. The scorecard default is the onboarding program, because that is where the inputs are still moving off the tracker."
  }

  dimension: line_of_business {
    type: string
    sql: ${TABLE}.line_of_business ;;
    description: "Which line of business the program serves. A label for the filter, not a measure."
  }

  dimension: equipment_list_count {
    type: number
    sql: ${TABLE}.equipment_list_count ;;
    description: "How many PO lines the approved equipment list says this program has. For TS-LINE-RAMP that number is 40, and it was published before the tracker arrived."
  }

  dimension: notes {
    type: string
    sql: ${TABLE}.notes ;;
    description: "Why this program is in the lab. Not a field anyone types on a PO."
  }
}
