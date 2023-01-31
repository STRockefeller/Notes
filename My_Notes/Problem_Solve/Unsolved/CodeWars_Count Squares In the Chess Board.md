# CodeWars:Count Squares In the Chess Board:20220503:C #

[Reference](https://www.codewars.com/kata/5bc6f9110ca59325c1000254/csharp)

## Question

### Task

You are given a `chessBoard`, a 2d integer array that contains only `0` or `1`. `0` represents a chess piece and `1` represents a empty grid. It's always square shape.

Your task is to count the number of squares made of empty grids.

The smallest size of the square is `2 x 2`. The biggest size of the square is `n x n`, where `n` is the size of chess board.

A square can overlap the part of other squares. For example:

If

```
chessBoard=[
  [1,1,1],
  [1,1,1],
  [1,1,1]
]
```

...there are four 2 x 2 squares in the chess board:

```
[1,1, ]  [ ,1,1]  [ , , ]  [ , , ]
[1,1, ]  [ ,1,1]  [1,1, ]  [ ,1,1]
[ , , ]  [ , , ]  [1,1, ]  [ ,1,1]
```

And one 3 x 3 square:

```
[1,1,1]
[1,1,1]
[1,1,1]
```

Your output should be an object/dict. Each item in it should be: `size:number`, where size is the square's size, and number is the number of squares.

For example, if there are four `2 x 2` squares and one `3 x 3` square in the chess board, the output should be: `{2:4,3:1}` (or any equivalent hash structure in your language). The order of items is not important, `{3:1,2:4}` is also a valid output.

If there is no square in the chess board, just return `{}`.

### Note

- `2 <= chessBoard.Length <= 220`

- `5` fixed testcases
- `100` random testcases, testing for correctness of solution
- `100` random testcases, testing for performance of code
- All inputs are valid.
- Pay attention to code performance.
- If my reference solution gives the wrong result in the random tests, please let me know(post an issue).

### Example

For

```
chessBoard = [
  [1,1],
  [1,1]
]
```

the output should be `{2:1}`.

For

```
chessBoard = [
  [0,1],
  [1,1]
]
```

the output should be `{}`.

For

```
chessBoard = [
  [1,1,1],
  [1,1,1],
  [1,1,1]
]
```

the output should be `{2:4,3:1}`.

For

```
chessBoard = [
  [1,1,1],
  [1,0,1],
  [1,1,1]
]
```

the output should be `{}`.

## My Solution

4kyu 題目有提供我會的語言只有C#，正好久違地複習一下。

題目說是chessboard但其實和chess沒有半毛錢關係。看來是單純的數正方形題目。

### version1 (timeout)

把最左上角當作參考點(O)，其他正方形包含的點以(X)表示，剩餘棋盤上的點以0和1表示

假如有題目
$$
\begin{bmatrix}
1&1&1\\
1&1&1\\
1&1&1
\end{bmatrix}
$$
從左上找起，先看index(0,0)

2*2(有)
$$
\begin{bmatrix}
O&X&1\\
X&X&1\\
1&1&1
\end{bmatrix}
$$

3*3(有)
$$
\begin{bmatrix}
O&X&X\\
X&X&X\\
X&X&X
\end{bmatrix}
$$

4*4(無)，因為總寬<0+4

然後看index(0,1)

2*2(有)
$$
\begin{bmatrix}
1&O&X\\
1&X&X\\
1&1&1
\end{bmatrix}
$$

3*3(無)，因為總寬<1+3

...etc

---

大概整理出一些規律如下

1. 以同一個基準點來說，它的大方形定包含小方形，所以小的找不到，就不用找更大的了。
2. 找不到的情形大致分為:
   1. 超出棋盤大小
   2. 範圍內包含0

3. 以這個解法來說，光輪完一遍基準點就要接近n^2的複雜度了

```C#
using System;
using System.Collections.Generic;
public class ChessBoard
{
    private static int[][] board;
    private static int len = 0;
    public static Dictionary<int, int> Count(int[][] b)
    {
        board = b;
        len = b.Length;
        Dictionary<int, int> res = new Dictionary<int, int>();
        (int x, int y) fromIndex;
        for (int i = 0; i < len; i++)
        {
            for (int j = 0; j < len; j++)
            {
                fromIndex = (i, j);
                if (!IsEmpty(board[i][j]))
                    continue;
                int rank = 2;
                while (HasSquare(rank, fromIndex))
                {
                    if (!res.ContainsKey(rank))
                        res[rank] = 0;
                    res[rank] = res[rank] + 1;
                    rank++;
                }
            }
        }

        return res;
    }
    private static bool IsEmpty(int n) => n == 1;
    private static bool HasSquare(int rank, (int x, int y) fromIndex)
    {
        #region out of range
        if (Math.Max(fromIndex.x, fromIndex.y) + rank > len)
            return false;

        #endregion out of range

        #region not empty
        for (int i = fromIndex.x; i < fromIndex.x + rank; i++)
        {
            int j = fromIndex.y + rank - 1;
            if (!IsEmpty(board[i][j]))
                return false;
        }

        for (int j = fromIndex.y; j < fromIndex.y + rank; j++)
        {
            int i = fromIndex.x + rank - 1;
            if (!IsEmpty(board[i][j]))
                return false;
        }
        #endregion not empty

        return true;
    }
}
```

結果 : timeout

---

### version 2(abandon)

看來要想個快一點的演算法了

如果倒過來做呢，上一次由小找到大，這次由最大的開始找

譬如
$$
\begin{bmatrix}
1&1&1&1&1\\
1&1&1&1&1\\
1&1&0&1&1\\
1&1&1&1&1\\
1&1&1&1&1
\end{bmatrix}
$$
一樣基準點從左上開始，先找最大的，邊長為基準點往右或下較短距離者，第一點就是邊長5
$$
\begin{bmatrix}
O&X&X&X&X\\
X&X&X&X&X\\
X&X&0&X&X\\
X&X&X&X&X\\
X&X&X&X&X
\end{bmatrix}
$$
碰到0了往內縮到碰到0之前的地方...這個方法感覺不會比較快
$$
\begin{bmatrix}
O&X&1&1&1\\
X&X&1&1&1\\
1&1&0&1&1\\
1&1&1&1&1\\
1&1&1&1&1
\end{bmatrix}
$$

總之先來歸納公式

假設全部的位置都為空

一個2*2的棋盤來=>{2:1}

一個3*3的棋盤
$$
\begin{bmatrix}
1&1&1\\
1&1&1\\
1&1&1
\end{bmatrix}
$$

$$
\begin{bmatrix}
X&X&1\\
X&X&1\\
1&1&1
\end{bmatrix}
$$

有{2:4}以及{3:1}

一個4*4的棋盤
$$
\begin{bmatrix}
1&1&1&1\\
1&1&1&1\\
1&1&1&1\\
1&1&1&1
\end{bmatrix}
$$

$$
\begin{bmatrix}
X&X&X&1\\
X&X&X&1\\
X&X&X&1\\
1&1&1&1
\end{bmatrix}
$$

有{3:4}
$$
\begin{bmatrix}
X&X&1&1\\
X&X&1&1\\
1&1&1&1\\
1&1&1&1
\end{bmatrix}
$$
{2:9}以及{4:1}

堆論得到:對於一個n*n的棋盤，會有以下squares
$$
n: 1\\
n-1: 2^2\\
n-2: 3^2\\
...\\
n-k:(1+k)^2
$$

寫了個雛形如下

```C#
using System;
using System.Collections.Generic;

public class ChessBoard
{
    private static int[][] board;
    private static int len = 0;

    public static Dictionary<int, int> Count(int[][] b)
    {
        board = b;
        len = b.Length;
        Dictionary<int, int> res = new Dictionary<int, int>();
        (int x, int y) fromIndex;
        for (int i = 0; i < len; i++)
        {
            for (int j = 0; j < len; j++)
            {
                fromIndex = (i, j);
                if (!IsEmpty(board[i][j]) || HasCounted(board[i][j]))
                    continue;
                AppendResult(FindBiggestSquare(fromIndex), res);
            }
        }

        return res;
    }

    /// <summary>
    /// find the biggest square according to the specified index
    /// </summary>
    /// <returns>side length of the square</returns>
    private static int FindBiggestSquare((int x, int y) fromIndex)
    {
        int tempDimension = len - Math.Max(fromIndex.x, fromIndex.y);
        int res = tempDimension;
        for (int i = 0; i < tempDimension; i++)
            for (int j = 0; j < tempDimension; j++)
                if (board[fromIndex.x + i][fromIndex.y + j] == 0)
                {
                    int temp = Math.Min(i, j);
                    res = res < temp ? res : temp;
                }

        for (int i = fromIndex.x; i < res; i++)
            for (int j = fromIndex.y; j < res; j++)
                board[i][j] = 2;
        return res;
    }

    private static void AppendResult(int sideLength, Dictionary<int, int> res)
    {
        for (int i = 0; i < sideLength - 1; i++)
        {
            if (!res.ContainsKey(sideLength - i))
                res[sideLength - i] = 0;
            res[sideLength - i] += (1 + i) * (1 + i);
        }
    }

    private static bool IsEmpty(int n) => n == 1;
    private static bool HasCounted(int n) => n == 2;
}
```

重複計算的排除較為複雜，還沒搞定

試著將已經計算過的地方改為2，但發現會排除過多

例如
$$
\begin{bmatrix}
0&1&1&1&1\\
1&1&1&1&1\\
1&1&1&1&1\\
0&1&1&0&1\\
1&1&1&1&1\\
\end{bmatrix}
$$
第一步驟算完會變成
$$
\begin{bmatrix}
0&2&2&2&1\\
1&2&2&2&1\\
1&2&2&2&1\\
0&1&1&0&1\\
1&1&1&1&1\\
\end{bmatrix}
$$

然後因為我不會把2當作參考點，所以如以下地方就會找不到
$$
\begin{bmatrix}
0&2&2&X&X\\
1&2&2&X&X\\
1&2&2&2&1\\
0&1&1&0&1\\
1&1&1&1&1\\
\end{bmatrix}
$$

$$
\begin{bmatrix}
0&2&2&2&1\\
1&2&2&X&X\\
1&2&2&X&X\\
0&1&1&0&1\\
1&1&1&1&1\\
\end{bmatrix}
$$

$$
\begin{bmatrix}
0&2&X&X&X\\
1&2&X&X&X\\
1&2&X&X&X\\
0&1&1&0&1\\
1&1&1&1&1\\
\end{bmatrix}
$$

$$
\begin{bmatrix}
0&2&2&2&1\\
1&2&2&2&1\\
1&X&X&2&1\\
0&X&X&0&1\\
1&1&1&1&1\\
\end{bmatrix}
$$

---

換個想法，同樣的例子
$$
\begin{bmatrix}
0&1&1&1&1\\
1&1&1&1&1\\
1&1&1&1&1\\
0&1&1&0&1\\
1&1&1&1&1\\
\end{bmatrix}
$$
如果我第一次找完標記成如下
$$
\begin{bmatrix}
0&0&2&1&1\\
1&2&2&1&1\\
1&1&1&1&1\\
0&1&1&0&1\\
1&1&1&1&1\\
\end{bmatrix}
$$
參考點因為與他相關的squares都被找到了所以標記為0

往外一層標記為2 => 只能找邊長>2的squares，因為<=2的都找過了

再往外標記為1 => 能找邊長>1的squares

所以再接下來會變成
$$
\begin{bmatrix}
0&0&0&2&1\\
1&2&2&2&1\\
1&1&1&1&1\\
0&1&1&0&1\\
1&1&1&1&1\\
\end{bmatrix}
$$
放棄，這個寫法超麻煩，而且根本沒省到時間...

---

### version 3 (timeout)

拿上一版修改，不套公式了，跟第一版一樣只看參考點在右上角的情形

```C#
using System;
using System.Collections.Generic;

public class ChessBoard
{
    private static int[][] board;
    private static int len = 0;

    public static Dictionary<int, int> Count(int[][] b)
    {
        board = b;
        len = b.Length;
        Dictionary<int, int> res = new Dictionary<int, int>();
        (int x, int y) fromIndex;
        for (int i = 0; i < len; i++)
        {
            for (int j = 0; j < len; j++)
            {
                fromIndex = (i, j);
                if (!IsEmpty(board[i][j]))
                    continue;
                AppendResult(FindBiggestSquare(fromIndex), res);
            }
        }

        return res;
    }

    /// <summary>
    /// find the biggest square according to the specified index
    /// </summary>
    /// <returns>side length of the square</returns>
    private static int FindBiggestSquare((int x, int y) fromIndex)
    {
        int tempDimension = len - Math.Max(fromIndex.x, fromIndex.y);
        int res = tempDimension;
        for (int i = 0; i < tempDimension; i++)
            for (int j = 0; j < tempDimension; j++)
                if (board[fromIndex.x + i][fromIndex.y + j] == 0)
                {
                    int temp = Math.Max(i, j);
                    res = res < temp ? res : temp;
                }
        return res;
    }

    private static void AppendResult(int sideLength, Dictionary<int, int> res)
    {
        for (int i = 2; i <= sideLength; i++)
        {
            if (!res.ContainsKey(i))
                res[i] = 0;
            res[i]++;
        }
    }

    private static bool IsEmpty(int n) => n == 1;
}
```

解出來了，但依然timeout

紀錄一下vs的測試執行時間

這版

![](https://i.imgur.com/87YappM.png)

第一版

![](https://i.imgur.com/XJSQ0ax.png)

差不多爛..

## Better Solutions
