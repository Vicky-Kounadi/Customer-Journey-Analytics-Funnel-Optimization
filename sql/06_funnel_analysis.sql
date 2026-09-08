-- CUSTOMER JOURNEY ANALYTICS + FUNNEL OPTIMIZING
-- Perform EDA and Funnel analysis on my db

-- How many users reached each stage?
SELECT event_name, COUNT(DISTINCT user_id) AS users
FROM fact_events fe
JOIN dim_events de ON fe.event_id=de.event_id
GROUP BY fe.event_id;