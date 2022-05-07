create table SubParts (
  sno char(2) not null,
  pno char(2) not null,
  primary key (sno, pno)
);

insert into SubParts values
  ('S1', 'P1'), ('S1', 'P2'), ('S1', 'P3'),
  ('S2', 'P1'), ('S2', 'P2'), ('S2', 'P3'), -- S1 - S2
  ('S3', 'P1'), ('S3', 'P2'),
  ('S4', 'P1'), ('S4', 'P2'), -- S3 - S4
  ('S5', 'P1');

-- A1
select
  S0.sno, S1.sno
from
  SubParts as S0
  inner join SubParts as S1
    on S0.sno < S1.sno
      and not exists ( -- S1 containts S0
        select S3.pno from SubParts as S3 where S3.sno = S0.sno
        except
        select S4.pno from SubParts as S4 where S4.sno = S1.sno
      )
      and not exists ( -- S0 containts S1
        select S4.pno from SubParts as S4 where S4.sno = S1.sno
        except
        select S3.pno from SubParts as S3 where S3.sno = S0.sno
      )
group by
  S0.sno, S1.sno;

-- A2
select
  S0.sno, S1.sno
from
  SubParts as S0
  inner join SubParts as S1
    on S0.sno < S1.sno
      and S0.pno = S1.pno
group by
  S0.sno, S1.sno
having
  count(*) = (
    select count(*) from SubParts as S2 where S2.sno = S0.sno
  )
  and count(*) = (
    select count(*) from SubParts as S3 where S3.sno = S1.sno
  );

-- A3
select
  S0.sno, S1.sno
from
  SubParts as S0
  inner join SubParts as S1
    on S0.sno < S1.sno
      and not exists ( -- (A ∨ B) - (A ∧ B) = Φ
        (
          select S3.pno from SubParts as S3 where S3.sno = S0.sno
          union
          select S4.pno from SubParts as S4 where S4.sno = S1.sno
        )
        except
        (
          select S3.pno from SubParts as S3 where S3.sno = S0.sno
          intersect
          select S4.pno from SubParts as S4 where S4.sno = S1.sno
        )
      )
group by
  S0.sno, S1.sno;
