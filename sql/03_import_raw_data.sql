-- CUSTOMER JOURNEY ANALYTICS + FUNNEL OPTIMIZING
-- Import CSV and make a table to store the raw data

CREATE TABLE raw_events (
	user_id VARCHAR(20),
    session_id VARCHAR(50), 
    event_time DATETIME,
    event VARCHAR(50),
	device VARCHAR(50),
    region VARCHAR(50),
	channel VARCHAR(50),
	product_category VARCHAR(50),
    revenue DECIMAL(15,2) DEFAULT 0.00,
	bonus_flag BOOLEAN
);

SELECT * FROM raw_events;
SELECT COUNT(*) FROM raw_events;


