-- CUSTOMER JOURNEY ANALYTICS + FUNNEL OPTIMIZING
-- Create the projects tables setup in a star scheme fashion

-- Just checks to scrap old db
DROP TABLE IF EXISTS fact_events;
DROP TABLE IF EXISTS dim_users;
DROP TABLE IF EXISTS dim_calendar;
DROP TABLE IF EXISTS dim_events;
DROP TABLE IF EXISTS dim_product_categories;
DROP TABLE IF EXISTS dim_channels;
DROP TABLE IF EXISTS dim_devices;

-- Dimension table for DEVICE types used for customer sessions
CREATE TABLE dim_devices (
	device_id INT PRIMARY KEY AUTO_INCREMENT,
    device_name VARCHAR(50) UNIQUE NOT NULL
);

SELECT * FROM dim_devices;

-- Dimension table for CHANNEL types from where the user accessed
CREATE TABLE dim_channels (
	channel_id INT PRIMARY KEY AUTO_INCREMENT,
    channel_name VARCHAR(50) UNIQUE NOT NULL
);

SELECT * FROM dim_channels;

-- Dimension table for our business' PRODUCT categories
CREATE TABLE dim_product_categories (
	product_category_id INT PRIMARY KEY AUTO_INCREMENT,
    product_category_name VARCHAR(50) UNIQUE NOT NULL
);

SELECT * FROM dim_product_categories;


-- Dimension table for different EVENTS in the session
CREATE TABLE dim_events (
	event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(50) UNIQUE NOT NULL,
    stage_order INT UNIQUE,
    is_funnel_stage BOOLEAN NOT NULL,
    stage_description VARCHAR(100)
);

SELECT * FROM dim_events;