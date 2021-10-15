# CodeWars:Snafooz solver:20211012:Go

[Reference](https://www.codewars.com/kata/6108f2fa3e38e900070b818c)



## Question

So I have a few Snafooz puzzles at home (which are basically jigsaw puzzles that are 3d)

http://www.ideagroup.net/products/puzzlesgames/c-1012.html

https://www.youtube.com/watch?v=ZTuL9O_gQpk

and it's a nice and fun puzzle. The only issue is, well, I'm not very good at it... Or should I say not better than my dad.

As you can see this is a big problem which only has one sensible solution... I need to cheat.

The puzzle is made of 6 pieces (each piece is 6x6 array which represents a jigsaw like puzzle piece), each one a side of a cube, and all you need to do is construct the cube by attaching the pieces together kinda like a 3d jigsaw puzzle.

You may rotate, flip and\or reorganize the pieces but not change their shape.

**Example:**

Let's say these are our pieces-

```
1:
xx x
xxxxxx
 xxxxx
xxxxxx
xxxxxx
  x xx

2:
  x
 xxxxx
xxxxx
xxxxxx
 xxxx
xxx

3:
xx x
 xxxxx
xxxxxx
 xxxxx
xxxxxx
 x  xx
 
4:

 xxxx
 xxxxx
 xxxx
 xxxx
 x x
 
5:
x xx
xxxxx
xxxxxx
 xxxx
 xxxxx
  xxx
6:
 x   x
xxxxxx
 xxxxx
 xxxx
xxxxxx
  x xx
```

Our solution would look something like this:

```
          ----------
          | xx  x  | 
          | xxxxxx | 
          |  xxxxx | 
          | xxxxxx | 
          | xxxxxx | 
          |   xx x |
-----------------------------
 |   x    | xx  x  |        |
 |  xxxxx |  xxxxx |  xxxx  |
 | xxxxx  | xxxxxx |  xxxxx |
 | xxxxxx |  xxxxx |  xxxx  |
 |  xxxx  | xxxxxx |  xxxx  |
 | xxx    |  x  xx |  x x   | 
-----------------------------
          | x xx   |
          | xxxxx  |
          | xxxxxx |
          |  xxxx  |
          |  xxxxx |
          |   xxx  |
          ----------
          |  x   x |
          | xxxxxx |
          |  xxxxx |
          |  xxxx  |
          | xxxxxx |
          |  x  xx |
          ----------
```

(this is just a flattened cube)

Here is a pic describing which edges are touching, and need to match (marked by letters), and the matching corners (marked with numbers):

```
        5aaaa6
        i....h
        i....h
        i....h
        i....h
        1bbbb2

5iiii1  1bbbb2  2hhhh6
g....f  f....e  e....l
g....f  f....e  e....l
g....f  f....e  e....l
g....f  f....e  e....l
7jjjj4  4cccc3  3kkkk8

        4cccc3
        j....k
        j....k
        j....k
        j....k
        7dddd8

        7dddd8
        g....l
        g....l
        g....l
        g....l
        5aaaa6
```

**Bad Example:**

Having two pieces next to each other that don't fit-

```
xxxxxx    xxxxx
xxxxxx   xxxxxx
xxxxxx    xxxxx
xxxxx     xxxxx
xxxxxx    xxxxx
xxxxxx   xxxxxx
```

or

```
xxxxxx
xxxxxx
xxxxxx
xxxxxx
xxxxxx
x   xx

 x x x
xxxxxx
xxxxxx
xxxxxx
xxxxxx
xxxxxx
```

The right way would be like this -

```
xxxxxx    xxxxx
xxxxx    xxxxxx
xxxxxx    xxxxx
xxxxx    xxxxxx
xxxxx    xxxxxx
xxxxxx    xxxxx
```

or

```
xxxxxx
xxxxxx
xxxxxx
xxxxxx
xxxxxx
x x xx

 x x
xxxxxx
xxxxxx
xxxxxx
xxxxxx
xxxxxx
```

Now all you need to do is use the input which will be a 3d array (6x6x6) where arr[0] is the first piece (which will be a 6 by 6 matrix) arr[1] is the second and so on… And you will return the answer in a new 6x6x6 matrix in which the pieces are all in the right orientation in this order->

```
  0
1 2 3
  4
  5
```

***NOTES***

1. Each piece is represented by a 6x6 array of numbers: `1`s indicate the piece, `0`s indicate empty space.
2. All cases will be solvable
3. Don't be too concerned about optimizations (after all my dad isn't THAT fast)

Good Luck!



## My Solution

沒玩過Snafooz 這東西光靠敘述還是搞不懂題目要的是什麼，最簡單就是排序，但我不認為4 kyu會這麼簡單

![](https://i.imgur.com/uZ3JVYu.png)



事實證明還需要旋轉、翻轉。*不確定會不會有非完全密合(留有空隙)的情況，不過先不考慮吧，不然有點太難了*。

~~題目自己說不要管速度的喔，到時候就不要給我跳timeout~~



題目裡面比較有參考價值的提示有二

組合規則

```
        5aaaa6
        i....h
        i....h
        i....h
        i....h
        1bbbb2

5iiii1  1bbbb2  2hhhh6
g....f  f....e  e....l
g....f  f....e  e....l
g....f  f....e  e....l
g....f  f....e  e....l
7jjjj4  4cccc3  3kkkk8

        4cccc3
        j....k
        j....k
        j....k
        j....k
        7dddd8

        7dddd8
        g....l
        g....l
        g....l
        g....l
        5aaaa6
```

次序

```go
  0
1 2 3
  4
  5
```



題目似乎也沒有指定回傳的順序，姑且先把輸入的第一個array不做翻轉/旋轉直接作為回傳的第一個array，以這樣的基準開始

一個角落會有三個面共用，不太容易做判斷，先從邊下手比較合適

一條邊緣會由兩個面共用，去除角落，有四個位置必須對得起來，例如0101->1010，考慮到翻轉的情形0101->0101也可以

考慮到

```
1aaaa2 2bbbb3
c....d d....e
c....d d....e
c....d d....e
c....d d....e
4ffff5 5gggg6
```

在側邊的部分難以比較，以及旋轉/翻轉的麻煩，把輸入矩陣的邊跟角提出來處理似乎是個好主意。*中間的部分我先當作它永遠都是實心填滿的*。



大概長這樣

```go
type side [6]int

func (s side)reverse()side{return [6]int{}}

func matchSides(side1, side2 side) sideMatchStatus { return sideMatchStatus{} }

type sideMatchStatus struct {
	match        bool
	matchReverse bool
}

//  side1
// s     s
// i     i
// d     d
// e     e
// 4     2
//  side3
type piece struct {
	side1 side
	side2 side
	side3 side
	side4 side
}

func (p *piece) rotate()           {}
func (p *piece) swap()             {}
func (p piece) toArray() [6][6]int { return [6][6]int{} }
func newPiece([6][6]int) piece     { return piece{} }
```

邊緣比對的部分本來是打算回傳列舉，但考慮到可能有對稱導致正反都對的上的情況，改成struct



實作

```go
type side [6]int

func (s side) reverse() side {
	var res side
	for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
		res[i], res[j] = s[j], s[i]
	}
	return res
}

func matchSides(side1, side2 side) sideMatchStatus {
	var res sideMatchStatus
	res.match = subMatch(side1, side2)
	res.matchReverse = subMatch(side1.reverse(), side2)
	return res
}

func subMatch(side1, side2 side) bool {
	if (side1[0] == 1 && side2[0] == 1) || (side1[5] == 1 && side2[5] == 1) {
		return false
	}
	for i := 1; i < 5; i++ {
		if side1[i]^side2[i] == 0 {
			return false
		}
	}
	return true
}

type sideMatchStatus struct {
	match        bool
	matchReverse bool
}

//  side1
// s     s
// i     i
// d     d
// e     e
// 4     2
//  side3
type piece struct {
	side1 side
	side2 side
	side3 side
	side4 side
}

// CW
func (p *piece) rotate() {
	newSide1 := p.side4.reverse()
	newSide2 := p.side1
	newSide3 := p.side2.reverse()
	newSide4 := p.side3
	p.side1 = newSide1
	p.side2 = newSide2
	p.side3 = newSide3
	p.side4 = newSide4
}

// left-right
func (p *piece) swap() {
	newSide1 := p.side1.reverse()
	newSide2 := p.side4
	newSide3 := p.side3.reverse()
	newSide4 := p.side2
	p.side1 = newSide1
	p.side2 = newSide2
	p.side3 = newSide3
	p.side4 = newSide4
}

func (p piece) toArray() [6][6]int {
	res := [6][6]int{}
	for i := 0; i < 6; i++ {
		for j := 0; j < 6; j++ {
			res[i][j] = 1
		}
	}
	res[0] = p.side1
	res[5] = p.side3
	for i := 1; i < 5; i++ {
		for j := 0; j < 6; j++ {
			if j == 0 {
				res[i][j] = p.side4[i]
			} else if j == 5 {
				res[i][j] = p.side2[i]
			} else {
				res[i][j] = 1
			}
		}
	}
	return res
}

func newPiece(p [6][6]int) piece {
	rightSide, leftSide := [6]int{}, [6]int{}
	for i := 0; i < 6; i++ {
		for j := 0; j < 6; j++ {
			switch j {
			case 0:
				leftSide[i] = p[i][j]
			case 5:
				rightSide[i] = p[i][j]
			default:
				continue
			}
		}
	}
	return piece{
		side1: p[0],
		side2: rightSide,
		side3: p[5],
		side4: leftSide,
	}
}

```

沒意外的話就不管這塊了

---

前置準備完成後開始想要怎麼解了。

每個角落會有三個邊，對應到三個面的話會找到兩兩一組共三對邊，然後角落的點只能使用一次

以第0個面做基準，拿右下角的點來看，三對邊分別是 (第n面-第m邊) 0-2&3-1 0-3&2-1 2-2&3-4

再加上反轉與否的考慮就是 0-2&3-1r 0-3&2-1 2-2&3-4

## Better Solutions

