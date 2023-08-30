# LeetCode:97:20230825:C\#

tags: #problem_solve

[Reference](https://leetcode.com/problems/interleaving-string/)

## Question

Given strings `s1`, `s2`, and `s3`, find whether `s3` is formed by an **interleaving** of `s1` and `s2`.

An **interleaving** of two strings `s` and `t` is a configuration where `s` and `t` are divided into `n` and `m` 

substrings

 respectively, such that:

- `s = s1 + s2 + ... + sn`
- `t = t1 + t2 + ... + tm`
- `|n - m| <= 1`
- The **interleaving** is `s1 + t1 + s2 + t2 + s3 + t3 + ...` or `t1 + s1 + t2 + s2 + t3 + s3 + ...`

**Note:** `a + b` is the concatenation of strings `a` and `b`.

**Example 1:**

![](https://assets.leetcode.com/uploads/2020/09/02/interleave.jpg)

**Input:** s1 = "aabcc", s2 = "dbbca", s3 = "aadbbcbcac"
**Output:** true
**Explanation:** One way to obtain s3 is:
Split s1 into s1 = "aa" + "bc" + "c", and s2 into s2 = "dbbc" + "a".
Interleaving the two splits, we get "aa" + "dbbc" + "bc" + "a" + "c" = "aadbbcbcac".
Since s3 can be obtained by interleaving s1 and s2, we return true.

**Example 2:**

**Input:** s1 = "aabcc", s2 = "dbbca", s3 = "aadbbbaccc"
**Output:** false
**Explanation:** Notice how it is impossible to interleave s2 with any other string to obtain s3.

**Example 3:**

**Input:** s1 = "", s2 = "", s3 = ""
**Output:** true

**Constraints:**

- `0 <= s1.length, s2.length <= 100`
- `0 <= s3.length <= 200`
- `s1`, `s2`, and `s3` consist of lowercase English letters.

**Follow up:** Could you solve it using only `O(s2.length)` additional memory space?

## My Solution

Approach:

~~3 pointers on the each string and compare the chars~~

It doesn't work on the following situation

"abc" "acb" "acabcb" => it should be true, but if I take the 'a' from s1 first, it will result to false.

```csharp
public class Solution
{
    public bool IsInterleave(string s1, string s2, string s3)
    {
        if (s3.Length != s1.Length + s2.Length)
        {
            return false;
        }
        bool?[,] dp = new bool?[s1.Length + 1, s2.Length + 1];
        return SubIsInterleave(s1, s2, s3, s1.Length, s2.Length, dp);
    }

    private bool SubIsInterleave(string s1, string s2, string s3, int l1, int l2, bool?[,] dp)
    {
        if (dp[l1, l2] != null)
        {
            return (bool)dp[l1, l2];
        }
        if (l1 == 0)
        {
            bool res = s2[..l2] == s3[..l2];
            dp[l1, l2] = res;
            return res;
        }
        if (l2 == 0)
        {
            bool res = s1[..l1] == s3[..l1];
            dp[l1, l2] = res;
            return res;
        }

        if (s3[l1+l2-1] == s1[l1-1])
        {
            if (SubIsInterleave(s1, s2, s3, l1 - 1, l2, dp))
            {
                dp[l1, l2] = true;
                return true;
            }
        }
        if (s3[l1+l2-1] == s2[l2-1])
        {
            if(SubIsInterleave(s1, s2, s3, l1, l2 - 1, dp)){
                dp[l1, l2] = true;
                return true;
            }
        }
        dp[l1,l2] = false;
        return false;
    }


    private IEnumerable<(int l1, int l2)> PossibleSlices(int len)
    {
        for (int i = 0; i <= len; i++)
        {
            yield return (i, len - i);
        }
    }
}
```

![result](https://i.imgur.com/gpanuLz.png)

## Better Solutions
