**How many users do we have?**

```
select 
  count(distinct user_id) as total_users
from dbt_christine_y.stg_greenery__users
```

**Answer:** 130

**On average, how many orders do we receive per hour?**

```
with hourly_orders as (
  select
    checkout_date_utc::date as day,
    extract(hour from checkout_date_utc) as hour,
    count(distinct order_id) as total_orders
  from dbt_christine_y.stg_greenery__orders
  group by 1,2
  ),
final as (
  select avg(total_orders) as average
  from hourly_orders
)
select * from final
```

**Answer:** 7.52

**On average, how long does an order take from being placed to being delivered?**

```
with delivery_times as (
  select
    order_id,
    checkout_date_utc,
    delivered_date_utc,
    delivered_date_utc-checkout_date_utc as time_to_delivery
  from dbt_christine_y.stg_greenery__orders
  ),
final as (
  select avg(time_to_delivery) 
  from delivery_times
  )
select * from final;
```

**Answer:** 3 days 21 hrs

**How many users have only made one purchase? Two purchases? Three+ purchases?**

```
with user_order_counts as (
  select
    user_id,
    count(distinct order_id) as num_orders
  from dbt_christine_y.stg_greenery__orders
  group by 1
  ),
final as (
  select 
    case when num_orders >= 3 then '3+'
         else num_orders::varchar end as num_orders,
    count(distinct user_id) as num_users
  from user_order_counts
  group by 1
  order by 1 asc
  )
select * from final;
```

**Answer:** 25 (1 purchase), 28 (2 purchases), 71 (3+ purchases)

**On average, how many unique sessions do we have per hour?**

```
with sessions_per_hour as (
  select
    event_time_utc::date as session_date,
    extract(hour from event_time_utc) as hour,
    count(distinct session_id) as unique_sessions
  from dbt_christine_y.stg_greenery__events
  group by 1,2
  ),
final as (
  select 
    avg(unique_sessions)
  from sessions_per_hour
  order by 1 asc
  )
select * from final;
```

**Answer:** 16.3