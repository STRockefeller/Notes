# LeetCode:1218:20230714:dart

tags: #problem_solve

[Reference](https://leetcode.com/problems/longest-arithmetic-subsequence-of-given-difference/description/)

## Question

Given an integer array arr and an integer `difference`, return the length of the longest subsequence in arr which is an arithmetic sequence such that the `difference` between adjacent elements in the subsequence equals `difference`.

A subsequence is a sequence that can be derived from arr by deleting some or no elements without changing the order of the remaining elements.

Example 1:

```text
Input: arr = [1,2,3,4], difference = 1
Output: 4
Explanation: The longest arithmetic subsequence is [1,2,3,4].
```

Example 2:

```text
Input: arr = [1,3,5,7], difference = 1
Output: 1
Explanation: The longest arithmetic subsequence is any single element.
```

Example 3:

```text
Input: arr = [1,5,7,8,5,3,4,2,1], difference = -2
Output: 4
Explanation: The longest arithmetic subsequence is [7,5,3,1].
```

Constraints:

1 <= `arr.length` <= $10^5$
$-10^4$ <= `arr[i]`, `difference` <= $10^4$

## My Solution

record the result of each subarray end with the index.

```dart
class Solution {
  int longestSubsequence(List<int> arr, int difference) {
    Map<int, int> dpTable = {};

    int max = 0;
    for (int i = 0; i < arr.length; i++) {
      int newValue = (dpTable[arr[i] - difference] ?? 0) + 1;
      max = newValue > max ? newValue : max;
      dpTable[arr[i]] = newValue;
    }

    return max;
  }
}
```

![result](https://i.imgur.com/SYoRRDy.png)

## Better Solutions
