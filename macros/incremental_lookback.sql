{%- macro incremental_lookback(
    column_name, 
    lookback_days=3, 
    default_date='2020-01-01'
) %}

    {%- if is_incremental() -%}
        and {{ column_name }} >= (
            select coalesce( date_sub( max({{ column_name }}), {{lookback_days}}), cast('{{default_date}}' as date) ) 
            from {{ this }}
        )
        {%- endif %}

{%- endmacro -%}