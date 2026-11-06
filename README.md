Global Retailer Sales Analytic

An end-to-end sales analytics project using SQL (PostgreSQL) and Power BI to explore retail sales performance across products, customers, brands, categories, countries, stores, and time.

Portfolio note: Revenue in the SQL analysis is calculated as Quantity × Unit Price USD. It is therefore an estimated sales revenue metric, not necessarily recognized revenue. The current SQL queries do not apply the Exchange_Rates table to convert transaction currencies.

-- Project Overview

Retail sales data can be used to understand what sells, who purchases, which markets perform well, and how sales change over time. This project combines relational data analysis in SQL with interactive Power BI reporting to help answer those business questions.

---- Objectives

Measure estimated sales revenue, units sold, and unique orders.
Identify high-performing products, categories, brands, customers, and countries.
Review monthly sales trends and month-over-month revenue changes.
Calculate average order value and average delivery time.
Find products that have never been sold and customers who have never purchased.
Present findings in an interactive Power BI dashboard.
Tools & Skills
-- SQL / PostgreSQL: table creation, joins, aggregations, GROUP BY, HAVING, CTEs, LAG(), DENSE_RANK(), date calculations, and subqueries. --power BI:** KPI cards, charts, slicers/filters, interactive report exploration, and business insight presentation. --Data preparation: working with multiple CSV files and matching keys across fact and dimension tables. --Business analysis: sales performance, customer behavior, product performance, and delivery analysis.

Dataset
The project uses the following CSV files and a SQL script. The row counts below are based on the files used to prepare this README.

File	Rows	Purpose
Sales.csv	62,884	Sales transactions / line items, including order dates, customer, store, product, quantity, and currency code
Customers.csv	15,266	Customer attributes such as gender, location, country, continent, and birthday
Products.csv	2,517	Product name, brand, color, unit cost, unit price, subcategory, and category
Exchange_Rates.csv	11,215	Date, currency, and exchange-rate values
Global_electronic_retailer.sql	—	SQL table definitions and analysis queries
Global_electronic_retailer.pbix	—	Power BI report file
The SQL script also defines a stores table with store key, country, state, square meters, and open date. Include the corresponding stores CSV in the repository if it is part of your final project files.

Main tables
Sales: the central fact table, with one row per sales line item.
Customers: customer descriptive attributes.
Products: product, brand, price, and category details.
Stores: store country/state and store attributes.
Exchange Rates: exchange rate by date and currency.
Key relationships
Sales.CustomerKey → Customers.CustomerKey
Sales.ProductKey → Products.ProductKey
Sales.StoreKey → Stores.StoreKey
Exchange_Rates is available for currency-related analysis, but it is not applied in the current revenue calculations.

Business Questions Answered with SQL
The SQL script contains queries to investigate:

What is the total estimated sales revenue in USD?
How many total units were sold?
How many unique orders were placed?
What are the top 10 products by estimated revenue?
Which product categories generate the highest revenue?
Which countries generate the highest revenue?
Which brands generate the highest revenue?
Who are the top 10 customers by estimated spending?
Which stores generate the highest revenue?
What is the average delivery time in days?
Which products have never been sold?
Which customers have never purchased anything?
What is the monthly revenue trend?
What is the month-over-month revenue growth percentage?
What are the top three products in each category?
Which customers purchased in multiple months?
Which gender contributes the highest estimated revenue?
What is the average order value?
KPI Definitions
The following definitions describe the logic used in the SQL analysis. Use matching definitions in Power BI so the report and SQL results are consistent.

| KPI | Definition |

| Total Sales Revenue (USD) | SUM(Quantity × Unit Price USD) | | Total Units Sold | SUM(Quantity) | | Total Orders | COUNT(DISTINCT Order Number) | | Average Order Value (USD) | Average of each order's estimated revenue | | Average Delivery Time (Days) | Average of Delivery Date - Order Date, excluding missing dates | | Monthly Revenue | Estimated revenue grouped by order month | | Month-over-Month Growth (%) | (Current Month Revenue - Previous Month Revenue) / Previous Month Revenue × 100 |

Important calculation limitation: The current SQL queries multiply quantity by the product's USD unit price. They do not use the transaction's Currency Code or the Exchange_Rates table to convert prices. Describe this KPI as estimated revenue based on USD list price unless you update the calculation to apply exchange rates and any required business rules.

Power BI Dashboard
Open Global_electronic_retailer.pbix in Power BI Desktop to explore the report.

The report is intended to support analysis of:

Overall sales KPIs
Revenue by product category
Product and brand performance
Customer spending and top customers
Country/store performance where the available fields support it
Trends and business insights through interactive dashboard
How to Use This Project
1. Create the database and tables
Open PostgreSQL using pgAdmin or your preferred SQL client.
Create a database, for example global_retailer_sales.
Run Global_electronic_retailer.sql to create the tables.
Import each CSV into its matching table, ensuring date and numeric columns use compatible data types.
The supplied SQL script drops and recreates tables with DROP TABLE IF EXISTS; review it before running it in a database containing data you need to keep.

2. Run the analysis
Execute the analysis queries in Global_electronic_retailer.sql. Review the results and compare them with the corresponding Power BI measures and visuals.

--4. Open the Power BI report

Open Global_electronic_retailer.pbix in Power BI Desktop. If prompted, update the data-source paths or reconnect to the CSV/database sources, then refresh the report.

-- Key Takeaways

This project demonstrates an analytics workflow from relational data and SQL business questions to an interactive Power BI report. It focuses on measuring sales, comparing product and customer performance, understanding monthly trends, and identifying gaps such as unsold products or customers with no purchases.

-- Skills Demonstrated

SQL querying • Relational data modeling • Data aggregation • Window functions • CTEs • KPI definition • Power BI reporting • Interactive data exploration • Business analysis

Aspiring Data Analyst | SQL | Power BI
