# LeetCode:46:20230802:C\#

tags: #problem_solve #permutation #arrangement #leetcode/medium #c_sharp

[Reference](https://leetcode.com/problems/permutations/)

## Question

Given an array `nums` of distinct integers, return _all the possible permutations_. You can return the answer in **any order**.

**Example 1:**

```text
Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
```

**Example 2:**

```text
Input: nums = [0,1]
Output: [[0,1],[1,0]]
```

**Example 3:**

```text
Input: nums = [1]
Output: [[1]]
```

**Constraints:**

- `1 <= nums.length <= 6`
- `-10 <= nums[i] <= 10`
- All the integers of `nums` are **unique**.

## My Solution

```c#
public class Solution
{
    public IList<IList<int>> Permute(int[] nums)
    {
        bool[] used = new bool[nums.Length];
        for (int i = 0; i < used.Length; i++)
        {
            used[i] = false;
        }

        return Backtrack(nums, used, new List<int>()).Cast<IList<int>>().ToList();
    }

    private List<List<int>> Backtrack(int[] nums, bool[] used, List<int> temp)
    {
        List<List<int>> result = new List<List<int>>();

        if (temp.Count == nums.Length)
        {
            result.Add(new List<int>(temp));
        }

        for (int i = 0; i < nums.Length; i++)
        {
            if (!used[i])
            {
                used[i] = true;
                temp.Add(nums[i]);
                result.AddRange(Backtrack(nums, used, temp));
                temp.RemoveAt(temp.Count - 1);
                used[i] = false;
            }
        }

        return result;
    }
}
```

result:

![image](https://i.imgur.com/ecPCjvo.png)

## Better Solutions
