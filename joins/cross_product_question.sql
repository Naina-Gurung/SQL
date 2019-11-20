--//given table :


drop table Employees;
create table Employees(names string);

insert into table Employees
select 
'Usher' names;

select * from Employees order by names
+------------+--+
|     names  |
+------------+--+
| Dorry      | 1
| Madhu      | 2
| Nemo       | 3
| Usher      | 4
+------------+--+
4 rows selected (28.967 seconds)
--//output:
select
a.names a_name,
b.names b_name
from Employees  a,Employees b
where a.names<> b.names order by a_name,b_name;

expected output:
+---------+---------+--+
| a_name  | b_name  |
+---------+---------+--+
| Dorry   | Madhu   |
| Dorry   | Nemo    |
| Dorry   | Usher   |
| Madhu   | Nemo    |
| Madhu   | Usher   |
| Nemo    | Usher   |
+---------+---------+--+
12 rows selected (10.115 seconds)


with inp as
(
select
a.names a_name,
b.names b_name,
a.rn as a1,
b.rn as b1,
case when a.rn<b.rn then a.rn else b.rn end c1,
case when a.rn<b.rn then b.rn else a.rn end d1
from 
(select names,row_number() over(order by names asc) rn from Employees ) a,
(select names,row_number() over(order by names asc) rn from Employees ) b
where a.names<> b.names 
),
otpt as
(
select
a_name,
b_name,
concat(c1,'/',d1) chk_rw
from  inp
) 
select * from (
select 
a_name,
b_name,
row_number() over (partition by chk_rw order by chk_rw asc) rn
from
otpt
) abc
where rn=1
order by a_name,b_name;

innermost query results:
+---------+---------+-----+-----+-----+-----+--+
| a_name  | b_name  | a1  | b1  | c1  | d1  |
+---------+---------+-----+-----+-----+-----+--+
| Dorry   | Madhu   | 1   | 2   | 1   | 2   |
| Dorry   | Nemo    | 1   | 3   | 1   | 3   |
| Dorry   | Usher   | 1   | 4   | 1   | 4   |

| Madhu   | Dorry   | 2   | 1   | 1   | 2   |
| Madhu   | Nemo    | 2   | 3   | 2   | 3   |
| Madhu   | Usher   | 2   | 4   | 2   | 4   |

| Nemo    | Dorry   | 3   | 1   | 1   | 3   |
| Nemo    | Madhu   | 3   | 2   | 2   | 3   |
| Nemo    | Usher   | 3   | 4   | 3   | 4   |

| Usher   | Dorry   | 4   | 1   | 1   | 4   |
| Usher   | Madhu   | 4   | 2   | 2   | 4   |
| Usher   | Nemo    | 4   | 3   | 3   | 4   |
+---------+---------+-----+-----+-----+-----+--+
12 rows selected (17.196 seconds)

inner query concat  results:
+---------+---------+---------+--+
| a_name  | b_name  | chk_rw  |
+---------+---------+---------+--+
| Dorry   | Madhu   | 1/2     |
| Dorry   | Nemo    | 1/3     |
| Dorry   | Usher   | 1/4     |
| Madhu   | Dorry   | 1/2     |
| Madhu   | Nemo    | 2/3     |
| Madhu   | Usher   | 2/4     |
| Nemo    | Dorry   | 1/3     |
| Nemo    | Madhu   | 2/3     |
| Nemo    | Usher   | 3/4     |
| Usher   | Dorry   | 1/4     |
| Usher   | Madhu   | 2/4     |
| Usher   | Nemo    | 3/4     |
+---------+---------+---------+--+
12 rows selected (11.741 seconds)

final answer:
+-------------+-------------+---------+--+
| abc.a_name  | abc.b_name  | abc.rn  |
+-------------+-------------+---------+--+
| Dorry       | Madhu       | 1       |
| Dorry       | Nemo        | 1       |
| Dorry       | Usher       | 1       |
| Madhu       | Nemo        | 1       |
| Madhu       | Usher       | 1       |
| Nemo        | Usher       | 1       |
+-------------+-------------+---------+--+
6 rows selected (11.705 seconds)
