{{
    config(
        materialized = 'view'
    )

}}

with addresses_source as (
    select * from {{ source('src_greenery','addresses') }}
),

renamed_recast as (
    select
        address_id as address_guid
        ,address
        ,case when length(zipcode::varchar) < 5 then '0'||zipcode::varchar else zipcode::varchar end as zipcode
        ,state
        ,country
    from addresses_source
)

select * 
from renamed_recast