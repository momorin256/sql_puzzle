create table Payroll (
  check_id integer not null primary key,
  check_amt decimal(8, 2) not null
);

insert into Payroll values
  (1, 5.0), (2, 5.0), (3, 5.0),
  (4, 7.0), (5, 7.0), (6, 7.0), (7, 7.0),
  (8, 9.0), (9, 9.0);

-- A1
select distinct
  check_amt, cnt
from
(
  select
    check_id,
    check_amt,
    count(*) over (partition by check_amt)
  from
    Payroll
) as T0(check_id, check_amt, cnt)
where
  cnt = (
    select max(check_cnt)
    from (select count(*) from Payroll group by check_amt) as T1(check_cnt));

-- A2
select
  check_amt, count(*)
from
  Payroll
group by
  check_amt
having
  count(*) = (
    select max(check_cnt)
    from (select count(*) as check_cnt from Payroll group by check_amt) as T(check_cnt)
  );

