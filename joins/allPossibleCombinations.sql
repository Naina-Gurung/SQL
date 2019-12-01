We have a member table with two columns. The table provide all the accounts registered by each Member.
Build a SQL that would generate all possible combinations for email accounts created by each member.
Combinations should not repeat. Desired output.
MEMBER TABLE:
+-------------+-------------------------+--+
| member.mid  |      member.email       |
+-------------+-------------------------+--+
| 100         | M100_Email_1@gmail.com  |
| 100         | M100_Email_2@gmail.com  |
| 100         | M100_Email_3@gmail.com  |
| 100         | M100_Email_4@gmail.com  |

| 200         | M200_Email_1@gmail.com  |
| 200         | M200_Email_2@gmail.com  |
| 200         | M200_Email_3@gmail.com  |

| 300         | M300_Email_1@gmail.com  |
| 300         | M300_Email_2@gmail.com  |
+-------------+-------------------------+--+
9 rows selected (0.173 seconds)


DESIRED OUTPUT:
MID email1                  email2
100 M100_Email_1@gmail.com  M100_Email_2@gmail.com
100 M100_Email_1@gmail.com  M100_Email_3@gmail.com
100 M100_Email_1@gmail.com  M100_Email_4@gmail.com
100 M100_Email_2@gmail.com  M100_Email_3@gmail.com
100 M100_Email_2@gmail.com  M100_Email_4@gmail.com
100 M100_Email_3@gmail.com  M100_Email_4@gmail.com

200 M200_Email_1@gmail.com  M200_Email_2@gmail.com
200 M200_Email_1@gmail.com  M200_Email_3@gmail.com
200 M200_Email_2@gmail.com  M200_Email_3@gmail.com

300 M300_Email_1@gmail.com  M300_Email_2@gmail.com



with inp as
(
select
a.mid,
a.email email1,
b.email email2,
a.rn as a1,
b.rn as b1,
case when a.rn<b.rn then a.rn else b.rn end c1,
case when a.rn<b.rn then b.rn else a.rn end d1
from
(select mid,email,row_number() over(partition by mid order by mid,email asc) rn from member   ) a,
(select mid,email,row_number() over(partition by mid  order by mid,email asc) rn from member   ) b
where a.mid=b.mid and a.email<> b.email
),
otpt as (
select
mid,
email1,
email2,
concat(c1,'/',d1) chk_rw
from  inp
)
select mid,email1,email2 from (
select
mid,
email1,
email2,
row_number() over (partition by mid,chk_rw order by mid,email1,chk_rw asc) rn
from
otpt
) abc
where rn=1
order by mid,email1,email2;


--output of the query:
+------+-------------------------+-------------------------+--+
| mid  |         email1          |         email2          |
+------+-------------------------+-------------------------+--+
| 100  | M100_Email_1@gmail.com  | M100_Email_2@gmail.com  |
| 100  | M100_Email_1@gmail.com  | M100_Email_3@gmail.com  |
| 100  | M100_Email_1@gmail.com  | M100_Email_4@gmail.com  |
| 100  | M100_Email_2@gmail.com  | M100_Email_3@gmail.com  |
| 100  | M100_Email_2@gmail.com  | M100_Email_4@gmail.com  |
| 100  | M100_Email_3@gmail.com  | M100_Email_4@gmail.com  |
| 200  | M200_Email_1@gmail.com  | M200_Email_2@gmail.com  |
| 200  | M200_Email_1@gmail.com  | M200_Email_3@gmail.com  |
| 200  | M200_Email_2@gmail.com  | M200_Email_3@gmail.com  |
| 300  | M300_Email_1@gmail.com  | M300_Email_2@gmail.com  |
+------+-------------------------+-------------------------+--+
10 rows selected (15.388 seconds)
