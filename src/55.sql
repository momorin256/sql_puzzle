create table RacingResults (
  track_id char(3) not null,
  race_date date not null,
  race_nbr integer not null,
  win_name char(30) not null,
  place_name char(30) not null,
  show_name char(30) not null,
  primary key (track_id, race_date, race_nbr)
);

insert into RacingResults values
  ('001', '2022-05-01', 1, 'A1', 'B2', 'C3'),
  ('002', '2022-05-02', 2, 'A1', 'C3', 'B2'),
  ('003', '2022-05-03', 3, 'C3', 'B2', 'A1'),
  ('004', '2022-05-04', 4, 'A1', 'D4', 'C3');

-- A1
with HourseNames(name) as
(
  (select win_name from RacingResults)
  union
  (select place_name from RacingResults)
  union
  (select show_name from RacingResults)
)
select
  name,
  (select count(*) from RacingResults where win_name = name) as win,
  (select count(*) from RacingResults where place_name = name) as place,
  (select count(*) from RacingResults where show_name = name) as show
from
  HourseNames;

/*
              name              | win | place | show
--------------------------------+-----+-------+------
 A1                             |   3 |     0 |    1
 B2                             |   0 |     2 |    1
 C3                             |   1 |     1 |    2
 D4                             |   0 |     1 |    0
*/
