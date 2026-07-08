-- CUSTOMER JOURNEY ANALYTICS + FUNNEL OPTIMIZING
-- Create the project database and character configuration

DROP DATABASE IF EXISTS customer_journey_analytics;

CREATE DATABASE IF NOT EXISTS customer_journey_analytics
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE customer_journey_analytics;

-- Make sure its active
SELECT DATABASE();

-- For updates and deletes for start
SET SQL_SAFE_UPDATES = 0;