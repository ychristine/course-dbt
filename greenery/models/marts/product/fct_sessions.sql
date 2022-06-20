{{
  config(
    materialized='table'
  )
}}

with session_start_end as (
select
  session_guid
  ,user_guid
  ,min(event_time_utc) as session_start_utc
  ,max(event_time_utc) as session_end_utc
from  {{ ref('stg_greenery__events') }}
group by 1,2
)
select 
  a.session_guid
  ,a.user_guid
  ,session_start_utc
  ,session_end_utc - session_start_utc as session_length
  ,b.tot_pageviews
  ,b.unique_products_viewed
  ,b.tot_add_to_carts
  ,b.unique_products_added_to_cart
  ,b.tot_checkouts
  ,c.landing_page
from session_start_end a
left join {{ref('int_events_grouped')}} b on a.session_guid = b.session_guid
left join {{ref('int_session_landing_page')}} c on a.session_guid = c.session_guid