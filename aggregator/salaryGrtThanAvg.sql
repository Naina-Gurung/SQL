drop table semployee;
create table employee
(employee_no int,
employee_name string,
department_no int,
salary decimal(6,2),
manager_no int);


select * from employee order by department_no,employee_no

HR - 1
DSC -2
+--------------------------+----------------------------+----------------------------+---------------------+-------------------------+--+
| employee.employee_no     | employee.employee_name     | employee.department_no     | employee.salary     | employee.manager_no     |
+--------------------------+----------------------------+----------------------------+---------------------+-------------------------+--+
| 7                        | G                          | NULL                       | 550.1               | 1002                    |
| 1                        | A                          | 1                          | 100.1               | 1001                    |
| 2                        | B                          | 1                          | 120.5               | 1001                    |
| 3                        | C                          | 1                          | 320                 | 1001                    |
| 9                        | K                          | 1                          | 320                 | 1001                    |
| 4                        | D                          | 2                          | 500                 | 1002                    |
| 5                        | E                          | 2                          | 550.2               | 1002                    |
| 6                        | F                          | 2                          | 550.1               | 1002                    |
+--------------------------+----------------------------+----------------------------+---------------------+-------------------------+--+
8 rows selected (27.806 seconds)

select
employee_no,
employee_name,
department_no,
salary,
cast(avg(salary)  over(partition by department_no order  by department_no) as decimal(6,2)) as avg
from
employee
where department_no is not null
order by department_no,employee_no

+--------------+----------------+----------------+---------+---------+--+
| employee_no  | employee_name  | department_no  | salary  |   avg   |
+--------------+----------------+----------------+---------+---------+--+
| 1            | A              | 1              | 100.1   | 180.2   |
| 2            | B              | 1              | 120.5   | 180.2   |
| 3            | C              | 1              | 320     | 180.2   |
| 4            | D              | 2              | 500     | 533.43  |
| 5            | E              | 2              | 550.2   | 533.43  |
| 6            | F              | 2              | 550.1   | 533.43  |
+--------------+----------------+----------------+---------+---------+--+
6 rows selected (50.972 seconds)

select * from (
select
employee_no,
employee_name,
department_no,
salary,
cast(avg(salary)  over(partition by department_no order  by department_no) as decimal(6,2)) as avg,
max(salary) over(partition by department_no order  by department_no) as max_salary
from
employee
where department_no is not null) a
where max_salary>avg
order by department_no,employee_no
+----------------+------------------+------------------+-----------+---------+---------------+--+
| a.employee_no  | a.employee_name  | a.department_no  | a.salary  |  a.avg  | a.max_salary  |
+----------------+------------------+------------------+-----------+---------+---------------+--+
| 3              | C                | 1                | 320       | 215.15  | 320           |
| 9              | K                | 1                | 320       | 215.15  | 320           |
| 5              | E                | 2                | 550.2     | 533.43  | 550.2         |
| 6              | F                | 2                | 550.1     | 533.43  | 550.2         |
+----------------+------------------+------------------+-----------+---------+---------------+--+
4 rows selected (55.083 seconds)
