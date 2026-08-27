{% macro find_all_datatypes() %}

    {% set models={} %}

    {% for node in graph.nodes.values() %}
        {% if node.resource_type in ['model','snapshot','seed'] and node.config.materialized != 'ephemeral' %}

            {% set rel = api.Relation.create(database=node.database, schema=node.schema, identifier=node.alias or node.name) %}
            {% set columns_dict={} %}

            {% for col in adapter.get_columns_in_relation(rel) %}
                {% do columns_dict.update({ col.name:col.dtype }) %}
            {% endfor %}

            {% do models.update( { node.name:columns_dict } ) %}

        {% endif %}
    {% endfor %}


    {% set lines = [] %}
    {% for table_name, columns in models.items() %}
        {% if columns | length == 0 %}
            {% do lines.append(table_name ~ ':') %}
        {% else %}
            {% set col_lines = [] %}
            {% for col_name, data_type in columns.items() %}
                {% do col_lines.append('    ' ~ col_name ~ ': ' ~ data_type) %}
            {% endfor %}
            {% do lines.append(table_name ~ ':\n' ~ (col_lines | join('\n'))) %}
        {% endif %}
    {% endfor %}

    {{ log('Pulling all column data types: \n\n' ~ (lines | join('\n')), info=True) }}
{% endmacro %}