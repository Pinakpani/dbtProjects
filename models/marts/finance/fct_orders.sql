with orders as (

    select * from {{ ref('stg_jaffle_shop_orders') }}

),

payments as (

    select * from {{ ref('stg_stripe__payments') }}

),

order_payments as (
    select 
    order_id,
    sum(case when status='success' then payment_amount end) as order_amount
    from orders left join payments using(order_id)
    group by 1
),

final as (
    select 
        order_id,
        customer_id,
        order_date,
        coalesce(order_amount,0) as amount
        from orders o left join order_payments p using(order_id)    
)

select * from final