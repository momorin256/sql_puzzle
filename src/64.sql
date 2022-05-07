create table Boxes (
  box_id char(1) not null,
  dim char(1) not null,
  primary key (box_id, dim),
  low integer not null,
  high integer not null
);

insert into Boxes values
  (1, 'x', 0, 2), (1, 'y', 0, 2), (1, 'z', 0, 2), -- 1-2, 1-4
  (2, 'x', 1, 3), (2, 'y', 1, 3), (2, 'z', 1, 3), -- 2-4
  (3, 'x', 7, 9), (3, 'y', 7, 9), (3, 'z', 7, 9), -- 3-4
  (4, 'x', 1, 8), (4, 'y', 1, 8), (4, 'z', 1, 8);

select
  B0.box_id, B1.box_id
from
  Boxes as B0
  inner join Boxes as B1
    on B0.box_id < B1.box_id
      and B0.dim = B1.dim
      and ((B0.low between B1.low and B1.high) or (B0.high between B1.low and B1.high))
group by
  B0.box_id, B1.box_id
having
  count(*) = (select count(*) from Boxes where box_id = B0.box_id);
