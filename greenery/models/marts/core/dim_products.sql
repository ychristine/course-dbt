{{
  config(
    materialized='table'
  )
}}

/* PRODUCT INFORMATION & QUANTITY IN INVENTORY */
    select
        p.product_guid
        ,p.product_name
        ,p.product_price
        ,p.inventory_quantity
    from {{ref('stg_greenery__products')}} p
