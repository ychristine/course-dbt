{{
  config(
    materialized='table'
  )
}}

select
  *
from {{ ref('stg_greenery__events') }}
where event_type = 'add_to_cart'