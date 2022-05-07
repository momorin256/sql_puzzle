create table Personnel (
  emp_id integer not null primary key,
  name varchar(10) not null
);

create table Phones (
  emp_id integer not null references Personnel(emp_id),
  phone_type char(3) not null
    check (phone_type in ('hom', 'fax')),
  phone_nbr char(12) not null,
  primary key (emp_id, phone_type)
);

insert into Personnel values
  (1, 'Alice'), (2, 'Bob'), (3, 'Choco'), (4, 'Dudo');

insert into Phones values
  (1, 'hom', '111-111-111'),
  (1, 'fax', '999-999-999'),
  (2, 'hom', '111-111-111'),
  (3, 'fax', '999-999-999');

-- A1

select
  name,
  P1.phone_nbr as home,
  P2.phone_nbr as fax
from
  Personnel
  left outer join Phones as P1
    on Personnel.emp_id = P1.emp_id
      and P1.phone_type = 'hom'
  left outer join Phones as P2
  on Personnel.emp_id = P2.emp_id
    and P2.phone_type = 'fax';

-- A2

select
  Personnel.name,
  max(
    case
      when P1.phone_type = 'hom' then P1.phone_nbr
      else null
    end),
  max(
    case
      when P1.phone_type = 'fax' then P1.phone_nbr
      else null
    end)
from
  Personnel
  left outer join Phones as P1
    on P1.emp_id = Personnel.emp_id
group by
  Personnel.emp_id, Personnel.name;
