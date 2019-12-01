Create table Logs(
    Id INT,
    Num INT
);
Insert into table  Logs Values
(1,1),
(2,1),
(3,1),
(4,2),
(5,1),
(6,2),
(7,2);
input1:
+----------+-----------+--+
| logs.id  | logs.num  |
+----------+-----------+--+
| 1        | 1         |
| 2        | 1         |
| 3        | 1         |
| 4        | 2         |
| 5        | 1         |
| 6        | 2         |
| 7        | 2         |
+----------+-----------+--+
7 rows selected (0.102 seconds)

Input2:
drop table Logs;
Create table Logs(
    Id INT,
    Num INT
);
insert into table logs values (1,3),(2,3),(3,3),(4,3);
+----------+-----------+--+
| logs.id  | logs.num  |
+----------+-----------+--+
| 1        | 3         |
| 2        | 3         |
| 3        | 3         |
| 4        | 3         |
+----------+-----------+--+
4 rows selected (0.095 seconds)


select distinct
num
from
(
select
num,
case when(lead (num,1) over (order by id) = num)
and
(lead (num,2) over (order by id) =num)
then 1 else 0
end  consecutive_numbers
from
Logs
) temp
where consecutive_numbers=1;
