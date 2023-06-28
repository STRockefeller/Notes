# LeetCode:1187:20230609:cpp

#problem_solve

[Reference](https://leetcode.com/problems/make-array-strictly-increasing/)

## Question

Given two integer arrays `arr1` and `arr2`, return the minimum number of operations (possibly zero) needed to make `arr1` strictly increasing.

In one operation, you can choose two indices `0 <= i < arr1.length` and `0 <= j < arr2.length` and do the assignment `arr1[i] = arr2[j]`.

If there is no way to make `arr1` strictly increasing, return `-1`.

**Example 1:**

**Input:** arr1 = [1,5,3,6,7], arr2 = [1,3,2,4]
**Output:** 1
**Explanation:** Replace `5` with `2`, then `arr1 = [1, 2, 3, 6, 7]`.

**Example 2:**

**Input:** arr1 = [1,5,3,6,7], arr2 = [4,3,1]
**Output:** 2
**Explanation:** Replace `5` with `3` and then replace `3` with `4`. `arr1 = [1, 3, 4, 6, 7]`.

**Example 3:**

**Input:** arr1 = [1,5,3,6,7], arr2 = [1,6,3,3]
**Output:** -1
**Explanation:** You can't make `arr1` strictly increasing.

**Constraints:**

- `1 <= arr1.length, arr2.length <= 2000`
- `0 <= arr1[i], arr2[i] <= 10^9`

## My Solution

```cpp
class Solution
{
public:
    int makeArrayIncreasing(vector<int> &arr1, vector<int> &arr2)
    {
        sort(arr2.begin(), arr2.end());
        int count = 0;
        for (int i = 1; i < int(arr1.size()) - 1; i++)
        {
            if (arr1[i] <= arr1[i - 1])
            {
                bool swapped = false;
                for (int j = 0; j < int(arr2.size()); j++)
                {
                    if (arr2[j] > arr1[i - 1])
                    {
                        arr1[i] = arr2[j];
                        swapped = true;
                        // remove redundant elems
                        arr2.erase(arr2.begin(), arr2.begin() + j + 1);
                        count++;
                        break;
                    }
                }
                if (!swapped)
                    return -1;
            }
        }
        return count;
    }
};
```

![wrong answer](https://i.imgur.com/Uqym74N.png)



## Better Solutions
