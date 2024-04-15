# CodeWars:John and Ann sign up for Codewars:20220217:Go

tags: #problem_solve #codewars/5kyu #golang

[Reference](https://www.codewars.com/kata/57591ef494aba64d14000526)

## Question

John and his wife Ann have decided to go to Codewars. On the first day Ann will do one kata and John - he wants to know how it is working - 0 kata.

Let us call `a(n)` - and `j(n)` - the number of katas done by Ann - and John - at day `n`. We have `a(0) = 1` and in the same manner `j(0) = 0`.

They have chosen the following rules:

- On day `n` the number of katas done by Ann should be `n` minus the number of katas done by John at day `t`, `t` being equal to the number of katas done by Ann herself at day `n - 1`
- On day `n` the number of katas done by John should be `n` minus the number of katas done by Ann at day `t`, `t` being equal to the number of katas done by John himself at day `n - 1`

Whoops! I think they need to lay out a little clearer exactly what there're getting themselves into!

### Could you write

- functions `ann(n)` and `john(n)` that return the **list** of the number of katas Ann/John does on the first `n` days;
- functions `sum_ann(n)` and `sum_john(n)` that return the **total** number of katas done by Ann/John on the first `n` days

### Examples

```
john(11)  -->  [0, 0, 1, 2, 2, 3, 4, 4, 5, 6, 6]
ann(6)    -->  [1, 1, 2, 2, 3, 3]

sum_john(75)  -->  1720
sum_ann(150)  -->  6930
```

#### Note

Keep an eye on performance.

## My Solution

照慣例先整理題目：

1. a(0) = 1
2. j(0) = 0
3. a(n) = n - j(t) , where t = a(n-1)
4. 整理第三點， a(n) = n - j(a(n-1))
5. j(n) = n - a(t), where t = j(n-1)
6. j(n) = n - a(j(n-1))

題目要的方法:

1. ann(n)/john(n) => 一個list表示前n天 Ann/John 每天解題量
2. sum_ann(n)/sum_john(n) ==> 前n天的總解題量

沒頭緒，試著延伸一點看看..

j(0) = 0

a(0) = 1

j(1) = 1 - a(j(0)) = 1 - a(0) = 0 ~~抓到，第二天也沒做題目~~

a(1) = 1 - j(a(0)) = 1 - j(1) = 1

j(2) = 2 - a(j(1)) = 2 - a(0) = 1

a(2) = 2 - j(a(1)) = 2 - j(1) = 2

兩人的解題數相互關聯，目前沒有看出能只算出其中一邊的方法

總之先用最笨的方法來寫出脈絡，再接著優化它

n和j的function，先按題目寫，之後可以再優化成把已經算過的紀錄下來增加效率

```go
func a(n int) int {
	if n == 0 {
		return 1
	}
	return n - j(a(n-1))
}

func j(n int) int {
	if n == 0 {
		return 0
	}
	return n - a(j(n-1))
}
```

Ann 和 John的方法大概如下

```go
func Ann(n int) []int {
	res := make([]int, n)
	for i := 0; i < n; i++ {
		res[i] = a(i)
	}
	return res
}

func John(n int) []int {
	res := make([]int, n)
	for i := 0; i < n; i++ {
		res[i] = j(i)
	}
	return res
}
```

總和

```go
func SumJohn(n int) int {
	j := John(n)
	sum := 0
	for _, elem := range j {
		sum += elem
	}
	return sum
}

func SumAnn(n int) int {
	a := Ann(n)
	sum := 0
	for _, elem := range a {
		sum += elem
	}
	return sum
}
```

嗯，寫完了，但效率肯定世界爛，直接來優化一下

因為用的是golang沒有properties可以用，只好用global variables來存計算過的內容

```go
package kata

var kataAnn map[int]int = make(map[int]int)
var kataJohn map[int]int = make(map[int]int)

func Ann(n int) []int {
	res := make([]int, n)
	for i := 0; i < n; i++ {
		res[i] = a(i)
	}
	return res
}

func John(n int) []int {
	res := make([]int, n)
	for i := 0; i < n; i++ {
		res[i] = j(i)
	}
	return res
}

func SumJohn(n int) int {
	j := John(n)
	sum := 0
	for _, elem := range j {
		sum += elem
	}
	return sum
}

func SumAnn(n int) int {
	a := Ann(n)
	sum := 0
	for _, elem := range a {
		sum += elem
	}
	return sum
}

func a(n int) int {
	if n == 0 {
		kataAnn[0] = 1
		return 1
	}
	if val, ok := kataAnn[n]; ok {
		return val
	}
	res := n - j(a(n-1))
	kataAnn[n] = res
	return res
}

func j(n int) int {
	if n == 0 {
		kataJohn[0] = 1
		return 0
	}
	if val, ok := kataJohn[n]; ok {
		return val
	}
	res := n - a(j(n-1))
	kataJohn[n] = res
	return res
}

```

ok，一次過

## Better Solutions

先略過，沒看到什麼令人眼睛一亮的解法，可能是題目太簡單的緣故?
