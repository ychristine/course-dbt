{{
    config(
        materialized = 'view'
    )

}}

with events_source as (
    select * from {{ source('src_greenery','events') }}
),

renamed_recast as (
    select
        event_id as event_guid
        ,session_id as session_guid
        ,user_id as user_guid
        ,page_url
        ,created_at as event_time_utc
        ,event_type
        ,order_id as order_guid
        ,product_id as product_guid
    from events_source
)

select * 
from renamed_recast