{{
  config(
    materialized='view'
  )
}}

/** Add product information to events **/

select
    e.*
    ,p.product_name
    ,p.product_price
from {{ ref('stg_greenery__events') }} e
left join {{ ref('dim_products')}} p on e.product_guid = p.product_guid