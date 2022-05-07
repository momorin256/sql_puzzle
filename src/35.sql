create table InventoryAdjustments (
  req_date date not null,
  req_qty integer not null check (req_qty <> 0),
  primary key (req_date, req_qty)
);

insert into InventoryAdjustments values
  ('2022-05-01', 100),
  ('2022-05-02', 120),
  ('2022-05-03', -150),
  ('2022-05-04', 50),
  ('2022-05-05', -35);

-- A1

select
  req_date,
  req_qty,
  sum(req_qty) over (order by req_date)
from
  InventoryAdjustments;

-- A2

select
  req_date,
  req_qty,
  (
    select sum(req_qty)
    from InventoryAdjustments as I1
    where I1.req_date <= I0.req_date
  )
from
  InventoryAdjustments as I0;

-- A3

select
  I0.req_date,
  I0.req_qty,
  sum(I1.req_qty)
from
  InventoryAdjustments as I0
  inner join InventoryAdjustments as I1
    on I1.req_date <= I0.req_date
group by
  I0.req_date, I0.req_qty;

-- A3'

select
  I0.req_date,
  I0.req_qty,
  sum(I1.req_qty)
from
  InventoryAdjustments as I0, InventoryAdjustments as I1
where
  I1.req_date <= I0.req_date
group by
  I0.req_date, I0.req_qty;
