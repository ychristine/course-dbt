{{
  config(
    materialized='table'
  )
}}

/* ORDERS WITH PRODUCTS PURCHASED INFORMATION, PRODUCT GUID, QUANTITY, NAME, PRICE. */

select
    oi.order_guid
    ,o.user_guid
    ,o.checkout_date_utc
    ,oi.product_guid
    ,oi.product_quantity
    ,p.product_name
    ,p.product_price
from {{ ref('stg_greenery__order_items') }} as oi
left join {{ ref('stg_greenery__orders') }} as o on oi.order_guid = o.order_guid
left join {{ ref('stg_greenery__products') }} as p on p.product_guid = oi.product_guid