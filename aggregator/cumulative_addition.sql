create table transactions
(id int, amt int,direction string);


select * from transactions order by id;
+-----------------+------------------+------------------------+--+
| transactions.id | transactions.amt | transactions.direction  |
+-----------------+------------------+------------------------+--+
| 1               | 100              | IN                     |
| 2               | 100              | IN                     |
| 3               | 50               | OUT                    |
| 4               | 100              | IN                     |
| 5               | 200              | OUT                    |
| 6               | 50               | OUT                    |
+-----------------+------------------+------------------------+--+
6 rows selected (33.876 seconds)

create table transactions_1 as
select
id,
case when direction='IN' then amt
else -amt
end amt,
direction
from transactions order by id;

+-----+-------+------------+--+
| id  |  amt  | direction  |
+-----+-------+------------+--+
| 1   | 100   | IN         |
| 2   | 100   | IN         |
| 3   | -50   | OUT        |
| 4   | 100   | IN         |
| 5   | -200  | OUT        |
| 6   | -50   | OUT        |
+-----+-------+------------+--+
6 rows selected (31.066 seconds)

//full query:
select
id,
amt,
sum(amt) over(order by id,amt rows between unbounded preceding and current row) as balance
from (select
id,
case when direction='IN' then amt
else -amt
end amt,
direction
from transactions) a
order by id,amt;
