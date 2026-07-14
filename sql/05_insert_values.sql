-- CUSTOMER JOURNEY ANALYTICS + FUNNEL OPTIMIZING
-- Transform and load/insert data from raw_events into their respective tables

-- DEVICES
INSERT INTO dim_devices(device_name)
SELECT DISTINCT device
FROM raw_events;

SELECT * FROM dim_devices;
SELECT COUNT(*) FROM dim_devices;

-- CHANNELS
INSERT INTO dim_channels(channel_name)
SELECT DISTINCT channel
FROM raw_events;

SELECT * FROM dim_channels;
SELECT COUNT(*) FROM dim_channels;

-- PRODUCT CATEGORIES
INSERT INTO dim_product_categories(product_category_name)
SELECT DISTINCT product_category
FROM raw_events;

SELECT * FROM dim_product_categories;
SELECT COUNT(*) FROM dim_product_categories;

-- CALENDAR
INSERT INTO dim_calendar(date_id, full_date, year, month, day, quarter, week, weekday_num, day_name, month_name, is_weekend)
SELECT DISTINCT REPLACE(DATE(event_time), '-', ''), 
			DATE(event_time),
            YEAR(event_time),
            MONTH(event_time),
            DAY(event_time),
            QUARTER(event_time),
            WEEK(event_time),
            WEEKDAY(event_time) +1,
            DAYNAME(event_time),
            MONTHNAME(event_time),
            CASE WHEN (WEEKDAY(event_time)+1)=6 OR (WEEKDAY(event_time)+1)=7
				THEN 1
			ELSE 0
			END
FROM raw_events;

SELECT * FROM dim_calendar;
SELECT COUNT(*) FROM dim_calendar;

-- EVENTS
INSERT INTO dim_events(event_name, is_funnel_stage, stage_order, stage_description)
SELECT DISTINCT event,
		CASE WHEN event = 'Browse' OR event = 'Add to Cart' OR event = 'Checkout' OR event = 'Purchase' 
				THEN 1
			ELSE 0
		END AS flag,
        CASE WHEN event = 'Browse'  THEN 1
			WHEN event = 'Add to Cart' THEN 2
			WHEN event = 'Checkout' THEN 3
			WHEN event = 'Purchase' THEN 4
			ELSE NULL
		END AS st,
		CASE WHEN event = 'Browse'  THEN 'Customer is browsing products'
			WHEN event = 'Add to Cart' THEN 'Customer adds an item to the cart'
			WHEN event = 'Checkout' THEN 'Customer begins checkout'
			WHEN event = 'Purchase' THEN 'Customer completes the purchase'
			ELSE NULL
		END AS descr
FROM raw_events;

SELECT * FROM dim_events;
SELECT COUNT(*) FROM dim_events;

-- USERS 
INSERT INTO dim_users(user_id, region, has_bonus)
SELECT DISTINCT user_id, region,
			CASE WHEN r.bonus_flag='Yes' THEN 1
			ELSE 0
		END AS bonus
FROM raw_events;

SELECT * FROM dim_users;
SELECT COUNT(*) FROM dim_users;