{{
  config(
    materialized='view'
  )
}}

/* ALL BUYERS ORDER SUMMARY */

    select  user_guid
            ,sum(order_cost) as submitted_gmv
            ,sum(promo_discount_amount) as promo_discount_redeemed
            ,count(distinct order_guid) as submitted_orders
            ,count(distinct case when promo_id is not null then order_guid else null end) as promo_orders
            ,count(distinct case when order_status in ('shipped','delivered') then order_guid else null end) as shipped_orders
            ,count(distinct case when order_status = 'delivered' then order_guid else null end) as delivered_orders
    from {{ref('fct_orders')}}
    group by 1