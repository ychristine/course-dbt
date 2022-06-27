{{
  config(
    materialized='table'
  )
}}



select
  {{ dbt_utils.surrogate_key(['session_guid', 'product_guid']) }} as surrogate_key
  ,c.*
  ,o.product_guid
  ,o.product_name
  ,o.product_quantity
  ,o.product_price
from {{ ref('fct_checkout') }} c
left join {{ ref('fct_order_items')}} o on o.order_guid = c.order_guid