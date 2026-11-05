# One row per day, from 2025-06-01 through 2026-04-30.
# Role-playing: the explore joins this view more than once
# (PO date, received date, placed-in-service date) under different names.
# Do not put a measure on this view.

view: dim_date {
  sql_table_name: capex.dim_date ;;

  dimension: date_key {
    type: number
    sql: ${TABLE}.date_key ;;
    description: "YYYYMMDD integer. A convenience key. The join uses full_date."
  }

  dimension: full_date {
    primary_key: yes
    type: date
    sql: ${TABLE}.full_date ;;
    description: "The calendar day. Aging does not use this table. Aging uses the as-of date in lab_parameters so the bucket does not move while you are demoing."
  }

  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
    description: "Calendar year. A group-by, not a sum."
  }

  dimension: quarter {
    type: number
    sql: ${TABLE}.quarter ;;
    description: "Calendar quarter, 1 through 4."
  }

  dimension: month {
    type: number
    sql: ${TABLE}.month ;;
    description: "Calendar month number."
  }

  dimension: month_name {
    type: string
    sql: ${TABLE}.month_name ;;
    description: "Short month name for an axis. Not a measure."
  }

  dimension: week_of_year {
    type: number
    sql: ${TABLE}.week_of_year ;;
    description: "ISO week. The Monday delivery is a schedule, not this field."
  }

  dimension: day_of_week {
    type: number
    sql: ${TABLE}.day_of_week ;;
    description: "ISO day, Monday = 1. Used only to mark weekdays."
  }

  dimension: day_name {
    type: string
    sql: ${TABLE}.day_name ;;
    description: "Monday through Sunday."
  }

  dimension: is_weekday {
    type: yesno
    sql: ${TABLE}.is_weekday = 1 ;;
    description: "Weekday flag. This calendar does not know holidays. Do not pretend it does."
  }
}
