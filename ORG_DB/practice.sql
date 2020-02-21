CREATE TABLE sales(
    sales_employee VARCHAR(50) NOT NULL,
    fiscal_year INT NOT NULL,
    sale DECIMAL(14,2) NOT NULL,
    PRIMARY KEY(sales_employee,fiscal_year)
);
 
INSERT INTO sales(sales_employee,fiscal_year,sale)
VALUES('Bob',2016,100),
      ('Bob',2017,150),
      ('Bob',2018,200),
      ('Alice',2016,150),
      ('Alice',2017,100),
      ('Alice',2018,200),
       ('John',2016,200),
      ('John',2017,150),
      ('John',2018,250);
 
SELECT * FROM sales;

select sum(sale) from sales;


select fiscal_year, sum(sale) from sales group by fiscal_year;

-- Window Functions -- Over
-- Like the aggregate functions with the GROUP BY clause, window functions
-- also operate on a subset of rows but they do not reduce the number of rows returned by the query.

-- Return the total sale for each employee along with the total sales of the employees by fiscal_year using window function 
select s.*,  sum(sale) over(partition by fiscal_year) from sales s;

-- Note that window functions are performed on the result set 
-- after all JOIN, WHERE, GROUP BY, and HAVING clauses, and 
-- before the ORDER BY, LIMIT and SELECT DISTINCT

-- general syntax of window function
-- window_function_name(expression) 
--    OVER (
--        [partition_defintion]
--        [order_definition]
--        [frame_definition]
--    )
    
-- ---------------------------------------------------------------------------------------------------------------------    
-- FIRST_VALUE() Window function example 

CREATE TABLE overtime (
    employee_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    hours INT NOT NULL,
    PRIMARY KEY (employee_name , department)
);

INSERT INTO overtime(employee_name, department, hours)
VALUES('Diane Murphy','Accounting',37),
('Mary Patterson','Accounting',74),
('Jeff Firrelli','Accounting',40),
('William Patterson','Finance',58),
('Gerard Bondur','Finance',47),
('Anthony Bow','Finance',66),
('Leslie Jennings','IT',90),
('Leslie Thompson','IT',88),
('Julie Firrelli','Sales',81),
('Steve Patterson','Sales',29),
('Foon Yue Tseng','Sales',65),
('George Vanauf','Marketing',89),
('Loui Bondur','Marketing',49),
('Gerard Hernandez','Marketing',66),
('Pamela Castillo','SCM',96),
('Larry Bott','SCM',100),
('Barry Jones','SCM',65);

-- ---------------------------------------------------------------------------------------------------------------------
-- The following statement gets the employee name, overtime, and the employee who has the least overtime:

select * from overtime;

select employee_name, hours, 
FIRST_VALUE(EMPLOYEE_NAME) OVER (ORDER BY HOURS) LEAST_OVER_TIME 
FROM OVERTIME;

-- ---------------------------------------------------------------------------------------------------------------------

SELECT EMPLOYEE_NAME, DEPARTMENT, HOURS, 
FIRST_VALUE(EMPLOYEE_NAME) OVER(PARTITION BY DEPARTMENT ORDER BY HOURS) LEAST_OVER_TIME 
FROM OVERTIME;

create table test1 (item int, start_date date, end_date date, discount int); 

insert into test1 values(1, '2019-06-01', '2019-06-10', 10);
insert into test1 values(1, '2019-06-11', '2019-06-11', 20);

delete from test1 where item =2;
select * from test1;

-- ---------------------------------------------------------------------------------------------------------------------

use practice;

CREATE TABLE t (
    val INT
);
 

-- ---------------------------------------------------------------------------------------------------------------------
-- RANK AND Dense Rank
-- ---------------------------------------------------------------------------------------------------------------------
CREATE TABLE t (val INT);
 
INSERT INTO t(val)
VALUES(1),(2),(2),(3),(4),(4),(5);
 
SELECT * FROM t;

SELECT val, dense_rank() over (order by val) my_rank 
from t;

SELECT VAL, RANK() OVER (ORDER BY VAL) MY_RANK, DENSE_RANK() OVER(ORDER BY VAL) MY_DENSE_RANK
FROM T;
-- ---------------------------------------------------------------------------------------------------------------------


-- ---------------------------------------------------------------------------------------------------------------------
-- LAG FUNCTION
-- ---------------------------------------------------------------------------------------------------------------------
SELECT * FROM SALES;

SELECT SALES_EMPLOYEE, FISCAL_YEAR, SALE, LAG(SALE, 1) OVER(ORDER BY SALES_EMPLOYEE, FISCAL_YEAR) AS PREV_YR_SALE
FROM SALES;

select * from orders;
select * from orderdetails;
select * from products;

WITH productline_sales AS (
	SELECT productline,
		   YEAR(orderDate) as order_year,
		   ROUND(SUM( quantityordered * priceeach), 0) order_value
	FROM orders
    INNER JOIN orderdetails USING (orderNumber)
    INNER JOIN products USING (productcode)
    GROUP BY productline, order_year
)
SELECT 
		productline,
        order_year,
        order_value,
        LAG(order_value, 1) OVER ( 
									PARTITION BY productline
									ORDER BY order_year
								 ) prev_year_order_value
FROM 
	productline_sales;
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
-- NTH VALUE
-- ---------------------------------------------------------------------------------------------------------------------
CREATE TABLE basic_pays(
    employee_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary INT NOT NULL,
    PRIMARY KEY (employee_name , department)
);
 
INSERT INTO 
 basic_pays(employee_name, 
    department, 
    salary)
VALUES
 ('Diane Murphy','Accounting',8435),
 ('Mary Patterson','Accounting',9998),
 ('Jeff Firrelli','Accounting',8992),
 ('William Patterson','Accounting',8870),
 ('Gerard Bondur','Accounting',11472),
 ('Anthony Bow','Accounting',6627),
 ('Leslie Jennings','IT',8113),
 ('Leslie Thompson','IT',5186),
 ('Julie Firrelli','Sales',9181),
 ('Steve Patterson','Sales',9441),
 ('Foon Yue Tseng','Sales',6660),
 ('George Vanauf','Sales',10563),
 ('Loui Bondur','SCM',10449),
 ('Gerard Hernandez','SCM',6949),
 ('Pamela Castillo','SCM',11303),
 ('Larry Bott','SCM',11798),
 ('Barry Jones','SCM',10586);

Select * from basic_pays order  by salary;
insert into basic_pays values('Deepankar Kotnala','Analytics',6627);


select
	employee_name,
    salary,
    department,
    NTH_VALUE(employee_name,1) over(partition by department order by salary) second_lowest_salary
    from basic_pays order by department;
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
-- NTILE
-- ---------------------------------------------------------------------------------------------------------------------
CREATE TABLE t (
    val INT NOT NULL
);
 
INSERT INTO t(val) 
VALUES(1),(2),(3),(4),(5),(6),(7),(8),(9);
 
SELECT * FROM t;

SELECT 
    val, 
    NTILE (4) OVER (
        ORDER BY val
    ) bucket
FROM 
    t group by val;  -- this group by is important
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
-- PERCENT_RANK 
-- ---------------------------------------------------------------------------------------------------------------------
CREATE TABLE productLineSales
SELECT
    productLine,
    YEAR(orderDate) orderYear,
    quantityOrdered * priceEach orderValue
FROM
    orderDetails
        INNER JOIN
    orders USING (orderNumber)
        INNER JOIN
    products USING (productCode)
GROUP BY
    productLine ,
    YEAR(orderDate);    



WITH t AS (
    SELECT
        productLine,
        SUM(orderValue) orderValue
    FROM
        productLineSales
    GROUP BY
        productLine
)
SELECT
    productLine,
    orderValue,
    ROUND(
       PERCENT_RANK() OVER (
          ORDER BY orderValue
       )
    ,2) percentile_rank
FROM
    t;
-- ---------------------------------------------------------------------------------------------------------------------

CREATE TABLE scores (
    name VARCHAR(20) PRIMARY KEY,
    score INT NOT NULL
);
 
INSERT INTO
 scores(name, score)
VALUES
 ('Smith',81),
 ('Jones',55),
 ('Williams',55),
 ('Taylor',62),
 ('Brown',62),
 ('Davies',84),
 ('Evans',87),
 ('Wilson',72),
 ('Thomas',72),
 ('Johnson',100);


select * from scores;

select name, score, 
row_number() over(order by score) row_num,
cume_dist() over(order by score) cumulative_score from scores;
-- ---------------------------------------------------------------------------------------------------------------------


-- ---------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------ UPGRAD PRACTICE ---------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------

use sys;

show tables in sys;

-- desc sys.customer1;
drop table if exists sys.customer1;
create table if not exists sys.customer1 select * from sys.customer;

#truncate
truncate table sys.customer1 ;
select * from sys.customer1 ;

set sql_safe_updates=0;

delete from sys.customer1 where id=1;

drop table if exists sys.customer;
create table sys.customer (
ID INT NOT NULL,
FirstName Varchar(255),
LastName Varchar(255),
city varchar(255),
Country Varchar(255),
Phone Varchar(255));

INSERT INTO sys.Customer
VALUES(1,'Maria','Anders','Berlin','Germany','030-0074321');
INSERT INTO sys.Customer (Id,FirstName,LastName,City,Country,Phone)VALUES(2,'Ana','Trujillo','México D.F.','Mexico','(5) 555-4729');
INSERT INTO sys.Customer (Id,FirstName,LastName,City,Country,Phone)VALUES(3,'Antonio','Moreno','México D.F.','Mexico','(5) 555-3932');

#supplier data
drop table if exists sys.Supplier;

create table if not exists sys.Supplier (
ID INT NOT NULL,
CompanyName Varchar(255),
ContactName Varchar(255),
city varchar(255),
Country Varchar(255),
Phone Varchar(255),
Fax Varchar(255));


INSERT INTO sys.Supplier (Id,CompanyName,ContactName,City,Country,Phone,Fax)VALUES(1,'Exotic Liquids','Charlotte Cooper','London','UK','(171) 555-2222',NULL);
INSERT INTO sys.Supplier (Id,CompanyName,ContactName,City,Country,Phone,Fax)VALUES(2,'New Orleans Cajun Delights','Shelley Burke','New Orleans','USA','(100) 555-4822',NULL);
INSERT INTO sys.Supplier (Id,CompanyName,ContactName,City,Country,Phone,Fax)VALUES(3,'Grandma Kelly''s Homestead','Regina Murphy','Ann Arbor','USA','(313) 555-5735','(313) 555-3349');

select distinct * from sys.supplier limit 10;

#product data
drop table if exists sys.Product;

create table sys.Product (
ID INT NOT NULL,
ProductName Varchar(255),
SupplierId INT,
UnitPrice FLOAT,
Package Varchar(255),
IsDiscontinued INT
);


INSERT INTO sys.Product (Id,ProductName,SupplierId,UnitPrice,Package,IsDiscontinued)VALUES(1,'Chai',1,18.00,'10 boxes x 20 bags',0);
INSERT INTO sys.Product (Id,ProductName,SupplierId,UnitPrice,Package,IsDiscontinued)VALUES(2,'Chang',1,19.00,'24 - 12 oz bottles',0);
INSERT INTO sys.Product (Id,ProductName,SupplierId,UnitPrice,Package,IsDiscontinued)VALUES(3,'Aniseed Syrup',1,10.00,'12 - 550 ml bottles',0);

select * from sys.Product a inner join sys.supplier b on a.supplierid=b.id;

#order data
drop table if exists sys.order;
create table sys.order (
#Id,OrderDate,CustomerId,TotalAmount,OrderNumber
ID INT NOT NULL,
OrderDate varchar(255),
CustomerId INT,
TotalAmount FLOAT,
OrderNumber INT
);



INSERT INTO sys.Order (Id,OrderDate,CustomerId,TotalAmount,OrderNumber)VALUES(1,'Jul  4 2012 12:00:00:000AM',85,440.00,'542378');
INSERT INTO sys.Order (Id,OrderDate,CustomerId,TotalAmount,OrderNumber)VALUES(705,'Mar 16 2014 12:00:00:000AM',1,493.2,'543082');
INSERT INTO sys.Order (Id,OrderDate,CustomerId,TotalAmount,OrderNumber)VALUES(2,'Jul  5 2012 12:00:00:000AM',79,1863.40,'542379');
INSERT INTO sys.Order (Id,OrderDate,CustomerId,TotalAmount,OrderNumber)VALUES(3,'Jul  8 2012 12:00:00:000AM',34,1813.00,'542380');


#orderitem

drop table if exists sys.orderitem;
create table sys.orderitem (
#Id,OrderId,ProductId,UnitPrice,Quantity
ID INT NOT NULL,
OrderId INT,
ProductId INT,
UnitPrice FLOAT,
Quantity FLOAT
);

INSERT INTO sys.OrderItem (Id,OrderId,ProductId,UnitPrice,Quantity)VALUES(1,1,11,14.00,12);
INSERT INTO sys.OrderItem  (Id,OrderId,ProductId,UnitPrice,Quantity)VALUES(2,1,42,9.80,10);
INSERT INTO sys.OrderItem  (Id,OrderId,ProductId,UnitPrice,Quantity)VALUES(3,1,72,34.80,5);

show indexes from sys.order;

#top 10 rows in customer table
select * from sys.customer limit 10;
select * from sys.order limit 10;

#indexing...always first crete the index and then sub query
alter table sys.customer add index idx_id(id);
show index from sys.customer;
show index from sys.order;
alter table sys.order add index idx_order_id (id) ;
alter table sys.order add index idx_ordernumber (ordernumber) ;



select * from sys.order;


#having function
#number of orders createed by an individual customer and total amount proessed till date
select 
a.id,count(distinct b.id) as total_orders, sum(totalamount) as totalamount
 from sys.customer a inner join sys.order b on a.id=b.customerid
 #where count(distinct b.id)>10
 group by a.id
 #total_order>10
 having count(distinct b.id)>10
 ;

#sub-queries...
select * from 
(select 
a.id,count(distinct b.id) as total_orders, sum(totalamount) as totalamount
 from sys.customer a inner join sys.order b on a.id=b.customerid
 #where count(distinct b.id)>10
 group by a.id )  ordr_bk
 #total_order>10
 where ordr_bk.total_orders>10
 ;

#rank & dense_rank

select * from sys.order order by totalamount desc limit 3;

#rank..top 3 order in descending order

select * from
(select a.*,rank() over (order by totalamount desc) as ranking 
from sys.order a order by totalamount desc) a
where ranking<=3
;

#rank..all the customers who have ordered from my website and I want to see top 3 orders

select * from
(select a.*,rank() over (partition by customerid order by totalamount desc) as ranking 
from sys.order a order by customerid,totalamount desc) a 
where ranking<=3
;

#rank and dense_rank
select a.*,rank() over (partition by customerid order by totalamount desc) as ranking 
from sys.order a 
where customerid in (1,2)
order by customerid,totalamount desc
;

select * from sys.order where customerid in (1,2) order by customerid;

#join
#inner, left, right, full outer, cross join
select * from sys.customer limit 10;
select * from sys.order limit 10;
select * from sys.orderitem where orderid=54 limit 10;

#inner join
select a.id as cust_id,a.firstname,b.id as orderid,c.productid,unitprice*quantity as totalamountspent
from sys.customer a 
#customer id i.e. a.id is primarykey and b.customerid in order table in foreign key
inner join sys.order b on a.id=b.customerid 
#b.id i.e. orderid from order table is primary key whereas orderid in orderitem is foreign key
inner join sys.orderitem c on b.id=c.orderid
where a.id=86
;

#inner join ...2nd way...self join 
select a.id as cust_id,a.firstname,b.id as orderid,c.productid,unitprice*quantity as totalamountspent
from sys.customer a , sys.order b ,sys.orderitem c 
#customer id i.e. a.id is primarykey and b.customerid in order table in foreign key
where a.id=b.customerid and
#b.id i.e. orderid from order table is primary key whereas orderid in orderitem is foreign key
b.id=c.orderid
and a.id=86
;

#left join

select a.id as cust_id,a.firstname,b.id as orderid
from sys.customer a 
#customer id i.e. a.id is primarykey and b.customerid in order table in foreign key
left join sys.order b on a.id=b.customerid 
where b.customerid is null
;

#right join

select a.id as cust_id,a.firstname,b.id as orderid
from sys.order b
right join sys.customer a 
#customer id i.e. a.id is primarykey and b.customerid in order table in foreign key
on a.id=b.customerid 
where b.customerid is null
;

#cross join
select * from sys.customer a cross join sys.order b
on a.id=b.id;

select * from sys.customer where id=22;
select * from sys.order where customerid=22;

-- ------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------
-- To get current time from current_timestamp 

select right(current_timestamp, length(current_timestamp)-11) as `current_time`;

-- OR 

select current_time;

-- ------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------
select current_date;

-- OR

select left(current_timestamp, length(current_timestamp) -9);
-- ------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------

-- find duplicate employee names
select FullName 
	    from (select FullName, count(*) as cnt 
		  from employee e1 
		  group by FullName 
		  having cnt >1) a; 
	    
