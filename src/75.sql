create table PubMap (
  pub_id char(5) not null primary key,
  x integer not null,
  y integer not null
);

insert into PubMap values
  ('P01', 0, 0),
  ('P02', 1, 2),
  ('P03', 4, 5),
  ('P04', -1, 1),
  ('P05', -1, -1);

-- A1
with Distances(pub_id_1, pub_id_2, dist) as
(
  select
    P0.pub_id,
    P1.pub_id,
    power(P0.x - P1.x, 2) + power(P0.y - P1.y, 2)
  from
    PubMap as P0
    inner join PubMap as P1
      on P0.pub_id <> P1.pub_id
)
select
  *
from
  Distances as D0
where
  D0.dist = (
    select min(D1.dist)
    from Distances as D1
    where D1.pub_id_1 = D0.pub_id_1
  );
