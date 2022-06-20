{{
  config(
    materialized='table'
  )
}}
/* PRODUCT INFORMATION & QUANTITY IN INVENTORY */

    select
        product_guid
        ,product_name
        ,product_price
        ,inventory_quantity
    from {{ref('stg_greenery__products')}}