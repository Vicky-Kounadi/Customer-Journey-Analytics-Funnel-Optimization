-- CUSTOMER JOURNEY ANALYTICS + FUNNEL OPTIMIZING
-- Transform and load/insert data from raw_events into their respective tables

-- DEVICES
INSERT INTO dim_devices(device_name)
SELECT DISTINCT device
FROM raw_events;

SELECT * FROM dim_devices;
SELECT COUNT(*) FROM dim_devices;

-- CHANNELS
INSERT INTO dim_channels(channel_name)
SELECT DISTINCT channel
FROM raw_events;

SELECT * FROM dim_channels;
SELECT COUNT(*) FROM dim_channels;

-- PRODUCT CATEGORIES
INSERT INTO dim_product_categories(product_category_name)
SELECT DISTINCT product_category
FROM raw_events;

SELECT * FROM dim_product_categories;
SELECT COUNT(*) FROM dim_product_categories;