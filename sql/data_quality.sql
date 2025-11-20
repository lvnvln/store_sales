-- ==========================================
-- Author: Polina
-- Project: Store Sales Forecasting
-- File: data_quality_checks.sql
-- Description: SQL queries used for checking 
--              data consistency, completeness,
--              and initial structure.
-- ==========================================

-- 1. Размеры таблиц

SELECT 'train' as table_name, COUNT(*) as row_count FROM store_sales.train
UNION ALL
SELECT 'test', COUNT(*) FROM store_sales.test
UNION ALL
SELECT 'holidays_events', COUNT(*) FROM store_sales.holidays_events
UNION ALL
SELECT 'oil', COUNT(*) FROM store_sales.oil
UNION ALL
SELECT 'stores', COUNT(*) FROM store_sales.stores
UNION ALL
SELECT 'transactions', COUNT(*) FROM store_sales.transactions;

-- 2. Диапазоны дат

SELECT 'train' as table_name, MIN(date) as min_date, MAX(date) as max_date 
FROM store_sales.train
UNION ALL
SELECT 'test', MIN(date), MAX(date) 
FROM store_sales.test
UNION ALL
SELECT 'transactions', MIN(date), MAX(date) 
FROM store_sales.transactions
UNION ALL
SELECT 'holidays_events', MIN(date), MAX(date) 
FROM store_sales.holidays_events
UNION ALL
SELECT 'oil', MIN(date), MAX(date) 
FROM store_sales.oil;

-- 3. Пропуски

SELECT SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date, 
SUM(CASE WHEN store_nbr IS NULL THEN 1 ELSE 0 END) AS null_store_nbr,
SUM(CASE WHEN family IS NULL THEN 1 ELSE 0 END) AS null_family,
SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
SUM(CASE WHEN onpromotion IS NULL THEN 1 ELSE 0 END) AS null_onpromotion
FROM store_sales.train;

-- 4. Уникальность ключей

SELECT 'train' as table_name, COUNT(*) AS row_count,
COUNT(DISTINCT id) as unique_id
FROM store_sales.train
UNION ALL
SELECT 'test', COUNT(*), COUNT(DISTINCT id)
FROM store_sales.test;

-- 5. Все ли магазины из train и test есть в stores

SELECT 'train' as table_name, COUNT(DISTINCT store_nbr) as stores_count 
FROM store_sales.train 
WHERE store_nbr IN
(SELECT DISTINCT store_nbr FROM store_sales.stores)
UNION ALL
SELECT 'test' as table_name, COUNT(DISTINCT store_nbr) as stores_count 
FROM store_sales.test 
WHERE store_nbr IN
(SELECT DISTINCT store_nbr FROM store_sales.stores)
UNION ALL
SELECT 'stores', COUNT(DISTINCT store_nbr)
FROM store_sales.stores;

-- 6. Количество магазинов и типов товара

SELECT COUNT(DISTINCT store_nbr) as stores_count,
COUNT(DISTINCT family) as family_count
FROM store_sales.train;

-- 7. Простейшая статистика продаж

SELECT MIN(sales) as min_sales,
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sales) as p25_sales,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sales) as median_sales,
ROUND(AVG(sales), 2) as avg_sales,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sales) as p75_sales,
PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY sales) as p90_sales,
PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY sales) as p95_sales,
MAX(sales) as max_sales
FROM store_sales.train;

-- 8. Топ-10 магазинов по суммарным продажам

SELECT store_nbr as store, SUM(sales) as total_sales, AVG(sales) as avg_sales
FROM store_sales.train
GROUP BY store_nbr
ORDER BY total_sales DESC;
-- limit 10

-- 9. Топ-10 категорий товаров по продажам

SELECT family, SUM(sales) AS total_sales, AVG(sales) AS avg_sales
FROM store_sales.train
GROUP BY family
ORDER BY total_sales DESC;
-- limit 10

-- 10. Продажи по датам

SELECT date, SUM(sales) AS total_sales
FROM store_sales.train
GROUP BY date
ORDER BY date;

-- 11. Продажи по дням недели

SELECT EXTRACT(DOW FROM date) AS dow, AVG(sales) AS avg_sales
FROM store_sales.train
GROUP BY EXTRACT(DOW FROM date)
ORDER BY dow;

-- 12. Продажи по месяцам и годам

SELECT EXTRACT(YEAR FROM date) AS year, EXTRACT(MONTH FROM date) AS month, SUM(sales) AS total_sales
FROM store_sales.train
GROUP BY year, month
ORDER BY year, month;
