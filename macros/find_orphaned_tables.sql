{% macro find_orphaned_tables(
    database='analytics',
    schemas=['intermediate','snapshots','seeds','staging','marts']
) %}

{# what actually exists in the warehouse #}
{% set sql %}
    {% for schema in schemas %}
        select
            table_schema,
            table_name,
            CASE WHEN table_type = 'VIEW' THEN 'VIEW' ELSE 'TABLE' END as object_type
        from {{ database }}.information_schema.tables
        where table_schema = '{{ schema }}'
        {% if not loop.last %}
        UNION ALL
        {% endif %}
    {% endfor %}
{% endset %}

{% set existing_relations = run_query(sql) %}

{# what the dbt project currently defines, regardless of what's been built in any one environment #}
{% set expected_tables = [] %}
{% for node in graph.nodes.values() %}
    {% if node.resource_type in ['model', 'snapshot', 'seed'] and node.config.materialized != 'ephemeral' %}
        {% do expected_tables.append((node.schema ~ '.' ~ (node.alias or node.name)) | lower) %}

        {# dbt-fusion's databricks adapter auto-creates an unversioned pointer view
           (e.g. dim_customers -> dim_customers_v2) whenever a versioned model's `version`
           matches its `latest_version`. That pointer has no manifest node of its own, so
           it has to be accounted for here explicitly or it reads as orphaned. #}
        {% if node.version is not none and node.version == node.latest_version %}
            {% do expected_tables.append((node.schema ~ '.' ~ node.name) | lower) %}
        {% endif %}
    {% endif %}
{% endfor %}

{# anything in the warehouse with no corresponding node in the manifest is orphaned #}
{% set orphaned_drops = [] %}
{% for row in existing_relations %}
    {% set relation_key = (row[0] ~ '.' ~ row[1]) | lower %}
    {% if relation_key not in expected_tables %}
        {% do orphaned_drops.append('DROP ' ~ row[2] ~ ' ' ~ (database | upper) ~ '.' ~ (row[0] | upper) ~ '.' ~ row[1] ~ ';') %}
    {% endif %}
{% endfor %}

{% if orphaned_drops | length > 0 %}
    {{ log('Orphaned objects in ' ~ database ~ ' (exist in the warehouse, not defined anywhere in the dbt project):\n\n    ' ~ (orphaned_drops | join('\n    ')), info=True) }}
{% else %}
    {{ log('No orphaned objects found in ' ~ database ~ '.', info=True) }}
{% endif %}

{% endmacro %}
