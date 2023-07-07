# LeetCode:2024:20230707:dart

tags: #problem_solve #two_pointers #sliding_window #dart

Reference

## Question

A teacher is writing a test with n true/false questions, with `'T'` denoting true and `'F'` denoting false. He wants to confuse the students by maximizing the number of consecutive questions with the same answer (multiple trues or multiple falses in a row).

You are given a string `answerKey`, where `answerKey[i]` is the original answer to the ith question. In addition, you are given an integer `k`, the maximum number of times you may perform the following operation:

Change the answer key for any question to `'T'` or `'F'` (i.e., set `answerKey[i]` to `'T'` or `'F'`).
Return the maximum number of consecutive `'T'`s or `'F'`s in the answer key after performing the operation at most `k` times.

Example 1:

```text
Input: answerKey = "TTFF", k = 2
Output: 4
Explanation: We can replace both the 'F's with 'T's to make answerKey = "TTTT".
There are four consecutive 'T's.
```

Example 2:

```text
Input: answerKey = "TFFT", k = 1
Output: 3
Explanation: We can replace the first 'T' with an 'F' to make answerKey = "FFFT".
Alternatively, we can replace the second 'T' with an 'F' to make answerKey = "TFFF".
In both cases, there are three consecutive 'F's.
```

Example 3:

```text
Input: answerKey = "TTFTTFTT", k = 1
Output: 5
Explanation: We can replace the first 'F' to make answerKey = "TTTTTFTT"
Alternatively, we can replace the second 'F' to make answerKey = "TTFTTTTT".
In both cases, there are five consecutive 'T's.
```

Constraints:

n == answerKey.length
1 <= n <= $5 * 10^4$
answerKey[i] is either 'T' or 'F'
1 <= k <= n

## My Solution

this problem is similar to [[LeetCode_Medium_Longest Subarray of 1's After Deleting One Element]]

Using [[Sliding Window]] approach.

```text
Left  Pointer:   ⬇
answer    key: TTTFTTFFTFT
Right Pointer:        ⬆

keys in the window: [TFTTFFT] contains: 4T and 3F
if (the amount of the less one) < k => legal status
if (current status is illegal) => move the left pointer.
```

```dart
import 'dart:math';

class Solution {
  // convert "T" and "F" to 1 and 0
  int _charMapping(String char) {
    return char == "F" ? 0 : 1;
  }

  int maxConsecutiveAnswers(String answerKey, int k) {
    int left = 0;
    int maxConfusing = 0;
    List<int> windowCount = [0, 0];
    for (int right = 0; right < answerKey.length; right++) {
      windowCount[_charMapping(answerKey[right])]++;
      while (windowCount.reduce(min) > k) {
        // illegal
        windowCount[_charMapping(answerKey[left])]--;
        left++;
      }
      maxConfusing = max(maxConfusing, windowCount[0] + windowCount[1]);
    }
    return maxConfusing;
  }
}

```

result: umm... Dart is so obscure in the LeetCode community that there are no other solutions available for me to compare with.

![image](https://i.imgur.com/LagCouJ.png)

so I rewrite it with golang again.

![image](https://i.imgur.com/rC8JX4N.png)

## Better Solutions
