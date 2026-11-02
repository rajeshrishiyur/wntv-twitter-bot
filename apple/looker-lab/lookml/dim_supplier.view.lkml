# One row per supplier. Three lab suppliers. Not a real vendor list.
# Joined many-to-one from the PO line. Not on the fan-out path.

view: dim_supplier {
  sql_table_name: capex.dim_supplier ;;

  dimension: supplier_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.supplier_id ;;
    description: "Supplier key on the PO line. The GSM owns the buy. A missing supplier would be a referential failure. This load has none."
  }

  dimension: supplier_name {
    type: string
    sql: ${TABLE}.supplier_name ;;
    description: "The name on a tile when someone asks who shipped the line. The reconciliation rate does not need it, so the join stays off that tile."
  }
}
