{% macro select_rank(table_name, column_name, rank=1) %}

    select  *
    from {{table_name}}
    where {{column_name}} = {{order_rank}}

{% endmacro %}
