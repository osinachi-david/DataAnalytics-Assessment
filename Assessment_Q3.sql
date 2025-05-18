-- Account Inactivity Alert
-- Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
-- Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .
-- Tables:
-- ●	plans_plan
-- ●	savings_savingsaccount

-- Expected Output:

-- plan_id	owner_id	type	last_transaction_date	inactivity_days
-- 1001	      305	   Savings	     2023-08-10	              92
SELECT 
    p.id as plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_fixed_investment = 1 THEN 'Investment'
        ELSE 'Savings'
    END as type,
    MAX(s.transaction_date) as last_transaction_date,
    DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) as inactivity_days
FROM 
    plans_plan p
LEFT JOIN 
    savings_savingsaccount s ON p.id = s.plan_id
WHERE 
    p.is_deleted = 0 
    AND p.is_archived = 0
    AND (p.is_regular_savings = 1 OR p.is_fixed_investment = 1)
GROUP BY 
    p.id, p.owner_id
HAVING 
    (last_transaction_date IS NULL OR 
     DATEDIFF(CURRENT_DATE, last_transaction_date) > 365)
ORDER BY 
    inactivity_days DESC;
    
-- Let me explain how this query fulfills the Account Inactivity Alert requirements:

-- 1. Core Purpose Match:
-- - The query directly addresses the ops team's need to identify inactive accounts
-- - It specifically looks for accounts with no transactions for over 365 days
-- - It includes both savings and investment accounts as requested

-- 2. Data Flow Example:
-- Let's say we have these accounts:
-- - Account A: Last transaction 2022-01-15 (over 1 year ago)
-- - Account B: Last transaction 2023-09-01 (recent)
-- - Account C: No transactions ever (NULL)

-- The query would:
-- - Include Account A (because > 365 days)
-- - Exclude Account B (because < 365 days)
-- - Include Account C (because NULL is treated as inactive)

-- 3. Key Components Alignment:
-- - Active accounts filter: Uses is_deleted = 0 AND is_archived = 0
-- - Account type identification: Uses CASE statement to label Savings/Investment
-- - Inactivity calculation: DATEDIFF function measures days since last transaction
-- - Comprehensive coverage: LEFT JOIN ensures accounts with no transactions are included

-- 4. Output Interpretation:
-- Using your example (1001, 305, Savings, 2023-08-10, 92):
-- - This shows a savings account
-- - Owned by user 305
-- - Last active on August 10, 2023
-- - Inactive for 92 days (though this wouldn't actually trigger the alert as it's less than 365 days)

-- The query effectively translates the business requirement into a technical solution that provides actionable insights for the ops team.