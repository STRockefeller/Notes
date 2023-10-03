# LeetCode:316:30230926:C\#

tags: #problem_solve #leetcode/medium #stack #monotonic_stack #c_sharp

[Reference](https://leetcode.com/problems/remove-duplicate-letters/)

## Question

Given a string `s`, remove duplicate letters so that every letter appears once and only once. You must make sure your result is **the smallest in lexicographical order** among all possible results.

**Example 1:**

**Input:** s = "bcabc"
**Output:** "abc"

**Example 2:**

**Input:** s = "cbacdcbc"
**Output:** "acdb"

**Constraints:**

- `1 <= s.length <= 104`
- `s` consists of lowercase English letters.

**Note:** This question is the same as 1081: [https://leetcode.com/problems/smallest-subsequence-of-distinct-characters/](https://leetcode.com/problems/smallest-subsequence-of-distinct-characters/)

---

**Explanation of _smallest lexicographical order among all possible results_**

First, lexicographical order is first determined by string length and then alphabetical order. Since the string length is predetermined by the constraints of the question (every letter appears once and only once) we only care about the alphabetical order.

Second, and more importantly, we're looking for lexicographical order **among all possible results**. That means for the second example of "cbacdcbc" we first determine what all possible results are...

"**cba**c**d**cbc" = "cbad"
"**c**b**a**c**d**c**b**c" = "cadb"
"c**bacd**cbc" = "bacd"
"c**ba**c**dc**bc" = "badc"
"c**ba**c**d**cb**c**" = "badc" (Note: This is a duplicate result but is a different subset of the original string than the last result.)
"cb**acd**c**b**c" = "acdb"
"cb**a**c**dcb**c" = "adcb"
"cb**a**c**d**c**bc**" = "adbc"

and once we order the results lexicographically...

1. "acdb"
2. "adbc"
3. "adcb"
4. "bacd"
5. "badc"
6. "badc"
7. "cadb"
8. "cbad"

we see that our first result is "acdb".

A common question I see in the discussions is "Why isn't the answer abcd" and I hope this explanation helps demonstrate that, while "abcd" is indeed lexicographically smaller, it is not actually one of our results since it's not a subset of the original string. Remember that our only operation available is _removing_ characters from the string; we cannot reorganize the characters.

It took me a minute to figure out after reading the question and I hope this helps other people out!

## My Solution

Approach:

- find all possible combinations
- order by string and take the first one

just kidding, this approach is too slow to solve the problem.

Approach2:

- find all possible indices for each letter in the string
- try to combine them with lexicographical order

for example: `cbacdcbc`

we have

```text
a: 2
b: 1, 6
c: 0, 3, 5, 7
d: 4
```

we take the letters from the first one of the string:

1. `c`
2. `cb` => `c` > `b` => since we have at least another `c` in the rest of the string, we can remove the first `c` to store `b` => `b`
3. `ba` => `b` > `a` => since we have at least another `b` in the rest of the string, we can remove the first `b` to store `a` => `a`
4. `ac`
5. `acd`
6. `acdc` => remove the last `c` since we have already had a `c` in our string. => `acd`
7. `acdb` => `d` > `b` => but we do not have another `b` in the rest of the string so we must take this one. => `acdb`
8. `acdbc` => remove the last `c` since we have already had a `c` in our string. => `acd` => `acdb`

```csharp
public class Solution
{
    public string RemoveDuplicateLetters(string s)
    {
        int[] lastAppearance = new int[26];
        lastAppearance.Populate(-1);
        bool[] isPicked = new bool[26];
        isPicked.Populate(false);

        for (int i = 0; i < 26; ++i)
        {
            lastAppearance[i] = s.LastIndexOf((char)(i + 'a'));
        }

        Stack<char> stack = new Stack<char>();
        for (int i = 0; i < s.Length; ++i)
        {
            if (stack.Count == 0)
            {
                stack.Push(s[i]);
                isPicked[s[i] - 'a'] = true;
                continue;
            }
            if (isPicked[s[i] - 'a'])
                continue;
            if (stack.Peek() < s[i])
            {
                stack.Push(s[i]);
                isPicked[s[i] - 'a'] = true;
                continue;
            }
            // stack.Peek() > s[i]
            while(stack.Count != 0 && stack.Peek()>s[i] && lastAppearance[stack.Peek() - 'a'] > i )
            {
                isPicked[stack.Peek() - 'a'] = false;
                stack.Pop();
            }
            isPicked[s[i] - 'a'] = true;
            stack.Push(s[i]);
        }

        // stack.Reverse();
        Stack<char> tmp = new();
        while(stack.Count != 0){
            tmp.Push(stack.Pop());
        }
        StringBuilder sb = new();
        while(tmp.Count != 0){
            sb.Append(tmp.Pop());
        }
        return sb.ToString();
    }
}

public static class ArrExtensions
{
    public static void Populate<T>(this T[] arr, T value)
    {
        for (int i = 0; i < arr.Length; i++)
        {
            arr[i] = value;
        }
    }
}
```

## Better Solutions

### Solution 1

```java
class Solution {
    public String removeDuplicateLetters(String s) {
        int[] lastIndex = new int[26];
        for (int i = 0; i < s.length(); i++){
            lastIndex[s.charAt(i) - 'a'] = i; // track the lastIndex of character presence
        }

        boolean[] seen = new boolean[26]; // keep track seen
        Stack<Integer> st = new Stack();

        for (int i = 0; i < s.length(); i++) {
            int curr = s.charAt(i) - 'a';
            if (seen[curr]) continue; // if seen continue as we need to pick one char only
            while (!st.isEmpty() && st.peek() > curr && i < lastIndex[st.peek()]){
                seen[st.pop()] = false; // pop out and mark unseen
            }
            st.push(curr); // add into stack
            seen[curr] = true; // mark seen
        }

        StringBuilder sb = new StringBuilder();
        while (!st.isEmpty())
            sb.append((char) (st.pop() + 'a'));
        return sb.reverse().toString();
    }
}
```
