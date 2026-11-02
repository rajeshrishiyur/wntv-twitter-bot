# One row per place an asset can be tagged.
# CM-A and CM-B are contract manufacturers. PLANT-01 is the internal plant.
# A code that is in this list can still be the wrong code for a PO line.

view: dim_site {
  sql_table_name: capex.dim_site ;;

  dimension: site_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.site_id ;;
    description: "Canonical site code after the tracker text is trimmed and mapped. A, Site A, and SITE-A all become CM-A. SITE-Z does not map, and that row is quarantined."
  }

  dimension: site_name {
    type: string
    sql: ${TABLE}.site_name ;;
    description: "The name on the scorecard filter. The filter on the PO explore is the PO receiving site, not the site someone typed on the asset."
  }

  dimension: site_type {
    type: string
    sql: ${TABLE}.site_type ;;
    description: "Contract manufacturer or internal plant. The plant is a real site. On PO line 00026 it is the wrong site."
  }
}
