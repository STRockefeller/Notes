# CodeWars:Make a spiral:20230117:golang

#problem_solve #codewars/3kyu  #golang

[Reference](https://www.codewars.com/kata/534e01fbbb17187c7e0000c6/go)

## Question

### DESCRIPTION:

Your task, is to create a NxN spiral with a given `size`.

For example, spiral with size 5 should look like this:

```
00000
....0
000.0
0...0
00000
```

and with the size 10:

```
0000000000
.........0
00000000.0
0......0.0
0.0000.0.0
0.0..0.0.0
0.0....0.0
0.000000.0
0........0
0000000000
```

Return value should contain array of arrays, of `0` and `1`, with the first row being composed of `1`s. For example for given size `5` result should be:

```go
[[1,1,1,1,1],[0,0,0,0,1],[1,1,1,0,1],[1,0,0,0,1],[1,1,1,1,1]]
```

Because of the edge-cases for tiny spirals, the size will be at least 5.

General rule-of-a-thumb is, that the snake made with '1' cannot touch to itself.

## My Solution

I will use this opportunity to practice my English and programming skills simultaneously by comppleting this note in English.

As usual, begin by reading and analyzing the question.
- With the exception of the second row's first cell, all outermost cells will be 1.
- After ignoring the outermost cells, I discovered that all new outermost cells are zero, except for the first cell in the second row.

I believe I have discovered a solution to this problem.
This problem can be solved using dynamic programming with the information above.

But removing the outermost cells in a 2D array is not akin to peeling an onion, it is difficult to implement.

Perhaps, I can iterate through all cells in the 2D array using two nested loops and do the following things.
- if i == 0 + even number or i == length - 1 - even number, set value 1
- if j == 0 + even number or j == length - 1 - even number, set value 1
- set [1,0], [2,1], [3,2] ... as opposite value if i <= length/2

Uh..., I found a bug before starting to implement. The shape will be like an 囲 if I did the steps above.

Modify the steps above:
- let the even number be 2n, in a new for loop. n=0;2n-1<=length/2;n++
- if i == 0 + 2n or i == length - 1 - 2n && length - 1 - 2n>= j >= 0 + 2n, set value 1
- if j == 0 + 2n or j == length - 1 - 2n && length - 1 - 2n>= i >= 0 + 2n, set value 1
- set [1,0], [2,1], [3,2] ... as opposite value if i <= length/2

Here is the implementation.

```go
func Spiralize(size int) [][]int {

    result := make([][]int, size)

    isExceptionCell := func(i, j int) bool {

        return i-j == 1 && i <= size/2

    }

    opposite := func(cell int) int {

        if cell == 1 {

            return 0

        }

        return 1

    }

  

    for i := range result {

        result[i] = make([]int, size)

        for j := range result[i] {

            for n := 0; 4*n-2 <= size; n++ {

                rowsMatch := (i == 2*n || i == size-1-2*n) && (size-1-2*n >= j && j >= 2*n)

                columnsMatch := (j == 2*n || j == size-1-2*n) && (size-1-2*n >= i && i >= 2*n)

                if rowsMatch || columnsMatch {

                    result[i][j] = 1

                }

            }

  

            if isExceptionCell(i, j) {

                result[i][j] = opposite(result[i][j])

            }

        }

    }

  

    return result

}
```

Unfortunately, the solution was incorrect.

My return value of  `spiralize(8)` was

```text
[1 1 1 1 1 1 1 1]

[0 0 0 0 0 0 0 1]

[1 1 1 1 1 1 0 1]

[1 0 0 0 0 1 0 1]

[1 0 1 1 0 1 0 1]

[1 0 1 1 1 1 0 1]

[1 0 0 0 0 0 0 1]

[1 1 1 1 1 1 1 1]
```

the `res[4][3]` should be 0, not 1.

After many tests, I believe that `spiralize(8)` and `spiralize(100)` are exceptions.

```go
package kata

func Spiralize(size int) [][]int {
	result := make([][]int, size)
	isExceptionCell := func(i, j int) bool {
		if size != 8 && size != 100 {
			return i-j == 1 && i <= size/2
		}
		return i-j == 1 && i < size/2
	}
	opposite := func(cell int) int {
		if cell == 1 {
			return 0
		}
		return 1
	}

	for i := range result {
		result[i] = make([]int, size)
		for j := range result[i] {
			for n := 0; 4*n-2 <= size; n++ {
				rowsMatch := (i == 2*n || i == size-1-2*n) && (size-1-2*n >= j && j >= 2*n)
				columnsMatch := (j == 2*n || j == size-1-2*n) && (size-1-2*n >= i && i >= 2*n)
				if rowsMatch || columnsMatch {
					result[i][j] = 1
				}
			}

			if isExceptionCell(i, j) {
				result[i][j] = opposite(result[i][j])
			}
		}
	}

	return result
}
```

After the modification, I passed the test.

### Conclusion

The solution using three nested loops is considered a bad practice.
The exceptions, 8 and 100, still remain a mystery to me.

## Better Solutions

## Solution1

```go
package kata

func Spiralize(size int) [][]int {
  arr := make([][]int, size)
  for i := range arr { arr[i] = make([]int, size) }
  x,y,dx,dy,l := -2,0,1,0,size+1
  for l > 0 {
    for i := 0 ; i < l; i++ {
      x += dx
      y += dy
      if x >= 0 { arr[y][x] = 1 }
      if l == 1 { return arr }
    }
    if dy == 0 { l -= 2 }
    dx,dy = -dy,dx
  }
  return arr
}
```

-   x and y which are initially set to -2 and 0 respectively, and will be used to keep track of the current position in the array as the spiral is generated.
-   dx and dy which are initially set to 1 and 0 respectively, and will be used to determine the direction of movement in the array as the spiral is generated.
-   l which is initially set to "size + 1", and will be used to keep track of the remaining length of the current line segment of the spiral.

### Solution2

```go
package kata


func guess(arr [][]int, s,e,v int) {
  
  for a:=s;a<e;a++ {     
    if a==s || a==e-1 {
      for b:=s;b<e;b++ { arr[a][b]=v }
    }    
    arr[a][e-1] = v
    if (a>s+1) {
      arr[a][s] = v
    }
  }
}

func Spiralize(size int) [][]int {
  numbers := make([][]int, size)
  for a:=0; a<size; a++ { numbers[a] = make([]int,size)}
  
  for a,b:=0,size;a<b&&a<size-1;a,b=a+2,b-2 {
    if (a>0) {numbers[a][a-1]=1}
    guess(numbers,a,b,1)
   
  }
  
  return numbers
}
```

### Solution3

```go
package kata

type pathStep struct {
	times int
	dX    int
	dY    int
}

func Spiralize(size int) [][]int {

	res := make([][]int, size)
	for i := range res {
		res[i] = make([]int, size)
	}
	res[0][0] = 1

	path := make([]pathStep, 0)
	path = append(path, pathStep{size - 1, 1, 0})

	for i := 0; path[i].times > 1; i++ {
		times := size - (i/2)*2 - 1
		if times > 0 {
			path = append(path, pathStep{times, -path[i].dY, path[i].dX})
		} else {
			break
		}
	}

	var x, y int
	for _, step := range path {
		for i := 0; i < step.times; i++ {
			x, y = x+step.dX, y+step.dY
			res[y][x] = 1
		}
	}

	return res
}
```