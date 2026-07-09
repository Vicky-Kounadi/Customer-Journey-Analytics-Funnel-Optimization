-- CUSTOMER JOURNEY ANALYTICS + FUNNEL OPTIMIZING
-- Import CSV and make a table to store the raw data

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';

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
	bonus_flag VARCHAR(5)
);

SELECT * FROM raw_events;
SELECT COUNT(*) FROM raw_events;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Funnel_Analysis_Data.csv'
INTO TABLE raw_events
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM raw_events;
SELECT COUNT(*) FROM raw_events;


