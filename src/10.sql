create table Pensions (
  sin char(3) not null,
  pen_year integer not null,
  month_cnt integer default 0 not null
    check (month_cnt between 0 and 12),
  earnings decimal(8, 2) default 0.00 not null
);

insert into Pensions values
  ('100', 2001, 12, 100.00),
  ('100', 2002, 12, 100.00),
  ('100', 2003, 12, 100.00),
  ('100', 2004, 12, 100.00),
  ('100', 2005, 12, 100.00),
  ('100', 2006, 12, 200.00), -- 100: 2002 - 2006 total 600.00

  ('200', 2001, 12, 100.00),
  ('200', 2002, 12, 100.00),
  ('200', 2003, 12, 100.00),
  ('200', 2004, 12, 100.00),
  ('200', 2005, 12, 100.00),
  ('200', 2006, 0, 0.00),
  ('200', 2007, 12, 100.00),
  ('200', 2008, 12, 100.00),
  ('200', 2009, 12, 100.00); -- 200: 2001 - 2005 total 500.00

-- A1
create view PenPeriods (sin, start_year, end_year, months, earnings) as
select
  P1.sin,
  P1.pen_year,
  P2.pen_year,
  (
    select sum(P3.month_cnt)
    from Pensions P3
    where P3.sin = P1.sin
      and P3.pen_year between P1.pen_year and P2.pen_year
  ),
  (
    select sum(P3.earnings)
    from Pensions P3
    where P3.sin = P1.sin
      and P3.pen_year between P1.pen_year and P2.pen_year
  )
from
  Pensions as P1
  inner join Pensions as P2
    on
      P1.sin = P2.sin
      -- and P1.pen_year < P2.pen_year
      and P2.pen_year >= P1.pen_year - 4
      and 0 < all
      (
        select month_cnt
        from Pensions as P3
        where P3.sin = P1.sin
          and P3.pen_year between P1.pen_year and P2.pen_year
      )
      and 60 <=
      (
        select sum(month_cnt)
        from Pensions as P3
        where P3.sin = P1.sin
          and P3.pen_year between P1.pen_year and P2.pen_year
      )
group by P1.sin, P1.pen_year, P2.pen_year;

select sin, start_year, end_year, earnings
from PenPeriods as P1
where end_year = (select max(end_year) from PenPeriods as P2 where P1.sin = P2.sin);

-- A2

select
  P1.sin, P1.pen_year, P3.pen_year, sum(P2.earnings)
from
  Pensions as P1
  inner join Pensions as P2
    on P2.sin = P1.sin
  inner join Pensions as P3
    on P3.sin = P1.sin
where
  P1.month_cnt > 0
  and P2.month_cnt > 0
  and P3.month_cnt > 0
  and P3.pen_year between P1.pen_year + 4 and P1.pen_year + 59
  and P2.pen_year between P1.pen_year and P3.pen_year
group by
  P1.sin, P1.pen_year, P3.pen_year
having
  60 >= sum(P2.month_cnt)
  and P3.pen_year - P1.pen_year + 1 = count(*);