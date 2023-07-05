# LeetCode:137:20230704:dart

tags: #problem_solve #dart

[Reference](https://leetcode.com/problems/single-number-ii/description/)

## Question

Given an integer array `nums` where every element appears **three times** except for one, which appears **exactly once**. _Find the single element and return it.

You must implement a solution with a linear runtime complexity and use only constant extra space.

**Example 1:**

```text
**Input:** nums = [2,2,3,2]
**Output:** 3
```

**Example 2:**

```text
**Input:** nums = [0,1,0,1,0,1,99]
**Output:** 99
```

**Constraints:**

- `1 <= nums.length <= 3 * 10^4`
- `-2^31 <= nums[i] <= 2^31 - 1`
- Each element in `nums` appears exactly **three times** except for one element which appears **once**.

## My Solution

### first one

remove duplicated ones.

```dart
class Solution {
  int singleNumber(List<int> nums) {
    while (true) {
      int count = 0;
      final int first = nums.first;
      nums.removeWhere((element) {
        if (element == first) {
          count++;
          return true;
        }
        return false;
      });
      if (count == 1) {
        return first;
      }
    }
  }
}
```

result

![image](https://i.imgur.com/FJinQhi.png)

### second one

using a map.

```dart
class Solution {
  int singleNumber(List<int> nums) {
    Map<int, int> set = {};
    nums.forEach((element) {
      int count = set[element] ?? 0;
      set[element] = count + 1;
    });

    for (var entry in set.entries) {
      if (entry.value == 1) {
        return entry.key;
      }
    }

    // impossible
    return -1;
  }
}
```

![image](https://i.imgur.com/OZk5f3Z.png)

## Better Solutions

### Solution 1

```cpp
class Solution {
 public:
  int singleNumber(vector<int>& nums) {
    int ans = 0;

    for (int i = 0; i < 32; ++i) {
      int sum = 0;
      for (const int num : nums)
        sum += num >> i & 1;
      sum %= 3;
      ans |= sum << i;
    }

    return ans;
  }
};
```

### Solution 2

```cpp
class Solution {
 public:
  int singleNumber(vector<int>& nums) {
    int ones = 0;
    int twos = 0;

    for (const int num : nums) {
      ones ^= (num & ~twos);
      twos ^= (num & ~ones);
    }

    return ones;
  }
};
```
