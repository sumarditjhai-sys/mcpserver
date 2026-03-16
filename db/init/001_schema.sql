-- ============================================
-- File: 001_create_schema.sql
-- Sales Database Schema for MCP Project
-- ============================================

-- Clean slate (careful in production!)
DROP SCHEMA IF EXISTS sales CASCADE;
CREATE SCHEMA sales;
SET search_path TO sales;

-- ============================================
-- ENUM TYPES
-- ============================================
CREATE TYPE customer_segment AS ENUM (
    'Enterprise',
    'Mid-Market',
    'Small Business',
    'Startup'
);

CREATE TYPE order_status AS ENUM (
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
    'Cancelled',
    'Refunded'
);

-- ============================================
-- TABLES
-- ============================================

-- Regions
CREATE TABLE regions (
    region_id   SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    country     VARCHAR(100) NOT NULL,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Product Categories
CREATE TABLE product_categories (
    category_id SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Products
CREATE TABLE products (
    product_id  SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL REFERENCES product_categories(category_id),
    name        VARCHAR(200) NOT NULL,
    sku         VARCHAR(50) NOT NULL UNIQUE,
    price       NUMERIC(10, 2) NOT NULL CHECK (price > 0),
    is_active   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Sales Reps
CREATE TABLE sales_reps (
    rep_id      SERIAL PRIMARY KEY,
    region_id   INTEGER NOT NULL REFERENCES regions(region_id),
    first_name  VARCHAR(100) NOT NULL,
    last_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(200) NOT NULL UNIQUE,
    phone       VARCHAR(20),
    hire_date   DATE NOT NULL,
    is_active   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Customers
CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    company_name  VARCHAR(200) NOT NULL,
    segment       customer_segment NOT NULL,
    region_id     INTEGER NOT NULL REFERENCES regions(region_id),
    contact_name  VARCHAR(200),
    email         VARCHAR(200) UNIQUE,
    phone         VARCHAR(20),
    address       TEXT,
    created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Orders
CREATE TABLE orders (
    order_id     SERIAL PRIMARY KEY,
    customer_id  INTEGER NOT NULL REFERENCES customers(customer_id),
    rep_id       INTEGER NOT NULL REFERENCES sales_reps(rep_id),
    order_date   DATE NOT NULL,
    status       order_status NOT NULL DEFAULT 'Pending',
    total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    notes        TEXT,
    created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- Order Items
CREATE TABLE order_items (
    item_id     SERIAL PRIMARY KEY,
    order_id    INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id  INTEGER NOT NULL REFERENCES products(product_id),
    quantity    INTEGER NOT NULL CHECK (quantity > 0),
    unit_price  NUMERIC(10, 2) NOT NULL CHECK (unit_price > 0),
    discount    NUMERIC(5, 2) DEFAULT 0 CHECK (discount >= 0 AND discount <= 100),
    line_total  NUMERIC(12, 2) GENERATED ALWAYS AS (
                    quantity * unit_price * (1 - discount / 100)
                ) STORED,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Sales Targets / Quotas
CREATE TABLE sales_targets (
    target_id    SERIAL PRIMARY KEY,
    rep_id       INTEGER NOT NULL REFERENCES sales_reps(rep_id),
    quarter      INTEGER NOT NULL CHECK (quarter BETWEEN 1 AND 4),
    year         INTEGER NOT NULL CHECK (year BETWEEN 2020 AND 2030),
    quota_amount NUMERIC(12, 2) NOT NULL CHECK (quota_amount > 0),
    created_at   TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(rep_id, quarter, year)
);

-- ============================================
-- INDEXES (for query performance)
-- ============================================
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_rep ON orders(rep_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_customers_segment ON customers(segment);
CREATE INDEX idx_customers_region ON customers(region_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_sales_targets_rep_period ON sales_targets(rep_id, year, quarter);