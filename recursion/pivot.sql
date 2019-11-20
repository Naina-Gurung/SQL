--given table:

create table abc(id int,name string,manager_id int);

+---------+------------+-----------------+--+
| abc.id  |  abc.name  | abc.manager_id  |
+---------+------------+-----------------+--+
| 1001    | Strictman  | NULL            |
| 505     | Jman       | 1001            |
| 501     | Bossman    | 1001            |
| 405     | noman      | 505             |
| 401     | yesman     | 501             |
| 305     | middleman  | 401             |
| 301     | goodman    | 401             |
| 105     | Will       | 405             |
| 101     | weekman    | 405             |
+---------+------------+-----------------+--+
9 rows selected (49.474 seconds)

--when you know the height of the tree tht you have to traverse till 4 levels 
with lvl1 as (
  select
  id  as emp_id,
  name as emp_name,
  manager_id,
  1 as lvl
  from abc
  where manager_id is null
),
lvl2 as (
select
id  as emp_id,
name as emp_name,
emp.manager_id,
lvl +1 as lvl
from abc  emp
join lvl1 prt
on emp.manager_id=prt.emp_id
),
lvl3 as (
  select
  id  as emp_id,
  name as emp_name,
  emp.manager_id,
  lvl +1 as lvl
  from abc  emp
  join lvl2 prt
  on emp.manager_id=prt.emp_id
),
lvl4 as (
  select
  id  as emp_id,
  name as emp_name,
  emp.manager_id,
  lvl +1 as lvl
  from abc  emp
  join lvl3 prt
  on emp.manager_id=prt.emp_id
)
insert into table abc_test
select * from lvl1
union
select * from lvl2
union
select * from lvl3
union
select * from lvl4
+------------------+--------------------+----------------------+---------------+--+
| abc_test.emp_id  | abc_test.emp_name  | abc_test.manager_id  | abc_test.lvl  |
+------------------+--------------------+----------------------+---------------+--+
| 101              | weekman            | 405                  | 4             |
| 105              | Will               | 405                  | 4             |
| 301              | goodman            | 401                  | 4             |
| 305              | middleman          | 401                  | 4             |
| 401              | yesman             | 501                  | 3             |
| 405              | noman              | 505                  | 3             |
| 501              | Bossman            | 1001                 | 2             |
| 505              | Jman               | 1001                 | 2             |
| 1001             | Strictman          | NULL                 | 1             |
+------------------+--------------------+----------------------+---------------+--+
9 rows selected (0.111 seconds)

select
concat_ws(',',collect_list(emp_name)) employees,
lvl
from
abc_test
group by lvl
+---------------------------------+------+--+
|            employees            | lvl  |
+---------------------------------+------+--+
| Strictman                       | 1    |
| Bossman,Jman                    | 2    |
| yesman,noman                    | 3    |
| weekman,Will,goodman,middleman  | 4    |
+---------------------------------+------+--+
4 rows selected (28.861 seconds)



--for recursive when you dont know the length of the tree.
set mapred.input.dir.recursive = true;
set hive.mapred.supports.subdirectories = true;


with cte as (
select
name as emp_name,
0 as lvl
from abc
where manager_id is null
union all
select
name as emp_name,
lvl +1 as lvl
from abc  emp
join cte prt
on emp.manager_id=cte.emp_id
)
select * from cte order by lvl;
