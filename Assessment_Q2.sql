-- Transaction Frequency Analysis
-- Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
-- Task: Calculate the average number of transactions per customer per month and categorize them:
-- ●	"High Frequency" (≥10 transactions/month)
-- ●	"Medium Frequency" (3-9 transactions/month)
-- ●	"Low Frequency" (≤2 transactions/month)
-- Tables:
-- ●	users_customuser
-- ●	savings_savingsaccount

-- Expected Output:

-- frequency_category	customer_count	avg_transactions_per_month
-- High Frequency	        250	                15.2
-- Medium Frequency	        1200	             5.5

WITH monthly_transactions AS (
    SELECT 
        sa.owner_id,
        DATE_FORMAT(sa.transaction_date, '%Y-%m') as month_year,
        COUNT(*) as transactions_per_month
    FROM savings_savingsaccount sa
    WHERE sa.transaction_date IS NOT NULL
    GROUP BY sa.owner_id, DATE_FORMAT(sa.transaction_date, '%Y-%m')
),
customer_avg_transactions AS (
    SELECT 
        owner_id,
        AVG(transactions_per_month) as avg_monthly_transactions
    FROM monthly_transactions
    GROUP BY owner_id
),
frequency_categories AS (
    SELECT 
        CASE 
            WHEN avg_monthly_transactions >= 10 THEN 'High Frequency'
            WHEN avg_monthly_transactions >= 3 AND avg_monthly_transactions < 10 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END as frequency_category,
        owner_id,
        avg_monthly_transactions
    FROM customer_avg_transactions
)
SELECT 
    frequency_category,
    COUNT(DISTINCT owner_id) as customer_count,
    ROUND(AVG(avg_monthly_transactions), 1) as avg_transactions_per_month
FROM frequency_categories
WHERE frequency_category IN ('High Frequency', 'Medium Frequency')
GROUP BY frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
    

--  Query Explanation:
--     Let me explain how this SQL query works to analyze transaction frequency:

-- Monthly Transactions Calculation:
-- The first CTE (monthly_transactions) breaks down transactions by customer and month

-- Customer Average Calculation:
-- The second CTE (customer_avg_transactions) averages these monthly counts per customer

-- Frequency Categorization:
-- The third CTE (frequency_categories) applies the business rules:
-- John with 10 transactions → "High Frequency"
-- Mary with 5 transactions → "Medium Frequency"
-- Bob with 2 transactions → "Low Frequency"

-- Final Aggregation:
-- Groups customers by their frequency category
-- Counts unique customers in each category
-- Calculates the average transactions for each group
-- Example output: "High Frequency": 250 customers averaging 15.2 transactions/month "Medium Frequency": 1,200 customers averaging 5.5 transactions/month

-- Observation: 
-- The query directly addresses the business requirement by segmenting customers based on their transaction frequency and providing meaningful metrics for each segment.