create table Categories (
  credit_cat char(1) not null,
  rqd_creadits integer not null
);

insert into Categories values
  ('A', 10),
  ('B', 3),
  ('C', 5);

create table CreditsEarned (
  student_name varchar(10) not null,
  credit_cat char(1) not null,
  credits integer not null
);

insert into CreditsEarned values
  ('Joe', 'A', 3), ('Joe', 'A', 2), ('Joe', 'A', 3), ('Joe', 'A', 3),
  ('Joe', 'B', 3),
  ('Joe', 'C', 3), ('Joe', 'C', 2), ('Joe', 'C', 3),

  ('Bob', 'A', 2), ('Bob', 'A', 12),
  ('Bob', 'C', 2), ('Bob', 'C', 4),

  ('Cis', 'A', 1), ('Cis', 'B', 1),

  ('Mac', 'A', 4), ('Mac', 'A', 4), ('Mac', 'A', 4), ('Mac', 'A', 3),
  ('Mac', 'B', 4), ('Mac', 'B', 3),
  ('Mac', 'C', 3), ('Mac', 'C', 3), ('Mac', 'C', 2);

-- A1
select
  student_name,
  (
    case
      when sum(has_enough_credits) = (select count(*) from Categories) then 'X'
      else null
    end
  ) as grad,
  (
    case
      when sum(has_enough_credits) <> (select count(*) from Categories) then 'X'
      else null
    end
  ) as nograd
from
(
  select
    student_name,
    (
      case
        when sum(credits) >= C0.rqd_creadits then 1
        else 0
      end
    )
  from
    CreditsEarned as E0
    inner join Categories as C0
      on E0.credit_cat = C0.credit_cat
  group by
    E0.student_name, E0.credit_cat, C0.rqd_creadits
) as T(student_name, has_enough_credits)
group by
  student_name;

-- A1'
select
  student_name,
  (
    case
      when count(student_name) = (select count(*) from Categories) then 'X'
      else null
    end
  ) as grad,
  (
    case
      when count(student_name) <> (select count(*) from Categories) then 'X'
      else null
    end
  ) as nograd
from
(
  select
    student_name, credit_cat, sum(credits)
  from
    CreditsEarned
  group by
    student_name, credit_cat
) as T(student_name, credit_cat, credits)
  left outer join Categories as C0
    on T.credit_cat = C0.credit_cat
      and T.credits >= C0.rqd_creadits
group by
  student_name;
