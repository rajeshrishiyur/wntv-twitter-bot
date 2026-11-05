# Grain: one row per PO line. This is the grain of reconciliation.
# A plain count is wrong once fact_asset is joined, because PO line 00018
# has two assets. count_distinct on po_line_id is the symmetric aggregate.
# Looker can protect a count_distinct of the primary key from that fan-out.
# A ratio you write by hand is not protected. The certified ratio below is
# lines with an asset / lines, both count_distinct. For TS-LINE-RAMP that is 38/40.

view: fact_po_line {
  sql_table_name: capex.fact_po_line ;;

  dimension: po_line_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.po_line_id ;;
    description: "The PO line. Reconciliation counts this, not the asset and not the tracker row. Line 00017 is the record the lab closes. Line 00018 is the fan-out."
    link: {
      label: "Open the PO line in the system of record"
      url: "https://capex.example.internal/po-line/{{ value }}"
    }
  }

  dimension: po_number {
    type: string
    sql: ${TABLE}.po_number ;;
    description: "The purchase order this line sits on. Several lines share one PO. The grain of the rate is still the line."
  }

  dimension: program_id {
    type: string
    sql: ${TABLE}.program_id ;;
    description: "Program on the line. The access filter is applied through dim_program, which joins on this. Do not filter it out of the explore or the security join has nothing to bind to."
  }

  dimension: supplier_id {
    type: string
    sql: ${TABLE}.supplier_id ;;
    description: "Who the GSM bought from. Needed for a supplier tile. Not needed for the reconciliation rate, so that tile does not join the supplier."
  }

  dimension: site_id {
    type: string
    sql: ${TABLE}.site_id ;;
    description: "Receiving site on the PO, from the equipment list. Not the site the CM typed. The three mismatches are visible only when you compare this to the asset site."
  }

  dimension: equipment_type {
    type: string
    sql: ${TABLE}.equipment_type ;;
    description: "test_station, handler, instrument, fixture, reused_fixture, or pack_cell. Reuse completeness uses reused_fixture as its denominator. The other types are not in that denominator."
  }

  dimension: qty {
    type: number
    sql: ${TABLE}.qty ;;
    description: "Units on the line. Almost every line is 1. Line 00018 is 2, and it has two serialized assets. Quantity is not a measure you sum across a fan-out without count discipline."
  }

  dimension: unit_cost {
    type: number
    sql: ${TABLE}.unit_cost ;;
    value_format_name: usd
    description: "Unit cost on the line, for a tile that needs it. Do not add these up and call the sum a savings number. Reused fixtures are 0 because they are not a new buy."
  }

  dimension_group: po {
    type: time
    timeframes: [raw, date, week, month]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.po_date ;;
    description: "The day the PO line was placed. It has to be on or before the received date. This is the buy, not the day the asset was capitalized."
  }

  dimension_group: received {
    type: time
    timeframes: [raw, date, week, month]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.received_date ;;
    description: "The day the CM received the line. Null means in transit. A default filter that hides nulls drops lines 00039 and 00040 and makes reconciliation 38/38."
  }

  # --- measures ---
  # po_line_count is count_distinct of the primary key. Joining two assets
  # onto line 00018 does not make this 41. A type: count would.

  measure: po_line_count {
    type: count_distinct
    sql: ${po_line_id} ;;
    description: "Distinct PO lines. Certified denominator. TS-LINE-RAMP is 40, including the two lines still in transit."
    drill_fields: [po_line_id, program_id, site_id, received_date, fact_asset.asset_id]
  }

  measure: lines_with_an_asset {
    type: count_distinct
    sql: ${po_line_id} ;;
    filters: [fact_asset.asset_id: "-NULL"]
    description: "Distinct PO lines that have at least one asset. Certified numerator. TS-LINE-RAMP is 38. Line 00018 counts once, even though it has two assets."
  }

  measure: reconciliation_rate {
    type: number
    sql: 1.0 * ${lines_with_an_asset} / NULLIF(${po_line_count}, 0) ;;
    value_format_name: percent_1
    description: "Certified definition: distinct PO lines with at least one asset, divided by distinct PO lines. TS-LINE-RAMP is 38/40 = 95.0%. Not assets divided by lines."
    drill_fields: [po_line_id, site_id, received_date, fact_asset.asset_id, fact_asset.serial_number]
  }

  measure: plain_row_count_do_not_certify {
    type: count
    hidden: yes
    description: "Joined rows. TS-LINE-RAMP is 41, because line 00018 is in the join twice. Hidden so it cannot be dropped on a tile by accident."
  }

  measure: reconciliation_rate_asset_version_do_not_certify {
    type: number
    hidden: yes
    sql: 1.0 * ${fact_asset.asset_count} / NULLIF(${po_line_count}, 0) ;;
    value_format_name: percent_1
    description: "Assets linked to a line, divided by lines. TS-LINE-RAMP is 39/40 = 97.5%. The second asset on 00018 hides one in-transit line. Do not certify."
  }
}
