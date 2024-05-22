# LeetCode:131:2024/5/22:golang

tags: #problem_solve #leetcode/medium #DFS #golang 

[Reference](https://leetcode.com/problems/palindrome-partitioning/description/)

## Question

Given a string `s`, partition `s` such that every 

substring

 of the partition is a 

**palindrome**

. Return _all possible palindrome partitioning of_ `s`.

**Example 1:**

**Input:** s = "aab"
**Output:** [["a","a","b"],["aa","b"]]

**Example 2:**

**Input:** s = "a"
**Output:** [["a"]]

**Constraints:**

- `1 <= s.length <= 16`
- `s` contains only lowercase English letters.

## My Solution

approach:

- 遍歷所有可能的分割做法，找出符合全部回文的組合記錄下來

```go
func partition(s string) [][]string {
    ans := [][]string{}
    for i:=1;i<=len(s);i++{
        res,ok := dfs(s,0,i,[]string{},[][]string{})
        if ok{
            ans = append(ans,res...)
        }
    }
    return ans
}

func dfs(s string, startIndex int, length int, curr []string, res [][]string)([][]string, bool){
    str := string(s[startIndex:startIndex+length])
    if isPalindrome(str){
        clone := append(curr,str)

        newIdx := startIndex+length
        if newIdx == len(s){
            return append(res,clone),true
        }

        anyMatch:=false
        for newLen := 1;newIdx+newLen<=len(s);newLen++{
            if newRes,ok:=dfs(s,newIdx,newLen,clone,res);ok{
                res = append(res,newRes...)
                anyMatch = true
            }
        }
        if anyMatch{
            return res,true
        }
    }

    return nil,false
}

func isPalindrome(str string)bool{
    for i:=0;len(str)-i-1>i;i++{
        if str[i]!=str[len(str)-i-1]{
               return false
        }
    }
    return true
}
```

頭腦有點混亂，outer loop應該是非必要但暫時想不到該怎麼去掉，總之先這樣應證想法有沒有問題

![image](https://i.imgur.com/wdvtqTj.png)

可惜看來有點問題，不過應該是出在實作面，一邊重構一邊處理好了。


- 首先dfs完全不需要回傳bool，我只要改成事先檢查字串是否回文，就能夠去掉這個回傳值減少複雜度了。
- 透過把新增的部分去除掉就不需要每次都clone curr 了，節省空間。
- 移除outer loop

```go
func partition(s string) [][]string {
    var result [][]string
    var current []string
    dfs(s, 0, current, &result)
    return result
}

func dfs(s string, start int, current []string, result *[][]string) {
    if start == len(s) {
        temp := make([]string, len(current))
        copy(temp, current)
        *result = append(*result, temp)
        return
    }
    
    for end := start; end < len(s); end++ {
        if isPalindrome(s[start:end+1]) {
            current = append(current, s[start:end+1])
            dfs(s, end+1, current, result)
            current = current[:len(current)-1] // backtrack
        }
    }
}

func isPalindrome(s string) bool {
    for i := 0; i < len(s)/2; i++ {
        if s[i] != s[len(s)-i-1] {
            return false
        }
    }
    return true
}
```

新版本

![image](https://i.imgur.com/9EaYQYp.png)

## Better Solutions
