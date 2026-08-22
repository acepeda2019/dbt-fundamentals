{# {{ codegen.generate_model_yaml(
    model_names=['stg_jaffle_shop__orders']
) }} #}


-- CLI Command to create model and pipe it into a file
{# dbt --quiet run-operation generate_model_yaml --args '{"model_names": ["stg_stripe__payments"]}' > models/staging/stripe/_stg_stripe.yml #}



dbt --quiet run-operation generate_model_yaml --args '{"model_names": ["fct_orders","dim_customers"]}' > models/marts/_mrt_models.yml