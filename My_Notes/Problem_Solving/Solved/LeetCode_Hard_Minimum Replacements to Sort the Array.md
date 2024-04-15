# LeetCode:2366:20230830:C\#

tags: #problem_solve #leetcode/hard #c_sharp

[Reference](https://leetcode.com/problems/minimum-replacements-to-sort-the-array/)

## Question

You are given a **0-indexed** integer array `nums`. In one operation you can replace any element of the array with **any two** elements that **sum** to it.

- For example, consider `nums = [5,6,7]`. In one operation, we can replace `nums[1]` with `2` and `4` and convert `nums` to `[5,2,4,7]`.

Return _the minimum number of operations to make an array that is sorted in **non-decreasing** order_.

**Example 1:**

```text
**Input:** nums = [3,9,3]
**Output:** 2
**Explanation:** Here are the steps to sort the array in non-decreasing order:
- From [3,9,3], replace the 9 with 3 and 6 so the array becomes [3,3,6,3]
- From [3,3,6,3], replace the 6 with 3 and 3 so the array becomes [3,3,3,3,3]
There are 2 steps to sort the array in non-decreasing order. Therefore, we return 2.
```

**Example 2:**

```text
**Input:** nums = [1,2,3,4,5]
**Output:** 0
**Explanation:** The array is already in non-decreasing order. Therefore, we return 0.
```

**Constraints:**

- `1 <= nums.length <= 10^5`
- `1 <= nums[i] <= 10^9`

## My Solution

Approach:

1. initial a new stack to store the result
2. move the last element from nums to the stack with the following steps
    1. peek from the stack and compare with the last item in nums.
    2. if the item ready to move is greater than the top one in the stack, replace it with the following steps
        1. separate to ceil(num/peek) parts with each parts has value (num/number of parts)
3. repeat the step 2 until nums.Length == 0
4. the answer is the difference between the length of the stack and the original nums

![image](LeetCode_Hard_Minimum%20Replacements%20to%20Sort%20the%20Array-0.svg)
![image](LeetCode_Hard_Minimum%20Replacements%20to%20Sort%20the%20Array-1.svg)
![image](LeetCode_Hard_Minimum%20Replacements%20to%20Sort%20the%20Array-2.svg)
![image](LeetCode_Hard_Minimum%20Replacements%20to%20Sort%20the%20Array-3.svg)

```Csharp
public class Solution {
    public long MinimumReplacement(int[] nums) {
        int originalLength = nums.Length;
        Stack<int> stack = new ();
        while (nums.Length > 0){
            int num = nums[nums.Length - 1];
            int top = stack.Count == 0 ? int.MaxValue : stack.Peek();
            if (num <= top){
                stack.Push(num);
                nums = nums[..(nums.Length-1)];
                continue;
            }
            int parts = (num/top) + (num % top != 0 ? 1 : 0);
            int value = num/parts; // it is necessary to consider the remainder of the division to get the most correct answer, but I don't care about it since I only need the top element on the stack correct.
            for (;parts > 0; parts --){
                stack.Push(value);
            }
            nums = nums[..(nums.Length-1)];
        }

        return stack.Count-originalLength;
    }
}
```

result: out of memory

![image](https://i.imgur.com/qMBXsum.png)

---

Improve:

- space complexity : O(n) -> O(1) : use an integer instead of stack
- return a long variable
- for loop instead of modifying the nums array

```csharp
public class Solution {
    public long MinimumReplacement(int[] nums) {
        int top = nums[nums.Length - 1];
        long ans = 0;
        for (int i = nums.Length - 1; i >= 0; i--){
            int num = nums[i];
            if (num <= top){
                top = num;
                continue;
            }
            int parts = (num/top) + (num % top != 0 ? 1 : 0);
            int value = num/parts;
            ans += parts -1;
            top = value;
        }

        return ans;
    }
}
```

result:

![image](https://i.imgur.com/mSQAr43.png)

## Better Solutions
