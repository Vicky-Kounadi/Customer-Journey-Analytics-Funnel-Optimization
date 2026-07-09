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
