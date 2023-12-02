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
