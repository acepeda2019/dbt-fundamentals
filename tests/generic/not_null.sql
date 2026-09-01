{% test not_null(model, column_name) %}

select *
from {{ model }}
where 1=1
    and {{ column_name }} is null 
    and {{ column_name }} not in ('0000')
{% endtest %}