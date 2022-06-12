{{
    config(
        materialized = 'view'
    )

}}

with orders_source as (
    select * from {{ source('src_greenery','orders') }}
),

renamed_recast as (
    select
        order_id
        ,user_id
        ,promo_id
        ,address_id
        ,created_at as checkout_date_utc
        ,order_cost
        ,shipping_cost
        ,order_total
        ,tracking_id
        ,shipping_service
        ,estimated_delivery_at as est_delivery_date_utc
        ,delivered_at as delivered_date_utc
        ,status
    from orders_source
)

select * 
from renamed_recast