{{
  config(
    materialized='view'
  )
}}

select
        event_guid
        ,session_guid
        ,user_guid
        ,page_url
        ,event_time_utc
        ,event_type
        ,order_guid
        ,product_guid
        ,row_number() over(partition by session_guid order by event_time_utc asc) as hit_number
from {{ ref('stg_greenery__events') }}