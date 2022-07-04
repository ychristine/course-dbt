{% macro distinct_sessions_with(column_name, threshold=1) %}

    count(distinct case when {{ column_name }} >= {{ threshold }} then session_guid end)

{% endmacro %}