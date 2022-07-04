# PART 2: Modelling Challenge

**How are our users moving through the product funnel?**

| FUNNEL | SESSIONS WITH | CVR |
| -------- | ------ | --------- |
| PAGE VIEW | 578 | 100%  |
| ADD TO CART| 467 | 80.9%    |
| CHECKOUT | 361 | 62.5% |


```
with sessions_agg as (
select sum(total_sessions) as total_sessions
       ,sum(page_view_sessions) as page_view_sessions
       ,sum(add_to_cart_sessions) as add_to_cart_sessions
       ,sum(checkout_sessions) as checkout_sessions
from dbt_christine_y.daily_product_funnel
)
select s.*
       ,page_view_sessions / total_sessions as page_view_cvr
       ,add_to_cart_sessions / total_sessions as add_to_cart_cvr
       ,checkout_sessions / total_sessions as checkout_cvr
from sessions_agg s

```

**Which steps in the funnel have largest drop off points?**

Checkout has the largest drop off, with a conversion rate of 77% from add_to_cart.

```
with sessions_agg as (
select sum(total_sessions) as total_sessions
       ,sum(page_view_sessions) as page_view_sessions
       ,sum(add_to_cart_sessions) as add_to_cart_sessions
       ,sum(checkout_sessions) as checkout_sessions
from dbt_christine_y.daily_product_funnel
)
select page_view_sessions / total_sessions::numeric as page_view_cvr
       ,add_to_cart_sessions / page_view_sessions::numeric as add_to_cart_from_pageview_cvr
       ,checkout_sessions / add_to_cart_sessions::numeric as checkout_from_add_to_cart_cvr
from sessions_agg
```