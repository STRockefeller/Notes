# LeetCode:Pairs of Songs With Total Durations Divisible by 60:20201210:C#

[Reference](https://leetcode.com/explore/challenge/card/december-leetcoding-challenge/570/week-2-december-8th-december-14th/3559/)



## Question

You are given a list of songs where the ith song has a duration of `time[i]` seconds.

Return *the number of pairs of songs for which their total duration in seconds is divisible by* `60`. Formally, we want the number of indices `i`, `j` such that `i < j` with `(time[i] + time[j]) % 60 == 0`.

 

**Example 1:**

```
Input: time = [30,20,150,100,40]
Output: 3
Explanation: Three pairs have a total duration divisible by 60:
(time[0] = 30, time[2] = 150): total duration 180
(time[1] = 20, time[3] = 100): total duration 120
(time[1] = 20, time[4] = 40): total duration 60
```

**Example 2:**

```
Input: time = [60,60,60]
Output: 3
Explanation: All three pairs have a total duration of 120, which is divisible by 60.
```

 

**Constraints:**

- `1 <= time.length <= 6 * 10^4`
- `1 <= time[i] <= 500`

## My Solution

LeetCode 2020 12月 第二週 活動題目(?)

試試身手，看題目其實並不複雜，重點應該是如何避免寫成O(n^2)

第一版

```C#
public class Solution {
    public int NumPairsDivisibleBy60(int[] time) {
        int res=0;
        int[] timeModulo = new int[time.Length];
        for(int i = 0; i<time.Length ; i++)
            timeModulo[i] = time[i]%60;
        int[] backet = new int[60];
        foreach(int t in timeModulo)
            backet[t]++;
        for(int i=1 ; i<30 ; i++)
            if(backet[i]!=0)
                res+=backet[i]*backet[60-i];
        res += take2(backet[0]) + take2(backet[30]);
        return res;
    }
    private int take2(int num) => num >= 2 ? factorial(num) / 2 * (factorial(num - 2)) : 0;
    private int factorial(int n)
    {
        int res = 1;
        foreach (int num in Enumerable.Range(1, n))
            res *= num;
        return res;
    }
}
```

進階測試，失敗。

---

20220420 分隔線

很閒，把之前沒寫出來的題目拿起來看看..
$$
同樣目標是避免 O(n^{2}) 的時間複雜度
$$
先來分析一下題目，看能不能找到簡易的解法

兩兩一對`%60==0`

可以先把每個元素都除以60取餘數，接著找加起來是60或0的答案

比如第一個case

[30,20,150,100,40]

=> [30,20,30,40,40]

如果抓著第一個30，再去找後面出現的30，然後抓20....就依然還是n^2 ==>所以不能這樣做

先分類，總共有 一個20 兩個30 兩個40



重新來一次，抓第一個30=>要找30=>發先30數量為2(減去自己為1)=>...

順序根本不重要，沒必要從第一個抓

假如用一個map存 餘數為OO的一共有XX個 ， 例如 map[OO]=XX

```go
func numPairsDivisibleBy60(time []int) int {
	m := make(map[int]int)
	for _, elem := range time {
		r := elem % 60
		if n, ok := m[r]; ok {
			m[r] = n + 1
		} else {
			m[r] = 1
		}
	}

	var count int
	for key, value := range m {
		if value == 0 {
			continue
		}
		switch key {
		case 0:
			fallthrough
		case 30:
			count += (value - 1) * value / 2
		default:
			ops, ok := m[60-key]
			if !ok {
				continue
			}
			count += value * ops
			m[60-key] = 0
		}
	}
	return count
}
```

![](https://i.imgur.com/PPEXlGe.png)

過關，可以再優化一下

```go
func numPairsDivisibleBy60(time []int) int {
	m := make(map[int]int)
	for _,elem := range time {
		m[elem%60]++
	}

	var count int
	for key, value := range m {
		switch key {
		case 0,30:
			count += (value - 1) * value >> 1
		default:
			count += value * m[60-key]
			m[60-key] = 0
		}
	}
	return count
}
```

![](https://i.imgur.com/1dRJhhC.png)

我感覺應該是有更好才對，但是結果反而變糟了，我猜是leetcode的問題，晚點用benchmark測測



## Better Solutions

