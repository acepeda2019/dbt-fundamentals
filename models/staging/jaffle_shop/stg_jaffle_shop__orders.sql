with base as (
    select * from {{ source('jaffle_shop', 'orders') }} 
),

renamed as (
    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status as order_status_raw,
        case 
            when status like '%return%' then 'returned'
            when status like '%pending%' then 'placed'
            else status
        end as order_status,
        datediff( {{ dbt.current_timestamp() }}, order_date ) as days_since_last_order
    from base
)


select * from renamed
