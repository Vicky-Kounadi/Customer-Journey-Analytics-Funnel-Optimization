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
-- 10.000

-- How many events in a session
WITH events_per_session AS (
	SELECT session_id, COUNT(*) AS events_count
	FROM raw_events
	GROUP BY session_id
)
SELECT MIN(events_count), MAX(events_count), AVG(events_count)
FROM events_per_session;
-- 1 to 4 avg 2

-- Can a session have 1+ purchases
SELECT session_id, COUNT(event) AS purchase_count
FROM raw_events
WHERE event="Purchase"
GROUP BY session_id
HAVING purchase_count > 1;
-- No

-- Can a sesion skip stages
WITH events_in_order AS (
    SELECT session_id, event_time,
        CASE event
            WHEN 'Browse' THEN 1
            WHEN 'Add to Cart' THEN 2
            WHEN 'Checkout' THEN 3
            WHEN 'Purchase' THEN 4
        END AS stage
    FROM raw_events
),
check_order AS (
    SELECT *, LAG(stage) OVER (PARTITION BY session_id ORDER BY event_time) AS previous_stage
    FROM events_in_order
)
SELECT *
FROM check_order
WHERE stage - previous_stage > 1;
-- No

-- Can events happen in wrong order
WITH events_in_order AS (
    SELECT session_id, event_time, event,
        CASE event
            WHEN 'Browse' THEN 1
            WHEN 'Add to Cart' THEN 2
            WHEN 'Checkout' THEN 3
            WHEN 'Purchase' THEN 4
        END AS stage_order
    FROM raw_events
),
check_order AS (
    SELECT *, LAG(stage_order) OVER (PARTITION BY session_id ORDER BY event_time) AS previous_stage
    FROM events_in_order
)
SELECT *
FROM check_order
WHERE stage_order < previous_stage;
-- No

-- Does every session start with browse
WITH first_event AS (
    SELECT session_id, MIN(event_time) AS first_time
    FROM raw_events
    GROUP BY session_id
)
SELECT r.session_id, r.event
FROM raw_events r
JOIN first_event f ON r.session_id = f.session_id AND r.event_time = f.first_time
WHERE r.event != 'Browse';
-- Yes

-- Does every purchase have a checkout before it-- does everyone pay
SELECT DISTINCT p.session_id
FROM raw_events p
WHERE p.event = 'Purchase'
AND NOT EXISTS (
    SELECT 1
    FROM raw_events c
    WHERE c.session_id = p.session_id AND c.event = 'Checkout' AND c.event_time < p.event_time
);
-- Yes

-- Revenue comes only from purchase
SELECT session_id, SUM(revenue) AS rev_not_pur
FROM raw_events
WHERE event != 'Purchase'
GROUP BY session_id
HAVING rev_not_pur > 0;
-- Yes

-- Multiple sessions per user
SELECT user_id, COUNT(DISTINCT session_id) AS sessions
FROM raw_events
GROUP BY user_id
HAVING sessions > 1;
-- No

-- Average session duration
WITH duration AS (
	SELECT session_id, MIN(event_time) AS session_start, MAX(event_time) AS session_end, 
		TIMESTAMPDIFF(MINUTE, MIN(event_time), MAX(event_time)) AS duration_minutes
	FROM raw_events
	GROUP BY session_id
)
SELECT AVG(duration_minutes)
FROM duration;
-- 3.98 min