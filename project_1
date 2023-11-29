1.
select * from sales_dataset_rfm_prj;
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE numeric USING (trim(ordernumber)::numeric);
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE int USING (trim(quantityordered)::int);
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING (trim(priceeach)::numeric);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE int USING (trim(orderlinenumber)::int);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric(18,2) USING (trim(sales)::numeric(18,2));

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date 
USING (trim(orderdate):: date);
	  

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN status TYPE text; 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN productline TYPE varchar; 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN msrp TYPE int USING (trim(msrp)::int);
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN customername TYPE varchar; 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN phone TYPE varchar; 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN addressline1 TYPE varchar; 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN addressline2 TYPE varchar; 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN city TYPE varchar; 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN state TYPE char(20); 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN postalcode TYPE char(20); 

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN country TYPE char(20); 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN territory TYPE char(20);
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN contactfullname TYPE char(50);
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN dealsize TYPE char(20); 

2. 
select orderdate
from public.sales_dataset_rfm_prj_clean
where orderdate is null;
select QUANTITYORDERED
from public.sales_dataset_rfm_prj_clean
where QUANTITYORDERED is null;
select PRICEEACH
from public.sales_dataset_rfm_prj_clean
where PRICEEACH is null;
select ORDERLINENUMBER
from public.sales_dataset_rfm_prj_clean
where ORDERLINENUMBER is null;
select SALES
from public.sales_dataset_rfm_prj_clean
where SALES is null;
select ORDERDATE
from public.sales_dataset_rfm_prj_clean
where ORDERDATE is null;

3. 

update public.sales_dataset_rfm_prj_clean
set CONTACTFIRSTNAME = 
initcap(left (CONTACTFULLNAME,position ('-' in CONTACTFULLNAME) -1 )),
CONTACTLASTNAME = initcap (substring (CONTACTFULLNAME 
		   from position ('-' in CONTACTFULLNAME) +1 for 
		 10 ))
alter table sales_dataset_rfm_prj_clean
add column CONTACTFIRSTNAME varchar(50);
alter table sales_dataset_rfm_prj_clean
add column CONTACTLASTNAME varchar(50);

4.  
alter table public.sales_dataset_rfm_prj_clean 
add column QTR_ID int;
update sales_dataset_rfm_prj_clean
set QTR_ID = extract (quarter from orderdate);
alter table public.sales_dataset_rfm_prj_clean 
add column MONTH_ID int;
update sales_dataset_rfm_prj_clean
set MONTH_ID = extract (month from orderdate);
alter table public.sales_dataset_rfm_prj_clean 
add column YEAR_ID int;
update sales_dataset_rfm_prj_clean
set YEAR_ID = extract (year from orderdate);

5. --TIM OUTLIER  
with twt_min_max as (
select Q1 -1.5*IQR as min_value,Q3 +1.5*IQR as max_value
from (
select 
percentile_cont(0.25) within group(order by quantityordered ) as Q1,
percentile_cont(0.75) within group(order by quantityordered ) as Q3,
percentile_cont(0.75) within group(order by quantityordered ) - 
percentile_cont(0.25) within group(order by quantityordered ) as IQR
from public.sales_dataset_rfm_prj)), twt_outlier as (
select * from sales_dataset_rfm_prj
where quantityordered < (select min_value from twt_min_max ) 
or quantityordered > (select max_value from twt_min_max )) ;
--XU LY OUTLIER
update sales_dataset_rfm_prj
set quantityordered = (select avg (quantityordered)) 
in (select quantityordered from twt_outlier ) 

6.
create table sales_dataset_rfm_prj as (
SELECT * FROM SALES_DATASET_RFM_PRJ_CLEAN )
