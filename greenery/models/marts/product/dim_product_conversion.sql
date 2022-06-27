{{
  config(
    materialized='table'
  )
}}


/* PRODUCT CONVERSION RATE */

with products_purchased as (

  select 
    product_guid
    ,sum(product_quantity) as qty_purchased
    ,count(distinct session_guid) as sessions_with_checkout
  from {{ref('fct_item_conversions')}}
  group by 1

),

sessions_with_pageview as (

  select 
    product_guid
    ,count(distinct session_guid) as sessions_with_pageview
    ,count(distinct event_guid) as total_pageviews
  from {{ref('fct_pageviews')}}
  group by 1

)

/* PRODUCT INFORMATION & QUANTITY IN INVENTORY */
    select
        p.product_guid
        ,p.product_name
        ,p.product_price
        ,p.inventory_quantity
        ,round((pp.sessions_with_checkout / sp.sessions_with_pageview)::numeric,6) as product_conversion_rate
    from {{ref('dim_products')}} p
    left join products_purchased pp on pp.product_guid = p.product_guid
    left join sessions_with_pageview sp on sp.product_guid = p.product_guid
