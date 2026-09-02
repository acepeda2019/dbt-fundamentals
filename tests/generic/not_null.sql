{% test not_null(model, column_name, date_sentinels=[], string_sentinels=[], number_sentinels=[]) %}

    {%- set date_sentinels = ['1900-01-01'] + date_sentinels -%}
    {%- set string_sentinels = ['0000'] + string_sentinels -%}
    {%- set number_sentinels = [] + number_sentinels -%}

    {%- set target_column = adapter.get_columns_in_relation(model) | selectattr('name', 'equalto', column_name) | first -%}
    {%- set dtype = (target_column.dtype | lower) if target_column else '' -%}
    {%- set is_date = 'date' in dtype or 'timestamp' in dtype -%}
    {%- set is_string = 'char' in dtype or 'string' in dtype -%}
    {%- set is_number = 'int' in dtype or 'decimal' in dtype or 'double' in dtype or 'float' in dtype or 'numeric' in dtype -%}
    
    {%- set sentinels = date_sentinels if is_date 
        else string_sentinels if is_string 
        else number_sentinels if is_number 
        else [] 
    -%}

    select *
    from {{ model }}
    where {{ column_name }} is null
    {%- if sentinels %}
       or {{ column_name }} in (
        {%- for s in sentinels -%}
            {%- if is_date -%}
                date('{{ s }}')
            {%- elif is_string -%}
                '{{ s }}'
            {%- else -%}
                {{ s }}
            {%- endif -%}
            {{ ", " if not loop.last }}
        {%- endfor %}
       )
    {%- endif %}

{% endtest %}
