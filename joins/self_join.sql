--//Given table:
--to find manager for each employee in an organization.

select * from abc order by emp_name;
+-------------+---------------+-----------------+--+
| abc.emp_id  | abc.emp_name  | abc.manager_id  |
+-------------+---------------+-----------------+--+
| 2000        | Dorry         | 2050            |
| 2002        | Garry         | 2000            |
| 2001        | James         | 2051            |
| 2003        | Nemo          | 2002            |
| 2051        | Richard       | NULL            |
| 2050        | Robert        | 2051            |
+-------------+---------------+-----------------+--+
6 rows selected (7.74 seconds)
--//output:
select
emp.emp_name as employee,
manager.emp_name as manager
from abc emp
left join abc manager
on emp.manager_id=manager.emp_id
order by employee

+-----------+----------+--+
| employee  | manager  |
+-----------+----------+--+
| Dorry     | Robert   |
| Garry     | Dorry    |
| James     | Richard  |
| Nemo      | Garry    |
| Richard   | NULL     |
| Robert    | Richard  |
+-----------+----------+--+
6 rows selected (10.115 seconds)
