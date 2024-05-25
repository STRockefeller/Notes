# LeetCode:1255:20240524:go

tags: #problem_solve

[Reference](https://leetcode.com/problems/maximum-score-words-formed-by-letters/description/)

## Question

Given a list of words, list of  single letters (might be repeating) and score of every character.

Return the maximum score of any valid set of words formed by using the given letters (words[i] cannot be used two or more times).

It is not necessary to use all characters in letters and each letter can only be used once. Score of letters 'a', 'b', 'c', ... ,'z' is given by score[0], score[1], ... , score[25] respectively.

 

Example 1:

Input: words = ["dog","cat","dad","good"], letters = ["a","a","c","d","d","d","g","o","o"], score = [1,0,9,5,0,0,3,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0]
Output: 23
Explanation:
Score  a=1, c=9, d=5, g=3, o=2
Given letters, we can form the words "dad" (5+1+5) and "good" (3+2+2+5) with a score of 23.
Words "dad" and "dog" only get a score of 21.
Example 2:

Input: words = ["xxxz","ax","bx","cx"], letters = ["z","a","b","c","x","x","x"], score = [4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,10]
Output: 27
Explanation:
Score  a=4, b=4, c=4, x=5, z=10
Given letters, we can form the words "ax" (4+5), "bx" (4+5) and "cx" (4+5) with a score of 27.
Word "xxxz" only get a score of 25.
Example 3:

Input: words = ["leetcode"], letters = ["l","e","t","c","o","d"], score = [0,0,1,1,1,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,0,0,0,0]
Output: 0
Explanation:
Letter "e" can only be used once.
 

Constraints:

1 <= words.length <= 14
1 <= words[i].length <= 15
1 <= letters.length <= 100
letters[i].length == 1
score.length == 26
0 <= score[i] <= 10
words[i], letters[i] contains only lower case English letters.

## My Solution

難得hard難度的題目看完之後馬上有想法。可能是因為和前幾天的每日主題相似吧。

Approach:

- 先不管letters夠不夠，針對每一個word組成或不組成的可能全部列出。
- 一一檢查所有可能並且記錄分數，不可能完成的就以0分計算。
- 這次不用遞迴了，改以二進制數值紀錄哪個單字要組成。這樣比較有練習到不一樣的寫法

```go
func maxScoreWords(words []string, letters []byte, score []int) int {
    remainLetters := make([]int,26)
    for _,c :=range letters{
        remainLetters[c-'a']++
    }

    maxScore := 0

    // while i == 0011. it means we form the 1st and second words
    for i:=0;i<(1<<len(words)+1);i++{
        clone := make([]int, len(remainLetters))
        copy(clone, remainLetters)

        var impossible bool
        currentScore := 0

        for j:=0;j<len(words);j++{
            if impossible {
                currentScore = 0
                break
            }
            if (i>>j)&1==1{
                for _,c := range words[j]{
                    if clone[c-'a'] <= 0{
                        impossible = true
                        break
                    }

                    clone[c-'a']--
                    currentScore += score[c-'a']
                }
            }
        }

        if currentScore > maxScore{
            maxScore = currentScore
        }
    }

    return maxScore
}
```

![image](https://i.imgur.com/XQ7bYex.png)

還以為秒殺，結果一般測試就過不了，來debug吧...

```go
func maxScoreWords(words []string, letters []byte, score []int) int {
    remainLetters := make([]int, 26)
    for _, c := range letters {
        remainLetters[c-'a']++
    }

    maxScore := 0

    for i := 0; i < (1 << len(words)+1); i++ {
        clone := make([]int, len(remainLetters))
        copy(clone, remainLetters)

        var impossible bool
        currentScore := 0

        for j := 0; j < len(words); j++ {
            if (i>>j)&1 == 1 {
                for _, c := range words[j] {
                    if clone[c-'a'] <= 0 {
                        impossible = true
                        break
                    }
                    clone[c-'a']--
                    currentScore += score[c-'a']
                }
            }
            if impossible {
                break
            }
        }

        if !impossible && currentScore > maxScore {
            maxScore = currentScore
        }
    }

    return maxScore
}
```

跳脫機制太醜了，試著重構一下就通過了。倒頭來還是沒看出原來哪裡出錯。😑

```go
func maxScoreWords(words []string, letters []byte, score []int) int {
    remainLetters := make([]int, 26)
    for _, c := range letters {
        remainLetters[c-'a']++
    }

    maxScore := 0

    for i := 0; i < (1 << len(words)+1); i++ {
        clone := make([]int, len(remainLetters))
        copy(clone, remainLetters)

        var impossible bool
        currentScore := 0

        for j := 0; j < len(words); j++ {
            if (i>>j)&1 == 1 {
                for _, c := range words[j] {
                    if clone[c-'a'] <= 0 {
                        impossible = true
                        break
                    }
                    clone[c-'a']--
                    currentScore += score[c-'a']
                }
            }
            if impossible {
                break
            }
        }

        if !impossible && currentScore > maxScore {
            maxScore = currentScore
        }
    }

    return maxScore
}
```

![image](https://i.imgur.com/pFnGrCg.png)

不過成績世界爛。

## Better Solutions
