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
        ,product_guid
        ,product_name
        ,product_price
    from {{ ref('int_events_all') }}
    where event_type = 'add_to_cart'