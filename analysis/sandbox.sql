{# with 

orders as (
    select * from {{ ref('stg_jaffle_shop__orders')}}
),
payments as (
    select * from {{ ref('stg_stripe__payments') }}
    where payment_status='success'
),
final as (
    select 
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    sum(p.amount) as lifetime_value
from orders o
    left join payments p on o.order_id = p.order_id
group by 1,2,3,4
)

select sum(lifetime_value) from final; #}


select distinct order_status from {{ ref('fct_orders' )}}

