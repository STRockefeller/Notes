# Kadane Algorithm

tags: #algorithms #kadane_algorithm #dynamic_programming

## References

- [wikipedia](https://en.wikipedia.org/wiki/Maximum_subarray_problem)
- [geeksforgeeks](https://www.geeksforgeeks.org/largest-sum-contiguous-subarray/)

## Overview

The algorithm scans the array from start to end, keeping track of the current sum of the subarray. It starts with the assumption that the maximum sum is the first element of the array, and then iteratively updates the maximum sum as it encounters new elements. If the current sum becomes negative, the algorithm resets it to zero, effectively ignoring any negative contributions to the sum. The maximum sum encountered during the scan is the desired result.

## Problem Statement

Given an array of integers, we want to find the subarray (contiguous elements) with the largest sum. In other words, we need to determine the maximum possible sum of a subarray within the given array.

## Algorithm Steps

The steps of the Kadane algorithm can be summarized as follows:

1. Initialize two variables: `maxSum` and `currentSum` to the value of the first element of the array.
2. Iterate over the array from the second element onwards.
    - Add the current element to `currentSum`.
    - If `currentSum` becomes negative, set it to zero.
    - If `currentSum` is greater than `maxSum`, update `maxSum` with the value of `currentSum`.
3. Return `maxSum` as the maximum sum of a contiguous subarray.

## Pseudocode

Here is the pseudocode representation of the Kadane algorithm:

```go
func kadaneAlgorithm(arr []int) int {
    maxEndingHere := arr[0]
    maxSoFar := arr[0]

    for i := 1; i < len(arr); i++ {
        maxEndingHere = max(arr[i], maxEndingHere+arr[i])
        maxSoFar = max(maxSoFar, maxEndingHere)
    }

    return maxSoFar
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity

Time complexity: O(n)

Space complexity: O(1)

## Conclusion

By scanning the array in a single pass and using [[Dynamic Programming]] techniques, it  achieves a linear time complexity. This algorithm can be applied to various scenarios, such as optimizing financial portfolios, analyzing time-series data, and solving other similar problems.
