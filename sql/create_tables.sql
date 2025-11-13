-- CREATE SCHEMA

CREATE SCHEMA IF NOT EXISTS store_sales;

-- TRAIN

DROP TABLE IF EXISTS store_sales.train;

CREATE TABLE store_sales.train (
    id INTEGER PRIMARY KEY,
    date DATE NOT NULL,
    store_nbr INTEGER NOT NULL,
    family VARCHAR(100) NOT NULL,
    sales DECIMAL(10,2) NOT NULL,
    onpromotion INTEGER
);

-- TEST

DROP TABLE IF EXISTS store_sales.test;

CREATE TABLE store_sales.test (
    id INTEGER PRIMARY KEY,
    date DATE NOT NULL,
    store_nbr INTEGER NOT NULL,
    family VARCHAR(100) NOT NULL,
    onpromotion INTEGER
);

-- TRANSACTIONS

DROP TABLE IF EXISTS store_sales.transactions;

CREATE TABLE store_sales.transactions (
    date DATE NOT NULL,
    store_nbr INTEGER NOT NULL,
    transactions INTEGER,
    PRIMARY KEY (date, store_nbr)
);

-- STORES

DROP TABLE IF EXISTS store_sales.stores;

CREATE TABLE store_sales.stores (
    store_nbr INTEGER PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(100),
    type VARCHAR(10),
    cluster INTEGER
);

-- OIL

DROP TABLE IF EXISTS store_sales.oil;

CREATE TABLE store_sales.oil (
    date DATE PRIMARY KEY,
    dcoilwtico DECIMAL(10,4)
);

-- HOLIDAYS_EVENTS

DROP TABLE IF EXISTS store_sales.holidays_events;

CREATE TABLE store_sales.holidays_events (
    id SERIAL PRIMARY KEY,   -- автоинкремент, уникальный ключ
    date DATE NOT NULL,
    type VARCHAR(100),
    locale VARCHAR(100),
    locale_name VARCHAR(100),
    description VARCHAR(200),
    transferred BOOLEAN
);

-- INDEXES

-- TRAIN indexes
CREATE INDEX idx_train_date ON store_sales.train (date);
CREATE INDEX idx_train_store ON store_sales.train (store_nbr);
CREATE INDEX idx_train_family ON store_sales.train (family);

-- TEST indexes
CREATE INDEX idx_test_date ON store_sales.test (date);
CREATE INDEX idx_test_store ON store_sales.test (store_nbr);

-- TRANSACTIONS indexes
CREATE INDEX idx_transactions_date ON store_sales.transactions (date);
CREATE INDEX idx_transactions_store ON store_sales.transactions (store_nbr);

-- HOLIDAYS index
CREATE INDEX idx_holidays_date ON store_sales.holidays_events (date);

-- OIL index
CREATE INDEX idx_oil_date ON store_sales.oil (date);
