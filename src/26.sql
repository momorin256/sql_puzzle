create table DataFlowDiagrams (
  diagram_name char(2) not null,
  bubble_name char(2) not null,
  flow_name char(2) not null
);

insert into DataFlowDiagrams values
  ('D1', 'B1', 'F1'),
  ('D1', 'B1', 'F2'),
  ('D1', 'B2', 'F1'),
  ('D1', 'B2', 'F2'),
  ('D1', 'B2', 'F3'),
  ('D1', 'B3', 'F2'),
  ('D1', 'B3', 'F3'), -- D1: B1 - F3, B3 - F1
  ('D2', 'B1', 'F1'),
  ('D2', 'B1', 'F2'),
  ('D2', 'B2', 'F1'); -- D2: B2 - F2

-- A1
select
  *
from
(
  select
    Bubbles.diagram_name, Bubbles.bubble_name, Flows.flow_name
  from
    (
      select
        diagram_name, bubble_name
      from
        DataFlowDiagrams
      group by
        diagram_name, bubble_name
    ) as Bubbles
    inner join
    (
      select
        diagram_name, flow_name
      from
        DataFlowDiagrams
      group by
        diagram_name, flow_name
    ) as Flows
    on
      Bubbles.diagram_name = Flows.diagram_name
) as T(diagram_name, bubble_name, flow_name)
except
  select * from DataFlowDiagrams;

-- A1'
select
  *
from
(
  select
    D0.diagram_name, D0.bubble_name, D1.flow_name
  from
    DataFlowDiagrams as D0
    cross join DataFlowDiagrams as D1
  where
    D0.diagram_name = D1.diagram_name
) as T(diagram_name, bubble_name, flow_name)
except
  select * from DataFlowDiagrams;
