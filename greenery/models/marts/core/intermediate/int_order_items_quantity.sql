{{
  config(
    materialized='view'
  )
}}

/* AGGREGATE ORDER INFORMATION */

select
    order_guid
    ,count(distinct product_guid) as unique_products
    ,sum(product_quantity) as total_product_qty
from {{ ref('stg_greenery__order_items') }}
group by 1