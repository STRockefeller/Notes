# SQL Tough Cases

## Negative Where Condition in Nullable Columns

```sql
SELECT name FROM Customer WHERE referee_id != 2
```

or

```sql
SELECT name FROM Customer WHERE referee_id <> 2
```

will **NOT** query the items whose `referee_id` is `null`

refer to [leecode584](https://leetcode.com/problems/find-customer-referee/)

according the the editorial of the problem:

Approach: Using <>(!=) and IS NULL [Accepted]
Intuition

Some people come out the following solution by intuition.

```sql
SELECT name FROM customer WHERE referee_Id <> 2;
```

However, this query will only return one result:Zack although there are 4 customers not referred by Jane (including Jane herself). All the customers who were referred by nobody at all (NULL value in the referee_id column) don’t show up. But why?

Algorithm

MySQL uses three-valued logic -- `TRUE`, `FALSE` and `UNKNOWN`. Anything compared to `NULL` evaluates to the third value: `UNKNOWN`. That “anything” includes `NULL` itself! That’s why MySQL provides the `IS NULL` and `IS NOT NULL` operators to specifically check for `NULL`.

Thus, one more condition 'referee_id IS NULL' should be added to the WHERE clause as below.

MySQL

```sql
SELECT name FROM customer WHERE referee_id <> 2 OR referee_id IS NULL;
```

or

```sql
SELECT name FROM customer WHERE referee_id != 2 OR referee_id IS NULL;
```

### Tips

The following solution is also wrong for the same reason as mentioned above. The key is to always use `IS NULL` or `IS NOT NULL` operators to specifically check for `NULL` value.

```sql
SELECT name FROM customer WHERE referee_id = NULL OR referee_id <> 2;
```

## why is UNION faster than OR

refer to [stackoverflow](https://stackoverflow.com/questions/15361972/why-is-union-faster-than-an-or-statement#:~:text=2%20Answers&text=The%20reason%20is%20that%20using,you%20are%20using%20the%20UNION%20.)

