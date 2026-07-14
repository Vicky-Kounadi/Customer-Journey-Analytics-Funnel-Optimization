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

-- Dimension table for DATE/CALENDAR details --timestamps only in the actual event-
CREATE TABLE dim_calendar (
	date_id INT PRIMARY KEY ,
    full_date DATE UNIQUE NOT NULL,
	year SMALLINT NOT NULL,
	month TINYINT NOT NULL, -- 1 till 12
	day TINYINT NOT NULL, -- 1 till 31
    quarter TINYINT NOT NULL, -- 1 till 4
	week TINYINT NOT NULL, -- 1 till 52-53
    weekday_num TINYINT NOT NULL, -- 1 till 7
	day_name VARCHAR(10) NOT NULL,
	month_name VARCHAR(10) NOT NULL,
	is_weekend BOOLEAN NOT NULL
);

SELECT * FROM dim_calendar;


-- Dimension table for USERS
CREATE TABLE dim_users (
    user_id VARCHAR(20) PRIMARY KEY,
    region VARCHAR(50) NOT NULL
);

SELECT * FROM dim_users;

CREATE TABLE fact_events (
	fact_event_id INT PRIMARY KEY AUTO_INCREMENT,
	session_id VARCHAR(50) NOT NULL, 
    user_id VARCHAR(20) NOT NULL,
	device_id INT NOT NULL,
	channel_id INT NOT NULL,
	product_category_id INT NOT NULL,
	event_id INT NOT NULL,
	date_id INT NOT NULL,
	event_timestamp DATETIME NOT NULL,
	revenue DECIMAL(15,2) DEFAULT 0.00,
	has_bonus BOOLEAN NOT NULL,
    
	FOREIGN KEY (user_id) REFERENCES dim_users(user_id),
	FOREIGN KEY (device_id) REFERENCES dim_devices(device_id),
	FOREIGN KEY (channel_id) REFERENCES dim_channels(channel_id),
	FOREIGN KEY (product_category_id) REFERENCES dim_product_categories(product_category_id),
	FOREIGN KEY (event_id) REFERENCES dim_events(event_id),
	FOREIGN KEY (date_id) REFERENCES dim_calendar(date_id)
);

SELECT * FROM fact_events;