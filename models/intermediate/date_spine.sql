{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2019-01-01' as date)",
    end_date="CAST(DATE_SUB( DATEADD( YEAR, 2, DATE_TRUNC('YEAR', CURRENT_DATE) ), 1) AS DATE)"
   )
}}

