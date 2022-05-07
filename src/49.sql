create table Production (
  production_center integer not null,
  wk_date date not null,
  batch_nbr integer not null,
  widget_cnt integer not null,
  primary key (production_center, wk_date, batch_nbr)
);

insert into Production values
  (1, '2022-05-01', 1, 10),
  (1, '2022-05-01', 2, 12),
  (1, '2022-05-01', 3, 15),
  (1, '2022-05-01', 4, 17),
  (1, '2022-05-01', 5, 20),
  (1, '2022-05-01', 6, 22),
  (2, '2022-05-01', 7, 30),
  (2, '2022-05-01', 8, 40),
  (2, '2022-05-01', 9, 50),
  (2, '2022-05-02', 10, 35),
  (2, '2022-05-02', 11, 45),
  (2, '2022-05-02', 12, 55);

select
  production_center, wk_date, avg(widget_cnt)
from
  Production
group by
  production_center, wk_date;

select
  T.production_center,
  T.wk_date,
  avg(T.widget_cnt),
  (T.rn - 1) * 3 / T.cnt as group
from
(
  select
    production_center,
    wk_date,
    batch_nbr,
    widget_cnt,
    row_number() over (partition by production_center, wk_date) as rn,
    count(*) over (partition by production_center, wk_date) as cnt
  from
    Production
) as T
group by
  T.production_center,
  T.wk_date,
  (T.rn - 1) * 3 / T.cnt
order by
  T.production_center, wk_date, (T.rn - 1) * 3 / T.cnt;
