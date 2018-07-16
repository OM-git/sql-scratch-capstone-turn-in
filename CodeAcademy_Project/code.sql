/* 1. Three queries will allow us to count and find how source
and campaigns are related */
-- Count the distinct campaigns
SELECT COUNT(DISTINCT utm_campaign) AS 'Number Of Campaigns'
FROM page_visits;
-- Count the distinct sources
SELECT COUNT(DISTINCT utm_source) AS 'Number Of Sources'
FROM page_visits;
-- find out relation between Source & Campaign
SELECT DISTINCT utm_source AS 'Source',
	utm_campaign AS 'Campaigns'
FROM page_visits;

-- 2. get the distinct pages on the website
SELECT DISTINCT page_name AS 'CoolTShirts pages'
FROM page_visits;

-- 3. The first touches the website has per campaign
-- using WITH, a temporary table finds the first touches by each user_id
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
-- next table is used to apply an inner join on first_touch and page_visits tables, 
-- this adds source and campaign to user_id and timestamp 
ft_attr AS (
	SELECT ft.user_id,
    		 ft.first_touch_at,
    		 pv.utm_source,
		     pv.utm_campaign
	FROM first_touch AS ft
	JOIN page_visits AS pv
    	ON ft.user_id = pv.user_id
    	AND ft.first_touch_at = pv.timestamp
)
-- counting and selecting each row that includes campaigns and ordering it
SELECT ft_attr.utm_campaign AS 'Campaigns',
       COUNT(*) AS 'Number of First Touches'
FROM ft_attr
GROUP BY 1
ORDER BY 2 DESC;

-- 4. The last touches the website has per campaign
-- using WITH, a temporary table finds the last touches by each user_id
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
-- next table is used to apply an inner join on last_touch and page_visits tables, 
-- this adds source and campaign to user_id and timestamp 
lt_attr AS (
	SELECT lt.user_id,
    		 lt.last_touch_at,
    		 pv.utm_source,
		     pv.utm_campaign
	FROM last_touch AS lt
	JOIN page_visits AS pv
    	ON lt.user_id = pv.user_id
    	AND lt.last_touch_at = pv.timestamp
)
-- counting and selecting each row that includes campaigns and ordering it
SELECT lt_attr.utm_campaign AS 'Campaigns',
       COUNT(*) AS 'Number of Last Touches'
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;

-- 5. selecting counting only the distinct page_name which 
corresponds to: "4 - purchase"
SELECT COUNT(DISTINCT user_id) AS '"4 - purchase" Users'
FROM page_visits
WHERE page_name = '4 - purchase';

-- 6. counting the last touches for each campaign in the purchase page 
-- using WITH, a temporary table finds the last touches by each user_id
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
  	WHERE page_name = '4 - purchase'
    GROUP BY user_id),
-- next table is used to apply an inner join on last_touch and page_visits tables, 
-- this adds source and campaign to user_id and timestamp 
lt_attr AS (
	SELECT lt.user_id,
    		 lt.last_touch_at,
    		 pv.utm_source,
		     pv.utm_campaign
	FROM last_touch AS lt
	JOIN page_visits AS pv
    	ON lt.user_id = pv.user_id
    	AND lt.last_touch_at = pv.timestamp
)
-- counting and selecting each row that includes campaigns and ordering it
SELECT lt_attr.utm_campaign AS 'Campaigns',
       COUNT(*) AS 'No. of Last Touches for purchase page'
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;