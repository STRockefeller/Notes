# Uva:10220:20220309:Go

[Reference](https://onlinejudge.org/external/102/10220.pdf)



## Question

A Japanese young girl went to a Science Fair at Tokyo.

There she met with a Robot named Mico-12, which had AI (You must know about AI-Artificial Intelligence).

The Japanese girl thought, she can do some fun with that Robot.

She asked her, “Do you have any idea about maths?”.

“Yes! I love mathematics”, The Robot replied.

“Okey! Then I am giving you a number, you have to find out the Factorial of that number.

Then find the sum of the digits of your result!.

Suppose the number is 5.

You first calculate 5! = 120, then find sum of the digits 1 + 2 + 0 = 3.

Can you do it?”.

“Yes. I can do!” Robot replied.

“Suppose the number is 100, what will be the result?”.

At this point the Robot started thinking and calculating.

After a few minutes the Robot head burned out and it cried out loudly “Time Limit Exceeds”.

The girl laughed at the Robot and said “The sum is definitely 648”.

“How can you tell that?” Robot asked the girl.

“Because I am an ACM World Finalist and I can solve the Big Number problems easily”.

Saying this, the girl closed her laptop computer and went away.

Now, your task is to help the Robot with the similar problem.

Input The input file will contain one or more test cases.

Each test case consists of one line containing an integers n (n ≤ 1000).

Output For each test case, print one line containing the required number.

This number will always fit into an integer, i.e. it will be less than 2 31 − 1.

### Sample Input 

5

60

100 

### Sample Output 

3 

288 

648

## My Solution

故事不重要，這題就是先問階乘再問digit sum，兩種都是經典題型，來計時看看能不能快速搞定

![](https://i.imgur.com/K8dmf1O.png)

```go
package main

import (
	"fmt"
)

func main() {
	var input int
	if _, err := fmt.Scan(&input); err != nil {
		fmt.Println("invalid input")
		return
	}

	fm := newFactorialMap()
	factorRes := fm.cal(input)

	digitSum := 0
	for factorRes >= 10 {
		digitSum += factorRes % 10
		factorRes /= 10
	}
	digitSum += factorRes
	fmt.Println(digitSum)
}

type factorialMap struct {
	value map[int]int
}

func newFactorialMap() factorialMap {
	var res factorialMap
	res.value = make(map[int]int)
	return res
}

func (fm *factorialMap) cal(input int) int {
	if input < 1 {
		fm.value[input] = 1
		return 1
	}
	if val, ok := fm.value[input]; ok {
		return val
	}
	return fm.cal(input-1) * input
}

```

小數值都對，但大的搞不定，忘記我是在寫big number了...改一下...

![](https://i.imgur.com/JSITJq9.png)

```go
package main

import (
	"fmt"
	"math/big"
)

func main() {
	var input int
	if _, err := fmt.Scan(&input); err != nil {
		fmt.Println("invalid input")
		return
	}

	fm := newFactorialMap()
	factorRes := fm.cal(input)

	digitSum := big.NewInt(0)
	for factorRes.Cmp(big.NewInt(10)) != -1 {
		var quo, rem big.Int
		quo.QuoRem(&factorRes, big.NewInt(10), &rem)
		digitSum = big.NewInt(0).Add(&rem, digitSum)
		factorRes = quo
	}
	digitSum = big.NewInt(0).Add(&factorRes, digitSum)
	fmt.Println(digitSum.Int64())
}

type factorialMap struct {
	value map[int]big.Int
}

func newFactorialMap() factorialMap {
	var res factorialMap
	res.value = make(map[int]big.Int)
	return res
}

func (fm *factorialMap) cal(input int) big.Int {
	if input < 1 {
		fm.value[input] = *big.NewInt(1)
		return *big.NewInt(1)
	}
	if val, ok := fm.value[input]; ok {
		return val
	}
	var res big.Int
	prev := fm.cal(input - 1)
	res.Mul(&prev, big.NewInt(int64(input)))
	return res
}

```

結果又花了近半小時才寫完，golang big 套件的方法真的寫得很不直覺

例如除法，我真的不相信有人不看註解可以知道這東西要怎麼用。

![](https://i.imgur.com/wvTnZ2I.png)

```go
// QuoRem sets z to the quotient x/y and r to the remainder x%y
// and returns the pair (z, r) for y != 0.
// If y == 0, a division-by-zero run-time panic occurs.
//
// QuoRem implements T-division and modulus (like Go):
//
//	q = x/y      with the result truncated to zero
//	r = x - y*q
//
// (See Daan Leijen, ``Division and Modulus for Computer Scientists''.)
// See DivMod for Euclidean division and modulus (unlike Go).
//
func (z *Int) QuoRem(x, y, r *Int) (*Int, *Int) {
	z.abs, r.abs = z.abs.div(r.abs, x.abs, y.abs)
	z.neg, r.neg = len(z.abs) > 0 && x.neg != y.neg, len(r.abs) > 0 && x.neg // 0 has no sign
	return z, r
}

```

這還是官方套件，完全無法跟上這個天才般的設計...

## Better Solutions

