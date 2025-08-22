-- 1. Calculate inventory turnover metrics per branch
SELECT
    bd.branch_name,
    SUM(CASE WHEN im.transaction_type = 'IN' THEN im.quantity ELSE 0 END) AS total_stock_in,
    SUM(CASE WHEN im.transaction_type = 'OUT' THEN im.quantity ELSE 0 END) AS total_stock_out,
    SUM(CASE WHEN im.transaction_type = 'IN' THEN im.quantity ELSE 0 END)
    - SUM(CASE WHEN im.transaction_type = 'OUT' THEN im.quantity ELSE 0 END)
    - SUM(CASE WHEN im.transaction_type = 'EXP' THEN im.quantity ELSE 0 END) AS current_stock,
    SUM(CASE WHEN im.transaction_type = 'EXP' THEN im.quantity ELSE 0 END) AS expired_items,
    ROUND(
        SUM(CASE WHEN im.transaction_type = 'OUT' THEN im.quantity ELSE 0 END) /
        NULLIF(
            ((SUM(CASE WHEN im.transaction_type = 'IN' THEN im.quantity ELSE 0 END) +
            (SUM(CASE WHEN im.transaction_type = 'IN' THEN im.quantity ELSE 0 END)
            - SUM(CASE WHEN im.transaction_type = 'OUT' THEN im.quantity ELSE 0 END)
            - SUM(CASE WHEN im.transaction_type = 'EXP' THEN im.quantity ELSE 0 END)
            ) ) / 2), 0
        ), 2
    ) AS stock_turnover_rate
FROM branch_details bd
LEFT JOIN inventory_movements im
    ON bd.branch_code = im.branch_code
    AND im.transaction_date >= CURRENT_DATE - INTERVAL '3 months'
WHERE bd.is_active = TRUE
GROUP BY bd.branch_name
ORDER BY stock_turnover_rate DESC;

-- 2. Analyze staff performance and sales 
SELECT 
    sr.staff_id,
    bd.branch_name,
    sr.role_code,
    sr.base_salary,
    sr.performance_score,
    COUNT(st.transaction_id) as total_transactions,
    COALESCE(SUM(st.total_amount), 0) as total_sales,
    COALESCE(SUM(st.discount_amount), 0) as total_discounts,
    COALESCE(AVG(st.total_amount), 0) as avg_transaction_value,
    ROUND(COALESCE(SUM(st.total_amount), 0) / NULLIF(sr.base_salary, 0) * 100, 2) as sales_to_salary_ratio
FROM staff_records sr
JOIN branch_details bd ON sr.branch_code = bd.branch_code
LEFT JOIN sales_transactions st ON sr.staff_id = st.staff_id
WHERE sr.resignation_date IS NULL
GROUP BY sr.staff_id, bd.branch_name, sr.role_code, sr.base_salary, sr.performance_score
ORDER BY total_sales DESC;
