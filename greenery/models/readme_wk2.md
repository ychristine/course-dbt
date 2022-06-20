# (Part 1) Models 

**What is our user repeat rate?**

80%

Using staging tables:

```
with user_orders as (
  select
    user_id,
    count(distinct order_id) as tot_orders
  from dbt_christine_y.stg_greenery__orders
  group by 1
  ),
buyer_counts as (
  select 
    count(distinct user_id) as tot_buyers
    ,count(distinct case when tot_orders > 1 then user_id else null end) as repeat_buyers
  from user_orders
  ),
final as (
  select 
    tot_buyers,
    repeat_buyers,
    repeat_buyers / tot_buyers::decimal as repeat_rate
  from buyer_counts
)
select * from final;
```

Alternatively, using new mart models:
```
with buyer_counts as (
  select 
    count(distinct case when submitted_orders > 0 then user_guid else null end) as tot_buyers
    ,count(distinct case when submitted_orders > 1 then user_guid else null end) as rpt_buyers
  from dbt_christine_y.fct_user_orders
)
select rpt_buyers/tot_buyers::decimal
from buyer_counts
```

**What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?**

Likely to purchase: Number/recency of sessions, on-platform engagements, first order value, number of items viewed.
Unlikely to purchase again: No recorded activity or bounced sessions/lack of engagement

# (Part 2) Tests 

**What assumptions are you making about each model? (i.e. why are you adding each test?)**

Basic assumptions on uniqueness of primary keys (if applicable), checking for null values, and positive values.

**Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?**

Didn't find this through testing but I noticed that there was an issue with the zip codes where the leading 0s disappear (this happened to me in real life too!), fixed this with by adding a transformation to the staging table.

**Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.**
I'm not sure exactly, but I would try to schedule the tests to run daily or as needed and email the output log to myself & data team.

