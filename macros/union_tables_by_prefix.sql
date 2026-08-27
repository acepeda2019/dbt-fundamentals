{%-  macro union_table_by_prefix(database, schema, prefix, columns=['*']) -%}

    {% set tables = dbt_utils.get_relations_by_prefix(database=database, schema=schema, prefix=prefix) %}

    {%- for table in tables %}
        select {{ columns | join(', ') }} 
        from {{ table }}
        {% if not loop.last %}
        UNION ALL
        {% endif -%}
    {%- endfor -%}

{%- endmacro -%}