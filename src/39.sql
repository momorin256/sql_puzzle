create table Losses (
  cust_nbr integer not null primary key,
  a integer, b integer, c integer, d integer, e integer
);

insert into Losses values
  (10, 14, 10, 3, NULL, NULL), -- custormer 10: plan 1, 2
  (99, 5, 10, 15, NULL, NULL); -- customer 99: plan 3, 1, 2

create table PolicyCriteria (
  criteria_id integer not null,
  criteria char(1) not null,
  crit_val integer not null,
  primary key (criteria_id, criteria, crit_val)
);

insert into PolicyCriteria values
  (1, 'A', 5), -- 1
  (1, 'A', 9),
  (1, 'A', 14),
  (1, 'B', 4),
  (1, 'B', 10),
  (1, 'B', 20),
  (2, 'B', 10), -- 2
  (2, 'B', 19),
  (3, 'A', 5), -- 3
  (3, 'B', 10),
  (3, 'B', 30),
  (3, 'C', 3),
  (3, 'C', 15),
  (4, 'A', 5), -- 4
  (4, 'B', 21),
  (4, 'B', 22);

-- A1

create view CustLosses as
select cust_nbr, 'A' as criteria, a as crit_val from Losses where a is not null
union
select cust_nbr, 'B' as criteria, b as crit_val from Losses where b is not null
union
select cust_nbr, 'C' as criteria, c as crit_val from Losses where c is not null
union
select cust_nbr, 'D' as criteria, d as crit_val from Losses where d is not null
union
select cust_nbr, 'E' as criteria, e as crit_val from Losses where e is not null;

create view CustCriteria(cust_nbr, criteria_id, crit_cnt) as
select
  C0.cust_nbr, P0.criteria_id, count(*)
from
  CustLosses as C0
  inner join PolicyCriteria as P0
    on C0.criteria = P0.criteria
      and C0.crit_val = P0.crit_val
group by
  C0.cust_nbr, P0.criteria_id
having
  count(*) = (
    select count(distinct P1.criteria)
    from PolicyCriteria as P1
    where P1.criteria_id = P0.criteria_id
  );

select
  C0.cust_nbr, C0.criteria_id
from
  CustCriteria as C0
where
  C0.crit_cnt = (
    select max(C1.crit_cnt)
    from CustCriteria as C1
    where C1.cust_nbr = C0.cust_nbr
  );
