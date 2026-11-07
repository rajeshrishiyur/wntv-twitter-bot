# Grain: one open or closed defect.
# Aging is not a column on the raw table. It is a derived table Looker
# persists in the warehouse (a PDT): the as-of date minus opened_date,
# bucketed 0-7, 8-30, and 31+. Closed rows are left out, so closing
# EX-PIS-00017 removes it from the 0-7 bucket on the next rebuild.
# The as-of date is lab_parameters (2026-03-16), not the wall clock,
# so the demo matches the answer key. In production you would use CURRENT_DATE
# and you would say so.

view: fact_exception {
  sql_table_name: capex.fact_exception ;;

  dimension: exception_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.exception_id ;;
    description: "One defect. EX-PIS-00017 is the blank placed-in-service date on PO line 00017. Closing it does not create a second row."
  }

  dimension: program_id {
    type: string
    sql: ${TABLE}.program_id ;;
    description: "Program the defect belongs to. The access filter on the exceptions explore uses this, same as the PO explore."
  }

  dimension: po_line_id {
    type: string
    sql: ${TABLE}.po_line_id ;;
    description: "PO line the defect is on. Null for the orphan, which has an asset and no line."
  }

  dimension: asset_id {
    type: string
    sql: ${TABLE}.asset_id ;;
    description: "Asset the defect is on. Null for the two in-transit lines, which have a line and no asset."
  }

  dimension: defect_type {
    type: string
    sql: ${TABLE}.defect_type ;;
    description: "missing_placed_in_service, duplicate_serial, orphan_asset, site_mismatch, pis_before_received, or in_transit_no_asset. The queue is typed so a review can close a class, not a color."
  }

  dimension: field_name {
    type: string
    sql: ${TABLE}.field_name ;;
    description: "The input that is wrong. The owner is the owner of this field, not whoever has the tracker open."
  }

  dimension: owner_id {
    type: string
    sql: ${TABLE}.owner_id ;;
    description: "Who closes it. Finance for the date. The CM coordinator for a serial or a site they typed. The GSM for the orphan and for in-transit."
  }

  dimension_group: opened {
    type: time
    timeframes: [raw, date, week, month]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.opened_date ;;
    description: "The day the defect was logged. Aging starts here, not on the day someone first typed the bad value. Publish that choice or two people will age the same row differently."
  }

  dimension_group: closed {
    type: time
    timeframes: [raw, date, week, month]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.closed_date ;;
    description: "The day the field was corrected in the system of record. Null while the defect is open. The lab starts with every row null."
  }

  dimension: site_id {
    type: string
    sql: ${TABLE}.site_id ;;
    description: "Site on the exception. For a line, this is the PO receiving site."
  }

  dimension: triage_class {
    type: string
    sql: ${TABLE}.triage_class ;;
    description: "go-live, fast-follow, or enhancement. Every row in this file is go-live, because the book is wrong without the fix. A nicer chart would be an enhancement, and this queue has none."
  }

  dimension: detail {
    type: string
    sql: ${TABLE}.detail ;;
    description: "One sentence on what is wrong and why the field matters. The review reads this, not a status color."
  }

  measure: exception_count {
    type: count_distinct
    sql: ${exception_id} ;;
    description: "Distinct exceptions. Open plus closed, unless the tile filters closed_date to null. The aging tile uses the derived table, which is already open-only."
    drill_fields: [exception_id, po_line_id, asset_id, field_name, owner_id, opened_date, defect_type, detail]
  }
}

view: exception_aging {
  derived_table: {
    datagroup_trigger: capex_daily
    sql:
      SELECT
        e.exception_id,
        e.program_id,
        e.po_line_id,
        e.asset_id,
        e.defect_type,
        e.field_name,
        e.owner_id,
        e.opened_date,
        e.site_id,
        e.triage_class,
        e.detail,
        DATE_DIFF(p.as_of_date, e.opened_date, DAY) AS age_days,
        CASE
          WHEN DATE_DIFF(p.as_of_date, e.opened_date, DAY) <= 7 THEN '0-7'
          WHEN DATE_DIFF(p.as_of_date, e.opened_date, DAY) <= 30 THEN '8-30'
          ELSE '31+'
        END AS aging_bucket
      FROM capex.fact_exception e
      CROSS JOIN capex.lab_parameters p
      WHERE e.closed_date IS NULL ;;
  }

  dimension: exception_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.exception_id ;;
    description: "The open exception. Closed rows are not in this table, so the bucket counts move when a close lands and the PDT rebuilds."
  }

  dimension: program_id {
    type: string
    sql: ${TABLE}.program_id ;;
    description: "Program, for the access filter and the dashboard filter."
  }

  dimension: po_line_id {
    type: string
    sql: ${TABLE}.po_line_id ;;
    description: "PO line, when the defect has one."
  }

  dimension: asset_id {
    type: string
    sql: ${TABLE}.asset_id ;;
    description: "Asset, when the defect has one."
  }

  dimension: defect_type {
    type: string
    sql: ${TABLE}.defect_type ;;
    description: "The class of defect. Drill lands on this so a bar is not a dead end."
  }

  dimension: field_name {
    type: string
    sql: ${TABLE}.field_name ;;
    description: "The input that is wrong."
  }

  dimension: owner_id {
    type: string
    sql: ${TABLE}.owner_id ;;
    description: "Who is on the hook to close it."
  }

  dimension_group: opened {
    type: time
    timeframes: [raw, date]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.opened_date ;;
    description: "The day the exception was opened. Age is as-of minus this day."
  }

  dimension: site_id {
    type: string
    sql: ${TABLE}.site_id ;;
    description: "Site on the exception."
  }

  dimension: triage_class {
    type: string
    sql: ${TABLE}.triage_class ;;
    description: "All 21 open rows are go-live."
  }

  dimension: detail {
    type: string
    sql: ${TABLE}.detail ;;
    description: "The sentence the owner acts on."
  }

  dimension: age_days {
    type: number
    sql: ${TABLE}.age_days ;;
    description: "Days from opened_date to the published as-of date, 2026-03-16. Age 7 is still the 0-7 bucket. Age 8 is 8-30."
  }

  dimension: aging_bucket {
    type: string
    sql: ${TABLE}.aging_bucket ;;
    description: "0-7, 8-30, or 31+. The 31+ rows are a close-out conversation, not a color. Before the fix the open counts are 7, 7, and 7."
    order_by_field: aging_bucket_sort
  }

  dimension: aging_bucket_sort {
    hidden: yes
    type: number
    sql: CASE ${aging_bucket} WHEN '0-7' THEN 1 WHEN '8-30' THEN 2 ELSE 3 END ;;
    description: "Sort key so 0-7 does not land after 31+ in an alphabetical axis."
  }

  measure: open_exceptions {
    type: count_distinct
    sql: ${exception_id} ;;
    description: "Open exceptions in the bucket. Drill goes to the rows, not to a second copy of the number."
    drill_fields: [exception_id, po_line_id, asset_id, field_name, owner_id, age_days, aging_bucket, detail]
  }
}
