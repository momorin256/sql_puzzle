-- ERROR:  cannot use subquery in check constraint
create table Hotel (
  room_id integer not null,
  arrival_date date not null,
  departure_date date not null,
  guest_name VARCHAR(20) not null,
  primary key (room_id, arrival_date),
  check (arrival_date <= departure_date),
  check (
    not exists (
      select 0 from Hotel as H1
        inner join Hotel as H2
      on H1.room_id = H2.room_id
        and H1.arrival_date between H2.arrival_date and H2.departure_date))
);
