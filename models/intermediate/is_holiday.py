import pandas
from pandas.tseries.holiday import USFederalHolidayCalendar


def model(dbt, session):
    dbt.config(
        materialized='table',
        submission_method='serverless_cluster',
        static_analysis='off',
        timeout=1800
    )

    df = dbt.ref('date_spine').toPandas()

    calendar = USFederalHolidayCalendar()
    us_holidays = set(
        calendar.holidays(start=df['date_day'].min(), end=df['date_day'].max()).date
    )
    df['is_holiday'] = df['date_day'].dt.date.isin(us_holidays)

    return df

