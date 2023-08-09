# Knapsack Problem

tags: #knapsack_problem #algorithms #dynamic_programming #greedy_algorithm

## References

[wikipedia](https://en.wikipedia.org/wiki/Knapsack_problem)
[ntnu algo](https://web.ntnu.edu.tw/~algo/KnapsackProblem.html)

## Abstract

Knapsack problem is a classical optimization problem with wide applicability in various fields. In this problem, one has to select a subset of items from a given set of n items, so that the total value is maximized while the constraint on the total weight is not violated.

## Fractional Knapsack Problem

In fractional knapsack problem, the user can select any fraction of an item and the goal is to maximize the total value of the selected items.

The Fractional Knapsack Problem is an important problem in computer science and can be solved using the **greedy algorithm**. To solve it, start by sorting all items by their benefit-to-weight-ratio in descending order. Then, select the highest ratio item to fill the knapsack up to the capacity (fractionally). Repeat this process with the next highest ratio item until the knapsack is completely full. Note: You should ensure that the total weight of the knapsack does not exceed its capacity.

## 0/1 Knapsack Problem

This variant of the knapsack problem allows for only complete items to be taken and excludes taking any fractions.

The 0/1 Knapsack Problem can be solved using dynamic programming.

Steps for solving 0/1 Knapsack Problem:

Create a two-dimensional array `K[n][W]` where n is the number of items and W is the capacity of the knapsack.
Fill the array with initial values. The value at index `K[i][w]` should be 0 where 0 ≤ i ≤ n.
Iterate over all items starting from item 0 to item N. For each item, iterate over all available weights from weight 0 to weight W.
Calculate the maximum value by taking maximum of the value already present at `K[i-1][w]` or the value obtained by including the current item `(v[i] + K[i-1][w-w[i]])`.
After both the loops, our result will be filled in `K[n][W]` which is our answer.

```C
 int knapsack(int W, int wt[], int val[], int n)
{
   int i, w;
   int K[n+1][W+1];

   // Build table K[][] in bottom up manner
   for (i = 0; i <= n; i++)
   {
       for (w = 0; w <= W; w++)
       {
           if (i==0 || w==0)
               K[i][w] = 0;
           else if (wt[i-1] <= w)
                 K[i][w] = max(val[i-1] + K[i-1][w-wt[i-1]],  K[i-1][w]);
           else
                 K[i][w] = K[i-1][w];
       }
   }

   return K[n][W];
}
```

### Step by step

If I have items like

| item  | value | weight |
| ----- | ----- | ------ |
| A     | 2     | 6      |
| B     | 2     | 3      |
| C     | 6     | 5      |
| D     | 5     | 4      |
| E     | 4     | 6      |

and if my bag has a limitation of weight <= 10

step 1:
Create a two-dimensional array (Knapsack Matrix), where each cell represents the maximum item value which could be stored in the knapsack for the given weight limit (rows) and number of items (columns).

|     | 0   | 1   | 2   | 3   | 4   |
| --- | --- | --- | --- | --- | --- |
| 0   |     |     |     |     |     |
| 1   |     |     |     |     |     |
| 2   |     |     |     |     |     |
| 3   |     |     |     |     |     |
| 4   |     |     |     |     |     |
| 5   |     |     |     |     |     |
| 6   |     |     |     |     |     |
| 7   |     |     |     |     |     |
| 8   |     |     |     |     |     |
| 9   |     |     |     |     |     |


Step 2:
Start filling the matrix from top-left corner to bottom-right corner.
First fill the leftmost column with zeros because we can’t take any item without considering its weight, which is not possible for a knapsack with zero capacity.

|     | 0   | 1   | 2   | 3   | 4   |
| --- | --- | --- | --- | --- | --- |
| 0   | 0   |     |     |     |     |
| 1   |     |     |     |     |     |
| 2   |     |     |     |     |     |
| 3   |     |     |     |     |     |
| 4   |     |     |     |     |     |
| 5   |     |     |     |     |     |
| 6   |     |     |     |     |     |
| 7   |     |     |     |     |     |
| 8   |     |     |     |     |     |
| 9   |     |     |     |     |     |

step 3:
For filling other columns, start from the top row which contains the maximum item values that can be taken, one at a time.

// WIP

## Unbounded Knapsack Problem

In unbounded version of the Knapsack problem, there is no limit on the number of copies of an item which can be taken.

There are two ways to solve a Unbounded Knapsack Problem.

### First Method: Dynamic Programming Approach

The first approach is using the dynamic programming method. In this method, you need to set up an array of size n (number of items) + 1 and fill it up with a recursive formula. The formula should look something like this:

`dp[i] = max( dp[i], dp[i – weight[j]] + cost[j] )`

where i is the available capacity, j is the item you are considering, weight is its corresponding weight, and cost is its corresponding cost.

### Second Method: Greedy Approach

The second approach is the greedy algorithm. This approach involves adding objects from the highest ratio of cost to weight. This means considering the item with the highest cost divided by its weight. You can use this approach if the items in the knapsack are non-divisible.

Once you have identified the object you want to add, you then check if its weight is small enough so that it doesn't exceed the capacity of the sack. If it does, then you don't add it and move on to the next highest ratio item.

## Bounded Knapsack Problem

In bounded version of Knapsack problem, there is a limit on the number of available copies of each item. The goal is still to maximize the total value of the chosen items.

To solve a Bounded Knapsack Problem, you have to:

Define your knapsack space: Make sure you know the weight limit and what type of items are allowed
Create a decision list: Create a list of all possible combinations of items to fit within your weight limit
Evaluate each combination based on its value: Calculate the total value of each item and decide which combination will yield the highest value
Implement the solution: Put into practice the combination that has the highest total value.
