create table X (
  no_alpha VARCHAR(10) not null
    check (upper(no_alpha) = lower(no_alpha)),

  some_alpha VARCHAR(10) not null
    check (upper(some_alpha) <> lower(no_alpha)),

  all_alpha VARCHAR(10) not null
    check (all_alpha similar to '[a-zA-Z]+')
);

insert into X values ('1234', '1bc4', 'abcd'); -- OK
insert into X values ('123d', '1bc4', 'abcd'); -- NG
insert into X values ('1234', '1234', 'abcd'); -- NG
insert into X values ('1234', '1bc4', '1bcd'); -- NG
