{{
  config(
    materialized='view'
  )
}}

with events_grouped as (
select
        session_guid
        ,user_guid
        ,event_type
        ,count(distinct event_time_utc) as total_events
        ,count(distinct product_guid) as unique_products
from {{ ref('stg_greenery__events') }}
group by 1,2,3
),
add_to_cart as (
  select session_guid
         ,total_events as tot_add_to_carts
         ,unique_products as unique_products_added_to_cart
  from events_grouped
  where event_type = 'add_to_cart'
),
checkout as (
  select session_guid
         ,total_events as tot_checkouts
  from events_grouped
  where event_type = 'checkout'
),
pageviews as (
  select session_guid
         ,total_events as tot_pageviews
         ,unique_products as unique_products_viewed
  from events_grouped
  where event_type = 'page_view'
),
sessions as ( 
  select distinct session_guid from events_grouped
)
select a.session_guid
       ,coalesce(b.tot_pageviews,0) as tot_pageviews
       ,coalesce(b.unique_products_viewed,0) as unique_products_viewed
       ,coalesce(c.tot_add_to_carts,0) as tot_add_to_carts
       ,coalesce(c.unique_products_added_to_cart,0) as unique_products_added_to_cart
       ,coalesce(d.tot_checkouts,0) as tot_checkouts
from sessions a
left join pageviews b on a.session_guid = b.session_guid
left join add_to_cart c on c.session_guid = a.session_guid
left join checkout d on a.session_guid = d.session_guid