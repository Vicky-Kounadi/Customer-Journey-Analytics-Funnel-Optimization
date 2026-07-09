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