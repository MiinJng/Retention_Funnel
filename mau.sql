-- Step 1: 각 유저의 첫 방문 날짜를 구하는 서브쿼리
WITH FirstVisit AS (
    SELECT 
        user_id,
        MIN(DATE(createdts)) AS first_visit_date
    FROM 
        kl_data_ecom_log_data
    GROUP BY 
        user_id
),
UserActivity AS (
    SELECT 
        a.user_id,
        DATE(a.createdts) AS visit_date,
        DATE_FORMAT(a.createdts, '%Y-%m') AS visit_month,
        CASE 
            WHEN DATE(a.createdts) = f.first_visit_date THEN 'new_user' 
            ELSE 'existing_user' 
        END AS user_type
    FROM 
        kl_data_ecom_log_data a
    JOIN 
        FirstVisit f ON a.user_id = f.user_id
)
SELECT
    visit_month AS month,
    SUM(CASE WHEN user_type = 'new_user' THEN 1 ELSE 0 END) AS new_mau,
    SUM(CASE WHEN user_type = 'existing_user' THEN 1 ELSE 0 END) AS origin_mau
FROM
    UserActivity
GROUP BY
    visit_month
ORDER BY
    visit_month;