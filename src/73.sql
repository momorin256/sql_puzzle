-- delete from my_table where coalesce(col1, col2, ..., col10) is null;
select
  'delete from '
  || 'my_table'
  || ' where coalesce('
  || (
      select
        array_to_string(array_agg(column_name), ', ')
      from
        information_schema.columns
      where
        table_name = 'my_table')
  || ') is null;';
