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