create table Roles (
  person varchar(10) not null,
  role char(1) not null,
  primary key (person, role)
);

insert into Roles values
  ('Smith', 'O'),
  ('Smith', 'D'),
  ('Jones', 'O'),
  ('White', 'D'),
  ('Brown', 'X');

-- A1
select
  person,
  case
    when count(*) = 1 then max(role)
    else 'B'
  end
from
  Roles
where
  role in ('O', 'D')
group by
  person;

-- A2

(
  select
    person,
    role
  from
    Roles as R0
  where
    role in ('O', 'D')
    and not exists (
      select 0
      from Roles as R1
      where R1.person = R0.person
        and R1.role <> R0.role
        and R1.role in ('O', 'D'))
)
union
(
  select
    person,
    'B'
  from
    Roles as R0
  where
    role in ('O', 'D')
    and exists (
      select 0
      from Roles as R1
      where R1.person = R0.person
        and R1.role <> R0.role
        and R1.role in ('O', 'D'))
);

-- A3
-- cast '::integer' is needed because of 'No function matches the given name and argument types'.
select
  person,
  substring('DOB' from sum(position(role in 'DO'))::integer for 1)
from
  Roles
where
  role in ('D', 'O')
group by
  person;
