# Kadane Algorithm

## 1. Introduction

The Kadane algorithm is a dynamic programming algorithm for finding the contiguous subarray within a one-dimensional array of numbers (containing at least one positive number) which has the largest sum. For example, for the sequence of values [-2, 1, -3, 4, -1, 2, 1, -5, 4], the contiguous subarray with the largest sum is [4, -1, 2, 1], with sum 6.

## 2. Algorithm

### 2.1. Algorithm

The algorithm is in the following:

```go
func maxSubArray(nums []int) int {
    maxSum := nums[0]
    currentSum := 0
    for _, num := range nums {
        currentSum += num
        if currentSum > maxSum {
            maxSum = currentSum
        }
        if currentSum < 0 {
            currentSum = 0
        }
    }
    return maxSum
}
```

### 2.2. Complexity

Time complexity: O(n)

Space complexity: O(1)

## 3. References

- <https://en.wikipedia.org/wiki/Maximum_subarray_problem>
