-- ============================================
-- File: 002_seed_data.sql
-- Realistic seed data for Sales DB
-- ============================================

SET search_path TO sales;

-- ============================================
-- REGIONS
-- ============================================
INSERT INTO regions (name, country) VALUES
    ('Northeast',   'United States'),
    ('Southeast',   'United States'),
    ('Midwest',     'United States'),
    ('West Coast',  'United States'),
    ('Southwest',   'United States'),
    ('Pacific NW',  'United States'),
    ('Ontario',     'Canada'),
    ('British Columbia', 'Canada');

-- ============================================
-- PRODUCT CATEGORIES
-- ============================================
INSERT INTO product_categories (name, description) VALUES
    ('SaaS Licenses',      'Monthly and annual software licenses'),
    ('Professional Services', 'Consulting, implementation, and training'),
    ('Hardware',            'Servers, networking equipment, peripherals'),
    ('Support Plans',       'Technical support and maintenance contracts'),
    ('Data & Analytics',    'Data platform and BI tool subscriptions');

-- ============================================
-- PRODUCTS
-- ============================================
INSERT INTO products (category_id, name, sku, price) VALUES
    -- SaaS Licenses
    (1, 'CloudSync Pro - Monthly',        'CSP-MON-001',   89.99),
    (1, 'CloudSync Pro - Annual',         'CSP-ANN-001',  899.99),
    (1, 'CloudSync Enterprise - Monthly', 'CSE-MON-001',  249.99),
    (1, 'CloudSync Enterprise - Annual',  'CSE-ANN-001', 2499.99),
    (1, 'DataVault Starter',              'DVS-MON-001',   49.99),
    (1, 'DataVault Business',             'DVB-MON-001',  149.99),

    -- Professional Services
    (2, 'Implementation Package - Basic',    'PS-IMP-B',  5000.00),
    (2, 'Implementation Package - Premium',  'PS-IMP-P', 15000.00),
    (2, 'Training Workshop (per day)',       'PS-TRN-D',  2500.00),
    (2, 'Custom Integration Service',       'PS-INT-C',  8000.00),
    (2, 'Architecture Review',              'PS-ARC-R',  3500.00),

    -- Hardware
    (3, 'Edge Server Node',           'HW-ESN-001', 12999.99),
    (3, 'Network Switch 48-Port',     'HW-NSW-048',  3499.99),
    (3, 'Backup Appliance 10TB',      'HW-BAK-010',  8999.99),
    (3, 'Wireless Access Point Pro',  'HW-WAP-PRO',   599.99),

    -- Support Plans
    (4, 'Standard Support - Annual',  'SP-STD-ANN',  1200.00),
    (4, 'Premium Support - Annual',   'SP-PRM-ANN',  3600.00),
    (4, 'Critical Support - Annual',  'SP-CRT-ANN',  7200.00),

    -- Data & Analytics
    (5, 'InsightEngine Basic',        'DA-IEB-MON',   199.99),
    (5, 'InsightEngine Pro',          'DA-IEP-MON',   499.99),
    (5, 'InsightEngine Enterprise',   'DA-IEE-MON',  1299.99),
    (5, 'DataStream Connector',       'DA-DSC-MON',    79.99);

-- ============================================
-- SALES REPS
-- ============================================
INSERT INTO sales_reps (region_id, first_name, last_name, email, phone, hire_date) VALUES
    (1, 'Sarah',    'Mitchell',  'sarah.mitchell@company.com',    '555-0101', '2021-03-15'),
    (1, 'James',    'Rodriguez', 'james.rodriguez@company.com',   '555-0102', '2022-06-01'),
    (2, 'Amara',    'Johnson',   'amara.johnson@company.com',     '555-0201', '2020-09-10'),
    (2, 'David',    'Chen',      'david.chen@company.com',        '555-0202', '2023-01-20'),
    (3, 'Emily',    'Thompson',  'emily.thompson@company.com',    '555-0301', '2021-07-05'),
    (3, 'Marcus',   'Williams',  'marcus.williams@company.com',   '555-0302', '2022-11-12'),
    (4, 'Priya',    'Patel',     'priya.patel@company.com',       '555-0401', '2020-01-08'),
    (4, 'Alex',     'Kim',       'alex.kim@company.com',          '555-0402', '2021-05-22'),
    (5, 'Carlos',   'Rivera',    'carlos.rivera@company.com',     '555-0501', '2022-03-30'),
    (6, 'Jessica',  'Nguyen',    'jessica.nguyen@company.com',    '555-0601', '2021-10-18'),
    (7, 'Michael',  'Brown',     'michael.brown@company.com',     '555-0701', '2023-04-01'),
    (8, 'Lisa',     'Wang',      'lisa.wang@company.com',         '555-0801', '2022-08-15');

-- ============================================
-- CUSTOMERS (30 companies)
-- ============================================
INSERT INTO customers (company_name, segment, region_id, contact_name, email, phone) VALUES
    ('Apex Financial Group',     'Enterprise',      1, 'Robert Hayes',      'rhays@apexfin.com',        '555-1001'),
    ('BrightPath Technologies',  'Mid-Market',      1, 'Karen Liu',         'kliu@brightpath.io',       '555-1002'),
    ('Summit Healthcare',        'Enterprise',      1, 'Thomas Wright',     'twright@summithc.com',     '555-1003'),
    ('Coastal Logistics Inc',    'Mid-Market',      2, 'Maria Gonzalez',    'mgonzalez@coastlog.com',   '555-1004'),
    ('Peachtree Media',          'Small Business',  2, 'Daniel Adams',      'dadams@peachtreemedia.com','555-1005'),
    ('SunBelt Manufacturing',    'Enterprise',      2, 'Patricia Moore',    'pmoore@sunbeltmfg.com',    '555-1006'),
    ('Great Lakes Energy',       'Enterprise',      3, 'Steven Clark',      'sclark@greatlakesenergy.com','555-1007'),
    ('Heartland Retail Co',      'Mid-Market',      3, 'Nancy Baker',       'nbaker@heartlandretail.com','555-1008'),
    ('Prairie Tech Solutions',   'Startup',         3, 'Kevin Zhao',        'kzhao@prairietech.io',     '555-1009'),
    ('Golden Gate Ventures',     'Enterprise',      4, 'Amanda Foster',     'afoster@ggventures.com',   '555-1010'),
    ('Pacific Rim Trading',      'Mid-Market',      4, 'Brian Tanaka',      'btanaka@pacrimtrade.com',  '555-1011'),
    ('Silicon Edge Labs',        'Startup',         4, 'Jennifer Walsh',    'jwalsh@siliconedge.io',    '555-1012'),
    ('Bay Area Health Systems',  'Enterprise',      4, 'Christopher Lee',   'clee@bayareahs.com',       '555-1013'),
    ('Desert Sun Solar',         'Mid-Market',      5, 'Stephanie Ruiz',    'sruiz@desertsunsolar.com', '555-1014'),
    ('Cactus Creek Farms',       'Small Business',  5, 'Matthew Howell',    'mhowell@cactuscreek.com',  '555-1015'),
    ('Cascadia Software',        'Mid-Market',      6, 'Rachel Kim',        'rkim@cascadiasw.com',      '555-1016'),
    ('Emerald City Consulting',  'Small Business',  6, 'Justin Park',       'jpark@emeraldcc.com',      '555-1017'),
    ('Timberline Industries',    'Enterprise',      6, 'Laura Bennett',     'lbennett@timberline.com',  '555-1018'),
    ('Maple Leaf Financial',     'Enterprise',      7, 'Andrew Scott',      'ascott@mapleleaffin.ca',   '555-1019'),
    ('Northern Shield Insurance','Mid-Market',      7, 'Michelle Dubois',   'mdubois@northshield.ca',   '555-1020'),
    ('Toronto Digital Agency',   'Startup',         7, 'Ryan Campbell',     'rcampbell@torontodig.ca',  '555-1021'),
    ('Vancouver Port Authority', 'Enterprise',      8, 'Diana Chang',       'dchang@vanport.ca',        '555-1022'),
    ('BC Timber Exports',        'Mid-Market',      8, 'George Wilson',     'gwilson@bctimber.ca',      '555-1023'),
    ('Quantum Dynamics Corp',    'Enterprise',      1, 'Olivia Martin',     'omartin@quantumdyn.com',   '555-1024'),
    ('Velocity Logistics',       'Mid-Market',      3, 'Nathan Reed',       'nreed@velocitylog.com',    '555-1025'),
    ('RedRock Analytics',        'Startup',         5, 'Samantha Flores',   'sflores@redrockdata.com',  '555-1026'),
    ('CloudNine Hospitality',    'Mid-Market',      2, 'Tyler Morgan',      'tmorgan@cloudnineh.com',   '555-1027'),
    ('FrostByte Gaming',         'Startup',         4, 'Ashley Cooper',     'acooper@frostbyte.io',     '555-1028'),
    ('Heritage Foods Ltd',       'Small Business',  7, 'Patrick O''Brien',  'pobrien@heritagefoods.ca', '555-1029'),
    ('Aurora Biotech',           'Enterprise',      6, 'Megan Stewart',     'mstewart@aurorabio.com',   '555-1030');

-- ============================================
-- ORDERS (spanning 2023-2024)
-- ============================================
INSERT INTO orders (customer_id, rep_id, order_date, status, notes) VALUES
    -- 2023 Q1
    (1,  1,  '2023-01-15', 'Delivered',  'Annual contract renewal'),
    (3,  1,  '2023-01-22', 'Delivered',  'New customer onboarding'),
    (7,  5,  '2023-02-03', 'Delivered',  'Expansion deal'),
    (10, 7,  '2023-02-14', 'Delivered',  'Enterprise bundle'),
    (19, 11, '2023-02-28', 'Delivered',  'Initial purchase'),
    (4,  3,  '2023-03-05', 'Delivered',  NULL),
    (16, 10, '2023-03-18', 'Delivered',  'Referred by Emerald City'),

    -- 2023 Q2
    (2,  2,  '2023-04-02', 'Delivered',  NULL),
    (6,  3,  '2023-04-15', 'Delivered',  'Large hardware order'),
    (8,  6,  '2023-05-01', 'Delivered',  'Mid-year expansion'),
    (11, 8,  '2023-05-12', 'Delivered',  NULL),
    (13, 7,  '2023-05-25', 'Delivered',  'Healthcare compliance package'),
    (14, 9,  '2023-06-08', 'Delivered',  NULL),
    (22, 12, '2023-06-20', 'Delivered',  'Port authority modernization'),

    -- 2023 Q3
    (1,  1,  '2023-07-10', 'Delivered',  'Add-on licenses'),
    (5,  4,  '2023-07-22', 'Delivered',  NULL),
    (9,  5,  '2023-08-05', 'Delivered',  'Startup growth package'),
    (12, 8,  '2023-08-18', 'Delivered',  NULL),
    (15, 9,  '2023-08-30', 'Delivered',  'Small business bundle'),
    (17, 10, '2023-09-12', 'Delivered',  NULL),
    (20, 11, '2023-09-25', 'Delivered',  'Insurance platform rollout'),

    -- 2023 Q4
    (24, 1,  '2023-10-03', 'Delivered',  'Enterprise deal - quantum computing div'),
    (6,  3,  '2023-10-18', 'Delivered',  'Year-end hardware refresh'),
    (10, 7,  '2023-11-01', 'Delivered',  'Contract expansion'),
    (18, 10, '2023-11-15', 'Delivered',  'Enterprise onboarding'),
    (21, 11, '2023-11-28', 'Delivered',  NULL),
    (23, 12, '2023-12-05', 'Delivered',  'Year-end deal'),
    (25, 6,  '2023-12-15', 'Delivered',  'Logistics platform'),
    (7,  5,  '2023-12-28', 'Delivered',  'Annual renewal'),

    -- 2024 Q1
    (1,  1,  '2024-01-08', 'Delivered',  '2024 renewal'),
    (3,  2,  '2024-01-20', 'Delivered',  NULL),
    (10, 7,  '2024-02-01', 'Delivered',  'Q1 expansion'),
    (13, 8,  '2024-02-14', 'Delivered',  NULL),
    (19, 11, '2024-02-28', 'Delivered',  'Annual renewal'),
    (27, 4,  '2024-03-10', 'Delivered',  'New customer'),
    (30, 10, '2024-03-22', 'Delivered',  'Biotech platform deal'),

    -- 2024 Q2
    (2,  1,  '2024-04-05', 'Delivered',  NULL),
    (6,  3,  '2024-04-18', 'Delivered',  'Quarterly order'),
    (8,  5,  '2024-05-02', 'Shipped',   'In transit'),
    (11, 7,  '2024-05-15', 'Delivered',  NULL),
    (14, 9,  '2024-05-28', 'Delivered',  NULL),
    (16, 10, '2024-06-10', 'Shipped',   NULL),
    (22, 12, '2024-06-22', 'Confirmed', 'Awaiting shipment'),

    -- 2024 Q3
    (26, 9,  '2024-07-05', 'Confirmed', 'Startup analytics package'),
    (28, 8,  '2024-07-18', 'Confirmed', 'Gaming platform infrastructure'),
    (29, 11, '2024-08-01', 'Pending',   'Awaiting approval'),
    (4,  3,  '2024-08-12', 'Pending',   'Q3 order'),
    (12, 7,  '2024-08-25', 'Pending',   NULL),
    (9,  6,  '2024-09-01', 'Pending',   'Growth package renewal'),
    (24, 2,  '2024-09-10', 'Cancelled', 'Budget freeze'),
    (5,  4,  '2024-09-15', 'Pending',   NULL);

-- ============================================
-- ORDER ITEMS
-- ============================================
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES
    -- Order 1: Apex Financial - Annual renewal
    (1, 4, 5,  2499.99, 10),    -- CloudSync Enterprise Annual x5
    (1, 17, 1, 3600.00, 0),     -- Premium Support

    -- Order 2: Summit Healthcare - Onboarding
    (2, 4,  10, 2499.99, 15),   -- Enterprise Annual x10
    (2, 8,  1,  15000.00, 0),   -- Implementation Premium
    (2, 18, 1,  7200.00, 0),    -- Critical Support

    -- Order 3: Great Lakes Energy - Expansion
    (3, 3,  20, 249.99, 5),     -- CloudSync Enterprise Monthly x20
    (3, 10, 1,  8000.00, 0),    -- Custom Integration
    (3, 21, 10, 1299.99, 10),   -- InsightEngine Enterprise x10

    -- Order 4: Golden Gate Ventures - Enterprise bundle
    (4, 4,  15, 2499.99, 20),   -- Enterprise Annual x15 (big discount)
    (4, 8,  1,  15000.00, 0),   -- Implementation Premium
    (4, 18, 1,  7200.00, 0),    -- Critical Support
    (4, 21, 5,  1299.99, 15),   -- InsightEngine Enterprise

    -- Order 5: Maple Leaf Financial
    (5, 4,  8,  2499.99, 10),   -- Enterprise Annual x8
    (5, 17, 1,  3600.00, 0),    -- Premium Support

    -- Order 6: Coastal Logistics
    (6, 2,  5,  899.99, 0),     -- CloudSync Pro Annual x5
    (6, 7,  1,  5000.00, 0),    -- Implementation Basic
    (6, 16, 1,  1200.00, 0),    -- Standard Support

    -- Order 7: Cascadia Software
    (7, 6,  10, 149.99, 5),     -- DataVault Business x10
    (7, 9,  2,  2500.00, 0),    -- Training x2 days
    (7, 20, 5,  499.99, 0),     -- InsightEngine Pro x5

    -- Order 8: BrightPath Technologies
    (8, 3,  5,  249.99, 0),     -- Enterprise Monthly x5
    (8, 19, 3,  199.99, 0),     -- InsightEngine Basic x3

    -- Order 9: SunBelt Manufacturing - Large hardware
    (9, 12, 3,  12999.99, 5),   -- Edge Server x3
    (9, 13, 5,  3499.99, 0),    -- Network Switch x5
    (9, 14, 2,  8999.99, 0),    -- Backup Appliance x2
    (9, 15, 20, 599.99, 10),    -- Wireless AP x20
    (9, 18, 1,  7200.00, 0),    -- Critical Support

    -- Order 10: Heartland Retail
    (10, 2, 8,  899.99, 5),     -- CloudSync Pro Annual x8
    (10, 16, 1, 1200.00, 0),    -- Standard Support

    -- Order 11: Pacific Rim Trading
    (11, 3,  3, 249.99, 0),     -- Enterprise Monthly x3
    (11, 22, 5, 79.99, 0),      -- DataStream Connector x5

    -- Order 12: Bay Area Health
    (12, 4,  12, 2499.99, 12),  -- Enterprise Annual x12
    (12, 8,  1,  15000.00, 0),  -- Implementation Premium
    (12, 18, 1,  7200.00, 0),   -- Critical Support
    (12, 21, 8,  1299.99, 10),  -- InsightEngine Enterprise x8

    -- Order 13: Desert Sun Solar
    (13, 2,  3,  899.99, 0),    -- CloudSync Pro Annual x3
    (13, 19, 2,  199.99, 0),    -- InsightEngine Basic x2

    -- Order 14: Vancouver Port Authority
    (14, 4,  6,  2499.99, 10),  -- Enterprise Annual x6
    (14, 10, 2,  8000.00, 0),   -- Custom Integration x2
    (14, 17, 1,  3600.00, 0),   -- Premium Support

    -- Order 15: Apex Financial - Add-on
    (15, 21, 3,  1299.99, 5),   -- InsightEngine Enterprise x3
    (15, 22, 10, 79.99, 0),     -- DataStream Connector x10

    -- Order 16: Peachtree Media
    (16, 1,  3,  89.99, 0),     -- CloudSync Pro Monthly x3
    (16, 5,  2,  49.99, 0),     -- DataVault Starter x2

    -- Order 17: Prairie Tech
    (17, 5,  5,  49.99, 20),    -- DataVault Starter x5 (startup discount)
    (17, 7,  1,  5000.00, 15),  -- Implementation Basic

    -- Order 18: Silicon Edge Labs
    (18, 6,  3,  149.99, 10),   -- DataVault Business x3
    (18, 19, 2,  199.99, 0),    -- InsightEngine Basic x2

    -- Order 19: Cactus Creek Farms
    (19, 1,  2,  89.99, 0),     -- CloudSync Pro Monthly x2
    (19, 16, 1,  1200.00, 0),   -- Standard Support

    -- Order 20: Emerald City Consulting
    (20, 2,  2,  899.99, 0),    -- CloudSync Pro Annual x2
    (20, 9,  1,  2500.00, 0),   -- Training 1 day

    -- Order 21: Northern Shield Insurance
    (21, 3,  5,  249.99, 5),    -- Enterprise Monthly x5
    (21, 20, 3,  499.99, 0),    -- InsightEngine Pro x3
    (21, 17, 1,  3600.00, 0),   -- Premium Support

    -- Order 22: Quantum Dynamics
    (22, 4,  20, 2499.99, 18),  -- Enterprise Annual x20 (big deal)
    (22, 8,  2,  15000.00, 0),  -- Implementation Premium x2
    (22, 18, 1,  7200.00, 0),   -- Critical Support
    (22, 21, 15, 1299.99, 12),  -- InsightEngine Enterprise x15

    -- Order 23: SunBelt - Hardware refresh
    (23, 12, 2,  12999.99, 0),  -- Edge Server x2
    (23, 13, 10, 3499.99, 8),   -- Network Switch x10

    -- Order 24: Golden Gate - Expansion
    (24, 21, 10, 1299.99, 10),  -- InsightEngine Enterprise x10
    (24, 9,  3,  2500.00, 0),   -- Training 3 days

    -- Order 25: Timberline Industries
    (25, 4,  8,  2499.99, 10),  -- Enterprise Annual x8
    (25, 8,  1,  15000.00, 0),  -- Implementation Premium
    (25, 17, 1,  3600.00, 0),   -- Premium Support

    -- Order 26: Toronto Digital Agency
    (26, 5,  3,  49.99, 25),    -- DataVault Starter x3 (startup)
    (26, 1,  3,  89.99, 10),    -- CloudSync Pro Monthly x3

    -- Order 27: BC Timber Exports
    (27, 2,  4,  899.99, 0),    -- CloudSync Pro Annual x4
    (27, 16, 1,  1200.00, 0),   -- Standard Support

    -- Order 28: Velocity Logistics
    (28, 3,  8,  249.99, 5),    -- Enterprise Monthly x8
    (28, 10, 1,  8000.00, 0),   -- Custom Integration
    (28, 20, 5,  499.99, 0),    -- InsightEngine Pro x5

    -- Order 29: Great Lakes - Renewal
    (29, 4,  20, 2499.99, 15),  -- Enterprise Annual x20
    (29, 18, 1,  7200.00, 0),   -- Critical Support

    -- 2024 Orders
    -- Order 30: Apex 2024 Renewal
    (30, 4,  5,  2499.99, 10),  -- Enterprise Annual x5
    (30, 17, 1,  3600.00, 0),   -- Premium Support
    (30, 21, 5,  1299.99, 5),   -- InsightEngine Enterprise x5

    -- Order 31: Summit Healthcare
    (31, 21, 5,  1299.99, 10),  -- InsightEngine Enterprise x5
    (31, 9,  2,  2500.00, 0),   -- Training x2

    -- Order 32: Golden Gate Q1
    (32, 22, 20, 79.99, 0),     -- DataStream Connector x20
    (32, 20, 10, 499.99, 10),   -- InsightEngine Pro x10

    -- Order 33: Bay Area Health
    (33, 21, 5,  1299.99, 10),  -- InsightEngine Enterprise x5
    (33, 9,  1,  2500.00, 0),   -- Training

    -- Order 34: Maple Leaf Renewal
    (34, 4,  8,  2499.99, 10),  -- Enterprise Annual x8
    (34, 17, 1,  3600.00, 0),   -- Premium Support
    (34, 21, 3,  1299.99, 0),   -- InsightEngine Enterprise x3

    -- Order 35: CloudNine Hospitality
    (35, 2,  6,  899.99, 0),    -- CloudSync Pro Annual x6
    (35, 7,  1,  5000.00, 0),   -- Implementation Basic
    (35, 16, 1,  1200.00, 0),   -- Standard Support

    -- Order 36: Aurora Biotech
    (36, 4,  12, 2499.99, 12),  -- Enterprise Annual x12
    (36, 8,  1,  15000.00, 0),  -- Implementation Premium
    (36, 18, 1,  7200.00, 0),   -- Critical Support
    (36, 21, 8,  1299.99, 8),   -- InsightEngine Enterprise

    -- Order 37: BrightPath
    (37, 3,  8,  249.99, 5),    -- Enterprise Monthly x8
    (37, 20, 5,  499.99, 0),    -- InsightEngine Pro x5

    -- Order 38: SunBelt Q2
    (38, 15, 30, 599.99, 12),   -- Wireless AP x30
    (38, 13, 5,  3499.99, 5),   -- Network Switch x5

    -- Order 39: Heartland
    (39, 2,  10, 899.99, 8),    -- CloudSync Pro Annual x10
    (39, 7,  1,  5000.00, 0),   -- Implementation Basic

    -- Order 40: Pacific Rim
    (40, 3,  5,  249.99, 0),    -- Enterprise Monthly x5
    (40, 20, 3,  499.99, 0),    -- InsightEngine Pro x3

    -- Order 41: Desert Sun Solar
    (41, 19, 5,  199.99, 0),    -- InsightEngine Basic x5
    (41, 22, 3,  79.99, 0),     -- DataStream Connector x3

    -- Order 42: Cascadia
    (42, 6,  15, 149.99, 10),   -- DataVault Business x15
    (42, 20, 8,  499.99, 5),    -- InsightEngine Pro x8

    -- Order 43: Vancouver Port
    (43, 12, 2,  12999.99, 5),  -- Edge Server x2
    (43, 14, 1,  8999.99, 0),   -- Backup Appliance
    (43, 18, 1,  7200.00, 0),   -- Critical Support

    -- Order 44: RedRock Analytics
    (44, 20, 3,  499.99, 15),   -- InsightEngine Pro x3 (startup)
    (44, 22, 5,  79.99, 0),     -- DataStream Connector x5

    -- Order 45: FrostByte Gaming
    (45, 12, 1,  12999.99, 0),  -- Edge Server x1
    (45, 6,  5,  149.99, 10),   -- DataVault Business x5
    (45, 19, 3,  199.99, 0),    -- InsightEngine Basic x3

    -- Order 46: Heritage Foods
    (46, 1,  5,  89.99, 0),     -- CloudSync Pro Monthly x5
    (46, 16, 1,  1200.00, 0),   -- Standard Support

    -- Order 47: Coastal Logistics
    (47, 3,  10, 249.99, 5),    -- Enterprise Monthly x10
    (47, 10, 1,  8000.00, 0),   -- Custom Integration

    -- Order 48: Silicon Edge
    (48, 6,  8,  149.99, 10),   -- DataVault Business x8
    (48, 7,  1,  5000.00, 10),  -- Implementation Basic

    -- Order 49: Prairie Tech Renewal
    (49, 6,  5,  149.99, 15),   -- DataVault Business x5
    (49, 20, 2,  499.99, 10),   -- InsightEngine Pro x2

    -- Order 50: Quantum Dynamics - Cancelled
    (50, 21, 10, 1299.99, 10),  -- Would have been big...

    -- Order 51: Peachtree Media
    (51, 2,  3,  899.99, 0),    -- CloudSync Pro Annual x3
    (51, 19, 2,  199.99, 0);    -- InsightEngine Basic x2

-- ============================================
-- UPDATE ORDER TOTALS from line items
-- ============================================
UPDATE orders o
SET total_amount = (
    SELECT COALESCE(SUM(oi.line_total), 0)
    FROM order_items oi
    WHERE oi.order_id = o.order_id
);

-- ============================================
-- SALES TARGETS (2023 & 2024)
-- ============================================
INSERT INTO sales_targets (rep_id, quarter, year, quota_amount) VALUES
    -- 2023 Quotas
    (1,  1, 2023, 50000),  (1,  2, 2023, 55000),  (1,  3, 2023, 55000),  (1,  4, 2023, 65000),
    (2,  1, 2023, 35000),  (2,  2, 2023, 40000),  (2,  3, 2023, 40000),  (2,  4, 2023, 45000),
    (3,  1, 2023, 45000),  (3,  2, 2023, 50000),  (3,  3, 2023, 50000),  (3,  4, 2023, 55000),
    (4,  1, 2023, 30000),  (4,  2, 2023, 30000),  (4,  3, 2023, 35000),  (4,  4, 2023, 35000),
    (5,  1, 2023, 50000),  (5,  2, 2023, 50000),  (5,  3, 2023, 55000),  (5,  4, 2023, 60000),
    (6,  1, 2023, 35000),  (6,  2, 2023, 40000),  (6,  3, 2023, 40000),  (6,  4, 2023, 45000),
    (7,  1, 2023, 60000),  (7,  2, 2023, 65000),  (7,  3, 2023, 65000),  (7,  4, 2023, 70000),
    (8,  1, 2023, 40000),  (8,  2, 2023, 45000),  (8,  3, 2023, 45000),  (8,  4, 2023, 50000),
    (9,  1, 2023, 30000),  (9,  2, 2023, 35000),  (9,  3, 2023, 35000),  (9,  4, 2023, 40000),
    (10, 1, 2023, 40000),  (10, 2, 2023, 45000),  (10, 3, 2023, 45000),  (10, 4, 2023, 50000),
    (11, 1, 2023, 40000),  (11, 2, 2023, 40000),  (11, 3, 2023, 45000),  (11, 4, 2023, 45000),
    (12, 1, 2023, 35000),  (12, 2, 2023, 40000),  (12, 3, 2023, 40000),  (12, 4, 2023, 45000),

    -- 2024 Quotas (increased targets)
    (1,  1, 2024, 60000),  (1,  2, 2024, 65000),  (1,  3, 2024, 65000),  (1,  4, 2024, 70000),
    (2,  1, 2024, 40000),  (2,  2, 2024, 45000),  (2,  3, 2024, 45000),  (2,  4, 2024, 50000),
    (3,  1, 2024, 50000),  (3,  2, 2024, 55000),  (3,  3, 2024, 55000),  (3,  4, 2024, 60000),
    (4,  1, 2024, 35000),  (4,  2, 2024, 35000),  (4,  3, 2024, 40000),  (4,  4, 2024, 40000),
    (5,  1, 2024, 55000),  (5,  2, 2024, 55000),  (5,  3, 2024, 60000),  (5,  4, 2024, 65000),
    (6,  1, 2024, 40000),  (6,  2, 2024, 45000),  (6,  3, 2024, 45000),  (6,  4, 2024, 50000),
    (7,  1, 2024, 70000),  (7,  2, 2024, 70000),  (7,  3, 2024, 75000),  (7,  4, 2024, 75000),
    (8,  1, 2024, 45000),  (8,  2, 2024, 50000),  (8,  3, 2024, 50000),  (8,  4, 2024, 55000),
    (9,  1, 2024, 35000),  (9,  2, 2024, 40000),  (9,  3, 2024, 40000),  (9,  4, 2024, 45000),
    (10, 1, 2024, 50000),  (10, 2, 2024, 50000),  (10, 3, 2024, 55000),  (10, 4, 2024, 55000),
    (11, 1, 2024, 45000),  (11, 2, 2024, 50000),  (11, 3, 2024, 50000),  (11, 4, 2024, 55000),
    (12, 1, 2024, 40000),  (12, 2, 2024, 45000),  (12, 3, 2024, 45000),  (12, 4, 2024, 50000);