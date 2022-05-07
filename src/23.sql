create table Titles (
  product_id integer not null primary key,
  magazine_sku integer not null,
  issn integer not null,
  issn_year integer not null
);

create table Newsstands (
  stand_id integer not null primary key,
  stand_name varchar(10) not null
);

create table Sales (
  product_id integer not null references Titles(product_id),
  stand_id integer not null references Newsstands(stand_id),
  net_sold_qty integer not null,
  primary key(product_id, stand_id)
);

insert into Titles values
  (1, 12345, 1, 2006),
  (2, 2667, 1, 2006),
  (3, 48632, 1, 2006),
  (4, 1107, 1, 2006),
  (5, 12345, 2, 2006),
  (6, 2667, 2, 2006),
  (7, 48632, 2, 2006),
  (8, 1107, 2, 2006);

insert into Newsstands values
  (1, 'Stand1'), (2, 'Stand2'), (3, 'Stand3'), (4, 'Stand4');

insert into Sales values
  (1, 1, 1), -- Stand1
  (2, 1, 4),
  (3, 1, 1),
  (4, 1, 1),
  (5, 1, 1),
  (6, 1, 2),
  (7, 1, 1),
  (3, 2, 1), -- Stand2
  (4, 2, 5),
  (8, 2, 6),
  (1, 3, 1), -- Stand3
  (2, 3, 3),
  (3, 3, 3),
  (4, 3, 1),
  (5, 3, 1),
  (6, 3, 3),
  (7, 3, 3),
  (1, 4, 1), -- Stand4
  (2, 4, 1),
  (3, 4, 4),
  (4, 4, 1),
  (5, 4, 1),
  (6, 4, 1),
  (7, 4, 2);

-- A1

select distinct
  stand_id, stand_name, avg_2667, avg_48632, avg_1107
from
  (
    select
      stand_id, stand_name, max(avg_2667), max(avg_48632), max(avg_1107)
    from
      (
        select
          S0.stand_id,
          N0.stand_name,
          avg(case when T0.magazine_sku = 2667 then S0.net_sold_qty else 0 end),
          avg(case when T0.magazine_sku = 48632 then S0.net_sold_qty else 0 end),
          avg(case when T0.magazine_sku = 1107 then S0.net_sold_qty else 0 end)
        from
          Sales as S0
          inner join Titles as T0
            on S0.product_id = T0.product_id
          inner join Newsstands as N0
            on S0.stand_id = N0.stand_id
        group by
          S0.stand_id, T0.magazine_sku, N0.stand_id
      ) as Tmp0(stand_id, stand_name, avg_2667, avg_48632, avg_1107)
    group by
      stand_id, stand_name
  ) as Tmp1(stand_id, stand_name, avg_2667, avg_48632, avg_1107)
where
  (avg_2667 > 2 and avg_48632 > 2) or (avg_1107 > 5);

-- A2

select
  S0.stand_id, N0.stand_name
from
  Sales as S0
  inner join Titles as T0
    on S0.product_id = T0.product_id
  inner join Newsstands as N0
    on S0.stand_id = N0.stand_id
group by
  S0.stand_id, N0.stand_name
having
  (
    (2 < avg(case when T0.magazine_sku = 2667 then net_sold_qty else null end))
    and
    (2 < avg(case when T0.magazine_sku = 48632 then net_sold_qty else null end))
  )
  or
  (5 < avg(case when T0.magazine_sku = 1107 then net_sold_qty else null end));
