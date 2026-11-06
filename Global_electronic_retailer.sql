--create table--
drop table if exists customers
create table customers(
customerkey integer primary key,
gender varchar(60),
name varchar(70),
city varchar(100),
state_code varchar(60),
state varchar(70),
zip_code varchar(100),
country varchar(70),
continent varchar(70),
birthday date
);

--create table
drop table if exists products
create table products(
ProductKey integer primary key,
Product_Name varchar(255),
Brand varchar(60),
Color varchar(50),
"Unit Cost USD"
numeric(12,2), 
"Unit Price USD"
numeric(12,2),
SubcategoryKey integer,
Subcategory varchar(100),
CategoryKey integer,
Category varchar(100)
);

--create table
drop table if exists stores
create table stores(
StoreKey integer primary key,
Country varchar(90),
States varchar(40),
Square_Meters varchar(30),
Open_Date date
);

--create table
drop table if exists exchange_rates
create table exchange_rates(
dates date,
currency varchar(29),
exchange numeric(12,6)
);

--create table
drop table if exists sales
create table sales(
order_number varchar(70),
line_item integer,
order_date date,
delivery_date date,
customerkey integer references customers(customerkey), 
storekey integer references stores(storekey),
productkey integer references products(productkey),
quantity integer,
currency_code varchar(80)
);


select * from customers;
select * from products;
select * from stores;
select * from exchange_rates;
select * from sales;


-- 1)What is the total estimated sales revenue in USD?

select 
sum(p."Unit Price USD" * s.quantity)as total_estimated_sales
from products p
join sales s on p.productkey=s.productkey

-- 2)How many total units were sold?

select
sum(quantity)as total_unit_sold
from sales;

-- 3)How many unique orders were placed?

select
count(distinct order_number) as total_order
from sales;

-- 4)Which are the top 10 products by estimated revenue?

select
P.Product_Name,
SUM(s.Quantity * P."Unit Price USD") AS revenue_usd
FROM sales s
JOIN products p
    ON s.ProductKey = P.ProductKey
GROUP BY P.ProductKey, P.Product_Name
LIMIT 10;

-- 5)Which product categories generate the highest revenue?

select p.category,
sum(s.quantity*p."Unit Price USD")AS revenue_usd
from products p join sales s on p.productkey=s.productkey
group by p.category
order by revenue_usd desc

-- 6)Which countries generate the highest revenue?

select st.country,
sum(s.quantity *p."Unit Price USD")AS revenue_usd
from stores st join sales s on st.storekey=s.storekey
join products p on p.productkey=s.productkey
group by st.country
order by revenue_usd desc

-- 7)Which brands generate the highest revenue?

select p.brand,
sum(s.quantity*p."Unit Price USD") as highest_revenue
from products p
join sales s on p.productkey=s.productkey
group by p.brand
order by highest_revenue desc

-- 8)Who are the top 10 customers by estimated spending?

select c.CustomerKey,c.Name,c.Country,
sum(s.Quantity* p."Unit Price USD") as spending_usd
from sales s
join customers c on s.CustomerKey= c.CustomerKey
join products p on s.ProductKey = p.ProductKey
group by c.CustomerKey, c.Name, c.Country
order by spending_usd desc
limit 10;

-- 9)Which stores generate the highest revenue?

select st.storekey,st.country,st.states,
sum(s.quantity*p."Unit Price USD")as highest_revenue
from stores st join sales s on st.storekey=s.storekey
join products p on p.productkey=s.productkey
group by st.storekey,st.country,st.states
order by highest_revenue desc;

-- 10)What is the average delivery time in days?

select round
(avg(delivery_date-order_date),2) as average_delivery_time
from sales 
where delivery_date is not null
and order_date is not null

-- 11)Which products have never been sold?

select p.productkey,p.product_name
from products p 
left join sales s 
on p.productkey=s.productkey
where s.productkey is null

-- 12)Which customers have never purchased anything?

select c.customerkey,c.name,c.country
from customers c
left join sales s
on c.customerkey=s.customerkey
where s.customerkey is null;

-- 13)What is the monthly revenue trend?

select extract(month from order_date)as sales_month,
sum(s.quantity*p."Unit Price USD")AS revenue_trend
from sales s
join products p
on p.productkey=s.productkey
group by extract(month from order_date)
order by sales_month

-- 14)What is the month-over-month revenue growth percentage?

with monthly_sales as(
select
extract(month from s.Order_date) AS sales_month,
sum(s.Quantity * p."Unit Price USD") AS revenue
from sales s
join products p
on s.ProductKey = p.ProductKey
group by extract(month from s.Order_date)),
comparison as (
select
sales_month,
revenue,
lag(revenue) over (
order by sales_month) as previous_revenue
from monthly_sales)
select
sales_month,
revenue,
previous_revenue,
ROUND(100.0 * (revenue - previous_revenue) 
/ NULLIF(previous_revenue, 0),2) as growth_percentage
from comparison
order by  sales_month;

-- 15)What are the top three products in each category?

with product_sales as (
select
p.Category,
p.ProductKey,
p.Product_name,
sum(s.quantity * p."Unit Price USD") as revenue
from products p
join sales s
on p.ProductKey = s.ProductKey
group by p.Category,p.ProductKey,p.Product_name
),
ranked as (
select *,
dense_rank() over (
partition by Category
order by revenue DESC) as product_rank
fROM product_sales
)
select*
from ranked
where product_rank <= 3
order by Category, product_rank;

-- 16)Which customers purchased in multiple months?

select
customerKey,
count(distinct extract(month from Order_date))
as active_months
from sales
group by CustomerKey
having count(
distinct extract(month from Order_date)
) > 1
order by  active_months desc;

-- 17)Which gender contributes the highest estimated revenue?

select
c.Gender,
sum(s.quantity * p."Unit Price USD") AS revenue_usd
from sales s
join customers c
on s.CustomerKey=c.CustomerKey
join products p
on s.ProductKey = p.ProductKey
group by c.Gender
order by revenue_usd desc;

-- 18)What is the average order value?

with order_totals as (
select s.Order_number,
sum(s.quantity * p."Unit Price USD") AS order_revenue
from sales s
join products p
on s.ProductKey = p.ProductKey
group by s.Order_number)

select round(avg(order_revenue),2)
as average_order_value_usd
from order_totals;