create table Samples (
  sample_time timestamp not null primary key,
  load real not null
);

insert into Samples values
  ('2022-05-01 00:00', 10.00),
  ('2022-05-01 00:15', 12.00),
  ('2022-05-01 00:30', 14.00),
  ('2022-05-01 00:45', 16.00),
  ('2022-05-01 01:00', 18.00),
  ('2022-05-01 01:15', 20.00),
  ('2022-05-01 01:30', 22.00),
  ('2022-05-01 01:45', 24.00);

select
  sample_time,
  load,
  avg(load) over (order by sample_time rows between 3 preceding and current row)
from
  Samples
where
  extract(minute from sample_time) = 0;
