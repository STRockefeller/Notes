# LeetCode:1863:20240520:go

tags: #problem_solve #leetcode/easy #bit #DFS #knapsack_problem 

[Reference](https://leetcode.com/problems/sum-of-all-subset-xor-totals/description/)

## Question

The **XOR total** of an array is defined as the bitwise `XOR` of **all its elements**, or `0` if the array is **empty**.

- For example, the **XOR total** of the array `[2,5,6]` is `2 XOR 5 XOR 6 = 1`.

Given an array `nums`, return _the **sum** of all **XOR totals** for every **subset** of_ `nums`. 

**Note:** Subsets with the **same** elements should be counted **multiple** times.

An array `a` is a **subset** of an array `b` if `a` can be obtained from `b` by deleting some (possibly zero) elements of `b`.

**Example 1:**

**Input:** nums = [1,3]
**Output:** 6
**Explanation:** The 4 subsets of [1,3] are:
- The empty subset has an XOR total of 0.
- [1] has an XOR total of 1.
- [3] has an XOR total of 3.
- [1,3] has an XOR total of 1 XOR 3 = 2.
0 + 1 + 3 + 2 = 6

**Example 2:**

**Input:** nums = [5,1,6]
**Output:** 28
**Explanation:** The 8 subsets of [5,1,6] are:
- The empty subset has an XOR total of 0.
- [5] has an XOR total of 5.
- [1] has an XOR total of 1.
- [6] has an XOR total of 6.
- [5,1] has an XOR total of 5 XOR 1 = 4.
- [5,6] has an XOR total of 5 XOR 6 = 3.
- [1,6] has an XOR total of 1 XOR 6 = 7.
- [5,1,6] has an XOR total of 5 XOR 1 XOR 6 = 2.
0 + 5 + 1 + 6 + 4 + 3 + 7 + 2 = 28

**Example 3:**

**Input:** nums = [3,4,5,6,7,8]
**Output:** 480
**Explanation:** The sum of all XOR totals for every subset is 480.

**Constraints:**

- `1 <= nums.length <= 12`
- `1 <= nums[i] <= 20`

## My Solution

### Approach

利用[[Knapsack Problem|0/1背包問題的思路]]針對Array中每一個元素枚舉取/不取的兩種可能，搭配[[Depth-First Search]]求解。

```go
func subsetXORSum(nums []int) int {
    return dfs(nums,0,0)
}

func dfs(nums []int, i int, sum int)int{
    if i == len(nums){
        return sum
    }

    include := dfs(nums, i+1, sum^nums[i])
    exclude := dfs(nums, i+1, sum)

    return include+exclude
}
```

## Better Solutions
