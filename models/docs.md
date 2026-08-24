{% docs customer_id %}
The unique identifier for a customer. Sourced from the `id` column in the
raw `jaffle_shop.customers` table and passed through unchanged as this
model's primary key, and to `stg_jaffle_shop__orders`, `dim_customers`,
and `fct_orders` as a foreign key linking each record back to a customer.
{% enddocs %}

{% docs order_id %}
The unique identifier for an order. Sourced from the `id` column in the
raw `jaffle_shop.orders` table and passed through to `stg_stripe__payments`
(as the `orderid` foreign key) and `fct_orders`, where it is used to join
orders to their payments.
{% enddocs %}

{% docs order_date %}
The date the order was placed.
{% enddocs %}

{% docs order_status %}
The current status of the order, e.g. `completed`, `placed`, `shipped`,
`return_pending`, or `returned`.
{% enddocs %}

{% docs customer_first_name %}
The customer's first name.
{% enddocs %}

{% docs customer_last_name %}
The customer's last name.
{% enddocs %}

{% docs payment_id %}
The unique identifier for a payment transaction. Sourced from the `id`
column in the raw `stripe.payments` table.
{% enddocs %}

{% docs payment_method %}
The method used to make the payment, e.g. credit card, bank transfer,
gift card, or coupon.
{% enddocs %}

{% docs payment_status %}
The status of the payment transaction: `success` or `fail`.
{% enddocs %}


{% docs lifetime_value %}
The total amount of successful payments associated with the order, summed from `stg_stripe__payments`.
{% enddocs %}