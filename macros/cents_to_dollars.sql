{% macro cents_to_dollars(column_name, decimal=2) -%}
    round( {{ column_name }} * 1.0 / 100 , {{decimal}} )
{%- endmacro %}