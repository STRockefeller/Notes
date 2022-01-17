# CodeWars:Sudoku Solution Validator:20211123:Go

[Reference](https://www.codewars.com/kata/529bf0e9bdf7657179000008/go)



## Question

### Sudoku Background

Sudoku is a game played on a 9x9 grid. The goal of the game is to fill all cells of the grid with digits from 1 to 9, so that each column, each row, and each of the nine 3x3 sub-grids (also known as blocks) contain all of the digits from 1 to 9.
(More info at: http://en.wikipedia.org/wiki/Sudoku)

### Sudoku Solution Validator

Write a function `validSolution`/`ValidateSolution`/`valid_solution()` that accepts a 2D array representing a Sudoku board, and returns true if it is a valid solution, or false otherwise. The cells of the sudoku board may also contain 0's, which will represent empty cells. Boards containing one or more zeroes are considered to be invalid solutions.

The board is always 9 cells by 9 cells, and every cell only contains integers from 0 to 9.

### Examples

```
validSolution([
  [5, 3, 4, 6, 7, 8, 9, 1, 2],
  [6, 7, 2, 1, 9, 5, 3, 4, 8],
  [1, 9, 8, 3, 4, 2, 5, 6, 7],
  [8, 5, 9, 7, 6, 1, 4, 2, 3],
  [4, 2, 6, 8, 5, 3, 7, 9, 1],
  [7, 1, 3, 9, 2, 4, 8, 5, 6],
  [9, 6, 1, 5, 3, 7, 2, 8, 4],
  [2, 8, 7, 4, 1, 9, 6, 3, 5],
  [3, 4, 5, 2, 8, 6, 1, 7, 9]
]); // => true
validSolution([
  [5, 3, 4, 6, 7, 8, 9, 1, 2], 
  [6, 7, 2, 1, 9, 0, 3, 4, 8],
  [1, 0, 0, 3, 4, 2, 5, 6, 0],
  [8, 5, 9, 7, 6, 1, 0, 2, 0],
  [4, 2, 6, 8, 5, 3, 7, 9, 1],
  [7, 1, 3, 9, 2, 4, 8, 5, 6],
  [9, 0, 1, 5, 3, 7, 2, 1, 4],
  [2, 8, 7, 4, 1, 9, 6, 3, 5],
  [3, 0, 0, 4, 8, 1, 1, 7, 9]
]); // => false
```

## My Solution

4kyu

老樣子這種二維矩陣我都喜歡把它變成Dictionary value-->tuple 的形式來解決。不過這次是使用golang，就另外做一個struct代替tuple吧。

```go
package kata

func ValidateSolution(m [][]int) bool {
	positionMap := arrayToMap(m)
	for _, positions := range positionMap {
		if len(positions) != 9 {
			return false
		}
		var checkRows, checkColumns, checkBlocks [9]bool
		for _, position := range positions {
			bn := getBlockNumber(position)
			if checkRows[position.x] || checkColumns[position.y] || checkBlocks[bn] {
				return false
			}
			checkRows[position.x] = true
			checkColumns[position.y] = true
			checkBlocks[bn] = true
		}
	}
	return true
}

func getBlockNumber(p position) int {
	switch {
	case p.x <= 2 && p.y <= 2:
		return 0
	case p.x > 2 && p.x <= 5 && p.y <= 2:
		return 1
	case p.x > 5 && p.y <= 2:
		return 2
	case p.x <= 2 && p.y > 2 && p.y <= 5:
		return 3
	case p.x > 2 && p.x <= 5 && p.y > 2 && p.y <= 5:
		return 4
	case p.x > 5 && p.y > 2 && p.y <= 5:
		return 5
	case p.x <= 2 && p.y > 5:
		return 6
	case p.x > 2 && p.x <= 5 && p.y > 5:
		return 7
	case p.x > 5 && p.y > 5:
		return 8
	}
	return -1
}

func arrayToMap(arr [][]int) map[int][]position {
	res := make(map[int][]position)
	for i, row := range arr {
		for j, number := range row {
			res[number] = append(res[number], position{i, j})
		}
	}
	return res
}

type position struct {
	x, y int
}

```

隨便寫寫想說來 try and error 然後一次就過了= =..

## Better Solutions



### Solution 1

```go
package kata

func ValidateSolution(m [][]int) bool {
  colUsed := [9][9]bool{}
  boxUsed := [3][3][9]bool{}
  for row := 0; row < 9; row++ {
    rowUsed := [9]bool{}
    for col := 0; col < 9; col++ {
      b := m[row][col]
      if b == 0 {
        return false
      }
      num := b - 1
      if rowUsed[num] || colUsed[col][num] || boxUsed[row/3][col/3][num] {
        return false
      }
      rowUsed[num] = true
      colUsed[col][num] = true
      boxUsed[row/3][col/3][num] = true
    }
  }
  return true
}
```



`boxUsed[row/3][col/3][num] = true` 這個寫法值得參考



### Solution 2

```go
package kata

func ValidateSolution(m [][]int) bool {
    for r := 0; r < 9; r++ {
        row, col, box := 0, 0, 0
        for c := 0; c < 9; c++ {
            i := (r % 3) * 3 + c % 3
            j := (r / 3) * 3 + c / 3
            row ^= 1 << uint(m[r][c])
            col ^= 1 << uint(m[c][r])
            box ^= 1 << uint(m[j][i])
        }
        if row != 1022 || col != 1022 || box != 1022 {
            return false
        }
    }
    return true
}
```

お見事です



寫得很精簡但又不是這麼容易看懂

首先是`i` `j`

```go
i := (r%3)*3 + c%3
j := (r/3)*3 + c/3
```

從題目和上下文可以判斷，`i` `j`是拿來區分9個方形區塊的，問題在於它是**怎麼做到的**

`r` `c` 表示目前這點的座標，試著用不同區塊的座標套進去看`i` `j`分別會是什麼樣子

(0,0) => i=0 j=0

(1,1) => i=4 j=0

--

(3,5) => i=2 j=4

(4,4) => i=4 j=4

--

(3,0) => i=0 j=3

(3,2) => i=2 j=3

---

稍微試了一下，`j`應該代表所在的區塊，`i`則是座標在那個區塊的哪個位置

圖解大概像是:

```
123 | 123 | 123      |     |    
456 | 456 | 456   1  |  2  |  3 
789 | 789 | 789      |     |    
--------------- ----------------
123 | 123 | 123      |     |    
456 | 456 | 456   4  |  5  |  6 
789 | 789 | 789      |     |    
--------------- ----------------
123 | 123 | 123      |     |    
456 | 456 | 456   7  |  8  |  9 
789 | 789 | 789      |     |    
```

`i`----------------------------`j`---------------------------

`j`的部分就是 (r/3) 以及 (c/3) 可以找到唯一區塊，但是只想用一個數值表示，若直接相加會有重複情形(ex. 1+3 == 2+2) ，所以把其中一者\*3避免衝突

`i`則代表在區塊中的位置位置，公式我看不懂，但可以來歸納看看

拿第2區塊的第5個位置來看，座標是(4,1)，套公式  i = (4%3)*3 + 1%3 = 3+1 = 4

接著看第5區塊的第5個位置，座標是(4,4)，套公式  i = (4%3)*3 + 4%3 = 3+1 = 4

接著看第9區塊的第5個位置，座標是(7,7)，套公式  i = (7%3)*3 + 7%3 = 3+1 = 4

---

接著來看重點的部分

奇怪的算式

```go
row ^= 1 << uint(m[r][c])
col ^= 1 << uint(m[c][r])
box ^= 1 << uint(m[j][i])
```

奇怪的條件式

```go
if row != 1022 || col != 1022 || box != 1022 {
    return false
}
```

把測試第一列的log拿出來看看

```
r = 0 , c = 0
i = 0 , j = 0
m[r][c] = 5 ,  m[c][r] = 5 , m[j][i] = 5
row = 32 ,  col = 32 , box = 32
r = 0 , c = 1
i = 1 , j = 0
m[r][c] = 3 ,  m[c][r] = 6 , m[j][i] = 3
row = 40 ,  col = 96 , box = 40
r = 0 , c = 2
i = 2 , j = 0
m[r][c] = 4 ,  m[c][r] = 1 , m[j][i] = 4
row = 56 ,  col = 98 , box = 56
r = 0 , c = 3
i = 0 , j = 1
m[r][c] = 6 ,  m[c][r] = 8 , m[j][i] = 6
row = 120 ,  col = 354 , box = 120
r = 0 , c = 4
i = 1 , j = 1
m[r][c] = 7 ,  m[c][r] = 4 , m[j][i] = 7
row = 248 ,  col = 370 , box = 248
r = 0 , c = 5
i = 2 , j = 1
m[r][c] = 8 ,  m[c][r] = 7 , m[j][i] = 2
row = 504 ,  col = 498 , box = 252
r = 0 , c = 6
i = 0 , j = 2
m[r][c] = 9 ,  m[c][r] = 9 , m[j][i] = 1
row = 1016 ,  col = 1010 , box = 254
r = 0 , c = 7
i = 1 , j = 2
m[r][c] = 1 ,  m[c][r] = 2 , m[j][i] = 9
row = 1018 ,  col = 1014 , box = 766
r = 0 , c = 8
i = 2 , j = 2
m[r][c] = 2 ,  m[c][r] = 3 , m[j][i] = 8
row = 1022 ,  col = 1022 , box = 1022
```

1<<5 ==> 100000 ==> 32

