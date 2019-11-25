--hive date functions
--get the first date of the last week when you query at any date
select date_sub(date_sub(current_date,1+pmod(datediff(current_date,'1900-01-08'),7)),7);
2019-11-17

--get the last date of the last week when you query at any date
select date_sub(date_sub(current_date,1+pmod(datediff(current_date,'1900-01-08'),7)),1);
2019-11-23

--get the first date of the current week
select date_sub(current_date,1+pmod(datediff(current_date,'1900-01-08'),7));
2019-11-24
--get the last date of the current week
select date_add(current_date,5 - pmod(datediff(current_date,'1900-01-08'),7));
2019-11-30


--first date of last month
Select date_add(last_day(add_months(current_date, -2)),1);
+-------------+--+
|     _c0     |
+-------------+--+
| 2019-10-01  |
+-------------+--+
1 row selected (0.198 seconds)
--last date of last month
Select last_day(add_months(current_date, -1));
+-------------+--+
|     _c0     |
+-------------+--+
| 2019-10-31  |
+-------------+--+
1 row selected (0.086 seconds)
