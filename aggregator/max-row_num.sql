--given table:
create table abc(e_name string,dept_name string, month string, salary int);

select * from abc order by dept_name,month,e_name,salary;
+-------------+----------------+------------+-------------+--+
| abc.e_name  | abc.dept_name  | abc.month  | abc.salary  |
+-------------+----------------+------------+-------------+--+
| A           | HR             | Jan        | 40000       |
| B           | HR             | Jan        | 45000       |
| A           | HR             | Feb        | 40000       |
| C           | DSC            | Jan        | 50000       |
| D           | DSC            | Jan        | 55000       |
| C           | DSC            | Apr        | 60000       |
| D           | DSC            | Apr        | 55000       |
+-------------+----------------+------------+-------------+--+
7 rows selected (0.34 seconds)


select dept_name,month,max(salary) from abc
group by dept_name,month order by dept_name,month
+------------+--------+--------+--+
| dept_name  | month  |  _c2   |
+------------+--------+--------+--+
| DSC        | Apr    | 60000  |
| DSC        | Jan    | 55000  |
| HR         | Feb    | 40000  |
| HR         | Jan    | 45000  |
+------------+--------+--------+--+
4 rows selected (59.495 seconds)
