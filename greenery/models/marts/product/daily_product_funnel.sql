{{
  config(
    materialized='table'
  )
}}

with product_funnel as (
    select  year
            ,month
            ,week
            ,day
            ,count(distinct session_guid) as total_sessions
            ,{{ distinct_sessions_with('total_page_view_events') }} as page_view_sessions
            ,{{ distinct_sessions_with('total_add_to_cart_events') }} as add_to_cart_sessions
            ,{{ distinct_sessions_with('total_checkout_events') }} as checkout_sessions
    from {{ref('dim_sessions')}}
    group by year, month, week, day
)
SELECT
  p.*
  ,page_view_sessions / total_sessions::numeric as page_view_cvr
  ,add_to_cart_sessions / total_sessions::numeric as add_to_cart_cvr
  ,checkout_sessions / total_sessions::numeric as checkout_cvr
from product_funnel p