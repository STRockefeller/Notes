# Sliding Window

tags: #algorithms #sliding_window #two_pointers #golang

Sliding window is a technique used in computer programming to efficiently process arrays or strings by maintaining a "window" of elements and moving it through the data structure. This technique is especially useful when solving problems that require finding subarrays or substrings that satisfy certain conditions.

The sliding window technique involves defining two pointers: `left` and `right`, which represent the boundaries of the window. Initially, both pointers are set to the beginning of the array or string. As we move the window to the right, we process the elements inside the window and update the pointers accordingly.

The main idea behind the sliding window technique is to avoid redundant calculations. By maintaining the window and updating it based on certain conditions, we can eliminate unnecessary computations and achieve better time complexity.

## Basic Algorithm

The basic algorithm for the sliding window technique can be summarized as follows:

1. Initialize the `left` and `right` pointers to the start of the array or string.
2. Iterate through the data structure, moving the `right` pointer one step at a time.
3. Update the window and process the elements inside it.
4. If a certain condition is satisfied, update the result or perform some action.
5. Move the `left` pointer to the right, reducing the size of the window.
6. Repeat steps 2-5 until reaching the end of the data structure.

## Example: Maximum Sum Subarray

Let's consider an example problem: finding the maximum sum of a subarray in an array of integers.

**Problem**: Given an array of integers, find the maximum sum of any contiguous subarray.

**Input**: `nums` - an array of integers.

**Output**: Maximum sum of any contiguous subarray.

To solve this problem using the sliding window technique, we can define the following variables:

- `left` - the left boundary of the window.
- `right` - the right boundary of the window.
- `maxSum` - the maximum sum found so far.
- `currentSum` - the sum of the current subarray.

We start by initializing `left`, `right`, `maxSum`, and `currentSum` to 0. Then, we iterate through the array, moving the `right` pointer one step at a time. At each step, we update `currentSum` by adding the element at `right` to the sum.

If `currentSum` becomes negative, we know that including the current element will not yield a maximum sum subarray. In this case, we update `left` to move the window to the right, effectively excluding the elements before the current one from the subarray.

If `currentSum` is greater than `maxSum`, we update `maxSum` with the new value.

The algorithm can be implemented in Go as follows:

```go
func maxSubarraySum(nums []int) int {
    left := 0
    right := 0
    maxSum := 0
    currentSum := 0

    for right < len(nums) {
        currentSum += nums[right]

        if currentSum < 0 {
            currentSum = 0
            left = right + 1
        }

        if currentSum > maxSum {
            maxSum = currentSum
        }

        right++
    }

    return maxSum
}
```

In this implementation, the `maxSubarraySum` function takes an array of integers `nums` as input and returns the maximum sum of any contiguous subarray.

## Complexity Analysis

The time complexity of the sliding window technique depends on the problem at hand. In the case of finding the maximum sum subarray, the algorithm has a linear time complexity of O(N), where N is the length of the input array.

The space complexity is O(1) since the algorithm only requires a constant amount of extra space to store the variables `left`, `right`, `maxSum`, and `currentSum`.

## Conclusion

The sliding window technique is a powerful tool for solving problems involving arrays or strings efficiently. By maintaining a window and updating it based on certain conditions, we can avoid redundant computations and achieve better time complexity.

Remember to carefully define the variables and conditions specific to the problem you are trying to solve. Also, be mindful of the edge cases and boundary conditions that may arise during the implementation.

## References

- [ChatGPT](https://chat.openai.com/share/9fe03648-cfd0-436b-95be-410f005dbd1e)