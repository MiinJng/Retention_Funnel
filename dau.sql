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
    visit_date,
    SUM(CASE WHEN user_type = 'new_user' THEN 1 ELSE 0 END) AS new_dau,
    SUM(CASE WHEN user_type = 'existing_user' THEN 1 ELSE 0 END) AS origin_dau
FROM
    UserActivity
GROUP BY
    visit_date
ORDER BY
    visit_date;
