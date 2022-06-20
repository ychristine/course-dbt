{{
  config(
    materialized='table'
  )
}}

/* USER LEVEL ORDER SUMMARY */

select  a.user_guid
        ,submitted_gmv
        ,promo_discount_redeemed
        ,submitted_orders
        ,submitted_gmv/submitted_orders::decimal as avg_order_value
        ,promo_orders
        ,shipped_orders
        ,delivered_orders
        ,b.first_order_guid
        ,b.first_checkout_date_utc
        ,b.last_order_guid
        ,b.last_checkout_date_utc
from {{ref('int_user_orders_grouped')}} a
left join {{ref('int_user_first_last_order')}} b on a.user_guid = b.user_guid



