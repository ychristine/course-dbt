{{
    config(
        materialized = 'view'
    )

}}

with promos_source as (
    select * from {{ source('src_greenery','promos') }}
),

renamed_recast as (
    select
        lower(promo_id) as promo_id
        ,discount as promo_discount_amount
        ,status as promo_status
    from promos_source
)

select * 
from renamed_recast