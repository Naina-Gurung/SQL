over_id	ball_id	runs	extras	batsman

drop table cricket_dashboard;
create table cricket_dashboard
(
over_id int,
ball_id int,
runs int,
extras int,
batsman string
);

insert into table cricket_dashboard values (1,1,4,0,"B1");
insert into table cricket_dashboard values (1,2,4,0,"B2");
insert into table cricket_dashboard values (1,3,1,0,"B2");
insert into table cricket_dashboard values (1,4,0,0,"B2");
insert into table cricket_dashboard values (1,5,4,1,"B2");
insert into table cricket_dashboard values (1,6,4,1,"B1");
insert into table cricket_dashboard values (2,1,4,0,"B1");
insert into table cricket_dashboard values (2,2,4,0,"B1");
insert into table cricket_dashboard values (2,3,4,0,"B1");
insert into table cricket_dashboard values (2,4,2,0,"B2");
insert into table cricket_dashboard values (2,5,2,0,"B2");
insert into table cricket_dashboard values (2,6,2,0,"B2");

input:
  +------------+------------+---------+-----------+------------+--+
  | a.over_id  | a.ball_id  | a.runs  | a.extras  | a.batsman  |
  +------------+------------+---------+-----------+------------+--+
  | 1          | 1          | 4       | 0         | B1         |
  | 1          | 2          | 4       | 0         | B2         |
  | 1          | 3          | 1       | 0         | B2         |
  | 1          | 4          | 0       | 0         | B2         |
  | 1          | 5          | 4       | 1         | B2         |
  | 1          | 6          | 4       | 1         | B1         |
  | 2          | 1          | 4       | 0         | B1         |
  | 2          | 2          | 4       | 0         | B1         |
  | 2          | 3          | 4       | 0         | B1         |
  | 2          | 4          | 2       | 0         | B2         |
  | 2          | 5          | 2       | 0         | B2         |
  | 2          | 6          | 2       | 0         | B2         |
  +------------+------------+---------+-----------+------------+--+
  12 rows selected (28.763 seconds)

answer:
//scenario 1: to find the over_id, ball_id,runs and batsman who scored consecutive runs but runs should not be 0.
query:
with inp as
  (select
  over_id,
  ball_id,
  case when extras=1 then 0
  else runs
  end runs,
  batsman
  from
  cricket_dashboard
),
stg as (
select
over_id,
ball_id,
runs,
batsman,
row_number() over(partition by over_id,batsman,runs  order by over_id,ball_id,batsman,runs asc) rnk
from
inp),
otpt as (
  select
  over_id,
  ball_id,
  runs,
  batsman,
  rnk,
  min(rnk) over(partition by over_id,batsman,runs order by rnk asc) min1,
  max(rnk)  over (partition by over_id,batsman,runs  order by rnk desc) max1
  from
  stg
)
select
over_id,
ball_id,
runs,
batsman
from
otpt
where max1=3 and min1=1
and runs<>0
order by over_id,
ball_id;

output: get the batsman who scored consecutive runs
+----------+----------+-------+----------+--+
| over_id  | ball_id  | runs  | batsman  |
+----------+----------+-------+----------+--+
| 2        | 4        | 2     | B2       |
| 2        | 5        | 2     | B2       |
| 2        | 6        | 2     | B2       |
+----------+----------+-------+----------+--+
3 rows selected (135.177 seconds)

//scenario 2: get the over_id,ball_id, batsman,runs who scored consecutively 4s 3 times based on batsman.
even if the batsman score 4s more than 3 times,only  print the first 3 consecutive.
with inp as
(select
over_id,
ball_id,
case when extras=1 then 0
else runs
end runs,
batsman
from
cricket_dashboard),
stg as (
  select
  over_id,
  ball_id,
  batsman,
  runs,
  row_number() over (partition by batsman,runs order by over_id,ball_id ) rn
  from
  inp
   where runs=4
  group by
  over_id,
  ball_id,
  batsman,
  runs
) ,
output as
(select
over_id,
ball_id,
batsman,
runs,
rn,
count(rn) over(partition by batsman order by runs) cnt
from
stg )
select
over_id,
ball_id,
batsman,
runs
from
output
where rn<=3 and cnt>=3
order by batsman,over_id,ball_id

output:
+----------+----------+----------+-------+--+
| over_id  | ball_id  | batsman  | runs  |
+----------+----------+----------+-------+--+
| 1        | 1        | B1       | 4     |
| 2        | 1        | B1       | 4     |
| 2        | 2        | B1       | 4     |
+----------+----------+----------+-------+--+
3 rows selected (120.746 seconds)
