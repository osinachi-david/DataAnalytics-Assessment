# DataAnalytics-Assessment
Cowry Data Analytics Assessment

#1. High-Value Customers with Multiple Products
Query Explanation:

1. The Common Table Expression (CTE) "CustomerPlans" creates a temporary result set that:
- Combines user information with their plans and savings accounts
- For each user, calculates:
  * Number of regular savings plans they own
  * Number of investment funds they own
  * Total amount of all their deposits
- Creates a full name by combining first and last names

2. The main query then:
- Filters to show only customers who have at least one savings plan AND one investment fund
- Orders results by total deposits (highest to lowest)

Example scenario:
If we have a user "John Smith" who has:
- 2 savings plans
- 1 investment fund
- Total deposits of $10,000

And "Jane Doe" who has:
- 1 savings plan
- 0 investment funds
- Total deposits of $5,000

The query would:
- Include John Smith (because he has both types of plans)
- Exclude Jane Doe (because she has no investment funds)

This query helps identify customers who are diversifying their portfolio with both savings and investments, ordered by their total financial commitment.

The query effectively answers the business question: "Who are our most valuable customers that use both savings and investment products?"
