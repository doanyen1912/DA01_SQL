--1 
/*Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)*/ 
select count(distinct user_id) as total_user,
count(order_id)as total_order,
 format_date('%Y-%m', created_at) as month
from bigquery-public-data.thelook_ecommerce.order_items
 where status = 'Complete'
 and
 format_date('%Y-%M', created_at) between '2019-01' and '2022-04'
 group by  1
 order by 1
=> so luong mua hang va so luong don hang deu tang 

--2 
/*Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng */

select count(distinct user_id ) as total_user,
round(avg (sale_price ),2 ) as avg_price,
format_date ('%y-%m',created_at) as month
 from  bigquery-public-data.thelook_ecommerce.order_items
 group by 1
order by 1
=> ca gia tri trung binh va luong khach moi thang deu tang theo thoi gian

--3 
/*Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
first_name, last_name, gender, age, tag (hiển thị youngest nếu trẻ tuổi nhất, oldest nếu lớn tuổi nhất)
*/ 

with twt_min as (select first_name, last_name, gender, age,
min(age) over (partition by gender) as min_age,
 format_date('%Y-%m', created_at) as month
 from bigquery-public-data.thelook_ecommerce.users
 where  format_date('%Y-%M', created_at) between '2019-01' and '2022-04') 
 , twt_max as (
  select first_name, last_name, gender, age,
max(age) over (partition by gender) as max_age,
 format_date('%Y-%m', created_at) as month
 from bigquery-public-data.thelook_ecommerce.users
 where  format_date('%Y-%M', created_at) between '2019-01' and '2022-04'
 )
-- do tuoi nho nhat = 12 , co 1067 nguoi 12 tuoi, 519 nguoi la nu gioi , 548 nguoi la nam gioi
select first_name, last_name, gender, age, 'youngest' as tag
from twt_min 
where age = min_age 
and gender = 'F'/'M'

--do tuoi lon nhat la 70, co 1053 nguoi co do tuoi bang 70, co 522 nu gioi va 531 nam gioi 
select first_name, last_name, gender, age, 'oldest' as tag
from twt_max 
where age = max_age 
and gender = 'F'/'M' 

-- cau nay e kbt tao bang temp e tao bi loi nhg chua bt sua o dau -- 

--4 
/*Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm).
month_year ( yyyy-mm), product_id, product_name, sales, cost, profit, rank_per_month 
*/
with product_sale as (
select 
format_date('%Y-%m', a.created_at) as month_year, b.id as product_id, b.name as product_name,sum(a.sale_price) as sales,round(sum(b.cost),2) as cost,
round(sum(a.sale_price) - sum(b.cost),2) as profit
from bigquery-public-data.thelook_ecommerce.order_items as a 
join bigquery-public-data.thelook_ecommerce.products as b
on a.product_id = b.id
group by 1,2,3
order by 1),
ranking as (
select month_year,product_id, product_name, sales, cost, profit,
dense_rank() over(partition by month_year order by product_sale.profit) as rank_per_month
from product_sale ) 

select *
from ranking where rank_per_month <= 5 
order by month_year 

--5: 
/*Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
Output: dates (yyyy-mm-dd), product_categories, revenue
*/ 
select format_date('%Y-%m-%d', b.created_at) as dates,
c.category as product_categories, round(sum(b.sale_price),2) as revenue
from bigquery-public-data.thelook_ecommerce.orders as a 
join bigquery-public-data.thelook_ecommerce.order_items as b 
on a.order_id = b.id
join bigquery-public-data.thelook_ecommerce.products as c  
on c.id = b.product_id 
where format_date('%Y-%m-%d', b.created_at) between '2022-02-1' and '2022-04-16'
group by 1,2
order by 1,round(sum(b.sale_price),2) 


--PART 2--
--create view vw_vw_ecommerce_analyst as (
with vw_vw_ecommerce_analyst as (
with bang_1 as (
select 
format_date('%Y-%m', a.created_at) as year_month,
c.category as product_category,
round (sum(b.sale_price),2) as TPV,
round (sum(b.order_id),2) as TPO,
sum(cost) as Total_cost,
sum(retail_price) - sum(cost)  as Total_profit,
round(sum(retail_price) - sum(cost) / sum(cost),2 ) as Profit_to_cost_ratio
from bigquery-public-data.thelook_ecommerce.orders as a 
join bigquery-public-data.thelook_ecommerce.order_items as b 
on a.order_id = b.id
join bigquery-public-data.thelook_ecommerce.products as c 
on b.product_id = c.id 
group by a.created_at ,c.category, format_date('%Y-%m', a.created_at)
order by format_date('%Y-%m', a.created_at) 
)

/*(doanh thu tháng sau-doanh thu tháng trước)/doanh thu tháng trước
 (số đơn hàng tháng sau - số đơn hàng tháng trước)/số đơn tháng trước"*/
,this_month as (
SELECT year_month,
SUM(TPV)  as sum_sale,
lead(SUM(TPV)) over (order by year_month ) as next_ms,
sum(TPO) as sum_order,
lead(sum(TPO)) over (order by year_month ) as next_mo
from bang_1
group by year_month 
order by year_month)

,growth as (select *,
concat((round(((sum_sale - next_ms )/sum_sale),2)),'%') as Revenue_growth ,
concat((round(((sum_order - next_mo )/sum_order),2)),'%') as Order_growth 
from this_month
 
 )
select *
from bang_1 as d 
join growth as e  
on d.year_month = e.year_month
)

--cohort chart--
with cte as (
  select 
  format_date('%Y-%m', first) as cohort_date,date,
  ((extract year from date ) - (extrac year from first)) *12 
  +  ((extract month from date ) - (extrac month from first)) + 1 as index 
  from (
    select user_id,created_at as date,
    min(created_at) over(partition by user_id) as first 
    from bigquery-public-data.thelook_ecommerce.order_items 
    where created_at between '2019-01-01' and '2019-05-01'
  )
   
),
cte1 as (
  select cohort_date,index,count(distinct user_id ) as count_user
  from cte 
  group by cohort_date,index
),
cohort as (
  select cohort_date,
  sum (case when index =1 then count_user else 0 end) as m1,
  sum (case when index =2 then count_user else 0 end) as m2,
  sum (case when index =3 then count_user else 0 end) as m3,
  sum (case when index =4 then count_user else 0 end) as m4
  from cte1 
  group by cohort_date
  order by cohort_date
)
select cohort_date,
round(100.00*m1/m1,2)||'%' as m1,
round(100.00*m2/m1,2)||'%' as m2,
round(100.00*m3/m1,2)||'%' as m3,
round(100.00*m4/m1,2)||'%' as m4
from cohort
-- visualize--
with cte as (
  select user_id,
  format_date('%Y-%m', first) as cohort_date,date,
  ((extract year from date ) - (extrac year from first)) *12 
  +  ((extract month from date ) - (extrac month from first)) + 
  1 as index 
  from (
    select user_id,created_at as date,
    min(created_at) over(partition by user_id) as first 
    from bigquery-public-data.thelook_ecommerce.order_items 
    where created_at between '2019-01-01' and '2019-05-01'
  )
   
)
select cohort_date,index,count(distinct user_id) as count_user
from cte 
group by cohort_date, index
order by cohort_date, index
