The Trips table holds all taxi trips. Each trip has a unique Id, while Client_Id and Driver_Id are both
 foreign keys to the Users_Id at the Users table. Status is an ENUM type of (‘completed’,
‘cancelled_by_driver’, ‘cancelled_by_client’).
+----+-----------+-----------+---------+--------------------+----------+
| Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
+----+-----------+-----------+---------+--------------------+----------+
| 1  |     1     |    10     |    1    |     completed      |2013-10-01|
| 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
| 3  |     3     |    12     |    6    |     completed      |2013-10-01|
| 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
| 5  |     1     |    10     |    1    |     completed      |2013-10-02|
| 6  |     2     |    11     |    6    |     completed      |2013-10-02|
| 7  |     3     |    12     |    6    |     completed      |2013-10-02|
| 8  |     2     |    12     |    12   |     completed      |2013-10-03|
| 9  |     3     |    10     |    12   |     completed      |2013-10-03|
| 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
+----+-----------+-----------+---------+--------------------+----------+


The Users table holds all users. Each user has an unique Users_Id, and Role is
an ENUM type of (‘client’, ‘driver’, ‘partner’).

+----------+--------+--------+
| Users_Id | Banned |  Role  |
+----------+--------+--------+
|    1     |   No   | client |
|    2     |   Yes  | client |
|    3     |   No   | client |
|    4     |   No   | client |
|    10    |   No   | driver |
|    11    |   No   | driver |
|    12    |   No   | driver |
|    13    |   Yes   | driver |
+----------+--------+--------+

Write a SQL query to find the cancellation rate of requests made by unbanned users
 (both client and driver must be unbanned) between Oct 1, 2013 and Oct 3, 2013. The
  cancellation rate is computed by dividing the number of canceled (by client or driver)
   requests made by unbanned users by the total number of requests made by unbanned users.

For the above tables, your SQL query should return the following rows with the cancellation
rate being rounded to two decimal places.

+------------+-------------------+
|     Day    | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 |       0.33        |
| 2013-10-02 |       0.00        |
| 2013-10-03 |       0.50        |
+------------+-------------------+

create table trips(id int,client_id int,driver_id int,city_id int,status string,request_at date);
insert into table trips values(1,1,10,1,"completed","2013-10-01");
insert into table trips values(2,2,11,1,"cancelled_by_driver","2013-10-01");
insert into table trips values(3,3,12,6,"completed","2013-10-01");
insert into table trips values(4,4,13,7,"cancelled_by_client","2013-10-01");
insert into table trips values(5,1,10,1,"completed","2013-10-02");
insert into table trips values(6,2,11,6,"completed","2013-10-02");
insert into table trips values(7,3,12,6,"completed","2013-10-02");
insert into table trips values(8,2,12,12,"completed","2013-10-03");
insert into table trips values(9,3,10,12,"completed","2013-10-03");
insert into table trips values(10,4,13,12,"cancelled_by_driver","2013-10-03");

drop table users;
create table users(users_id int, banned string,role string);
insert into table users values (1,"No","client");
insert into table users values(2,"Yes","client");
insert into table users values(3,"No","client");
insert into table users values(4,"No","client");
insert into table users values(10,"No","driver");
insert into table users values(11,"No","driver");
insert into table users values(12,"No","driver");
insert into table users values(13,"No","driver");

answer:
select request_at as day,
round(sum(case when status like '%cancelled%' then 1 else 0 end)/count(status),2) as "cancellation rate"
from
(select
id,
client_id,
driver_id,
city_id,
status,
request_at,
case when c.banned="Yes" then "Yes"
else d.banned
end banned
from (
select
id,
client_id,
driver_id,
city_id,
status,
request_at,
b.banned
from trips a
left join users b
on a.client_id=b.users_id
) c
left join users d
on c.driver_id=d.users_id
) stg
where banned="No"
and request_at between date('2013-10-01') and date('2013-10-03')
group by request_at;
