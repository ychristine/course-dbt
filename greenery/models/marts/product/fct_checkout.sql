{{
  config(
    materialized='table'
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
    from {{ ref('int_events_all') }}
    where event_type = 'checkout'