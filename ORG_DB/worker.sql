CREATE DATABASE ORG;
SHOW DATABASES;
USE ORG;

CREATE TABLE Worker (
	WORKER_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT(15),
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25)
);

INSERT INTO Worker 
	(WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
		(001, 'Monika', 'Arora', 100000, '14-02-20 09.00.00', 'HR'),
		(002, 'Niharika', 'Verma', 80000, '14-06-11 09.00.00', 'Admin'),
		(003, 'Vishal', 'Singhal', 300000, '14-02-20 09.00.00', 'HR'),
		(004, 'Amitabh', 'Singh', 500000, '14-02-20 09.00.00', 'Admin'),
		(005, 'Vivek', 'Bhati', 500000, '14-06-11 09.00.00', 'Admin'),
		(006, 'Vipul', 'Diwan', 200000, '14-06-11 09.00.00', 'Account'),
		(007, 'Satish', 'Kumar', 75000, '14-01-20 09.00.00', 'Account'),
		(008, 'Geetika', 'Chauhan', 90000, '14-04-11 09.00.00', 'Admin');

CREATE TABLE Bonus (
	WORKER_REF_ID INT,
	BONUS_AMOUNT INT(10),
	BONUS_DATE DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Bonus 
	(WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
		(001, 5000, '16-02-20'),
		(002, 3000, '16-06-11'),
		(003, 4000, '16-02-20'),
		(001, 4500, '16-02-20'),
		(002, 3500, '16-06-11');
        
CREATE TABLE Title (
	WORKER_REF_ID INT,
	WORKER_TITLE CHAR(25),
	AFFECTED_FROM DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Title 
	(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM) VALUES
 (001, 'Manager', '2016-02-20 00:00:00'),
 (002, 'Executive', '2016-06-11 00:00:00'),
 (008, 'Executive', '2016-06-11 00:00:00'),
 (005, 'Manager', '2016-06-11 00:00:00'),
 (004, 'Asst. Manager', '2016-06-11 00:00:00'),
 (007, 'Executive', '2016-06-11 00:00:00'),
 (006, 'Lead', '2016-06-11 00:00:00'),
 (003, 'Lead', '2016-06-11 00:00:00');
 
 -- ------------------------------------------------------------------------------------
 -- Fetch the first name from worker table with alias name as "worker_name"
 select first_name as Worker_Name from worker;
 
-- ------------------------------------------------------------------------------------
 -- unique values of department from worker table
 select distinct department from worker;
 
 -- ------------------------------------------------------------------------------------
 -- print first 3 characters from first_name from worker table
 select substring(first_name, 1,3) from worker;
 
-- ------------------------------------------------------------------------------------
 -- Find The Position Of The Alphabet (‘A’) In The First Name Column ‘Amitabh’ From Worker Table
 select instr(first_name, 'a') as Position_of_A from worker where first_name='Amitabh';
 -- INSTR function is case-insensitive by default
 -- BINARY function makes it case-sensitive
 
-- ------------------------------------------------------------------------------------
-- Print The FIRST_NAME From Worker Table After Removing White Spaces From The Right Side.
 select rtrim(first_name) from worker;
 
-- ------------------------------------------------------------------------------------
-- Print The DEPARTMENT From Worker Table After Removing White Spaces From The Left Side
 select ltrim(department) from worker;
 
-- ------------------------------------------------------------------------------------
-- SQL Query To Print The FIRST_NAME From Worker Table After Replacing ‘a’ With ‘A’.
select replace(first_name, 'a', 'A') as first_name from worker;

-- ------------------------------------------------------------------------------------
 -- SQL Query To Print The FIRST_NAME And LAST_NAME From Worker Table Into A Single Column COMPLETE_NAME. A Space Char Should Separate Them.
 select concat(first_name,' ', last_name) Full_Name from worker;
 
-- ------------------------------------------------------------------------------------
-- SQL Query To Print All Worker Details From The Worker Table Order By FIRST_NAME Ascending
  select * from worker order by first_name asc;

-- ------------------------------------------------------------------------------------
-- SQL Query To Print Details Of Workers Excluding First Names, “Vipul” And “Satish” From Worker Table
select * from worker where first_name not in ('Vipul', 'Satish');

-- ------------------------------------------------------------------------------------
-- SQL Query To Print Details Of The Workers Who Have Joined In Feb’2014
select * from worker where year(joining_date)=2014 and month(joining_date)=2;

-- ------------------------------------------------------------------------------------
-- SQL Query To Fetch Worker Names With Salaries >= 50000 And <= 100000.
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) As Worker_Name, Salary
FROM worker 
WHERE Salary BETWEEN 50000 AND 100000;

-- ------------------------------------------------------------------------------------
-- SQL Query To Fetch The Employee name having highest salary in the department order by the number of workers in each department in descending order.
select concat(first_name,' ',last_name) Employee_name, Department, max(salary) as Highest_Salary, count(*) No_of_worker 
from worker group by  Department 
order by No_of_worker desc;

-- ------------------------------------------------------------------------------------
-- SQL Query To Print Details Of The Workers Who Are Also Managers.
select concat(w.first_name,' ',last_name) Manager_Name, w.Worker_id, t.Affected_from, w.joining_date, w.department 
from title t, worker w
where t.worker_ref_id = w.worker_id
and t.worker_title ='Manager';

-- SQL Query To Fetch Duplicate Records Having Matching Data In Some Fields Of A Table.
select * from title
group by worker_title, affected_from
having count(*) > 1;
