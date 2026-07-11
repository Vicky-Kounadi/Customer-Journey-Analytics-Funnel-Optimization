-- CUSTOMER JOURNEY ANALYTICS + FUNNEL OPTIMIZING
-- Check my data validity and general funnel structure

-- Records num
SELECT COUNT(*) FROM raw_events;
-- 21409 records

-- Dupliactes
SELECT *, COUNT(*) AS times
FROM raw_events
GROUP BY user_id, session_id, event_time, event, device, region, channel, product_category, revenue, bonus_flag
HAVING COUNT(*) > 1;
-- No duplicates

-- Missing values anywhere
SELECT *
FROM raw_events
WHERE user_id IS NULL OR 
	session_id IS NULL OR 
	event_time IS NULL OR
	event IS NULL OR
	device IS NULL OR
	region IS NULL OR
	channel IS NULL OR
	product_category IS NULL OR 
	revenue IS NULL OR 
	bonus_flag IS NULL;
-- None

-- Negative money
SELECT *
FROM raw_events
WHERE revenue < 0;
-- No

-- Bonus valid boolean
SELECT bonus_flag, COUNT(*) AS times
FROM raw_events
GROUP BY bonus_flag;
-- Only yes/no OK

-- COUNT QUERIES
-- How many events
SELECT event, COUNT(*)
FROM raw_events
GROUP BY event;

-- How many devices
SELECT device, COUNT(*) AS times
FROM raw_events
GROUP BY device;

-- How many channels
SELECT channel, COUNT(*) AS times
FROM raw_events
GROUP BY channel;

-- How many product categ
SELECT product_category, COUNT(*) AS times
FROM raw_events
GROUP BY product_category;


-- FUNNEL/SESSION OVERVIEW
-- How many sessions
SELECT COUNT(DISTINCT session_id)
FROM raw_events;

-- How many events in a session
WITH events_per_session AS (
	SELECT session_id, COUNT(*) AS events_count
	FROM raw_events
	GROUP BY session_id
)
SELECT MIN(events_count), MAX(events_count), AVG(events_count)
FROM events_per_session;

-- Can a session have 1+ purchases
SELECT session_id, COUNT(event) AS purchase_count
FROM raw_events
WHERE event="Purchase"
GROUP BY session_id
HAVING purchase_count > 1;