-- Question 1
-- 1. High-Value Customers with Multiple Products
-- Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
-- Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
-- Tables:
-- ●	users_customuser
-- ●	savings_savingsaccount
-- ●	plans_plan

-- Expected Output:

-- owner_id	name	savings_count	investment_count	total_deposits
-- 1001	John Doe	2	1	15000.00


WITH customer_plans AS (
    SELECT 
        u.id as owner_id,
        CONCAT(u.first_name, ' ', u.last_name) as name,
        COUNT(CASE WHEN p.is_regular_savings = 1 THEN 1 END) as savings_count,
        COUNT(CASE WHEN p.is_regular_savings = 0 THEN 1 END) as investment_count,
        COALESCE(SUM(s.amount), 0) as total_deposits
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    LEFT JOIN plans_plan p ON s.owner_id = p.owner_id
    GROUP BY u.id, u.first_name, u.last_name
)
SELECT 
    owner_id,
    name,
    savings_count,
    investment_count,
    total_deposits
FROM customer_plans
WHERE savings_count > 0 
AND investment_count > 0
ORDER BY total_deposits DESC;