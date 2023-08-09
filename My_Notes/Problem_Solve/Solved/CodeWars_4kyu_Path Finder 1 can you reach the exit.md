# CodeWars:Path Finder #1: can you reach the exit?:20210910:C\#

tags: #problem_solve #codewars/4kyu #c_sharp #shortest_path_faster_algorithm

[Reference](https://www.codewars.com/kata/5765870e190b1472ec0022a2/csharp)

## Question

relative problems:

- [[CodeWars_4kyu_Path Finder 2 shortest path]]
- [[CodeWars_Path Finder 3 the Alpinist]]

## Task

You are at position [0, 0] in maze NxN and you can **only** move in one of the four cardinal directions (i.e. North, East, South, West). Return `true` if you can reach position [N-1, N-1] or `false` otherwise.

- Empty positions are marked `.`.
- Walls are marked `W`.
- Start and exit positions are empty in all test cases.

## Path Finder Series

- [#1: can you reach the exit?](https://www.codewars.com/kata/5765870e190b1472ec0022a2)
- [#2: shortest path](https://www.codewars.com/kata/57658bfa28ed87ecfa00058a)
- [#3: the Alpinist](https://www.codewars.com/kata/576986639772456f6f00030c)
- [#4: where are you?](https://www.codewars.com/kata/5a0573c446d8435b8e00009f)
- [#5: there's someone here](https://www.codewars.com/kata/5a05969cba2a14e541000129)

## My Solution

我似乎發現了一個很有趣的系列

走迷宮，題目要求從[0,0]走到[N-1,N-1]，也就是從左上走到右下

思路:

用笨但是管用的辦法:把全部可以走的路都找出來

例如

1. [0 0]，標記已走過，如果遇到已經走過、不能走(超過地圖)或者牆壁，就返回false
2. [0 0] 往上[-1 0]不能走，往右[0 1]做為下一個標記點，往下[1 0]做為下一個標記點，往左[0 -1]不能走
3. 由[1 0]以及[0 1]再次執行相同過程
4. 直到全部不能走再判斷[N-1 N-1]是否走過----->還是改成走到目標點就直接回傳true好了，這樣可以早點結束

解答

```C#
       public static bool PathFinder(string maze)
        {
            string[] mazeSplit = maze.Split("\n");
            char[][] mazeArr = new char[mazeSplit.Length][];
            for (int i = 0; i < mazeSplit.Length; i++)
                mazeArr[i] = mazeSplit[i].ToCharArray();
            return SubFinder(ref mazeArr, new int[] { 0, 0 });
        }
        private static bool SubFinder(ref char[][] mazeArr,int[] index)
        {
            if (index.Any(i => i < 0)) { return false; }
            int size = mazeArr.Length-1;
            if (index.Any(i => i > size)) { return false; }
            if (index[0] == mazeArr.Length - 1 && index[1] == mazeArr[0].Length - 1)
                return true;
            if (mazeArr[index[0]][index[1]] == '.')
                mazeArr[index[0]][index[1]] = 'A';
            else
                return false;
            return SubFinder(ref mazeArr, new int[] { index[0] + 1, index[1] }) ||
                SubFinder(ref mazeArr, new int[] { index[0] - 1, index[1] }) ||
                SubFinder(ref mazeArr, new int[] { index[0], index[1] + 1 }) ||
                SubFinder(ref mazeArr, new int[] { index[0], index[1] - 1 });
        }
```

通關

## Better Solutions

## Solution 1

```C#
using System.Linq;
public class Finder
{
    private static bool PathFinder(int[][] maze, int x = 0, int y = 0) =>
        (x >= 0 && x < maze[0].Length) &&
        (y >= 0 && y < maze.Length) &&
        (maze[y][x] == 0) && (
            (x + 1 == maze[0].Length && y + 1 == maze.Length) ||
            (maze[y][x] = -1) == -1 && (
                PathFinder(maze, x + 1, y) ||
                PathFinder(maze, x - 1, y) ||
                PathFinder(maze, x, y + 1) ||
                PathFinder(maze, x, y - 1)));

    public static bool PathFinder(string maze) => 
        PathFinder(maze.Split('\n').Select(
            line => line .Select(c => '.' - c).ToArray()
        ).ToArray());
}
```

思路基本上和我的解法一樣，但是更為簡潔，只用兩個lambda expression 就解決了，佩服

## Solution 2

```C#
public class Finder {
    const int WALL = 2;
        const int VISITED = 1;
        public static bool PathFinder(string maze)
        {
            maze = maze.Replace(" ", string.Empty);
            int[,] matrix = CreateMatrix(maze);
            next(matrix, 0, 0);
            return matrix[matrix.GetLength(0) - 1, matrix.GetLength(1) - 1] == VISITED;
        }

        public static void next(int[,] matrix, int y, int x)
        {
            matrix[y, x] = VISITED;
            if (y > 0 && matrix[y - 1, x] != VISITED && matrix[y - 1, x] != WALL) // north
                next(matrix, y - 1, x);
            if (x > 0 && matrix[y, x - 1] != VISITED && matrix[y, x - 1] != WALL) // west
                next(matrix, y, x - 1);
            if (y < matrix.GetLength(0) - 1 && matrix[y + 1, x] != VISITED && matrix[y + 1, x] != WALL)
                next(matrix, y + 1, x);
            if (x < matrix.GetLength(1) - 1 && matrix[y, x + 1] != VISITED && matrix[y, x + 1] != WALL)
                next(matrix, y, x + 1);
        }

        public static int[,] CreateMatrix(string maze)
        {
            string[] str = maze.Split(new char[] { '\n' });
            int[,] matrix = new int[str.Length, str[0].Length];
            for(int row = 0; row < str[0].Length; row++)
            {
                for(int col = 0; col < str.Length; col++)
                {
                    if (str[col][row] == '.') matrix[col, row] = 0;
                    else matrix[col, row] = WALL;
                }
            }
            return matrix;
        }
    }
```

寫了不少字，但同時把思路表達得很清楚，是說其實每個人切入的角度都差不多...
