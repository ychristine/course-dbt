{{
    config(
        materialized = 'view'
    )

}}

with products_source as (
    select * from {{ source('src_greenery','products') }}
),

renamed_recast as (
    select
        product_id as product_guid
        ,name as product_name
        ,price as product_price
        ,inventory as inventory_quantity
    from products_source
)

select * 
from renamed_recast