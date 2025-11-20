-- ==========================================
-- Author: Polina
-- Project: Store Sales Forecasting
-- File: data_queries.sql
-- ==========================================

-- 1. Связь типа магазина и общих/средних продаж

SELECT s.type, SUM(t.sales) as total_sales, AVG(t.sales) as avg_sales
FROM store_sales.train as t JOIN store_sales.stores as s ON t.store_nbr=s.store_nbr
GROUP BY s.type
ORDER BY total_sales DESC;

-- 2. Продажи в праздник/не праздник

SELECT is_holiday, avg(total_sales) as avg_daily_sales
FROM (SELECT t.date, SUM(t.sales) as total_sales,
CASE WHEN h.date IS NULL THEN 0 ELSE 1 END AS is_holiday
FROM store_sales.train as t LEFT JOIN store_sales.holidays_events as h on t.date=h.date
GROUP BY t.date, is_holiday) table1
GROUP BY is_holiday

-- 3. Корреляция продаж и числа транзакций

SELECT t.date, t.store_nbr, SUM(t.sales) AS total_sales, tr.transactions
FROM store_sales.train t
JOIN store_sales.transactions tr ON t.date = tr.date AND t.store_nbr = tr.store_nbr
GROUP BY t.date, t.store_nbr, tr.transactions

-- 4. Корреляция цены на нефть и продаж

SELECT t.date, t.store_nbr, SUM(t.sales) AS total_sales, o.dcoilwtico
FROM store_sales.train t
JOIN store_sales.oil o
ON t.date = o.date AND t.date = o.date
GROUP BY t.date, t.store_nbr, o.dcoilwtico
ORDER BY t.date