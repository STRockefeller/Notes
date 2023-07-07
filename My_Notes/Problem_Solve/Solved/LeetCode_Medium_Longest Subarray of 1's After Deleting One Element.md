# LeetCode:1493:20230705:C\#

tags: #problem_solve #c_sharp #sliding_window #two_pointers

Reference

## Question

Given a binary array nums, you should delete one element from it.

Return the size of the longest non-empty subarray containing only 1's in the resulting array. Return 0 if there is no such subarray.

Example 1:

```text
Input: nums = [1,1,0,1]
Output: 3
Explanation: After deleting the number in position 2, [1,1,1] contains 3 numbers with value of 1's.
```

Example 2:

```text
Input: nums = [0,1,1,1,0,1,1,0,1]
Output: 5
Explanation: After deleting the number in position 4, [0,1,1,1,1,1,0,1] longest subarray with value of 1's is [1,1,1,1,1].
```

Example 3:

```text
Input: nums = [1,1,1]
Output: 2
Explanation: You must delete one element.
```

Constraints:

$1 <= nums.length <= 10^5$
nums[i] is either 0 or 1.

## My Solution

```Csharp
using System.Collections.Generic;

public class Solution
{
    public int LongestSubarray(int[] nums)
    {
        if (nums.All(num => num == 1))
        {
            return nums.Length - 1;
        }

        int currentLength = 0;
        int maxLength = 0;
        int prevLength = 0;

        for (int i = 0; i < nums.Length; i++)
        {
            if (nums[i] == 1)
            {
                currentLength++;
            }
            else
            {
                maxLength = Math.Max(maxLength, currentLength + prevLength);
                prevLength = currentLength;
                currentLength = 0;
            }
        }

        maxLength = Math.Max(maxLength, currentLength + prevLength);

        return maxLength;
    }
}
```

![image](https://i.imgur.com/QcqkTpR.png)

## Better Solutions

### Solution 1

```cpp
class Solution {
public:
    int longestSubarray(vector<int>& nums) {
        int n = nums.size(); // The size of the input array

        int left = 0; // The left pointer of the sliding window
        int zeros = 0; // Number of zeroes encountered
        int ans = 0; // Maximum length of the subarray

        for (int right = 0; right < n; right++) {
            if (nums[right] == 0) {
                zeros++; // Increment the count of zeroes
            }

            // Adjust the window to maintain at most one zero in the subarray
            while (zeros > 1) {
                if (nums[left] == 0) {
                    zeros--; // Decrement the count of zeroes
                }
                left++; // Move the left pointer to the right
            }

            // Calculate the length of the current subarray and update the maximum length
            ans = max(ans, right - left + 1 - zeros);
        }

        // If the entire array is the subarray, return the size minus one; otherwise, return the maximum length
        return (ans == n) ? ans - 1 : ans;
    }
};
```
