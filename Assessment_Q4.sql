-- 4. Customer Lifetime Value (CLV) Estimation
-- Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).
-- Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
-- ●	Account tenure (months since signup)
-- ●	Total transactions
-- ●	Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
-- ●	Order by estimated CLV from highest to lowest

-- Tables:
-- ●	users_customuser
-- ●	savings_savingsaccount

-- Expected Output:

-- customer_id	name	tenure_months	total_transactions	estimated_clv
-- 1001     	John Doe	24	               120	           600.00

WITH CustomerMetrics AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) as name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        AVG(s.amount * 0.001) AS avg_profit_per_transaction,
        SUM(s.amount) AS total_transaction_value
    FROM 
        users_customuser u
    LEFT JOIN 
        savings_savingsaccount s ON u.id = s.owner_id
    WHERE 
        u.is_active = 1
    GROUP BY 
        u.id, u.name, u.date_joined
    HAVING 
        tenure_months > 0
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(
        (total_transactions / tenure_months) * 12 * avg_profit_per_transaction,
        2
    ) AS estimated_clv
FROM 
    CustomerMetrics
ORDER BY 
    estimated_clv DESC;
    
    