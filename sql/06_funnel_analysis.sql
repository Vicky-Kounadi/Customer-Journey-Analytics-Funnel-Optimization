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

-- Overall conversion rate
WITH 
total_users AS(
	SELECT COUNT(*) AS total
    from dim_users
),
final_stage AS(
	SELECT fe.event_id, event_name, COUNT(DISTINCT user_id) AS final_users
	FROM fact_events fe
	JOIN dim_events de ON fe.event_id=de.event_id
    WHERE stage_order=4
	GROUP BY fe.event_id
)
SELECT total, final_users, ROUND((final_users / total) *100, 2) AS overall_conversion_rate
FROM total_users, final_stage;

-- What is the drop-off rate between each stage?
WITH 
funnel_stage AS(
	SELECT fe.event_id, event_name, COUNT(DISTINCT user_id) AS users
	FROM fact_events fe
	JOIN dim_events de ON fe.event_id=de.event_id
	GROUP BY fe.event_id
)
SELECT event_id, event_name,
		CASE WHEN event_id=1
			THEN 0
			ELSE (LAG(users) OVER (ORDER BY event_id) - users)  
		END AS users_lost,
		CASE WHEN event_id=1
			THEN 0
			ELSE ROUND( (LAG(users) OVER (ORDER BY event_id) - users) / (LAG(users) OVER (ORDER BY event_id)) * 100, 2)
		END AS dropoff_rate
FROM funnel_stage;

-- Biggest lekage point: drop-off is 70.95% at Checkout->Purchase

-- Average time between stages
WITH 
time_difference AS(
	SELECT session_id, event_id, event_timestamp, 
		CASE WHEN event_id=1
			THEN 0
			ELSE TIMESTAMPDIFF(MINUTE, (LAG(event_timestamp) OVER (PARTITION BY session_id ORDER BY event_id)), event_timestamp)
		END AS time_diff
	FROM fact_events
)
/*SELECT td.event_id, event_name, ROUND(AVG(time_diff), 2) AS diff_minutes
FROM time_difference td
JOIN dim_events de ON td.event_id=de.event_id
GROUP BY event_id
ORDER BY td.event_id;*/
SELECT CASE
		WHEN event_id = 1 THEN 'Browse'
		WHEN event_id = 2 THEN 'Browse → Add to Cart'
		WHEN event_id = 3 THEN 'Add to Cart → Checkout'
		WHEN event_id = 4 THEN 'Checkout → Purchase'
	END AS transition,
	ROUND( AVG(time_diff), 2) AS diff_minutes
FROM time_difference
GROUP BY transition;

-- Stage help to total revenue
WITH 
funnel_stage AS(
	SELECT fe.event_id, event_name, COUNT(DISTINCT user_id) AS users, SUM(revenue) as revenue
	FROM fact_events fe
	JOIN dim_events de ON fe.event_id=de.event_id
	GROUP BY fe.event_id
)
SELECT event_id, event_name, users, -- LAG(users) OVER (ORDER BY event_id) AS prev,
	CASE WHEN event_id=1
		THEN 100
        ELSE ROUND(users / (LAG(users) OVER (ORDER BY event_id)) * 100, 2)
	END AS conversion_rate,
    revenue
FROM funnel_stage fs;