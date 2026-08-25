{% set order_statuses = ['completed','placed','return_pending','returned','shipped'] %}


with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select order_id, sum(amount) as amount 
    from {{ ref('stg_stripe__payments') }}
    where payment_status = 'success'
    group by 1
),

pivoted as (
    select
        order_date,
        {% for status in order_statuses -%}
            SUM(CASE WHEN order_status = '{{ status }}' THEN amount ELSE 0 END) as {{ status }}
            {%- if not loop.last -%} , {% endif %}
        {% endfor %}
    from orders o
        left join payments p on o.order_id = p.order_id
    group by 1 order by 1 desc
)

select *
from pivoted

