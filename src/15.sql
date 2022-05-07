create table Salaries (
  emp_name varchar(10) not null,
  sal_date date not null,
  sal_amt decimal(8, 2) not null,
  primary key (emp_name, sal_date)
);

insert into Salaries values
  ('Tom', '1996-06-20', 500.00),
  ('Tom', '1996-08-20', 700.00),
  ('Tom', '1996-10-20', 800.00),
  ('Tom', '1996-12-20', 900.00),
  ('Dick', '1996-06-20', 500.00),
  ('Harry', '1996-06-20', 500.00),
  ('Harry', '1996-07-20', 700.00);

/* required result
 emp_name | current_salary | prev_salary |  sal_date  
----------+----------------+-------------+------------
 Tom      |         900.00 |      800.00 | 1996-12-20
 Dick     |         500.00 |             | 1996-06-20
 Harry    |         700.00 |      500.00 | 1996-07-20
*/

-- A1

select
  *
from
  (
    select
      emp_name,
      sal_amt,
      lag(sal_amt) over (partition by emp_name order by sal_date),
      sal_date
    from
      Salaries
  ) as T(emp_name, current_salary, prev_salary, sal_date)
where
  sal_date = (
    select max(S.sal_date)
    from Salaries as S
    where S.emp_name = T.emp_name
  );

-- subquery

select
  emp_name,
  sal_amt as current_salary,
  lag(sal_amt) over (partition by emp_name order by sal_date) as prev_salary,
  sal_date
from
  Salaries;

-- A2

select
  S0.emp_name, S0.sal_date, S0.sal_amt as current_salary, S1.sal_amt as prev_salary
from
  Salaries as S0
  left outer join Salaries as S1
    on S0.emp_name = S1.emp_name
      and S1.sal_date = (
        select max(S2.sal_date)
        from Salaries as S2
        where S2.emp_name = S0.emp_name
          and S2.sal_date < S0.sal_date
      )
where
  S0.sal_date = (
    select max(sal_date)
    from Salaries as S3
    where S3.emp_name = S0.emp_name
  );