create table PilotSkills (
  pilot varchar(10) not null,
  plane varchar(10) not null,
  primary key (pilot, plane)
);

create table Hangar (
  plane varchar(10) not null primary key
);

insert into PilotSkills values
  ('Alice', 'Plane-A'),
  ('Alice', 'Plane-B'),
  ('Becky', 'Plane-A'),
  ('Chris', 'Plane-B'),
  ('Chris', 'Plane-C');

insert into Hangar values
  ('Plane-A'), ('Plane-B');

select
  P0.pilot
from
  Hangar as H0
  inner join PilotSkills as P0
    on H0.plane = P0.plane
group by
  P0.pilot
having
  count(*) = (select count(*) from Hangar);
