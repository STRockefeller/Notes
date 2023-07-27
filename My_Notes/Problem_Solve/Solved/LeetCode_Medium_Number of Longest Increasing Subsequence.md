# LeetCode:673:20230721:go

tags: #problem_solve #golang #dynamic_programming

[Reference](https://leetcode.com/problems/number-of-longest-increasing-subsequence/)

## Question

Given an integer array nums, return the number of longest increasing subsequences.

Notice that the sequence has to be strictly increasing.

Example 1:

```text
Input: nums = [1,3,5,4,7]
Output: 2
Explanation: The two longest increasing subsequences are [1, 3, 4, 7] and [1, 3, 5, 7].
```

Example 2:

```text
Input: nums = [2,2,2,2,2]
Output: 5
Explanation: The length of the longest increasing subsequence is 1, and there are 5 increasing subsequences of length 1, so output 5.
```

Constraints:

1 <= nums.length <= 2000
$-10^6 <= nums[i] <= 10^6$

## My Solution

```go
func findNumberOfLIS(nums []int) int {
	// index: same as nums, value: length of LIS, count
	dpTable := make([][2]int, len(nums))

	getLessIndexes := func(i int) []int {
		res := []int{}
		maxNum := -9999999
		for j := i - 1; j >= 0; j-- {
			if nums[j] < nums[i] && nums[j] >= maxNum {
				maxNum = nums[j]
				res = append(res, j)
			}
		}
		return res
	}

	maxLength := 1
	for i := range nums {
		lessIndexes := getLessIndexes(i)
		if len(lessIndexes) == 0 {
			dpTable[i] = [2]int{1, 1}
			continue
		}

		partialMaxLength := 0
		for _, lessIndex := range lessIndexes {
			if dpTable[lessIndex][0] > partialMaxLength {
				partialMaxLength = dpTable[lessIndex][0]
			}
		}

		count := 0
		for _, lessIndex := range lessIndexes {
			if dpTable[lessIndex][0] == partialMaxLength {
				count += dpTable[lessIndex][1]
			}
		}

		dpTable[i] = [2]int{partialMaxLength + 1, count}
		if partialMaxLength+1 > maxLength {
			maxLength = partialMaxLength + 1
		}
	}

	res := 0
	for _, v := range dpTable {
		if v[0] == maxLength {
			res += v[1]
		}
	}
	return res
}
```

result

![image](https://i.imgur.com/1OBPz9l.png)

it's so bad 😂

## Better Solutions

### Solution1

[reference](https://leetcode.com/problems/number-of-longest-increasing-subsequence/solutions/3794723/efficient-dp-solution-lis-beats-98-4/)

```cpp
class Solution {
public:
    int findNumberOfLIS(vector<int>& nums) {
        int n = nums.size();
        if (n == 0) return 0;

        vector<int> dp(n, 1);
        int maxLength = 1;
        int result = 0;

        for (int i = 1; i < n; i++) {
            for (int j = 0; j < i; j++) {
                if (nums[i] > nums[j]) {
                    if (dp[j] + 1 > dp[i]) {
                        dp[i] = dp[j] + 1;
                    }
                }
            }
            maxLength = max(maxLength, dp[i]);
        }

        for (int i = 0; i < n; i++) {
            if (dp[i] == maxLength) {
                result++;
            }
        }

        return result;
    }
};
```

1. Initialize the dp and count arrays with all elements set to 1, as each element is a valid subsequence of length 1.
1. For each element at index i in the input array, iterate through all elements before it (index j from 0 to i-1).
1. Compare the values of nums[i] and nums[j]:
	- If nums[i] is greater than nums[j], we have a potential increasing subsequence.
	- Check if dp[j] + 1 (the length of the LIS ending at index j plus the current element) is greater than dp[i] (the current length of the LIS ending at index i). If so, update dp[i] to dp[j] + 1, and set count[i] to count[j] since we have found a new longer subsequence ending at i.
	- If dp[j] + 1 is equal to dp[i], it means we have found another subsequence with the same length as the one ending at i. In this case, we add count[j] to the existing count[i], as we have multiple ways to form subsequences with the same length.
1. Keep track of the maxLength of the LIS encountered during the process.
1. Finally, iterate through the dp array again, and for each index i, if dp[i] equals maxLength, add the corresponding count[i] to the result.
