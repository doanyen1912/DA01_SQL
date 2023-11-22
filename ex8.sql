--EX1: 
with erliest_date as(
  select *,
  first_value(order_date ) over (partition by customer_id order by order_date  ) as first_order
  from delivery) 
  
  select
  round((avg(order_date = customer_pref_delivery_date)*100),2)  as immediate_percentage 
  from erliest_date;
-- em lam ntn nhung dap an ra 42,86 khac voi dap an dung ac sua giup e aj-- 
--EX2: 
