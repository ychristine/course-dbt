{{
  config(
    materialized='table'
  )
}}

/* CONTAINS ALL USER INFORMATION */

select u.user_guid
        , u.first_name
        , u.last_name
        , u.email
        , u.phone_number
        , u.created_time_utc
        , u.updated_time_utc
        , u.address_guid
        , a.address
        , a.zipcode
        , a.state
        , a.country
from {{ref('stg_greenery__users')}} as u
left join {{ref('stg_greenery__addresses')}} as a on a.address_guid = u.address_guid