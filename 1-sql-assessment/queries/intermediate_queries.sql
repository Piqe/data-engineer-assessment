-- 1. Customer Purchase Patterns
SELECT 
    st.customer_id,
    COUNT(st.transaction_id) as total_transactions,
    SUM(st.total_amount) as total_spent,
    AVG(st.total_amount) as avg_transaction_value,
    SUM(st.discount_amount) as total_discounts_received,
    SUM(st.loyalty_points_earned) as total_points_earned,
    SUM(st.loyalty_points_redeemed) as total_points_redeemed,
    COUNT(DISTINCT st.branch_code) as branches_visited,
    COUNT(DISTINCT DATE(st.transaction_date)) as shopping_days,
    MIN(st.transaction_date) as first_purchase,
    MAX(st.transaction_date) as last_purchase
FROM sales_transactions st
GROUP BY st.customer_id
ORDER BY total_spent DESC;
