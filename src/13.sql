create table Register (
  course_id integer not null,
  student_name varchar(10) not null,
  teacher_name varchar(10) not null,
  primary key (course_id, student_name, teacher_name)
);

insert into Register values
  (1, 'Student1', 'Teacher1'),
  (2, 'Student1', 'Teacher1'),
  (2, 'Student1', 'Teacher2'),
  (3, 'Student1', 'Teacher1'),
  (3, 'Student1', 'Teacher2'),
  (3, 'Student1', 'Teacher3');

-- A1
select
  course_id,
  min(teacher_name),
  max(case
    when 1 = (select count(*) from Register as R1 where R0.course_id = R1.course_id)
      then NULL
    when 2 = (select count(*) from Register as R1 where R0.course_id = R1.course_id)
      then (
        select max(teacher_name)
        from Register as R1
        where R0.course_id = R1.course_id
          and R0.teacher_name <> R1.teacher_name
      )
    else '--More--'
  end)
from
  Register as R0
group by
  course_id;

-- A2
select
  course_id,
  student_name,
  min(teacher_name),
  case
    when count(*) = 1 then NULL
    when count(*) = 2 then max(teacher_name)
    else '--More--' end
from
  Register
group by
  course_id, student_name;
