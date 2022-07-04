{{
  config(
    materialized='table'
  )
}}


{% set event_types = dbt_utils.get_query_results_as_dict(
    "select distinct event_type from " ~ ref('int_events_all'))
    %}

WITH sessions as (
  select
    a.session_guid
    ,a.user_guid
    ,b.landing_page
    ,min(event_time_utc) as session_start_utc
    ,max(event_time_utc) as session_end_utc

    {% for event_type in event_types['event_type'] %}
    ,count(distinct case when event_type = '{{ event_type }}' then event_guid end) as total_{{ event_type }}_events
    {% endfor %}

  from {{ ref('int_events_all') }} a
  left join {{ref('int_session_landing_page')}} b on a.session_guid = b.session_guid
  {{ dbt_utils.group_by(n=3) }}
)
select
  s.*
  ,row_number() over(partition by user_guid order by session_start_utc asc) as visit_number
  ,date_trunc('year',session_start_utc) as year
  ,date_trunc('month',session_start_utc) as month
  ,date_trunc('week',session_start_utc) as week
  ,date_trunc('day',session_start_utc) as day
from sessions s
order by session_start_utc desc