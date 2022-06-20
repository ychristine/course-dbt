{{
  config(
    materialized='view'
  )
}}

/* ALL BUYERS AND FIRST/LAST ORDER INFORMATION */
WITH ordered as (
    select  user_guid
            ,order_guid
            ,checkout_date_utc
            ,row_number() over(partition by user_guid order by checkout_date_utc asc) as user_order_num_asc
            ,row_number() over(partition by user_guid order by checkout_date_utc desc) as user_order_num_desc
    from {{ref('stg_greenery__orders')}}
),
first_order as (
    select  user_guid
            ,order_guid as first_order_guid
            ,checkout_date_utc as first_checkout_date_utc
    from ordered
    where user_order_num_asc = 1
),
most_recent_order as ( 

    select  user_guid
            ,order_guid as last_order_guid
            ,checkout_date_utc as last_checkout_date_utc
    from ordered
    where user_order_num_desc = 1
)
select  a.user_guid
        ,a.first_order_guid
        ,a.first_checkout_date_utc
        ,b.last_order_guid
        ,b.last_checkout_date_utc
from first_order a
left join most_recent_order b on a.user_guid = b.user_guid