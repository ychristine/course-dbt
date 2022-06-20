{{
  config(
    materialized='table'
  )
}}

select
  *
from {{ ref('stg_greenery__events') }}
where event_type = 'page_view'