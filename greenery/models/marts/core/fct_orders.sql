{{
  config(
    materialized='table'
  )
}}

select
        o.order_guid
        ,o.user_guid
        ,o.checkout_date_utc
        ,row_number() over(partition by o.user_guid order by o.checkout_date_utc asc) as user_order_num
        ,oi.unique_products
        ,oi.total_product_qty
        ,o.order_cost
        ,o.shipping_cost
        ,o.order_total
        ,o.promo_id
        ,p.promo_discount_amount

        /* shipping fields */
        ,o.address_id as delivery_address
        ,o.tracking_id
        ,o.shipping_service
        ,o.est_delivery_date_utc
        ,o.delivered_date_utc
        ,date_trunc('day', delivered_date_utc - est_delivery_date_utc) as days_delivered_after_est
        ,o.order_status
from {{ ref('stg_greenery__orders') }} as o
left join {{ ref('int_order_items_quantity') }} as oi on oi.order_guid = o.order_guid
left join {{ ref('stg_greenery__promos') }} as p on p.promo_id = o.promo_id