### 
create database excelr001;
select*from factinternetsales;
use excelr001;
select*from factinternetsales;
select*from fact_internet_sales_new;

ALTER TABLE Fact_Internet_Sales_new
DROP COLUMN CustomerPONumber;

ALTER TABLE factinternetsales
DROP COLUMN CustomerPONumber;



### Q0  combine two tables
SELECT *
FROM factinternetsales

UNION ALL

SELECT *
FROM Fact_Internet_Sales_new;

CREATE TABLE sales AS
SELECT *
FROM factinternetsales

UNION ALL

SELECT *
FROM Fact_Internet_Sales_new;
select * from sales;

##### Q1  product name from product table to sales table

select* from dimproduct;
SELECT 
     s.SalesAmount,
    s.ProductKey,
   p.EnglishProductName,
    s.OrderDateKey
FROM sales s
LEFT JOIN dimproduct p
ON s.ProductKey = p.ProductKey;


####  2  customer full name from the customer table to sales table

select * from dimcustomer;
SELECT 
    s.SalesOrderNumber,
    
    concat(c.FirstName, ' ', c.LastName) AS CustomerFullName,
    
    
    s.SalesAmount,
    s.OrderDateKey

FROM sales s

LEFT JOIN dimcustomer c
    ON s.CustomerKey = c.CustomerKey

LEFT JOIN dimproduct p
    ON s.ProductKey = p.ProductKey;
    


##### Q 3 create date field from orderdatekey and year, month,quarter

SELECT 
    OrderDateKey,


    STR_TO_DATE(OrderDateKey, '%Y%m%d') AS OrderDate,

    -- A. Year
    YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Year,

    -- B. Month Number
    MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS MonthNo,

    -- C. Month Full Name
    MONTHNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS MonthFullName,

    -- D. Quarter (Q1,Q2,Q3,Q4)
    CONCAT('Q', QUARTER(STR_TO_DATE(OrderDateKey, '%Y%m%d'))) AS Quarter,

    -- E. YearMonth (YYYY-MMM)
    DATE_FORMAT(STR_TO_DATE(OrderDateKey, '%Y%m%d'), '%Y-%b') AS YearMonth,

    -- F. Weekday Number (1=Sunday, 7=Saturday)
    DAYOFWEEK(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS WeekdayNo,

    -- G. Weekday Name
    DAYNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS WeekdayName,

    -- H. Financial Month (April=1, March=12)
    CASE 
        WHEN MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) >= 4 
            THEN MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) - 3
        ELSE MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) + 9
    END AS FinancialMonth,

    -- I. Financial Quarter (April Start)
    CASE 
        WHEN MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q1'
        WHEN MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q2'
        WHEN MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4'
    END AS FinancialQuarter

FROM sales;



#### Q4  calculate sales amount

SELECT 
    UnitPrice,
    OrderQuantity,
    DiscountAmount,

    -- Calculate Sales Amount
    (UnitPrice * OrderQuantity * (1 - DiscountAmount)) AS SalesAmount

FROM sales;



### Q5  calculate production cost

SELECT 
    ProductStandardCost,
    OrderQuantity,
    (ProductStandardCost * OrderQuantity) AS ProductionCost
FROM sales;



#### Q6 calculate profit

SELECT 
    SalesAmount,
    ProductStandardCost,
    (SalesAmount - ProductStandardCost) AS Profit
FROM sales;









-- Find the total number of orders placed in Sales.
select count(*) as TotalOrders from `sales` ;

-- Find maximum sales amount placed in Sales.
select max(salesamount) as Maximumsales from `sales`;

--   List the top 5 products by total sales amount from from  Sales table.
select productKey, sum(salesamount) as Totalsales from `sales`
group by productkey
order by TotalSales desc
limit 5;


