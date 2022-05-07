create table StockHistory (
  ticker_sym char(5) not null,
  sale_date date not null,
  closing_price decimal(10, 4) not null,
  trend integer not null check (trend in (-1, 0, 1)),
  primary key (ticker_sym, sale_date)
);

update
  StockHistory
set
  trend = sign(closing_price - (lag(closing_price) over (partition by ticker_sym order by sale_date)));

create view StockTrends(ticker_sym, sale_date, closing_price, trend) as
select
  ticker_sym,
  sale_date,
  closing_price,
  sign(closing_price - (lag(closing_price) over (partition by ticker_sym order by sale_date)))
from
  StockHistory;
