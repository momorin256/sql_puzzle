create table Hotel (
  floor_nbr integer not null,
  room_nbr integer
);

insert into Hotel values
  (1, (select coalesce(max(room_nbr), 0) + 1 from Hotel));
insert into Hotel values
  (1, (select coalesce(max(room_nbr), 0) + 1 from Hotel));
insert into Hotel values
  (1, (select coalesce(max(room_nbr), 0) + 1 from Hotel));
insert into Hotel values
  (2, (select coalesce(max(room_nbr), 0) + 1 from Hotel));
insert into Hotel values
  (2, (select coalesce(max(room_nbr), 0) + 1 from Hotel));
insert into Hotel values
  (3, (select coalesce(max(room_nbr), 0) + 1 from Hotel));

-- ERROR: window functions are not allowed in UPDATE
update
  Hotel
set
  room_nbr = (floor_nbr * 100)
    + row_number() over (partition by floor_nbr);

-- A1
update
  Hotel
set
  room_nbr = (T.floor_nbr * 100) + rn
from
(
  select
    floor_nbr,
    room_nbr,
    row_number() over (partition by floor_nbr) as rn
  from
    Hotel
) as T
where
  Hotel.room_nbr = T.room_nbr;

-- A2
update
  Hotel
set
  room_nbr = Hotel.floor_nbr * 100 + (
    select count(*)
    from Hotel as H0
    where (H0.floor_nbr = Hotel.floor_nbr) and (H0.room_nbr <= Hotel.room_nbr)
  );

-- A3
select distinct
  'update Hotel set room_nbr = '
    || '(' || cast(floor_nbr as char(1)) || ' * 100)'
    || '+ number(*)'
    || 'where floor_nbr = ' || cast(floor_nbr as char(1)) || ';'
from
  Hotel;
