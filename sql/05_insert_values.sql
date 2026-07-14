-- CUSTOMER JOURNEY ANALYTICS + FUNNEL OPTIMIZING
-- Transform and load/insert data from raw_events into their respective tables

-- DEVICES
INSERT INTO dim_devices(device_name)
SELECT DISTINCT device
FROM raw_events;

SELECT * FROM dim_devices;
SELECT COUNT(*) FROM dim_devices;