-- CUSTOMER JOURNEY ANALYTICS + FUNNEL OPTIMIZING
-- Perform EDA and Funnel analysis on my db

-- How many users reached each stage?
SELECT event_name, COUNT(DISTINCT user_id) AS users
FROM fact_events fe
JOIN dim_events de ON fe.event_id=de.event_id
GROUP BY fe.event_id;

-- What is the conversion rate between each stage?
WITH 
funnel_stage AS(
	SELECT fe.event_id, event_name, COUNT(DISTINCT user_id) AS users
	FROM fact_events fe
	JOIN dim_events de ON fe.event_id=de.event_id
	GROUP BY fe.event_id
)
SELECT event_id, event_name, users, -- LAG(users) OVER (ORDER BY event_id) AS prev,
	CASE WHEN event_id=1
		THEN 100
        ELSE ROUND(users / (LAG(users) OVER (ORDER BY event_id)) * 100, 2)
	END AS conversion_rate
FROM funnel_stage;