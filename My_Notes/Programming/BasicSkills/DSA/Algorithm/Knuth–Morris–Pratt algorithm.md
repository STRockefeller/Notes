# Knuth–Morris–Pratt algorithm

tags: #string_searching_algorithms #algorithms

[wiki](https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm)

[初學者學 KMP 演算法](https://yeefun.github.io/kmp-algorithm-for-beginners/)

[GFG](https://www.geeksforgeeks.org/kmp-algorithm-for-pattern-searching/?ref=lbp)

[BSC](http://www.btechsmartclass.com/data_structures/knuth-morris-pratt-algorithm.html)

## wiki sample

[維基百科](https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm)這個範例還滿好懂得，借來用一下

To illustrate the algorithm's details, consider a (relatively artificial) run of the algorithm, where `W` = "ABCDABD" and `S` = "ABC ABCDAB ABCDABCDABDE". At any given time, the algorithm is in a state determined by two integers:

- `m`, denoting the position within `S` where the prospective match for `W` begins,
- `i`, denoting the index of the currently considered character in `W`.

In each step the algorithm compares `S[m+i]` with `W[i]` and increments `i` if they are equal. This is depicted, at the start of the run, like

![](https://i.imgur.com/NlW4j9w.png)

The algorithm compares successive characters of `W` to "parallel" characters of `S`, moving from one to the next by incrementing `i` if they match. However, in the fourth step `S[3] = ' '` does not match `W[3] = 'D'`. Rather than beginning to search again at `S[1]`, we note that no `'A'` occurs between positions 1 and 2 in `S`; hence, having checked all those characters previously (and knowing they matched the corresponding characters in `W`), there is no chance of finding the beginning of a match. Therefore, the algorithm sets `m = 3` and `i = 0`.

![](https://i.imgur.com/aNS3Lu7.png)

This match fails at the initial character, so the algorithm sets `m = 4` and `i = 0`

![](https://i.imgur.com/1h1NBAh.png)

Here, `i` increments through a nearly complete match `"ABCDAB"` until `i = 6` giving a mismatch at `W[6]` and `S[10]`. However, just prior to the end of the current partial match, there was that substring `"AB"` that could be the beginning of a new match, so the algorithm must take this into consideration. As these characters match the two characters prior to the current position, those characters need not be checked again; the algorithm sets `m = 8` (the start of the initial prefix) and `i = 2` (signaling the first two characters match) and continues matching. Thus the algorithm not only omits previously matched characters of `S` (the `"AB"`), but also previously matched characters of `W` (the prefix `"AB"`).

![](https://i.imgur.com/5HPgM5R.png)

This search at the new position fails immediately because `W[2]` (a `'C'`) does not match `S[10]` (a `' '`). As in the first trial, the mismatch causes the algorithm to return to the beginning of `W` and begins searching at the mismatched character position of `S`: `m = 10`, reset `i = 0`.

![](https://i.imgur.com/U8HWZW2.png)

The match at `m=10` fails immediately, so the algorithm next tries `m = 11` and `i = 0`.

![](https://i.imgur.com/ZPJtJbU.png)

Once again, the algorithm matches `"ABCDAB"`, but the next character, `'C'`, does not match the final character `'D'` of the word `W`. Reasoning as before, the algorithm sets `m = 15`, to start at the two-character string `"AB"` leading up to the current position, set `i = 2`, and continue matching from the current position.

![](https://i.imgur.com/FTHGgo3.png)

This time the match is complete, and the first character of the match is `S[15]`.

## Realization

總之先來實作一次試試。

例如

```text
Input:  txt[] =  "ABC ABCDAB ABCDABCDABDE"
        pat[] =  "ABCDABD"
Output: Pattern found at index 15
```

首先第一個例子，先照著wiki的步驟來

m => 整個字串的index

s => 整個字串

w => 要找的字串

i => 要找的字串的index

```text
             1         2
m: 01234567890123456789012
S: ABC ABCDAB ABCDABCDABDE
W: ABCDABD
i: 0123456
```

找到m=3發現`" "!="D"`。

相同的部分有`ABC`，後綴為  `" "` `"C "` `"BC "` `"ABC "`。

要找的前綴為 `"A"` `"AB"` `"ABC"`，全都對不上，所以接著從m=4開始找

```text
             1         2
m: 01234567890123456789012
S: ABC ABCDAB ABCDABCDABDE
W:     ABCDABD
i:     0123456
```

找到m=10發現`" "!="D"`。

相同的部分有`ABCDAB`，後綴為 `" "` `"B "`...

總之全都對不上，所以接著從m=11開始找

```text
             1         2
m: 01234567890123456789012
S: ABC ABCDAB ABCDABCDABDE
W:            ABCDABD
i:            0123456
```

找到m=17發現`"C"!="D"`。

相同的部分有`ABCDAB`，後綴為  `"C"` `"BC"` `"ABC"` `"DABC"` `"CDABC"` `"BCDABC"` `"ABCDABC"`。

要找的前綴為 `"A"` `"AB"` `"ABC"` `"ABCD"` `"ABCDA"` `"ABCDAB"` `"ABCDABD"`

`"ABC"`對上了，所以下次從m=15+3開始找。

```text
             1         2
m: 01234567890123456789012
S: ABC ABCDAB ABCDABCDABDE
W:                ABCDABD
i:                0123456
```

順利找到要找的字串

抓一下重點

1. 已經對過的部分，要把後綴整理出來
2. 要找的字的前綴也要整理出來
3. 每次比對完，把1 2 的結果拿來對，找出下一次比對開始的地方

架構大概像是

```go
func KMP(s, w string) (index int) {
 m := 0
 for m+len(w) <= len(s) {
  ok, next := subKMP(s, w, m)
  if ok {
   return m
  }
  m = next
 }
 return -1
}

func subKMP(s, w string, m int) (success bool, next int) {
 // do something
}
```

或者用遞迴

```go
func KMP(s, w string) (index int) {
 m := 0
 return subKMP(s, w, m)
}

func subKMP(s, w string, m int) (index int) {
 var success bool
 var next int
 // do something
 if !success {
  return subKMP(s, w, next)
 }
 return m
}
```

不過實際上，會更推薦使用LPS table 去完成它，大概會像是

```go
func KMP(s, w string) int {
 m := 0
 i := 0
 next := getNext(s)

 for m < len(s) && i < len(w) {
  if s[m] == w[i] {
   m++
   i++
  } else if i <= 0 {
   m++
  } else {
   i = next[i-1]
  }
 }

 if i >= len(w) {
  return m - len(w)
 } else {
  return -1
 }
}

func getNext(s string) map[int]int {
 // do something
}
```

其中`getNext`會吐出LPS表，這個方法的執行效率關係到整個KMP演算法的效率

## LPS Table

從上一節可以看出，kmp演算法的重點落在於LPS table，這邊就來重點了解一下LPS table是甚麼樣子?他能怎麼幫助我們實現KMP演算法，又該如何取得?

再把wiki的範例拿來用

```
             1         2
m: 01234567890123456789012
S: ABC ABCDAB ABCDABCDABDE
W: ABCDABD
i: 0123456
```

LPS table 只針對字串，以一個array呈現，值代表到該處為止prefix和suffix相符的個數(中文有點差，描述得不是很好，待改善)

先用wiki的範例來寫個LPS table。

以字串 `ABCCDABD`為例，以下P代表prefix，S同理

index 0 : "A" => P: "",S: ""=> 0

index 1 : "AB"  => P:"A"; S:"B" => 0

index 2 : "ABC"  => P:"AB","A"; S:"BC","B" => 0

...

index 4: "ABCDA" => P:"A" ...; S:"A"... => 1

index 5: "ABCDAB" => P:"AB"...;S:"AB"... => 2

index 6: "ABCDABD" => P:...;S:... => 0

總之就是找前後綴相同的字串中最長者的長度，全部寫完大概會像是

```
text: ABCDABD
LPS:  0000120
```

再看一個比較複雜的例子

```
text: abcabffabcabc
LPS:  0001200123453
```

然後就是把這個表實作出來

```go
func getNext(s string) map[int]int {
 next := make(map[int]int)

 for i := 0; i < len(s); i++ {
  subStr := s[0 : i+1]

  for j := len(subStr) - 1; j >= 1; j-- {
   if subStr[0:j] == subStr[len(subStr)-j:] {
    next[i] = j

    break
   }
  }
 }

 return next
}

```

兩個迴圈，直接讓kmp的效率蕩然無存

實際上LPS表的實作方式有很多種。下面提供來自[這篇文章](https://yeefun.github.io/kmp-algorithm-for-beginners/)的做法為參考

把前面比較複雜的例子拿來看

```
text: abcabffabcabc
LPS:  0001200123453
```

我們把整個字串和substring對在一起比較

index0:

```
                     1
index:     0123456789012
string:    abcabffabcabc
substring: a
LPS:       0
```

index1:

```
                      1
index:      0123456789012
string:     abcabffabcabc
substring: ab
LPS:       00
```

index2:

```
                       1
index:       0123456789012
string:      abcabffabcabc
substring: abc
LPS:       000
```

index3: 對上了

```
                        1
index:        0123456789012
string:       abcabffabcabc
substring: abca
LPS:       0001
```

繼續...

```
                        1
index:        0123456789012
string:       abcabffabcabc
substring: abcab
LPS:       00012
```

index5: 沒對上，需要往前找，這邊結果是0， 後面再細講

```
                        1
index:        0123456789012
string:       abcabffabcabc
substring: abcabf
LPS:       000120
```

繼續...

一直到index11:

```
                            1
index:            0123456789012
string:           abcabffabcabc
substring: abcabffabcab
LPS:       000120012345
```

index12:沒對上

```
                            1
index:            |01234|56789012
string:           |abcab|ffabcabc
substring: abcabff|abcab|c
LPS:       0001200|12345|?
```

往前找"abcab"

```
                            1
index:            |01234|56789012
string:           |abcab|ffabcabc
substring: abcabff|abcab|c
           -----
LPS:       0001200|12345|?
```

值為2，把檢查的位置移動到index2

```
                               1
index:               0123456789012
string:              abcabffabcabc
substring: abcabffabcabc
LPS:       000120012345?
```

對上了，這邊要填入的數值要從"abcab"之後+1，也就是2+1=3

```
                               1
index:               0123456789012
string:              abcabffabcabc
substring: abcabffabcabc
LPS:       0001200123453
```

完成

---

再提供一種LPS的思路，原理是一樣的，不過我們這次用指針來表示。(在記事本中演練可以直接移動指針效果特別好)

```
index:     0123456789012
           ⬇
string:    abcabffabcabc
substring: abcabffabcabc
           ⬆
LPS:
```

老樣子第一位先填入0

```
index:     0123456789012
           ⬇
string:    abcabffabcabc
substring: abcabffabcabc
            ⬆
LPS:       0
```

然後繼續...

到 index 3 發現兩邊對上了，填入1，兩邊指針後移

```
index:     0123456789012
           ⬇
string:    abcabffabcabc
substring: abcabffabcabc
              ⬆
LPS:       000
```

```
index:     0123456789012
            ⬇
string:    abcabffabcabc
substring: abcabffabcabc
               ⬆
LPS:       0001
```

```
index:     0123456789012
             ⬇
string:    abcabffabcabc
substring: abcabffabcabc
                ⬆
LPS:       00012
```

index 5 沒對上，把上指針(以下簡稱UI)移動到 LPS[UI-1] 也就是 0 的位置繼續

```
index:     0123456789012
           ⬇
string:    abcabffabcabc
substring: abcabffabcabc
                ⬆
LPS:       00012
```

```
index:     0123456789012
                ⬇
string:    abcabffabcabc
substring: abcabffabcabc
                       ⬆
LPS:       000120012345
```

一直到 index 12 又沒對上，把UI 移動到 LPS[UI-1] 也就是 2 繼續

```
index:     0123456789012
             ⬇
string:    abcabffabcabc
substring: abcabffabcabc
                       ⬆
LPS:       000120012345
```

這次對上了，LPS填入UI+1 = 3

```
index:     0123456789012
              ⬇
string:    abcabffabcabc
substring: abcabffabcabc
                        ⬆
LPS:       0001200123453
```

結束

接著把它實作出來

```go
func getNext(s string) map[int]int {
 next := make(map[int]int)

 iPartial := 1

 iWhole := iPartial - 1

 for iPartial < len(s) {
  if s[iPartial] == s[iWhole] {
   iPartial++
   iWhole++

   next[iPartial-1] = iWhole
  } else if iWhole <= 0 {
   iPartial++

   next[iPartial-1] = 0
  } else {
   iWhole = next[iWhole-1]
  }
 }

 return next
}
```

### Usage

好不容易算出LPS table，但是不會用就尷尬了。

老樣子拿wiki範例出來用

```
             1         2
m: 01234567890123456789012
S: ABC ABCDAB ABCDABCDABDE
W: ABCDABD
i: 0123456
```

我們算出 w 的 LPS table，並且把它填上去

```
             1         2
m: 01234567890123456789012
S: ABC ABCDAB ABCDABCDABDE
W: ABCDABD
i: 0123456
l: 0000120
```

開始來比較

```
               1         2
m: |0123456|7890123456789012
S: |ABC ABC|DAB ABCDABCDABDE
W: |ABCDABD|
i: |0123456|
l: |0000120|
```

`ABC ABC` vs `ABCDABD` 從index 3開始對不上，找LPS[2] = 0，我們就直接把整個字串移動到之後的位置繼續。

```
             1         2
m: 01234567890123456789012
S: ABC ABCDAB ABCDABCDABDE
W:     ABCDABD
i:     0123456
l:     0000120
```

`ABCDAB` vs `ABCDABD` 從index 6開始對不上，找LPS[5] = 2。把index 2 放到沒對上的位置繼續。

```
             1         2
m: 01234567890123456789012
S: ABC ABCDAB ABCDABCDABDE
W:         ABCDABD
i:         0123456
l:         0000120
```

`AB ABCD` vs `ABCDABD` index 2 開始對不上， LPS[1] = 0

```
             1         2
m: 01234567890123456789012
S: ABC ABCDAB ABCDABCDABDE
W:            ABCDABD
i:            0123456
l:            0000120
```

`ABCDABC` vs `ABCDABD` index 6 開始對不上， LPS[5] = 2。把index 2 放到沒對上的位置繼續。

```
             1         2
m: 01234567890123456789012
S: ABC ABCDAB ABCDABCDABDE
W:                ABCDABD
i:                0123456
l:                0000120
```

完成查詢。
