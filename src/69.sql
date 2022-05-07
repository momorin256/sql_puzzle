create table WidgetInventory (
  receipt_nbr integer not null primary key,
  purchase_date date not null,
  qty_on_hand integer not null check (qty_on_hand >= 0),
  unit_price decimal(12, 4) not null
);

insert into WidgetInventory values
  (1, '2022-01-01', 15, 10.00),
  (2, '2022-01-02', 25, 12.00),
  (3, '2022-01-03', 40, 13.00),
  (4, '2022-01-04', 35, 12.00),
  (5, '2022-01-05', 45, 10.00);

-- A1

-- LIFO
with WidgetInventoryWithSum(receipt_nbr, purchase_date, qty_on_hand, unit_price, total_qty) as
(
  select
    receipt_nbr,
    purchase_date,
    qty_on_hand,
    unit_price,
    coalesce(sum(qty_on_hand) over (order by purchase_date desc rows between unbounded preceding and 1 preceding), 0)
  from
    WidgetInventory
  where
    purchase_date <= '2022-01-05'
)
select
  sum (
    case
      when total_qty + qty_on_hand <= 100 then qty_on_hand * unit_price
      else (100 - total_qty) * unit_price
    end)
from
  WidgetInventoryWithSum
where
  receipt_nbr >= (
    select max(W1.receipt_nbr)
    from WidgetInventoryWithSum as W1
    where W1.total_qty + W1.qty_on_hand >= 100);

-- FIFO
with WidgetInventoryWithSum(receipt_nbr, purchase_date, qty_on_hand, unit_price, total_qty) as
(
  select
    receipt_nbr,
    purchase_date,
    qty_on_hand,
    unit_price,
    coalesce(sum(qty_on_hand) over (order by purchase_date rows between unbounded preceding and 1 preceding), 0)
  from
    WidgetInventory
  where
    purchase_date <= '2022-01-05'
)
select
  sum (
    case
      when (total_qty + qty_on_hand) <= 100 then qty_on_hand * unit_price
      else (100 - total_qty) * unit_price
    end
  )
from
  WidgetInventoryWithSum
where
  receipt_nbr <= (
    select min(W1.receipt_nbr)
    from WidgetInventoryWithSum as W1
    where W1.total_qty + W1.qty_on_hand >= 100);

-- A2

-- LIFO
select sum(v)
from
(
  select
    case
      when sum(W1.qty_on_hand) <= 100 then W0.qty_on_hand * W0.unit_price
      else (100 - (sum(W1.qty_on_hand) - W0.qty_on_hand)) * W0.unit_price
    end
  from
    WidgetInventory as W0
    inner join WidgetInventory as W1
      on W0.purchase_date <= W1.purchase_date
  group by
    W0.receipt_nbr, W0.qty_on_hand, W0.unit_price
  having
    sum(W1.qty_on_hand) - W0.qty_on_hand <= 100
) as T(v);
