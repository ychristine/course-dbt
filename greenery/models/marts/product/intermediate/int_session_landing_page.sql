
{{
  config(
    materialized='view'
  )
}}

select session_guid, page_url as landing_page
from {{ref('int_events_ordered')}}
where hit_number = 1
