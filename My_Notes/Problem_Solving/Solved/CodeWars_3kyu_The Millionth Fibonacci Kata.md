# CodeWars:The Millionth Fibonacci Kata:20230704:go

tags: #problem_solve #golang #codewars/3kyu #Fibonacci_sequence

[Reference](https://www.codewars.com/kata/53d40c1e2f13e331fc000c26)

## Question

The year is 1214. One night, Pope Innocent III awakens to find the the archangel Gabriel floating before him. Gabriel thunders to the pope:

> Gather all of the learned men in Pisa, especially Leonardo Fibonacci. In order for the crusades in the holy lands to be successful, these men must calculate the millionth number in Fibonacci's recurrence. Fail to do this, and your armies will never reclaim the holy land. It is His will.

The angel then vanishes in an explosion of white light.

Pope Innocent III sits in his bed in awe. How much is a million? he thinks to himself. He never was very good at math.

He tries writing the number down, but because everyone in Europe is still using Roman numerals at this moment in history, he cannot represent this number. If he only knew about the invention of zero, it might make this sort of thing easier.

He decides to go back to bed. He consoles himself, The Lord would never challenge me thus; this must have been some deceit by the devil. A pretty horrendous nightmare, to be sure.

Pope Innocent III's armies would go on to conquer Constantinople (now Istanbul), but they would never reclaim the holy land as he desired.

---

In this kata you will have to calculate `fib(n)` where:

```
fib(0) := 0
fib(1) := 1
fin(n + 2) := fib(n + 1) + fib(n)
```

Write an algorithm that can handle `n` up to `2000000`.

Your algorithm must output the exact integer answer, to full precision. Also, it must correctly handle negative numbers as input.

**HINT I**: Can you rearrange the equation `fib(n + 2) = fib(n + 1) + fib(n)` to find `fib(n)` if you already know `fib(n + 1)` and `fib(n + 2)`? Use this to reason what value `fib` has to have for negative values.

**HINT II**: See [https://web.archive.org/web/20220614001843/https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-11.html#%_sec_1.2.4](https://web.archive.org/web/20220614001843/https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-11.html#%_sec_1.2.4)

## My Solution

```go
package kata

import "math/big"

func fib(n int64) *big.Int {
	memo := map[int64]*big.Int{
		0: big.NewInt(0),
		1: big.NewInt(1),
	}

	if n < 0 {
		for i := int64(-1); i >= n-1; i-- {
			diff := new(big.Int).Sub(memo[i+2], memo[i+1])
			memo[i] = diff
		}
	}

	for i := int64(len(memo)); i <= n; i++ {
		sum := new(big.Int).Add(memo[i-1], memo[i-2])
		memo[i] = sum
	}

	return memo[n]
}

```

timed out with `fib(2000000)`

---

According to [[Fibonacci sequence]].

```go
package kata

import "math/big"

func fib(n int64) *big.Int {
	a := [2][2]*big.Int{{big.NewInt(1), big.NewInt(1)}, {big.NewInt(1), big.NewInt(0)}}

	if n == 0 {
		return big.NewInt(0)
	}
	if n < 0 {
		if (-n)%2 == 0 {
			return new(big.Int).Neg(fib(-n))
		}
		return fib(-n)
	}

	return matrixExponentiation(a, n-1)[0][0]
}

// Function to raise a matrix to the power of n
func matrixExponentiation(a [2][2]*big.Int, n int64) [2][2]*big.Int {
	if n == 0 {
		return [2][2]*big.Int{{big.NewInt(1), big.NewInt(0)}, {big.NewInt(0), big.NewInt(1)}}
	}

	if n%2 == 1 {
		m := matrixExponentiation(a, (n-1)/2)
		return multiplyMatrices(multiplyMatrices(m, m), a)
	} else {
		M := matrixExponentiation(a, n/2)
		return multiplyMatrices(M, M)
	}
}

func multiplyMatrices(a [2][2]*big.Int, b [2][2]*big.Int) [2][2]*big.Int {
	c := [2][2]*big.Int{}

	c[0][0] = new(big.Int).Mul(a[0][0], b[0][0])
	c[0][0].Add(c[0][0], new(big.Int).Mul(a[0][1], b[1][0]))

	c[0][1] = new(big.Int).Mul(a[0][0], b[0][1])
	c[0][1].Add(c[0][1], new(big.Int).Mul(a[0][1], b[1][1]))

	c[1][0] = new(big.Int).Mul(a[1][0], b[0][0])
	c[1][0].Add(c[1][0], new(big.Int).Mul(a[1][1], b[1][0]))

	c[1][1] = new(big.Int).Mul(a[1][0], b[0][1])
	c[1][1].Add(c[1][1], new(big.Int).Mul(a[1][1], b[1][1]))

	return c
}

```

## Better Solutions

### Solution 1

```go
package kata

import (
  "math/big"
)
var (
  a1,a2,ta,tb,tc = new(big.Int),new(big.Int),new(big.Int),new(big.Int),new(big.Int)
)
func fib(n int64) (*big.Int){
  switch n{
    case 0:return big.NewInt(0)
    case 1:return big.NewInt(1)
  }
  p:=big.NewInt(1)
  if n<0{
    n=-n
    if n % 2==0{p=big.NewInt(-1)}
  }
  a := big.NewInt(1)
  b := big.NewInt(1)
  c := big.NewInt(1)
  d := big.NewInt(0)
  rc := big.NewInt(0)
  rd := big.NewInt(1)
  for ; n>0; n >>= 1{
    if n%2==1 {
      tc.Set(rc)
      rc.Add(a1.Mul(tc,a),a2.Mul(rd,c))
      rd.Add(a1.Mul(tc,b),a2.Mul(rd,d))
    }
    ta.Set(a); tb.Set(b); tc.Set(c)
    a.Add(a1.Mul(ta,ta),a2.Mul(b,c))
    b.Add(a1.Mul(ta,tb),a2.Mul(tb,d))
    c.Add(a1.Mul(tc,ta),a2.Mul(d,tc))
    d.Add(a1.Mul(tc,tb),a2.Mul(d,d))
  }
  return p.Mul(p,rc)
}
```

### Solution 2

```go
package kata

import "math/big"

func fib(n int64) (*big.Int){
      if n == 0 || n == 1 {return big.NewInt(n)}
      if n >= 2 && n % 2 == 0 {
        k := n / 2
        fk := fib(k)
        two:=big.NewInt(2)
        two.Mul(two, fib(k - 1))
        two.Add(two,fk)
        return two.Mul(two, fk)
      }
      if (n >= 2) {
          k := (n + 1) / 2
          fk1 := fib(k - 1)
          fk2 := fib(k)
          fk2.Mul(fk2,fk2)
          fk1.Mul(fk1,fk1)
          return fk2.Add(fk2,fk1)
      }
      a , b := big.NewInt(0), big.NewInt(1)
      for i := int64(0); i > n; i-- {
          a, b = b.Sub(b,a), a
      }
      return a
}
```
