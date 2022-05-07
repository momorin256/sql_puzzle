-- PostgreSQL 14.2

-- create tables;
CREATE TABLE Personnel (
  emp_id INTEGER NOT NULL PRIMARY KEY
);

CREATE TABLE ExcuseList (
  reason_code CHAR(40) NOT NULL PRIMARY KEY
);

CREATE TABLE Absenteeism (
  emp_id INTEGER NOT NULL REFERENCES Personnel (emp_id) ON DELETE CASCADE,
  absent_date DATE NOT NULL,
  reason_code CHAR(40) NOT NULL REFERENCES ExcuseList (reason_code),
  severity_points INTEGER NOT NULL
    CHECK (severity_points BETWEEN 0 AND 40),
  PRIMARY KEY (emp_id, absent_date)
);

-- sample data
insert into Personnel values (1), (2);

insert into ExcuseList values ('some reason'), ('long term illness');

insert into Absenteeism values
  (1, '2022-05-01', 'some reason', 10),
  (1, '2022-05-02', 'some reason', 10), -- should update to 0
  (1, '2022-05-03', 'some reason', 10), -- should update to 0
  (2, '2022-05-01', 'some reason', 10),
  (2, '2022-05-03', 'some reason', 20),
  (2, '2022-05-05', 'some reason', 30); -- over 40 points

-- records to update
select * from Absenteeism as A1
  where exists (
    select 0 from Absenteeism as A2
      where A1.emp_id = A2.emp_id
        and A1.absent_date - interval '1' day = A2.absent_date);

-- update
update Absenteeism as A1
  set severity_points = 0,
    reason_code = 'long term illness'
  where exists (
    select 0 from Absenteeism as A2
      where A1.emp_id = A2.emp_id
        and A1.absent_date - interval '1' day = A2.absent_date);

-- delete 1
delete from Personnel
  where emp_id in 
    (select emp_id from Absenteeism
      group by emp_id
      having (sum(severity_points) >= 40));

-- delete 2
delete from Personnel as P
  where exists (
    select 0 from Absenteeism as A
      where P.emp_id = A.emp_id
      group by A.emp_id
      having sum(severity_points) >= 40);

-- delete 3
delete from Personnel as P
  where emp_id = (
    select emp_id from Absenteeism as A
      where P.emp_id = A.emp_id
      group by A.emp_id
      having sum(severity_points) >= 40);

-- Note for MySQL

-- reference constraint
CREATE TABLE Absenteeism (
  emp_id INTEGER NOT NULL,
  absent_date DATE NOT NULL,
  reason_code CHAR(40) NOT NULL REFERENCES ExcuseList (reason_code),
  severity_points INTEGER NOT NULL
    CHECK (severity_points BETWEEN 0 AND 40),
  PRIMARY KEY (emp_id, absent_date),
  FOREIGN KEY (emp_id) REFERENCES Personnel (emp_id) ON DELETE CASCADE
);

-- avoid "ERROR 1093 (HY000): You can't specify target table 'A1' for update in FROM clause"
update Absenteeism as A1
  set severity_points = 0,
    reason_code = 'long term illness'
  where emp_id in (
    select emp_id from (
      select emp_id from Absenteeism as A2
      where A1.emp_id = A2.emp_id
        and A1.absent_date - interval 1 day = A2.absent_date) as temp);

-- inverval must not have quotations
update Absenteeism as A1
  set severity_points = 0,
    reason_code = 'long term illness'
  where exists (
    select 0 from Absenteeism as A2
      where A1.emp_id = A2.emp_id
        and A1.absent_date - interval 1 day = A2.absent_date);