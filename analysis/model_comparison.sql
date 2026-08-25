--------------------------------------------------------------------------------
-- Compare and Classify Query Results
--------------------------------------------------------------------------------

{# {% set old_query %}
  select * from {{ ref('dim_customers', v=1) }}
{% endset %}

{% set new_query %}
  select * from {{ ref('dim_customers', v=2) }}
{% endset %}

{% if execute %}
    {{ 
        audit_helper.compare_and_classify_query_results(
            old_query, 
            new_query, 
            primary_key_columns=['customer_id'], 
            columns=['customer_id', 'number_of_orders', 'first_order_date', 'most_recent_order_date']
        )
    }}
{% endif%} #}

--------------------------------------------------------------------------------
-- Compare Row Counts
--------------------------------------------------------------------------------

{% set old_relation = adapter.get_relation(
      database = "analytics",
      schema = "acepeda",
      identifier = "dim_customers_v1"
) -%}

{% set dbt_relation = ref('dim_customers',v=2) %}

{{ audit_helper.compare_row_counts(
    a_relation = old_relation,
    b_relation = dbt_relation
) }}