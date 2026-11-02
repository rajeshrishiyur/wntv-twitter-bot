# One row per input owner. Six people, six roles.
# GSM, TPM, AME, the two CM coordinators, Finance fixed assets.
# The names are lab labels so a tile has someone to point at.

view: dim_input_owner {
  sql_table_name: capex.dim_input_owner ;;

  dimension: owner_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.owner_id ;;
    description: "Who must close the field. This is the owner on the exception, which is not always the person who typed the row."
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
    description: "The login on the field-edit log. Person-dependent counts distinct user ids inside 90 days, not distinct display names."
  }

  dimension: person_name {
    type: string
    sql: ${TABLE}.person_name ;;
    description: "The name you say in the review. The join key is owner_id."
  }

  dimension: role_code {
    type: string
    sql: ${TABLE}.role_code ;;
    description: "GSM, TPM, AME, CM_A, CM_B, or FIN. The role is why the person is in the room."
  }

  dimension: role_name {
    type: string
    sql: ${TABLE}.role_name ;;
    description: "Global Supply Manager, Technical Program Manager, Advanced Manufacturing Engineer, CM site coordinator, or Finance fixed assets."
  }

  dimension: home_site_id {
    type: string
    sql: ${TABLE}.home_site_id ;;
    description: "Set for the two CM coordinators. Empty for the roles that are not tied to one site. Jordan's row-level security is on program, not on this column."
  }
}
