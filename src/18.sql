create table Consumers (
  conname varchar(10) not null,
  address varchar(1) not null,
  con_id integer not null primary key,
  fam integer
);

insert into Consumers values
  ('Bob', 'A', 1, null),
  ('Mary', 'A', 2, 1),
  ('Joe', 'B', 3, null),
  ('Vickie', 'B', 4, 3),
  ('Mark', 'C', 5, null),
  ('Wayne', 'D', 6, null);

-- delete Bob, Joe

delete from
  Consumers as C0
where
  fam is null
  and exists (
    select 0
    from Consumers as C1
    where C0.address = C1.address
      and C0.con_id <> C1.con_id
  );
