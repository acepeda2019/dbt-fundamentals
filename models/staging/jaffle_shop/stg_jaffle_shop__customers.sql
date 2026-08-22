with base as (
    select * from {{ source('jaffle_shop', 'customers') }}
),

renamed as (
    select  
        id as customer_id,
        first_name,
        last_name,
        first_name || ' ' || last_name as customer_name
    from base
)

select * from renamed