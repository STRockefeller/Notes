# LeetCode:287:20230919:C\#

tags: #problem_solve #leetcode/medium #hash_set #linked_list #cycle_detection #bit

[Reference](https://leetcode.com/problems/find-the-duplicate-number/description/?envType=daily-question&envId=2023-09-19)

## Question

Given an array of integers `nums` containing `n + 1` integers where each integer is in the range `[1, n]` inclusive.

There is only **one repeated number** in `nums`, return _this repeated number_.

You must solve the problem **without** modifying the array `nums` and uses only constant extra space.

**Example 1:**

**Input:** nums = [1,3,4,2,2]
**Output:** 2

**Example 2:**

**Input:** nums = [3,1,3,4,2]
**Output:** 3

**Constraints:**

- `1 <= n <= 10^5`
- `nums.length == n + 1`
- `1 <= nums[i] <= n`
- All the integers in `nums` appear only **once** except for **precisely one integer** which appears **two or more** times.

**Follow up:**

- How can we prove that at least one duplicate number must exist in `nums`?
- Can you solve the problem in linear runtime complexity?

## My Solution

illegal approach: hash set

```csharp
public class Solution {
    public int FindDuplicate(int[] nums) {
        HashSet<int> set = new();
        foreach(int num in nums){
          if (set.Contains(num))
            return num;
          set.Add(num);
        }
        return -1;
    }
}
```

![image](https://i.imgur.com/u9gdZMr.png)

it was fast but did not meet the condition `uses only constant extra space` which means I have to solve it with space complexity O(1)

## Better Solutions

### Solution 1

bit solution , [reference](https://leetcode.com/problems/find-the-duplicate-number/solutions/1892921/9-approaches-count-hash-in-place-marked-sort-binary-search-bit-mask-fast-slow-pointers/?envType=daily-question&envId=2023-09-19)

This method is convert all the numbers to binary numbers. If we can get each digit of the repeated number in binary, we can rebuild the repeated number.

Count all the bits of [1,n][1, n][1,n] and array numbers as 111 respectively, and then restore them bit by bit to get this repeated number.

For example, the iiith digit, note that in the nums\textit{nums}nums array, the sum of all the elements whose ith digit is 111 is xxx as convert the number to binary.

As the range [1,n][1, n][1,n], we can also count the sum of the number whose iiith digit is 111, we denoted it yyy.

We can easily get that x>yx > yx>y.

The following table lists whether each bit in the binary of each number is 111 or 000 and what the xxx and yyy of the corresponding bit are:

1	3	4	2	2	x	y
Bit 0	1	1	0	0	0	2	2
Bit 1	1	0	1	1	1	3	2
Bit 2	0	0	1	0	0	1	1
From the table, we found that only the 111th bit x>yx > yx>y, so after bitwise restoration target=(010)2=(2)10\textit{target}=(010)_2=(2)_{10}target=(010)
2
​
 =(2)
10
​
 , which is the answer.

The proof of correctness is actually similar to method 111. We can consider the change of the number xxx of the iii-th in different example arrays.

If target\textit{target}target appears twice in the test case array, the rest of the numbers appear once, and the iiith bit of target\textit{target}target is 111, then the nums\textit{nums}nums array x, is exactly one greater than y. If bit iii of \textit{target} is 000, then both are equal.

If target\textit{target}target appears three or more times in the array of test cases, then there must be some numbers that are not in the nums\textit{nums}nums array. At this time, it is equivalent to replacing these with target\textit{target}target, we consider the impact on xxx when replacing:

If the iii-th bit of the number to be replaced is 111, and the iii-th bit of target\textit{target}target is 111: xxx remains unchanged, x>yx > yx>y.

If the iii-th bit of the number being replaced is 000, and the iii-th bit of target\textit{target}target is 111: x plus one, x>yx > yx>y.

If the i-th bit of the number to be replaced is 111, and the iii-th bit of target\textit{target}target is 000: xxx minus one, x≤yx \le yx≤y.

If the iii-th bit of the number to be replaced is 000, and the iii-th bit of target\textit{target}target is 000: x remains unchanged, satisfying x≤yx \le yx≤y.

Therefore, if the ith bit of target\textit{target}target is 111, then after each replacement, only xxx will be unchanged or increased. If it is 000, only xxx will be unchanged or decreased.

When x>yx > yx>y, the ith bit of target\textit{target}target is 111, otherwise it is 000. We only need to restore this repeated number bitwise.

With extra O(nlogn)O(nlogn)O(nlogn) space, without modifying the input.

```java
    public static int findDuplicate_bit(int[] nums) {
        int n = nums.length;
        int ans = 0;
        int bit_max = 31;
        while (((n - 1) >> bit_max) == 0) {
            bit_max -= 1;
        }

        for (int bit = 0; bit <= bit_max; ++bit) {
            int x = 0, y = 0;
            for (int i = 0; i < n; ++i) {
                if ((nums[i] & (1 << bit)) != 0) {
                    x += 1;
                }
                if (i >= 1 && ((i & (1 << bit)) != 0)) {
                    y += 1;
                }
            }
            if (x > y) {
                ans |= 1 << bit;
            }
        }

        return ans;
    }
```

## Solution 2

cycle detection

```Csharp
public class Solution {
    public int FindDuplicate(int[] nums) {
        int slow = nums[0];
        int fast = nums[0];

        do {
            slow = nums[slow];
            fast = nums[nums[fast]];
        } while (slow != fast);

        slow = nums[0];
        while (slow != fast) {
            slow = nums[slow];
            fast = nums[fast];
        }

        return slow;
    }
}
```
