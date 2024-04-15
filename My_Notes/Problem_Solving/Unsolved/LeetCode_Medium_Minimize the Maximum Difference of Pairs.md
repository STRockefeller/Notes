# LeetCode:2616:20230809:C\#

tags: #problem_solve

[Reference](https://leetcode.com/problems/minimize-the-maximum-difference-of-pairs/)

## Question

You are given a **0-indexed** integer array `nums` and an integer `p`. Find `p` pairs of indices of `nums` such that the **maximum** difference amongst all the pairs is **minimized**. Also, ensure no index appears more than once amongst the `p` pairs.

Note that for a pair of elements at the index `i` and `j`, the difference of this pair is `|nums[i] - nums[j]|`, where `|x|` represents the **absolute** **value** of `x`.

Return _the **minimum** **maximum** difference among all_ `p` _pairs._ We define the maximum of an empty set to be zero.

**Example 1:**

**Input:** nums = [10,1,2,7,1,3], p = 2
**Output:** 1
**Explanation:** The first pair is formed from the indices 1 and 4, and the second pair is formed from the indices 2 and 5.
The maximum difference is max(|nums[1] - nums[4]|, |nums[2] - nums[5]|) = max(0, 1) = 1. Therefore, we return 1.

**Example 2:**

**Input:** nums = [4,2,1,2], p = 1
**Output:** 0
**Explanation:** Let the indices 1 and 3 form a pair. The difference of that pair is |2 - 2| = 0, which is the minimum we can attain.

**Constraints:**

- `1 <= nums.length <= 10^5`
- `0 <= nums[i] <= 10^9`
- `0 <= p <= (nums.length)/2`

## My Solution

```C#
public class Solution
{
    public int MinimizeMax(int[] nums, int p)
    {
        Array.Sort(nums);

        // binary search
        int left = 0;
        int right = nums[nums.Length - 1] - nums[0];
        int res = int.MaxValue;
        while (left <= right)
        {
            int mid = left + (right - left) / 2;
            if (ValidateMinMaxValue(nums, new bool[nums.Length], p, mid))
            {
                res = mid;
                right = mid - 1;
            }
            else
                left = mid + 1;
        }

        return res;
    }

    private bool ValidateMinMaxValue(int[] nums, bool[] used, int p, int min)
    {
        if (p == 0)
            return true;
        for (int i = 0; i < nums.Length; i++)
        {
            if (used[i])
                continue;
            for (int j = i + 1; j < nums.Length; j++)
            {
                if (used[j] || Difference(nums[i], nums[j]) > min)
                    continue;
                bool[] updatedUsed = (bool[])used.Clone();
                updatedUsed[i] = true;
                updatedUsed[j] = true;
                if (ValidateMinMaxValue(nums, updatedUsed, p - 1, min))
                    return true;
            }
        }
        return false;
    }

    private int Difference(int a,int b)
    {
        return a > b ? a - b : b - a;
    }
}
```

result: timed out

![image](https://i.imgur.com/QkSMrPH.png)

---

improve the efficiency

- since `nums` has been sorted, the `Difference` function is redundant.
- do NOT copy `used`
- add more `break` and `continue` conditions in the loop

```c#
public class Solution
{
    public int MinimizeMax(int[] nums, int p)
    {
        Array.Sort(nums);

        // binary search
        int left = 0;
        int right = nums[nums.Length - 1] - nums[0];
        int res = int.MaxValue;
        while (left <= right)
        {
            int mid = left + (right - left) / 2;
            if (ValidateMinMaxValue(nums, new bool[nums.Length], p, mid))
            {
                res = mid;
                right = mid - 1;
            }
            else
                left = mid + 1;
        }

        return res;
    }

    private bool ValidateMinMaxValue(int[] nums, bool[] used, int p, int min)
    {
        if (p == 0)
            return true;
        for (int i = 0; i < nums.Length; i++)
        {
            if (used[i] || (i > 0 && nums[i] == nums[i - 1]))
                continue;
            for (int j = i + 1; j < nums.Length; j++)
            {
                if (used[j])
                    continue;
                if (nums[j] - nums[i] > min)
                    break;
                used[i] = true;
                used[j] = true;
                if (ValidateMinMaxValue(nums, used, p - 1, min))
                    return true;
                used[i] = false;
                used[j] = false;
            }
        }
        return false;
    }
}
```

still timed out

---

## Better Solutions
