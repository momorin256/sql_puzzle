-- ERROR:  cannot use subquery in check constraint
create table Reservations (
  reserver varchar(10) not null primary key,
  start_seat integer not null,
  end_seat interval not null,
  check (
    start_seat <= end_seat
  ),
  check (
    not exists (
      select *
      from Reservations as R0
      where reserver <> R0.reserver
        and (
          (start_seat between R0.start_seat and R0.end_seat)
          or (end_seat between R0.start_seat and R0.end_seat))
    )
  )
);
