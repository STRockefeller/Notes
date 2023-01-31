# CodeWars:Path Finder #2: shortest path:20210911:C\#

#problem_solve #codewars/4kyu #c_sharp #shortest_path_faster_algorithm

[Reference](https://www.codewars.com/kata/57658bfa28ed87ecfa00058a)

relative problems:

- [[CodeWars_4kyu_Path Finder 1 can you reach the exit]]
- [[CodeWars_Path Finder 3 the Alpinist]]

## Question

### Task

You are at position `[0, 0]` in maze NxN and you can **only** move in one of the four cardinal directions (i.e. North, East, South, West). Return the minimal number of steps to exit position `[N-1, N-1]` *if* it is possible to reach the exit from the starting position. Otherwise, return `-1`.

Empty positions are marked `.`. Walls are marked `W`. Start and exit positions are guaranteed to be empty in all test cases.

### Path Finder Series

- [#1: can you reach the exit?](https://www.codewars.com/kata/5765870e190b1472ec0022a2)
- [#2: shortest path](https://www.codewars.com/kata/57658bfa28ed87ecfa00058a)
- [#3: the Alpinist](https://www.codewars.com/kata/576986639772456f6f00030c)
- [#4: where are you?](https://www.codewars.com/kata/5a0573c446d8435b8e00009f)
- [#5: there's someone here](https://www.codewars.com/kata/5a05969cba2a14e541000129)

## My Solution

基本上是第一題的延續，就是多了步數計算。直接拿之前的答案來改應該比較快。

我上一題的答案

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

首先假設這個方法找到的路徑是沒有特別繞路的(因為會排除重複走的路)

接著需要給他新增移動次數的累計

原本的死路判別也要留下

提早return 的動作要拿掉，因為可能後面有更短的路徑

### 第一版 拿上一個KATA的解答快速修改(失敗 錯誤)

初步完成如下

```C#
        public static int PathFinder(string maze)
        {
            string[] mazeSplit = maze.Split("\n");
            char[][] mazeArr = new char[mazeSplit.Length][];
            for (int i = 0; i < mazeSplit.Length; i++)
                mazeArr[i] = mazeSplit[i].ToCharArray();
            return SubFinder(ref mazeArr, new int[] { 0, 0 }).steps;
        }

        private static SubFinderResult SubFinder(ref char[][] mazeArr, int[] index)
        {
            if (index.Any(i => i < 0)) { return new SubFinderResult { steps = -1, goal = false }; }
            int size = mazeArr.Length - 1;
            if (index.Any(i => i > size)) { return new SubFinderResult { steps = -1, goal = false }; }
            if (index[0] == mazeArr.Length - 1 && index[1] == mazeArr[0].Length - 1)
                return new SubFinderResult { steps = 0, goal = true };
            if (mazeArr[index[0]][index[1]] == '.')
                mazeArr[index[0]][index[1]] = 'A';
            else
                return new SubFinderResult { steps = -1, goal = false };
            List<SubFinderResult> subFinderResults = new List<SubFinderResult>() {
                SubFinder(ref mazeArr, new int[] { index[0] + 1, index[1] }),
                SubFinder(ref mazeArr, new int[] { index[0] - 1, index[1] }),
                SubFinder(ref mazeArr, new int[] { index[0], index[1] + 1 }),
                SubFinder(ref mazeArr, new int[] { index[0], index[1] - 1 })};
            if(!subFinderResults.Any(sr => sr.goal))
                return new SubFinderResult { steps = -1, goal = false };
            return new SubFinderResult { steps = 1 + subFinderResults.Where(sr => sr.goal).Select(sr => sr.steps).Min(), goal = true };
        }

        private struct SubFinderResult
        {
            public int steps;
            public bool goal;
        }
```

結果是失敗的，把走過的路線標記為無法再走會導致其他路線繞遠路

case

```
.........WW.W.W..W...WW...W....W...WW...W.W..WW......W...W.WW.W..WW..W...WW...WWW.WW..W.W.WW...W....
W....W.......WW.W.......W......W.W.W...WWWW.W........W......WW.WW.W.......W..............W..W.W.....
.........W..W..W.W...WW..WW.....W.WW.W..W.W......W...W..W...W...W..W.W..WWW..WWW...WW..W..W..W..WWWW
...W.....WW............W..W...WW.W....W....WW.......W....W..WWW........W.WWW...W.W.....W..W.W.W.WW..
..W...........W.W.W..........W.W...W...W.WWW.W..........W........W..W......W.W.W..WW..W........W...W
.W......W....W..W.W......WW..W...W..W..W..W.W..WWW..W.WWW......W.....W.WW.W.W..WW.W...W.....W.W.WWW.
..W.W...W.W.W.WWW.W.....W...W...W..WW......WWW.....W..W.....W...........WW......WW...W....W..WW....W
..W...W..WW.......W.WWWW..W..WW.......WW....W......W..W...WWW....W...W..W.......W.WWWWWW.WW....W....
.W..W.....W..W.....W......WWWWW.........WWW.WW.....W...WW..W..............W...........W......W.W....
WW..W.........WWW..............W....W.........W..W..W.W.WW..........W...WW..W.....WW.....WW...WW....
WW...W.W..W.W................WWW...W..W.WWW...WW..WW.W......W..WW.W........W........WW...W...W...W..
..W.W.WW.WW.W......WWWWW.W...WW.....WWW..W.W....W......W..WW....................W.W.W........W..WW.W
W.......WW....W...W.W....W.WWWWW.W....W.W.W.W..W...WW..W...W.WW.....W.........W.W....W.....W......WW
.W.W.........W.....WW..W.....W.............WW...W...........WW........W.WW..WW....W.WWWWW.W.W..W...W
....W............W...WW.....W.W..WWW.......W........WW.WW..........WWW......W.W....W..............WW
W.W.W..W...W..W.W........W..W....WW...........W....W..W..WW...W.WWWWW.....W...W.W...W..W........WWWW
.WW.W..W...WWWWW...W..W........W....W.........W.....W.W.W.W..W.W....W.......W..W.W...........W.W....
WW.W.....W.WW.W....W..W..W.........W.WW.W..W.W....WWWW...WW..W.......WWW....WWWWWW......WW.W.WW....W
.W...W......W.......WWWWW...W..W...WWW..W...W.W..WW.W......WW..W.W...W..W..W.WW......W..WWW.WW....W.
......W...........W..WWW.W.........WW....WW.W.W....WW......W..............W...W...W.....W...........
...W.W.WW...W.WWW................WWW........WW.W...W.....WW...W...WWW..W.W............W.WW..W...W...
..W....W..W..W...W...W........W..WW.WW..W..W......W..WWW...W.W.W...W....W..W..W.........W.WW.W...WW.
......WW..W...W....WW...W.W..WW.....W.W.W.......WW...W....W.WWW.W....WWW.....W.....W....W.W.W..WWW..
.WW.WW....WW.W...WW...W.WW...W...W..WW...W...W.........W...W...W.W.......W..WW...W.W.W.W.....WW..W..
.W...W.W..W..W..W.WW.....W.WWW.W....W.........W..........W....WWWW.....................W..W...W..WW.
..W......W.....W.W...........WW...WW.W.....WW....W.W....W..W....W..W.W.....W.W...............W....WW
.W....W...W.....W.....W.W......W...W.W.......WW.W.....WW.W.....WW.W...W.............W....WW.........
.....W..............W..W.W..W....W..W...W.W.WW...W.......W...WW.....W..W...WWW........W....WWW.W....
W....W..WWWW.W......W...W.W.......W.........WW.W............WW..W.W..WW.W..W......W.......W.WW..W...
..W....W.......W....W.....W.........W.W.WW.WW....WW.WWW...W.....WW..W..W..W..W....W.W.WWW....W......
...W..W.W......W.WW.........W....WW...W..WW....WW.......W.W.......W...W...W.......WW..W....W........
W..W..W.W...W...WWW..WW......W..W...W..WW.W....W.WW...WW....W...WW.....WW....W.WWW.W......W.........
.W.WW...W..W..WW.W.WW..W...WWW.....W...W........WWW...W..............W....WW...W......W...W...W.....
WW..........WW....W..W...WW....WW...W.WW.......W.WWW...WWW.W.....W.W...W..WW.....W..W.WW........WW..
W.....WW......W.....WWWW..W......W..W.....W......W.W.....W..W.....W..WWW.........W.WW.W.W.W.....W.W.
WWW...W.W..WW.W.......W........WWW.......WW.W....W...WW...W..W..W.W.W..W..........W....W.......W....
.....W.W.WW.....W..W.W....WW..W..W..WW....WWWWW.....W...W..W.......................W..WWW.WW...WWWW.
WW..W...WW.WWW....WWW..W....W.WW.WW...W..W.......W...WW.W..WW..W.....W............WW...W.WW....W.WWW
.......W.WWWW............W..W....W.WW.W.WW.......W.WW.WW...W..W....WW.....WW....W..WW..W.....W...W..
.W..W.WWW...W.W.....WW.WW.W.....WW.W.........W..................W.W...W.WWW..WW.WW.W...W.WW.....W...
W.W..W.W...WW..W........W.....W..........W...W......WW..WW..W.....WW...W...W.WW.........WWW.W...WW..
W..WW........WW...W.W..WW..W.....WW.WW.W.W......W....WW..WW.W.......W.......W.....W.....W.W.W......W
.....W...W...W.W...W..W.....W.W.....WW....W..W.W....W...W....WW...WW.W.....W..W....WW...W.....W.....
...W..W....................W........W........WW.WW.W....W...WW...W......W...W....W..................
.W.WW.....WWW...W..W..W.W....W..W...W......W.W..W.W..W..W.WW.....W.W.WW.W.WW.W.W....W..W......W.W.W.
.W.W...WW....W..W.....WWW.WW....W....W.WW...W.WW...WW..W........W...W...W..W.W..W.W.....W..W...W.WW.
....W..W...........W..WW.WW...W.............W....W..W..WW..W.WW.W.W.W....W...W..W....WWW.W.W.WWW....
W......WWW........W.W.WWW..WW.....W........W..........W......W..........WW......W.W.W....W....WWW.WW
.....W.WW...W......W....W.......WWW.W.W..W....WW...........WW.W..W.W..W..........W.WW.........W.....
W..W......W..W...WWW.WW..WW..W......W.W....W..WWW....W......WW...W....WW.........W....WW............
........W...W....W.WWW.......W.....W.W..WWW..W......WW.....WW.W..W.W.W.W.W.W.WW.........W......WW..W
....W...W..WW...W..W....W.....W..W...WW.......W.W..W..........W...W.WW.WWWW...W......W.W.......WW...
.WW.W.W.WW...W.W...W.W.W.W...W.W..W.W......W..W...W..W.....WW...W....W.W.......W....W.W..W..W.W.....
W.....WWW....WW...W...W...W..W........W...........W..W.......W...........W.....WWW..W...W....W......
.......W...WW.WW.W.....WW..WWW....WWW.W.W..WW.W.WW..W.W........W...........W......W...W...W...WWW...
...W.....W.W.W....W.....WWWW..................W....W.W...W...W.WW.W..W..WW.W..........W..W.WWW.....W
W.W..WW....W.W.WW..W...WWWWWWW...W.....W..WWW.W....WW.W.WWW.....W...W......W..W....W..W....WWW...W.W
.......W..WW..W.WW..W..W......W.W.....W.....W.WWW...W.W......W.W.....W..WW...W....W.......W.WW....W.
....W.W..W........W.W.W...W.W..W....WWW...WWWW.WW....WWW..WW.....W.W..WW..WW....W...W......W..W..W..
.W..W..WWWW...............W.....WW.....W..........W.W..W....W.W...........W......W...W..............
.W..W....W.....W...WW...W........W.......WWW....W......W...WWW..W......WW.W..W.......W.............W
WW.WW......WW..............WW..........WW..WW...........W.........W.....W.W.....W.W......W....WW....
......W..W...W.....W.W....W.W.......W.WWW..WW.......W.....W.......W............W..W.......W.WW.....W
.WWW...WWW........W.W.....WWW..........WW.W.W.W...............WWWW.WWW...WW.......W..WW..W.W.WW....W
..W....WWW.......W...WW.WW.W..W...W......W.W...WW.W...W.WW.W...WWW..W.......W......WW..WWW..W..W...W
.....W.W.W..WW..W.W....W...W...........W..WW.W.....WW..WW...W.W...........W..WW..W......W..W.....W..
WW.WW.W...W......W...W.......W...W...W...WW.W.W..W.WW..W.....WW.W...W......W.W..................W...
W.W.WWW......W..W..W.WW.WW...WW...WW..W.....W.W..W.W...W.W..W........WWW....W...W.W..WW......W..W..W
......WW..............W.W........W.W...W........W.W.W.W.WW....W.W...W......W.W..WW..W...W..WWW....W.
..WW....W.WWWW....W....W.W....W........W..WW..WW...WW.WW.....W...WWWW.W..W......W...........W.......
..W....W.....WWW...W.W..........W..W.W.WW.W.W..W..W.W...........W...........WW.W.WW...W.......W.W...
.WW....W....W....WWW.W....WW..............W..W....W.............WWW.....W...WW.WWW........W.....WWW.
...W..W...W....W...WW...W......W.W..W..W.WW.WW.........WW.W....W......WWW...W.W.W..WWWW...W..W......
W..W..WW..W....W....W.......WWW..W.....W...W..WW...W.W.W..WWW.............W..WW..W......WW..W.......
.WW...W..W....WW.W.WW...W.W.W..WW........WW....WW..WW...W..W.W..W..W.....W.....W....W.....W.........
WW.....W..W....W.W..WWW.W.....WWW....W..W.....W..W.W.....W.W...W.....W.W...W.......WW......W..WW....
........W....W..W......W.W..W..WW.........W...........W......W..W...WWW.W.........W..W.W...W...W...W
..W.W....W....W..W....W......WWW..W.W....W.....W.......WWW.............W.WWWW...W....WWW.WW..W.WW.W.
...W........W.W......WWW.....W...WWW............W.W.W.W....WW...W...W........W..W.WWWW........W..W.W
.W.W....WW..W..W.....W............W....WW....W...........W.W.....W..WW....W...W.W..WW.....W....W....
....W...WW..WW.W..W.W.W.....W.W..W...W........W....W....W.WW...W.W........W...W..WW...W.......W..W..
W.WW....W.W.....WW........WW.W....WW.......W.WW..W.WW..W..W.W.W.WW....W..W...W..W..W.....W....W....W
......WWW...W.WW.W....W........WW...W....W..W...W.....W...........W..........W.WW.W.W..W..W....W....
......W..W.W.W.W..WW..W.WW.WW.....W.W............W.....W......WW..WW.W.W.W.....WW.W.W.......W......W
W.WW..W.W..WWWW...............W...W.........W.W........W.......W.W..W.W.W.W...W...W.WW.....W.W.....W
W....W.....W.W...W.WWW..W...............W..W........WW...W....WWW.......W...........W...W.W..WWWW...
W.WW..W.............WW..W.....W.W......W....W.........WW....WW.W..............W....W....W..W....W.W.
.W....W....WW..W.......W..WW..W.......W.W.....W..W.....WW..WWWW.WW.W.W..W...W.....W........W........
WWW....W.WW.....WW..W...W..W.WWWW...WW........WW......W..WW....W.W.W...W.WW.......W....W....W.WW...W
.W.....W......WW.W..WW......WW.W......W....W.W...W......WW.WW............W.W.....WWW.W..W...W...WW..
.WW.WWW..W..W..W..W.....W...W...WW.WW..W..W............W.W.....W.W.W..W...W....WWW...WWW..W.......W.
.W.......W........WW....W....W...W..WW.W.........WW...W.W.WW..W...WW.W...W...W...WWW..W.W...W....WW.
.WWWWW.W...WWW...W..W.WW.W..WW....W..W........W.W.WW...W...............W..W..W.WWW...WWW....WW.WWW..
..WW.W.W......W...W.......WW......W.........W.....W.W.W.W..WWW.....WW....W.W......W..W.W..W.....W.W.
WWW.W.............WWWWWWWW....W.........W....W...W.....WW.......W....W...........W.W...W...WW.WW....
W...........WWW.....W....W.................W.........W..W.....W...WWW...W..W...W..........W.....W...
..W.W...WW.W.WW..WW...W.W..WW..W.....W.WWW..W....WW..W...W.W..W.....WW..W..W....W........WWWWW.W....
....W.W.W...........W...W....W.W........W.WW.....W..WW.W....W.W.....WW.WW......WW.....W.......WW.W.W
..W.W..W..W.....W.W.................W..WWWW.W..WW.....W...WW.W........W..W...W.......WW.W...........
...W....WWW.WWW.W.....W.W.W...........W.W.W........W.W.W....WW....W..W.W.W...WWW.W..W....W..W.......
```

Expected 198

Actual 312

---

### 第二版 移除當次走過的標記(失敗 過於費時)

好吧，我承認這題沒想像中的簡單，來想想新的遞迴模式吧

- 多傳入方向，不走回頭路==>不行，形成環形loop就走不出去了
- 走完之後移除這次的標記==>可以考慮

```C#
        public static int PathFinder(string maze)
        {
            string[] mazeSplit = maze.Split("\n");
            char[][] mazeArr = new char[mazeSplit.Length][];
            for (int i = 0; i < mazeSplit.Length; i++)
                mazeArr[i] = mazeSplit[i].ToCharArray();
            return SubFinder(ref mazeArr, new int[] { 0, 0 }).steps;
        }

        private static SubFinderResult SubFinder(ref char[][] mazeArr, int[] index)
        {
            if (index.Any(i => i < 0)) { return new SubFinderResult { steps = -1, goal = false }; }
            int size = mazeArr.Length - 1;
            if (index.Any(i => i > size)) { return new SubFinderResult { steps = -1, goal = false }; }
            if (index[0] == mazeArr.Length - 1 && index[1] == mazeArr[0].Length - 1)
                return new SubFinderResult { steps = 0, goal = true };
            if (mazeArr[index[0]][index[1]] == '.')
                mazeArr[index[0]][index[1]] = 'A';
            else
                return new SubFinderResult { steps = -1, goal = false };
            List<SubFinderResult> subFinderResults = new List<SubFinderResult>();
            subFinderResults.Add(SubFinder(ref mazeArr, new int[] { index[0] + 1, index[1] }));
            subFinderResults.Add(SubFinder(ref mazeArr, new int[] { index[0], index[1] + 1 }));
            subFinderResults.Add(SubFinder(ref mazeArr, new int[] { index[0] - 1, index[1] }));
            subFinderResults.Add(SubFinder(ref mazeArr, new int[] { index[0], index[1] - 1 }));
            if (mazeArr[index[0]][index[1]] == 'A')
                mazeArr[index[0]][index[1]] = '.';
            if (!subFinderResults.Any(sr => sr.goal))
                return new SubFinderResult { steps = -1, goal = false };

            return new SubFinderResult { steps = 1 + subFinderResults.Where(sr => sr.goal).Select(sr => sr.steps).Min(), goal = true };
        }

        private struct SubFinderResult
        {
            public int steps;
            public bool goal;
        }
```

加入一個判斷，把這次之後走的路徑都標記為未走過=>等同是把通往終點的所有走法都走過一遍

結論，不可行。太浪費時間了

---

### 第三版， 把走過的路徑步數記下來省時間 (失敗 big maze 錯誤)

上一個做法把之前走過的路還要重新判斷，效率極差，這次針對這點改善

1. 把走過的點到終點的最短距離記下來，下次走到同樣的路就直接回傳距離，不繼續走下去了。
2. 或者走完一條成功的路線之後，記錄他的長度，之後走超過這個長度的就可以中斷了

=>彙整了一下:把從起點走到該點的步數記下來，下次走到該點就比較步數，比較少就覆蓋，多就終止

```C#
        public static int PathFinder(string maze)
        {
            string[] mazeSplit = maze.Split("\n");
            char[][] mazeArr = new char[mazeSplit.Length][];
            for (int i = 0; i < mazeSplit.Length; i++)
                mazeArr[i] = mazeSplit[i].ToCharArray();
            return SubFinder(ref mazeArr, new int[] { 0, 0 },0).steps;
        }

        private static SubFinderResult SubFinder(ref char[][] mazeArr, int[] index,int steps)
        {
            if (index.Any(i => i < 0)) { return new SubFinderResult { steps = -1, goal = false }; }
            int size = mazeArr.Length - 1;
            if (index.Any(i => i > size)) { return new SubFinderResult { steps = -1, goal = false }; }
            if (index[0] == mazeArr.Length - 1 && index[1] == mazeArr[0].Length - 1)
                return new SubFinderResult { steps = steps, goal = true };
            switch (mazeArr[index[0]][index[1]])
            {
                case 'W':
                    return new SubFinderResult { steps = -1, goal = false };
                case '.':
                    steps++;
                    mazeArr[index[0]][index[1]] = Convert.ToChar(steps);
                    break;
                default:
                    steps++;
                    if (Convert.ToInt32(mazeArr[index[0]][index[1]])<=steps)
                        return new SubFinderResult { steps = -1, goal = false };
                    mazeArr[index[0]][index[1]] = Convert.ToChar(steps);
                    break;
            }
            List<SubFinderResult> subFinderResults = new List<SubFinderResult>();
            subFinderResults.Add(SubFinder(ref mazeArr, new int[] { index[0] + 1, index[1] }, steps));
            subFinderResults.Add(SubFinder(ref mazeArr, new int[] { index[0], index[1] + 1 }, steps));
            subFinderResults.Add(SubFinder(ref mazeArr, new int[] { index[0] - 1, index[1] }, steps));
            subFinderResults.Add(SubFinder(ref mazeArr, new int[] { index[0], index[1] - 1 }, steps));
            if (!subFinderResults.Any(sr => sr.goal))
                return new SubFinderResult { steps = -1, goal = false };

            return new SubFinderResult { steps = subFinderResults.Where(sr => sr.goal).Select(sr => sr.steps).Min(), goal = true };
        }

        private struct SubFinderResult
        {
            public int steps;
            public bool goal;
        }
```

==>還是失敗，但是這次只差big maze沒過而已

Expected 198

Actual 208

---

### 第四版 修正字元儲存可能造成錯誤判斷的問題 (失敗 答案對，但是time out)

不確定怎麼錯的只能猜測，假設方法是管用的，那原因應該出在數字轉換為字元時出現'W'讓判斷錯誤，又或者數字太大超出限制。

先看第二項，一個char占用1 byte = 8 bits => -128~127 ，看起來很可能不夠用，那麼勢必得改變儲存的格式第一種情形也可以順便避開了。另外`index`的格式看起來很不舒服，順便改成value tuple好了。

最後決定使用Dictionary來儲存steps，改完如下

```C#
        public static int PathFinder(string maze)
        {
            string[] mazeSplit = maze.Split("\n");
            char[][] mazeArr = new char[mazeSplit.Length][];
            Dictionary<(int, int), int> pathSteps = new Dictionary<(int, int), int>();
            for (int i = 0; i < mazeSplit.Length; i++)
                mazeArr[i] = mazeSplit[i].ToCharArray();
            return SubFinder(ref mazeArr, (0, 0), 0, pathSteps).steps;
        }

        private static SubFinderResult SubFinder(ref char[][] mazeArr, (int x, int y) index, int steps, Dictionary<(int, int), int> pathSteps)
        {
            if (index.x < 0 || index.y < 0) { return new SubFinderResult { steps = -1, goal = false }; }
            int size = mazeArr.Length - 1;
            if (index.x > size || index.y > size) { return new SubFinderResult { steps = -1, goal = false }; }
            if (index.x == mazeArr.Length - 1 && index.y == mazeArr[0].Length - 1)
                return new SubFinderResult { steps = steps, goal = true };
            switch (mazeArr[index.x][index.y])
            {
                case 'W':
                    return new SubFinderResult { steps = -1, goal = false };

                default:
                    steps++;
                    if (pathSteps.ContainsKey(index))
                    {
                        pathSteps.TryGetValue(index, out int indexValue);
                        if (indexValue <= steps)
                            return new SubFinderResult { steps = -1, goal = false };
                        pathSteps.Remove(index);
                    }
                    pathSteps.Add(index, steps);
                    break;
            }
            List<SubFinderResult> subFinderResults = new List<SubFinderResult>();
            subFinderResults.Add(SubFinder(ref mazeArr, (index.x + 1, index.y), steps, pathSteps));
            subFinderResults.Add(SubFinder(ref mazeArr, (index.x, index.y + 1), steps, pathSteps));
            subFinderResults.Add(SubFinder(ref mazeArr, (index.x - 1, index.y), steps, pathSteps));
            subFinderResults.Add(SubFinder(ref mazeArr, (index.x, index.y - 1), steps, pathSteps));
            if (!subFinderResults.Any(sr => sr.goal))
                return new SubFinderResult { steps = -1, goal = false };

            return new SubFinderResult { steps = subFinderResults.Where(sr => sr.goal).Select(sr => sr.steps).Min(), goal = true };
        }

        private struct SubFinderResult
        {
            public int steps;
            public bool goal;
        }
```

結果: Time out

經過了一翻修改，想盡量減少遞迴的次數

```C#
        public static int PathFinder(string maze)
        {
            string[] mazeSplit = maze.Split("\n");
            char[][] mazeArr = new char[mazeSplit.Length][];
            Dictionary<(int, int), int> pathSteps = new Dictionary<(int, int), int>();
            for (int i = 0; i < mazeSplit.Length; i++)
                mazeArr[i] = mazeSplit[i].ToCharArray();
            return SubFinder(ref mazeArr, (0, 0), 0, pathSteps).steps;
        }

        private static SubFinderResult SubFinder(ref char[][] mazeArr, (int x, int y) index, int steps, Dictionary<(int, int), int> pathSteps)
        {
            if (index.x == mazeArr.Length - 1 && index.y == mazeArr[0].Length - 1)
                return new SubFinderResult { steps = steps, goal = true };
            if (mazeArr[index.x][index.y] == 'W')
            {
                pathSteps.Add(index, -1);
                return new SubFinderResult { steps = -1, goal = false };
            }
            steps++;
            if (pathSteps.ContainsKey(index))
            {
                pathSteps.TryGetValue(index, out int indexValue);
                if (indexValue <= steps)
                    return new SubFinderResult { steps = -1, goal = false };
                pathSteps[index] = steps;
            }
            else
                pathSteps.Add(index, steps);
            List<SubFinderResult> subFinderResults = new List<SubFinderResult>();
            pathSteps.TryGetValue((index.x + 1, index.y), out int nextStep);
            if (index.x < mazeArr.Length - 1 && stepCondition())
                subFinderResults.Add(SubFinder(ref mazeArr, (index.x + 1, index.y), steps, pathSteps));
            pathSteps.TryGetValue((index.x, index.y + 1), out nextStep);
            if (index.y < mazeArr.Length - 1 && stepCondition())
                subFinderResults.Add(SubFinder(ref mazeArr, (index.x, index.y + 1), steps, pathSteps));
            pathSteps.TryGetValue((index.x - 1, index.y), out nextStep);
            if (index.x > 0 && stepCondition())
                subFinderResults.Add(SubFinder(ref mazeArr, (index.x - 1, index.y), steps, pathSteps));
            pathSteps.TryGetValue((index.x, index.y - 1), out nextStep);
            if (index.y > 0 && stepCondition())
                subFinderResults.Add(SubFinder(ref mazeArr, (index.x, index.y - 1), steps, pathSteps));
            subFinderResults = subFinderResults.Where(sr => sr.goal).ToList();
            if (subFinderResults.Count == 0)
                return new SubFinderResult { steps = -1, goal = false };

            return new SubFinderResult { steps = subFinderResults.Select(sr => sr.steps).Min(), goal = true };
            bool stepCondition() => nextStep != -1 && (nextStep > steps || nextStep == 0);
        }

        private struct SubFinderResult
        {
            public int steps;
            public bool goal;
        }
```

依然time out

寫個測試來看看LOCAL側的執行時間，第一個是第一階段的四個簡單輸入，第二個是100*100的巨大迷宮

![](https://i.imgur.com/SWHtc06.png)

接著拿之前沒過關的程式碼看看幾秒內算Save

上一個版本

![](https://i.imgur.com/7U6Knr3.png)

無法執行測試，原因不明，單獨執行的話，第一個可以，但第二個不行，Debug可以進去，但結束時也不會更新測試結果。

最早的版本

![](https://i.imgur.com/qu9gV9F.png)

理所當然地沒有過關，時間也快到沒有參考價值...

第一個time out 版本

![](https://i.imgur.com/Yfr54no.png)

事實證明，速度越改越慢了...

總之綜合以上，猜測通關線約在1.2s左右

---

### 第五版 移除重複判斷，牆壁判別提前(失敗 time out)

突然想到C#的Array是屬於參考型別，所以不需要下多餘的`ref`關鍵字，雖然這個應該不影響速度，但還是順便改掉了。

```
        public static int PathFinder(string maze)
        {
            string[] mazeSplit = maze.Split("\n");
            char[][] mazeArr = new char[mazeSplit.Length][];
            Dictionary<(int, int), int> pathSteps = new Dictionary<(int, int), int>();
            for (int i = 0; i < mazeSplit.Length; i++)
                mazeArr[i] = mazeSplit[i].ToCharArray();
            return SubFinder( mazeArr, (0, 0), 0, pathSteps).steps;
        }

        private static SubFinderResult SubFinder( char[][] mazeArr, (int x, int y) index, int steps, Dictionary<(int, int), int> pathSteps)
        {
            if (index.x == mazeArr.Length - 1 && index.y == mazeArr[0].Length - 1)
                return new SubFinderResult { steps = steps, goal = true };
            steps++;
            if (pathSteps.ContainsKey(index))
                pathSteps[index] = steps;
            else
                pathSteps.Add(index, steps);
            List<SubFinderResult> subFinderResults = new List<SubFinderResult>();
            if (index.x < mazeArr.Length - 1 && stepCondition((index.x + 1, index.y)))
                subFinderResults.Add(SubFinder( mazeArr, (index.x + 1, index.y), steps, pathSteps));
            if (index.y < mazeArr.Length - 1 && stepCondition((index.x, index.y + 1)))
                subFinderResults.Add(SubFinder( mazeArr, (index.x, index.y + 1), steps, pathSteps));
            if (index.x > 0 && stepCondition((index.x - 1, index.y)))
                subFinderResults.Add(SubFinder( mazeArr, (index.x - 1, index.y), steps, pathSteps));
            if (index.y > 0 && stepCondition((index.x, index.y - 1)))
                subFinderResults.Add(SubFinder( mazeArr, (index.x, index.y - 1), steps, pathSteps));
            subFinderResults = subFinderResults.Where(sr => sr.goal).ToList();
            if (subFinderResults.Count == 0)
                return new SubFinderResult { steps = -1, goal = false };

            return new SubFinderResult { steps = subFinderResults.Select(sr => sr.steps).Min(), goal = true };
            bool stepCondition((int x,int y)nextIndex)
            {
                if (mazeArr[nextIndex.x][nextIndex.y] == 'W')
                    return false;
                pathSteps.TryGetValue(nextIndex, out int nextStep);
                return nextStep > steps+1 || nextStep == 0;
            }
        }

        private struct SubFinderResult
        {
            public int steps;
            public bool goal;
        }
```

![](https://i.imgur.com/tJcswf3.png)

還真的跑出1.2s，但是可惜依然是time out，もっと速く

### 第六版 移除複雜結構 (失敗 time out)

把回傳的`struct`去掉，並且不再使用list紀錄各個子路徑的結果

```C#
        public static int PathFinder(string maze)
        {
            string[] mazeSplit = maze.Split("\n");
            char[][] mazeArr = new char[mazeSplit.Length][];
            Dictionary<(int, int), int> pathSteps = new Dictionary<(int, int), int>();
            for (int i = 0; i < mazeSplit.Length; i++)
                mazeArr[i] = mazeSplit[i].ToCharArray();
            return SubFinder(mazeArr, (0, 0), 0, pathSteps);
        }

        private static int SubFinder(char[][] mazeArr, (int x, int y) index, int steps, Dictionary<(int, int), int> pathSteps)
        {
            if (index.x == mazeArr.Length - 1 && index.y == mazeArr[0].Length - 1)
                return steps;
            steps++;
            pathSteps[index] = steps;
            int routeValue;
            int min = int.MaxValue;
            if (index.x < mazeArr.Length - 1 && stepCondition((index.x + 1, index.y)))
            {
                routeValue = SubFinder(mazeArr, (index.x + 1, index.y), steps, pathSteps);
                if (routeValue != -1)
                    min = min < routeValue ? min : routeValue;
            }
            if (index.y < mazeArr.Length - 1 && stepCondition((index.x, index.y + 1)))
            {
                routeValue = SubFinder(mazeArr, (index.x, index.y + 1), steps, pathSteps);
                if (routeValue != -1)
                    min = min < routeValue ? min : routeValue;
            }
            if (index.x > 0 && stepCondition((index.x - 1, index.y)))
            {
                routeValue = SubFinder(mazeArr, (index.x - 1, index.y), steps, pathSteps);
                if (routeValue != -1)
                    min = min < routeValue ? min : routeValue;
            }
            if (index.y > 0 && stepCondition((index.x, index.y - 1)))
            {
                routeValue = SubFinder(mazeArr, (index.x, index.y - 1), steps, pathSteps);
                if (routeValue != -1)
                    min = min < routeValue ? min : routeValue;
            }
            min = min == int.MaxValue ? -1 : min;
            return min;
            bool stepCondition((int x, int y) nextIndex)
            {
                if (mazeArr[nextIndex.x][nextIndex.y] == 'W')
                    return false;
                if (nextIndex == (0, 0))
                    return false;
                pathSteps.TryGetValue(nextIndex, out int nextStep);
                return nextStep > steps + 1 || nextStep == 0;
            }
        }
```

![](https://i.imgur.com/XNZZcHe.png)

結果還是time out ... 何故か？600ms解掉big maze根本超快了好嗎?

---

### 第七版 先標記再走 (Pass)

新しいアイディア =>如果在走之前先標記應該可以省掉一些冤枉路

```C#
        public static int PathFinder(string maze)
        {
            string[] mazeSplit = maze.Split("\n");
            char[][] mazeArr = new char[mazeSplit.Length][];
            Dictionary<(int, int), int> pathSteps = new Dictionary<(int, int), int>();
            for (int i = 0; i < mazeSplit.Length; i++)
                mazeArr[i] = mazeSplit[i].ToCharArray();
            return SubFinder(mazeArr, (0, 0), 0, pathSteps);
        }

        private static int SubFinder(char[][] mazeArr, (int x, int y) index, int steps, Dictionary<(int, int), int> pathSteps)
        {
            if (index.x == mazeArr.Length - 1 && index.y == mazeArr[0].Length - 1)
                return steps;
            steps++;
            pathSteps[index] = steps;
            (bool down, bool right, bool up, bool left) dirToGo = (false, false, false, false);
            if (index.x < mazeArr.Length - 1 && stepCondition((index.x + 1, index.y)))
            {
                dirToGo.down = true;
                pathSteps[(index.x + 1, index.y)] = steps + 1;
            }
            if (index.y < mazeArr.Length - 1 && stepCondition((index.x, index.y + 1)))
            {
                dirToGo.right = true;
                pathSteps[(index.x, index.y + 1)] = steps + 1;
            }
            if (index.x > 0 && stepCondition((index.x - 1, index.y)))
            {
                dirToGo.up = true;
                pathSteps[(index.x - 1, index.y)] = steps + 1;
            }
            if (index.y > 0 && stepCondition((index.x, index.y - 1)))
            {
                dirToGo.left = true;
                pathSteps[(index.x, index.y - 1)] = steps + 1;
            }

            int routeValue;
            int min = int.MaxValue;
            if (dirToGo.down)
            {
                routeValue = SubFinder(mazeArr, (index.x + 1, index.y), steps, pathSteps);
                if (routeValue != -1)
                    min = min < routeValue ? min : routeValue;
            }
            if (dirToGo.right)
            {
                routeValue = SubFinder(mazeArr, (index.x, index.y + 1), steps, pathSteps);
                if (routeValue != -1)
                    min = min < routeValue ? min : routeValue;
            }
            if (dirToGo.up)
            {
                routeValue = SubFinder(mazeArr, (index.x - 1, index.y), steps, pathSteps);
                if (routeValue != -1)
                    min = min < routeValue ? min : routeValue;
            }
            if (dirToGo.left)
            {
                routeValue = SubFinder(mazeArr, (index.x, index.y - 1), steps, pathSteps);
                if (routeValue != -1)
                    min = min < routeValue ? min : routeValue;
            }
            min = min == int.MaxValue ? -1 : min;
            return min;
            bool stepCondition((int x, int y) nextIndex)
            {
                if (mazeArr[nextIndex.x][nextIndex.y] == 'W')
                    return false;
                if (nextIndex == (0, 0))
                    return false;
                pathSteps.TryGetValue(nextIndex, out int nextStep);
                return nextStep > steps + 1 || nextStep == 0;
            }
        }
```

![](https://i.imgur.com/geo3TQ5.png)

只比上一版快一點點

不過竟然通關了

![](https://i.imgur.com/Ub892tj.png)

timeout是12秒，不管這支執行了9秒還是7秒都比上一版快了不少，但是在LOCAL端測起來卻是差不多...

## Better Solutions

### Solution 1

```C#
using System.Linq;

public class Finder
{    
  public static int PathFinder(string maze)
  {
    var isOpen = maze.Split('\n').Select(a => a.Select(b => b == '.').ToArray()).ToArray();
    var stepsNeeded = isOpen.Select(a => a.Select(b => 999).ToArray()).ToArray();
    Flood(0, 0, isOpen, stepsNeeded, 0); 
    return stepsNeeded.Last().Last() < 999 ? stepsNeeded.Last().Last() : -1;
  }
  
  private static void Flood(int x, int y, bool[][] isOpen, int[][] stepsNeeded, int step)
  {
    if (isOpen[x][y] && stepsNeeded[x][y] > step)
    {
      stepsNeeded[x][y] = step;
      if (x > 0) Flood(x - 1, y, isOpen, stepsNeeded, step + 1);
      if (y > 0) Flood(x, y - 1, isOpen, stepsNeeded, step + 1);
      if (x < isOpen.GetLength(0) - 1) Flood(x + 1, y, isOpen, stepsNeeded, step + 1);
      if (y < isOpen.GetLength(0) - 1) Flood(x, y + 1, isOpen, stepsNeeded, step + 1);
    }
  }
}
```

這東西解開 big maze 只花了98ms，約為我的1/6

`isOpen`作為`bool[][]` 存取每個座標是否可走

`stepsNeeded`用來存從起點到目標的最短距離

接著遞迴

!! 這不是跟我的作法幾乎一樣嗎?而且他並沒有在走之前先標記，那為何可以這麼快?

是因為遞迴方法沒有回傳的關係嗎，我把step從終點一路傳回起點反而拖了時間?

### Solution 2

```C#
using System;                 //   ██████████████
using System.Text;            //   █☻═╗ˑˑˑˑˑˑˑ█ˑ█
using System.Threading.Tasks; //   █ˑ█║████████ˑ█
                              //   ███╚═╗█╔═══╗ˑ█
public class Finder           //   █ˑˑˑ█╚═╝█ˑ█╚╗█
{                             //   █ˑ██████████║█
  public class Grid           //   █ˑˑˑˑˑˑˑˑˑˑˑ♥█
  {                           //   ██████████████
     /*****************************************************************/
    /**  OPTIONAL VISUALISATION: Disable for improved performance!  **/
   /*****************************************************************/
    public void Print() 
    {
      char[,] map = new char[width,height];
      
      Parallel.For(0, grid.Length, delegate(int i) { 
        if( grid[i%(width), i/(width)] == WALL )
          map[i%(width), i/(width)] = '█'; 
        else
          map[i%width,i/height] = 'ˑ';
      });
      
      Random rnd = new Random();
      map[0,0] = (rnd.Next(0,2)==0 ? '☺' : '☻');
      map[width-1, height-1] = (rnd.Next(0,2)==0 ? '$' : '♥');
      
      DrawPath(map, width-1, height-1, Dir.NONE, -1);
      
      StringBuilder sb = new StringBuilder(width*height);
      for( int i=0; i<width; i++ )
        sb.Append('█');
      sb.AppendLine("██");
        
      for( int y=0; y<height; y++ ) {
        sb.Append('█');
        for( int x=0; x<width; x++ )
          sb.Append(map[x,y]);
        sb.AppendLine("█");
      }
      
      for( int i=0; i<width; i++ )
        sb.Append('█');
      sb.AppendLine("██");
      
      Console.WriteLine(sb);
    } 
    
     /*********************/
    /** STILL OPTIONAL: **/
   /*********************/
    bool DrawPath(char[,] map, int x, int y, Dir frm, int steps ) 
    {
      int tile=grid[x,y];
      if( steps == -1 )
        steps=tile;
      if( steps != tile || tile == BLANK || tile == WALL )
        return false;
      if(x==0&&y==0)
        return true;
      
      Dir to = Dir.NONE;
      if(      frm!=Dir.LEFT  && x > 0      && DrawPath(map, x-1, y, Dir.RIGHT, steps-1) )
        to = Dir.LEFT;
      else if( frm!=Dir.UP    && y > 0      && DrawPath(map, x, y-1, Dir.DOWN,  steps-1) )
        to = Dir.UP;
      else if( frm!=Dir.DOWN  && y+1<height && DrawPath(map, x, y+1, Dir.UP,    steps-1) )
        to = Dir.DOWN;
      else if( frm!=Dir.RIGHT && x+1<width  && DrawPath(map, x+1, y, Dir.LEFT,  steps-1) )
        to = Dir.RIGHT;
      if( to == Dir.NONE )
        return false;

      if( frm != Dir.NONE ) {
        switch( (int)frm + (int)to ) {
            case ((int)Dir.LEFT+(int)Dir.RIGHT): map[x,y]='═';
              break;
            case ((int)Dir.UP+(int)Dir.DOWN): map[x,y]='║';
              break;
            case ((int)Dir.UP+(int)Dir.RIGHT): map[x,y]='╚';
              break;
            case ((int)Dir.DOWN+(int)Dir.RIGHT): map[x,y]='╔';
              break;
            case ((int)Dir.LEFT+(int)Dir.UP): map[x,y]='╝';
              break;
            case ((int)Dir.LEFT+(int)Dir.DOWN): map[x,y]='╗';
              break;
        }
      }
      return true;
    }
     /***********************************/
    /**  END OPTIONAL VISUALISATION!  **/
   /***********************************/
  
    public enum Dir { NONE=0, LEFT=1, UP=2, RIGHT=4, DOWN=8 };
    int[,] grid;
    int width, height;
    static readonly int WALL=-1, BLANK=int.MaxValue;
    
    public int Steps => grid[width-1, height-1];
    
    public Grid( string maze ) {
      if( (width = maze.IndexOf('\n')) == -1 ) {
        width = maze.Length; 
        height = 1;
      } 
      else
        height = (maze.Length+1)/(width+1);

      grid = new int[width,height];
      
      Parallel.For(0, maze.Length, delegate(int i) 
      { 
        if( maze[i] == '.' )
          grid[i%(width+1), i/(width+1)] = BLANK;
        else if( maze[i] == 'W' )
          grid[i%(width+1), i/(width+1)] = WALL;
      });
    }
    
    public bool Explore(int x, int y, Dir frm, int steps ) {
      int c = grid[x,y];
      if( steps == BLANK || c < 1 || c <= steps ) // 999 == blank space. -1 == wall.
        return false;

      grid[x, y] = steps;
      if( (x==width-1 && y==height-1)
        || ( frm!=Dir.DOWN  && y+1<height && Explore(x, y+1, Dir.UP,    steps+1) )
        |  ( frm!=Dir.RIGHT && x+1<width  && Explore(x+1, y, Dir.LEFT,  steps+1) )
        |  ( frm!=Dir.UP    && y > 0      && Explore(x, y-1, Dir.DOWN,  steps+1) )
        |  ( frm!=Dir.LEFT  && x > 0      && Explore(x-1, y, Dir.RIGHT, steps+1) )
        ) return true;
      return false; 
    }
  }
  
  public static int PathFinder(string maze) 
  {
    if(maze.Length == 0 )
      return -1;
    if(maze.Length <= 2 )
      return maze.Length-1; // Spec guarantees no obstacles at entrance or exit.

    Grid grid = new Grid(maze);
    if( !grid.Explore(0,0,Grid.Dir.UP,0) ) {
      grid.Print(); 
      return -1;
    } 

    grid.Print(); /* OPTIONAL VISUALISATION: Disable for improved performance! */

    return grid.Steps;
  }
}
```

不只圖形化，還顯示轉彎路徑，佩服

```
標準輸出: 
█████
█☻█ˑ█
█║█ˑ█
█╚═$█
█████

█████
█☻█ˑ█
█ˑ█ˑ█
██ˑ$█
█████

████████
█☻ˑˑˑˑˑ█
█║ˑˑˑˑˑ█
█║ˑˑˑˑˑ█
█║ˑˑˑˑˑ█
█║ˑˑˑˑˑ█
█╚════♥█
████████

████████
█☺ˑˑˑˑˑ█
█ˑˑˑˑˑˑ█
█ˑˑˑˑˑˑ█
█ˑˑˑˑˑˑ█
█ˑˑˑˑˑ██
█ˑˑˑˑ█♥█
████████
```

```
 標準輸出: 
██████████████████████████████████████████████████████████████████████████████████████████████████████
█☻╗ˑˑˑˑˑˑˑ██ˑ█ˑ█ˑˑ█ˑˑˑ██ˑˑˑ█ˑˑˑˑ█ˑˑˑ██ˑˑˑ█ˑ█ˑˑ██ˑˑˑˑˑˑ█ˑˑˑ█ˑ██ˑ█ˑˑ██ˑˑ█ˑˑˑ██ˑˑˑ███ˑ██ˑˑ█ˑ█ˑ██ˑˑˑ█ˑˑˑˑ█
██║ˑˑˑ█ˑˑˑˑˑˑˑ██ˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑ█ˑ█ˑ█ˑˑˑ████ˑ█ˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑ██ˑ██ˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑ█ˑˑˑˑˑ█
█ˑ╚══╗ˑˑˑˑ█ˑˑ█ˑˑ█ˑ█ˑˑˑ██ˑˑ██ˑˑˑˑˑ█ˑ██ˑ█ˑˑ█ˑ█ˑˑˑˑˑˑ█ˑˑˑ█ˑˑ█ˑˑˑ█ˑˑˑ█ˑˑ█ˑ█ˑˑ███ˑˑ███ˑˑˑ██ˑˑ█ˑˑ█ˑˑ█ˑˑ█████
█ˑˑˑ█║ˑˑˑˑ██ˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑˑˑ██ˑ█ˑˑˑˑ█ˑˑˑˑ██ˑˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑ███ˑˑˑˑˑˑˑˑ█ˑ███ˑˑˑ█ˑ█ˑˑˑˑˑ█ˑˑ█ˑ█ˑ█ˑ██ˑˑ█
█ˑˑ█ˑ║ˑˑˑˑˑˑˑˑˑ█ˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑ█ˑ█ˑˑˑ█ˑˑˑ█ˑ███ˑ█ˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑ█ˑˑ█ˑˑˑˑˑˑ█ˑ█ˑ█ˑˑ██ˑˑ█ˑˑˑˑˑˑˑˑ█ˑˑˑ██
█ˑ█ˑˑ╚╗ˑˑ█ˑˑˑˑ█ˑˑ█ˑ█ˑˑˑˑˑˑ██ˑˑ█ˑˑˑ█ˑˑ█ˑˑ█ˑˑ█ˑ█ˑˑ███ˑˑ█ˑ███ˑˑˑˑˑˑ█ˑˑˑˑˑ█ˑ██ˑ█ˑ█ˑˑ██ˑ█ˑˑˑ█ˑˑˑˑˑ█ˑ█ˑ███ˑ█
█ˑˑ█ˑ█║ˑˑ█ˑ█ˑ█ˑ███ˑ█ˑˑˑˑˑ█ˑˑˑ█ˑˑˑ█ˑˑ██ˑˑˑˑˑˑ███ˑˑˑˑˑ█ˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ██ˑˑˑˑˑˑ██ˑˑˑ█ˑˑˑˑ█ˑˑ██ˑˑˑˑ██
█ˑˑ█ˑˑ║█ˑˑ██ˑˑˑˑˑˑˑ█ˑ████ˑˑ█ˑˑ██ˑˑˑˑˑˑˑ██ˑˑˑˑ█ˑˑˑˑˑˑ█ˑˑ█ˑˑˑ███ˑˑˑˑ█ˑˑˑ█ˑˑ█ˑˑˑˑˑˑˑ█ˑ██████ˑ██ˑˑˑˑ█ˑˑˑˑ█
█ˑ█ˑˑ█║ˑˑˑˑ█ˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑ█████ˑˑˑˑˑˑˑˑˑ███ˑ██ˑˑˑˑˑ█ˑˑˑ██ˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑ█ˑ█ˑˑˑˑ█
███ˑˑ█╚═══════╗███ˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑˑ█ˑ█ˑ██ˑˑˑˑˑˑˑˑˑˑ█ˑˑˑ██ˑˑ█ˑˑˑˑˑ██ˑˑˑˑˑ██ˑˑˑ██ˑˑˑˑ█
███ˑˑˑ█ˑ█ˑˑ█ˑ█║ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ███ˑˑˑ█ˑˑ█ˑ███ˑˑˑ██ˑˑ██ˑ█ˑˑˑˑˑˑ█ˑˑ██ˑ█ˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑ██ˑˑˑ█ˑˑˑ█ˑˑˑ█ˑˑ█
█ˑˑ█ˑ█ˑ██ˑ██ˑ█╚═╗ˑˑˑ█████ˑ█ˑˑˑ██ˑˑˑˑˑ███ˑˑ█ˑ█ˑˑˑˑ█ˑˑˑˑˑˑ█ˑˑ██ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑ█ˑ█ˑˑˑˑˑˑˑˑ█ˑˑ██ˑ██
██ˑˑˑˑˑˑˑ██ˑˑˑˑ█║ˑˑ█ˑ█ˑˑˑˑ█ˑ█████ˑ█ˑˑˑˑ█ˑ█ˑ█ˑ█ˑˑ█ˑˑˑ██ˑˑ█ˑˑˑ█ˑ██ˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑ█ˑˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑ███
█ˑ█ˑ█ˑˑˑˑˑˑˑˑˑ█ˑ╚══╗██ˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑ██ˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ██ˑˑˑˑˑˑˑˑ█ˑ██ˑˑ██ˑˑˑˑ█ˑ█████ˑ█ˑ█ˑˑ█ˑˑˑ██
█ˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑ█║ˑˑ██ˑˑˑˑˑ█ˑ█ˑˑ███ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑ██ˑ██ˑˑˑˑˑˑˑˑˑˑ███ˑˑˑˑˑˑ█ˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑ███
██ˑ█ˑ█ˑˑ█ˑˑˑ█ˑˑ█ˑ█ˑ║ˑˑˑˑˑˑ█ˑˑ█ˑˑˑˑ██ˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑ█ˑˑ██ˑˑˑ█ˑ█████ˑˑˑˑˑ█ˑˑˑ█ˑ█ˑˑˑ█ˑˑ█ˑˑˑˑˑˑˑˑ█████
█ˑ██ˑ█ˑˑ█ˑˑˑ█████ˑˑ║█ˑˑ█ˑˑˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑ█ˑ█ˑ█ˑ█ˑˑ█ˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑ█ˑˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑ█ˑˑˑˑ█
███ˑ█ˑˑˑˑˑ█ˑ██ˑ█ˑˑˑ║█ˑˑ█ˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑ██ˑ█ˑˑ█ˑ█ˑˑˑˑ████ˑˑˑ██ˑˑ█ˑˑˑˑˑˑˑ███ˑˑˑˑ██████ˑˑˑˑˑˑ██ˑ█ˑ██ˑˑˑˑ██
█ˑ█ˑˑˑ█ˑˑˑˑˑˑ█ˑˑˑˑˑ╚╗█████ˑˑˑ█ˑˑ█ˑˑˑ███ˑˑ█ˑˑˑ█ˑ█ˑˑ██ˑ█ˑˑˑˑˑˑ██ˑˑ█ˑ█ˑˑˑ█ˑˑ█ˑˑ█ˑ██ˑˑˑˑˑˑ█ˑˑ███ˑ██ˑˑˑˑ█ˑ█
█ˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ█║ˑ███ˑ█ˑˑˑˑˑˑˑˑˑ██ˑˑˑˑ██ˑ█ˑ█ˑˑˑˑ██ˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ█
█ˑˑˑ█ˑ█ˑ██ˑˑˑ█ˑ███ˑˑ╚══╗ˑˑˑˑˑˑˑˑˑˑ███ˑˑˑˑˑˑˑˑ██ˑ█ˑˑˑ█ˑˑˑˑˑ██ˑˑˑ█ˑˑˑ███ˑˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑˑˑ█ˑ██ˑˑ█ˑˑˑ█ˑˑˑ█
█ˑˑ█ˑˑˑˑ█ˑˑ█ˑˑ█ˑˑˑ█ˑˑˑ█║ˑˑˑˑˑˑˑ█ˑˑ██ˑ██ˑˑ█ˑˑ█ˑˑˑˑˑˑ█ˑˑ███ˑˑˑ█ˑ█ˑ█ˑˑˑ█ˑˑˑˑ█ˑˑ█ˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑ██ˑ█ˑˑˑ██ˑ█
█ˑˑˑˑˑˑ██ˑˑ█ˑˑˑ█ˑˑˑˑ██ˑ╚╗█ˑ█ˑˑ██ˑˑˑˑˑ█ˑ█ˑ█ˑˑˑˑˑˑˑ██ˑˑˑ█ˑˑˑˑ█ˑ███ˑ█ˑˑˑˑ███ˑˑˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑ█ˑ█ˑ█ˑˑ███ˑˑ█
█ˑ██ˑ██ˑˑˑˑ██ˑ█ˑˑˑ██ˑˑˑ█║██ˑˑˑ█ˑˑˑ█ˑˑ██ˑˑˑ█ˑˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑ█ˑ█ˑˑˑˑˑˑˑ█ˑˑ██ˑˑˑ█ˑ█ˑ█ˑ█ˑˑˑˑˑ██ˑˑ█ˑˑ█
█ˑ█ˑˑˑ█ˑ█ˑˑ█ˑˑ█ˑˑ█ˑ██ˑˑˑ║ˑ█ˑ███ˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑ████ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑˑˑ█ˑˑ██ˑ█
█ˑˑ█ˑˑˑˑˑˑ█ˑˑˑˑˑ█ˑ█ˑˑˑˑˑ╚═╗ˑˑˑ██ˑˑˑ██ˑ█ˑˑˑˑˑ██ˑˑˑˑ█ˑ█ˑˑˑˑ█ˑˑ█ˑˑˑˑ█ˑˑ█ˑ█ˑˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑ███
█ˑ█ˑˑˑˑ█ˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑ█ˑ█╚╗ˑˑˑˑ█ˑˑˑ█ˑ█ˑˑˑˑˑˑˑ██ˑ█ˑˑˑˑˑ██ˑ█ˑˑˑˑˑ██ˑ█ˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑ██ˑˑˑˑˑˑˑˑˑ█
█ˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑ█╚╗█ˑˑˑˑ█ˑˑ█ˑˑˑ█ˑ█ˑ██ˑˑˑ█ˑˑˑˑˑˑˑ█ˑˑˑ██ˑˑˑˑˑ█ˑˑ█ˑˑˑ███ˑˑˑˑˑˑˑˑ█ˑˑˑˑ███ˑ█ˑˑˑˑ█
██ˑˑˑˑ█ˑˑ████ˑ█ˑˑˑˑˑˑ█ˑˑˑ█ˑ█║ˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ██ˑ█ˑˑˑˑˑˑˑˑˑˑˑˑ██ˑˑ█ˑ█ˑˑ██ˑ█ˑˑ█ˑˑˑˑˑˑ█ˑˑˑˑˑˑˑ█ˑ██ˑˑ█ˑˑˑ█
█ˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑ█╚═╗ˑˑˑˑˑˑ█ˑ█ˑ██ˑ██ˑˑˑˑ██ˑ███ˑˑˑ█ˑˑˑˑˑ██ˑˑ█ˑˑ█ˑˑ█ˑˑ█ˑˑˑˑ█ˑ█ˑ███ˑˑˑˑ█ˑˑˑˑˑˑ█
█ˑˑˑ█ˑˑ█ˑ█ˑˑˑˑˑˑ█ˑ██ˑˑˑˑˑˑˑˑˑ█╚╗ˑˑ██ˑˑˑ█ˑˑ██ˑˑˑˑ██ˑˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑ█ˑˑˑˑˑˑˑ██ˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑˑ█
██ˑˑ█ˑˑ█ˑ█ˑˑˑ█ˑˑˑ███ˑˑ██ˑˑˑˑˑˑ█║ˑ█ˑˑˑ█ˑˑ██ˑ█ˑˑˑˑ█ˑ██ˑˑˑ██ˑˑˑˑ█ˑˑˑ██ˑˑˑˑˑ██ˑˑˑˑ█ˑ███ˑ█ˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ█
█ˑ█ˑ██ˑˑˑ█ˑˑ█ˑˑ██ˑ█ˑ██ˑˑ█ˑˑˑ███╚══╗ˑ█ˑˑˑ█ˑˑˑˑˑˑˑˑ███ˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑ██ˑˑˑ█ˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑ█ˑˑˑˑˑ█
███ˑˑˑˑˑˑˑˑˑˑ██ˑˑˑˑ█ˑˑ█ˑˑˑ██ˑˑˑˑ██╚╗ˑ█ˑ██ˑˑˑˑˑˑˑ█ˑ███ˑˑˑ███ˑ█ˑˑˑˑˑ█ˑ█ˑˑˑ█ˑˑ██ˑˑˑˑˑ█ˑˑ█ˑ██ˑˑˑˑˑˑˑˑ██ˑˑ█
██ˑˑˑˑˑ██ˑˑˑˑˑˑ█ˑˑˑˑˑ████ˑˑ█ˑˑˑˑˑˑ█║ˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑ█ˑˑ█ˑˑˑˑˑ█ˑˑ███ˑˑˑˑˑˑˑˑˑ█ˑ██ˑ█ˑ█ˑ█ˑˑˑˑˑ█ˑ█ˑ█
████ˑˑˑ█ˑ█ˑˑ██ˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑ███║ˑˑˑˑˑˑ██ˑ█ˑˑˑˑ█ˑˑˑ██ˑˑˑ█ˑˑ█ˑˑ█ˑ█ˑ█ˑˑ█ˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑ█
█ˑˑˑˑˑ█ˑ█ˑ██ˑˑˑˑˑ█ˑˑ█ˑ█ˑˑˑˑ██ˑˑ█ˑˑ█╚╗██ˑˑˑˑ█████ˑˑˑˑˑ█ˑˑˑ█ˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ███ˑ██ˑˑˑ████ˑ█
███ˑˑ█ˑˑˑ██ˑ███ˑˑˑˑ███ˑˑ█ˑˑˑˑ█ˑ██ˑ██╚═╗█ˑˑ█ˑˑˑˑˑˑˑ█ˑˑˑ██ˑ█ˑˑ██ˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑ██ˑˑˑ█ˑ██ˑˑˑˑ█ˑ████
█ˑˑˑˑˑˑˑ█ˑ████ˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑˑˑˑ█ˑ██║█ˑ██ˑˑˑˑˑˑˑ█ˑ██ˑ██ˑˑˑ█ˑˑ█ˑˑˑˑ██ˑˑˑˑˑ██ˑˑˑˑ█ˑˑ██ˑˑ█ˑˑˑˑˑ█ˑˑˑ█ˑˑ█
█ˑ█ˑˑ█ˑ███ˑˑˑ█ˑ█ˑˑˑˑˑ██ˑ██ˑ█ˑˑˑˑˑ██ˑ█ˑ║ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑ█ˑˑˑ█ˑ███ˑˑ██ˑ██ˑ█ˑˑˑ█ˑ██ˑˑˑˑˑ█ˑˑˑ█
██ˑ█ˑˑ█ˑ█ˑˑˑ██ˑˑ█ˑˑˑˑˑˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑ╚╗ˑˑ█ˑˑˑ█ˑˑˑˑˑˑ██ˑˑ██ˑˑ█ˑˑˑˑˑ██ˑˑˑ█ˑˑˑ█ˑ██ˑˑˑˑˑˑˑˑˑ███ˑ█ˑˑˑ██ˑˑ█
██ˑˑ██ˑˑˑˑˑˑˑˑ██ˑˑˑ█ˑ█ˑˑ██ˑˑ█ˑˑˑˑˑ██ˑ██║█ˑ█ˑˑˑˑˑˑ█ˑˑˑˑ██ˑˑ██ˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑ█ˑ█ˑ█ˑˑˑˑˑˑ██
█ˑˑˑˑˑ█ˑˑˑ█ˑˑˑ█ˑ█ˑˑˑ█ˑˑ█ˑˑˑˑˑ█ˑ█ˑˑˑˑˑ██║ˑˑˑ█ˑˑ█ˑ█ˑˑˑˑ█ˑˑˑ█ˑˑˑˑ██ˑˑˑ██ˑ█ˑˑˑˑˑ█ˑˑ█ˑˑˑˑ██ˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑ█
█ˑˑˑ█ˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑ█ˑ║ˑˑˑˑˑˑ██ˑ██ˑ█ˑˑˑˑ█ˑˑˑ██ˑˑˑ█ˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█
█ˑ█ˑ██ˑˑˑˑˑ███ˑˑˑ█ˑˑ█ˑˑ█ˑ█ˑˑˑˑ█ˑˑ█ˑˑˑ█ˑ║ˑˑˑˑ█ˑ█ˑˑ█ˑ█ˑˑ█ˑˑ█ˑ██ˑˑˑˑˑ█ˑ█ˑ██ˑ█ˑ██ˑ█ˑ█ˑˑˑˑ█ˑˑ█ˑˑˑˑˑˑ█ˑ█ˑ█ˑ█
█ˑ█ˑ█ˑˑˑ██ˑˑˑˑ█ˑˑ█ˑˑˑˑˑ███ˑ██ˑˑˑˑ█ˑˑˑˑ█║██ˑˑˑ█ˑ██ˑˑˑ██ˑˑ█ˑˑˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑ█ˑˑ█ˑ█ˑˑ█ˑ█ˑˑˑˑˑ█ˑˑ█ˑˑˑ█ˑ██ˑ█
█ˑˑˑˑ█ˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ██ˑ██ˑˑˑ█ˑˑˑˑˑˑˑ║ˑˑˑˑˑ█ˑˑˑˑ█ˑˑ█ˑˑ██ˑˑ█ˑ██ˑ█ˑ█ˑ█ˑˑˑˑ█ˑˑˑ█ˑˑ█ˑˑˑˑ███ˑ█ˑ█ˑ███ˑˑˑˑ█
██ˑˑˑˑˑˑ███ˑˑˑˑˑˑˑˑ█ˑ█ˑ███ˑˑ██ˑˑˑˑˑ█ˑˑˑ╚╗ˑˑˑ█ˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑ██ˑˑˑˑˑˑ█ˑ█ˑ█ˑˑˑˑ█ˑˑˑˑ███ˑ███
█ˑˑˑˑˑ█ˑ██ˑˑˑ█ˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑ███ˑ█ˑ█║ˑ█ˑˑˑˑ██ˑˑˑˑˑˑˑˑˑˑˑ██ˑ█ˑˑ█ˑ█ˑˑ█ˑˑˑˑˑˑˑˑˑˑ█ˑ██ˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑ█
██ˑˑ█ˑˑˑˑˑˑ█ˑˑ█ˑˑˑ███ˑ██ˑˑ██ˑˑ█ˑˑˑˑˑˑ█ˑ█║ˑˑˑ█ˑˑ███ˑˑˑˑ█ˑˑˑˑˑˑ██ˑˑˑ█ˑˑˑˑ██ˑˑˑˑˑˑˑˑˑ█ˑˑˑˑ██ˑˑˑˑˑˑˑˑˑˑˑˑ█
█ˑˑˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑˑ█ˑ███ˑˑˑˑˑˑˑ█ˑˑˑˑˑ█ˑ█ˑ║███ˑˑ█ˑˑˑˑˑˑ██ˑˑˑˑˑ██ˑ█ˑˑ█ˑ█ˑ█ˑ█ˑ█ˑ█ˑ██ˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑ██ˑˑ██
█ˑˑˑˑ█ˑˑˑ█ˑˑ██ˑˑˑ█ˑˑ█ˑˑˑˑ█ˑˑˑˑˑ█ˑˑ█ˑˑˑ██║ˑˑˑˑˑˑ█ˑ█ˑˑ█ˑˑˑˑˑˑˑˑˑˑ█ˑˑˑ█ˑ██ˑ████ˑˑˑ█ˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑ██ˑˑˑ█
█ˑ██ˑ█ˑ█ˑ██ˑˑˑ█ˑ█ˑˑˑ█ˑ█ˑ█ˑ█ˑˑˑ█ˑ█ˑˑ█ˑ█ˑˑ║ˑˑˑ█ˑˑ█ˑˑˑ█ˑˑ█ˑˑˑˑˑ██ˑˑˑ█ˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑ█ˑ█ˑˑ█ˑˑ█ˑ█ˑˑˑˑˑ█
██ˑˑˑˑˑ███ˑˑˑˑ██ˑˑˑ█ˑˑˑ█ˑˑˑ█ˑˑ█ˑˑˑˑˑˑˑˑ█║ˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑ███ˑˑ█ˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑ█
█ˑˑˑˑˑˑˑ█ˑˑˑ██ˑ██ˑ█ˑˑˑˑˑ██ˑˑ███ˑˑˑˑ███ˑ█║█ˑˑ██ˑ█ˑ██ˑˑ█ˑ█ˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑ█ˑˑˑ███ˑˑˑ█
█ˑˑˑ█ˑˑˑˑˑ█ˑ█ˑ█ˑˑˑˑ█ˑˑˑˑˑ████ˑˑˑˑˑˑˑˑˑˑˑ╚╗ˑˑˑˑˑ█ˑˑˑˑ█ˑ█ˑˑˑ█ˑˑˑ█ˑ██ˑ█ˑˑ█ˑˑ██ˑ█ˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑ███ˑˑˑˑˑ██
██ˑ█ˑˑ██ˑˑˑˑ█ˑ█ˑ██ˑˑ█ˑˑˑ███████ˑˑˑ█ˑˑˑˑˑ█║ˑ███ˑ█ˑˑˑˑ██ˑ█ˑ███ˑˑˑˑˑ█ˑˑˑ█ˑˑˑˑˑˑ█ˑˑ█ˑˑˑˑ█ˑˑ█ˑˑˑˑ███ˑˑˑ█ˑ██
█ˑˑˑˑˑˑˑ█ˑˑ██ˑˑ█ˑ██ˑˑ█ˑˑ█ˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑ█ˑ║ˑˑˑ█ˑ███ˑˑˑ█ˑ█ˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑ█ˑˑ██ˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑ█ˑ██ˑˑˑˑ█ˑ█
█ˑˑˑˑ█ˑ█ˑˑ█ˑˑˑˑˑˑˑˑ█ˑ█ˑ█ˑˑˑ█ˑ█ˑˑ█ˑˑˑˑ███ˑ║ˑ████ˑ██ˑˑˑˑ███ˑˑ██ˑˑˑˑˑ█ˑ█ˑˑ██ˑˑ██ˑˑˑˑ█ˑˑˑ█ˑˑˑˑˑˑ█ˑˑ█ˑˑ█ˑˑ█
█ˑ█ˑˑ█ˑˑ████ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑ██ˑˑˑˑˑ█╚═══╗ˑˑˑˑˑ█ˑ█ˑˑ█ˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█
█ˑ█ˑˑ█ˑˑˑˑ█ˑˑˑˑˑ█ˑˑˑ██ˑˑˑ█ˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑ███╚╗ˑˑ█ˑˑˑˑˑˑ█ˑˑˑ███ˑˑ█ˑˑˑˑˑˑ██ˑ█ˑˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑ██
███ˑ██ˑˑˑˑˑˑ██ˑˑˑˑˑˑˑˑˑˑˑˑˑˑ██ˑˑˑˑˑˑˑˑˑˑ██ˑˑ██║ˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑ█ˑ█ˑˑˑˑˑ█ˑ█ˑˑˑˑˑˑ█ˑˑˑˑ██ˑˑˑˑ█
█ˑˑˑˑˑˑ█ˑˑ█ˑˑˑ█ˑˑˑˑˑ█ˑ█ˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑ█ˑ███ˑˑ██╚═╗ˑˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑˑˑˑˑˑˑ█ˑ██ˑˑˑˑˑ██
█ˑ███ˑˑˑ███ˑˑˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑ███ˑˑˑˑˑˑˑˑˑˑ██ˑ█ˑ█ˑ█╚═══╗ˑˑˑˑˑˑˑˑˑˑ████ˑ███ˑˑˑ██ˑˑˑˑˑˑˑ█ˑˑ██ˑˑ█ˑ█ˑ██ˑˑˑˑ██
█ˑˑ█ˑˑˑˑ███ˑˑˑˑˑˑˑ█ˑˑˑ██ˑ██ˑ█ˑˑ█ˑˑˑ█ˑˑˑˑˑˑ█ˑ█ˑˑˑ██ˑ█╚═╗█ˑ██ˑ█ˑˑˑ███ˑˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑ██ˑˑ███ˑˑ█ˑˑ█ˑˑˑ██
█ˑˑˑˑˑ█ˑ█ˑ█ˑˑ██ˑˑ█ˑ█ˑˑˑˑ█ˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ██ˑ█ˑˑˑˑˑ██║ˑ██ˑˑˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ██ˑˑ█ˑˑˑˑˑˑ█ˑˑ█ˑˑˑˑˑ█ˑˑ█
███ˑ██ˑ█ˑˑˑ█ˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑ█ˑˑˑ██ˑ█ˑ█ˑˑ█ˑ██║ˑ█ˑˑˑˑˑ██ˑ█ˑˑˑ█ˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑ█
██ˑ█ˑ███ˑˑˑˑˑˑ█ˑˑ█ˑˑ█ˑ██ˑ██ˑˑˑ██ˑˑˑ██ˑˑ█ˑˑˑˑˑ█ˑ█ˑˑ█ˑ█ˑ║ˑ█ˑ█ˑˑ█ˑˑˑˑˑˑˑˑ███ˑˑˑˑ█ˑˑˑ█ˑ█ˑˑ██ˑˑˑˑˑˑ█ˑˑ█ˑˑ██
█ˑˑˑˑˑˑ██ˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑˑ█ˑ█ˑˑˑ█ˑˑˑˑˑˑˑˑ█ˑ█ˑ█║█ˑ██ˑˑˑˑ█ˑ█ˑˑˑ█ˑˑˑˑˑˑ█ˑ█ˑˑ██ˑˑ█ˑˑˑ█ˑˑ███ˑˑˑˑ█ˑ█
█ˑˑ██ˑˑˑˑ█ˑ████ˑˑˑˑ█ˑˑˑˑ█ˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑˑ█ˑˑ██ˑˑ██ˑˑˑ██║██ˑˑˑˑˑ█ˑˑˑ████ˑ█ˑˑ█ˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑ█
█ˑˑ█ˑˑˑˑ█ˑˑˑˑˑ███ˑˑˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑ█ˑ██ˑ█ˑ█ˑˑ█ˑˑ█ˑ█║ˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ██ˑ█ˑ██ˑˑˑ█ˑˑˑˑˑˑˑ█ˑ█ˑˑˑ█
█ˑ██ˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑ███ˑ█ˑˑˑˑ██ˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑˑˑˑ█ˑˑ║ˑˑˑˑˑˑˑˑˑˑ███ˑˑˑˑˑ█ˑˑˑ██ˑ███ˑˑˑˑˑˑˑˑ█ˑˑˑˑˑ███ˑ█
█ˑˑˑ█ˑˑ█ˑˑˑ█ˑˑˑˑ█ˑˑˑ██ˑˑˑ█ˑˑˑˑˑˑ█ˑ█ˑˑ█ˑˑ█ˑ██ˑ██ˑˑˑˑˑˑˑ╚╗██ˑ█ˑˑˑˑ█ˑˑˑˑˑˑ███ˑˑˑ█ˑ█ˑ█ˑˑ████ˑˑˑ█ˑˑ█ˑˑˑˑˑˑ█
██ˑˑ█ˑˑ██ˑˑ█ˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑ███ˑˑ█ˑˑˑˑˑ█ˑˑˑ█ˑˑ██ˑˑˑ█ˑ█║█ˑˑ███ˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ██ˑˑ█ˑˑˑˑˑˑ██ˑˑ█ˑˑˑˑˑˑˑ█
█ˑ██ˑˑˑ█ˑˑ█ˑˑˑˑ██ˑ█ˑ██ˑˑˑ█ˑ█ˑ█ˑˑ██ˑˑˑˑˑˑˑˑ██ˑˑˑˑ██ˑˑ██ˑ║ˑ█ˑˑ█ˑ█ˑˑ█ˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ█
███ˑˑˑˑˑ█ˑˑ█ˑˑˑˑ█ˑ█ˑˑ███ˑ█ˑˑˑˑˑ███ˑˑˑˑ█ˑˑ█ˑˑˑˑˑ█ˑˑ█ˑ█ˑˑ╚╗ˑ█ˑ█ˑˑˑ█ˑˑˑˑˑ█ˑ█ˑˑˑ█ˑˑˑˑˑˑˑ██ˑˑˑˑˑˑ█ˑˑ██ˑˑˑˑ█
█ˑˑˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑ█ˑˑˑˑˑˑ█ˑ█ˑˑ█ˑˑ██ˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ█╚══╗ˑˑ█ˑˑ█ˑˑˑ███ˑ█ˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑ█ˑˑˑ█ˑˑˑ█ˑˑˑ██
█ˑˑ█ˑ█ˑˑˑˑ█ˑˑˑˑ█ˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑ███ˑˑ█ˑ█ˑˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑˑ███╚══════╗ˑˑˑˑˑ█ˑ████ˑˑˑ█ˑˑˑˑ███ˑ██ˑˑ█ˑ██ˑ█ˑ█
█ˑˑˑ█ˑˑˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑˑ███ˑˑˑˑˑ█ˑˑˑ███ˑˑˑˑˑˑˑˑˑˑˑˑ█ˑ█ˑ█ˑ█ˑˑˑˑ██ˑˑˑ█╚╗ˑ█ˑˑˑˑˑˑˑˑ█ˑˑ█ˑ████ˑˑˑˑˑˑˑˑ█ˑˑ█ˑ██
█ˑ█ˑ█ˑˑˑˑ██ˑˑ█ˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑ██ˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑ█║ˑ██ˑˑˑˑ█ˑˑˑ█ˑ█ˑˑ██ˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑ█
█ˑˑˑˑ█ˑˑˑ██ˑˑ██ˑ█ˑˑ█ˑ█ˑ█ˑˑˑˑˑ█ˑ█ˑˑ█ˑˑˑ█ˑˑˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑ█ˑ██ˑˑˑ█ˑ█║ˑˑˑˑˑˑˑ█ˑˑˑ█ˑˑ██ˑˑˑ█ˑˑˑˑˑˑˑ█ˑˑ█ˑˑ█
██ˑ██ˑˑˑˑ█ˑ█ˑˑˑˑˑ██ˑˑˑˑˑˑˑˑ██ˑ█ˑˑˑˑ██ˑˑˑˑˑˑˑ█ˑ██ˑˑ█ˑ██ˑˑ█ˑˑ█ˑ█ˑ█ˑ██╚╗ˑˑ█ˑˑ█ˑˑˑ█ˑˑ█ˑˑ█ˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑ██
█ˑˑˑˑˑˑ███ˑˑˑ█ˑ██ˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑˑ██ˑˑˑ█ˑˑˑˑ█ˑˑ█ˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑ█╚══════╗ˑˑ█ˑ██ˑ█ˑ█ˑˑ█ˑˑ█ˑˑˑˑ█ˑˑˑˑ█
█ˑˑˑˑˑˑ█ˑˑ█ˑ█ˑ█ˑ█ˑˑ██ˑˑ█ˑ██ˑ██ˑˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑ██ˑˑ██ˑ█ˑ█ˑ█╚╗ˑˑˑ██ˑ█ˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑ██
██ˑ██ˑˑ█ˑ█ˑˑ████ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑ█ˑ█ˑˑ█ˑ█ˑ█ˑ█║ˑˑ█ˑˑˑ█ˑ██ˑˑˑˑˑ█ˑ█ˑˑˑˑˑ██
██ˑˑˑˑ█ˑˑˑˑˑ█ˑ█ˑˑˑ█ˑ███ˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑˑˑˑˑˑˑˑ██ˑˑˑ█ˑˑˑˑ███ˑˑˑˑˑˑˑ█ˑˑ║ˑˑˑˑˑˑˑˑ█ˑˑˑ█ˑ█ˑˑ████ˑˑˑ█
██ˑ██ˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑ██ˑˑ█ˑˑˑˑˑ█ˑ█ˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ██ˑˑˑˑ██ˑ█ˑˑˑˑˑˑˑˑˑˑˑ║ˑˑ█ˑˑˑˑ█ˑˑˑˑ█ˑˑ█ˑˑˑˑ█ˑ█ˑ█
█ˑ█ˑˑˑˑ█ˑˑˑˑ██ˑˑ█ˑˑˑˑˑˑˑ█ˑˑ██ˑˑ█ˑˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑ█ˑˑ█ˑˑˑˑˑ██ˑˑ████ˑ██ˑ█ˑ█ˑˑ█ˑˑ║█ˑˑˑˑˑ█ˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑ█
████ˑˑˑˑ█ˑ██ˑˑˑˑˑ██ˑˑ█ˑˑˑ█ˑˑ█ˑ████ˑˑˑ██ˑˑˑˑˑˑˑˑ██ˑˑˑˑˑˑ█ˑˑ██ˑˑˑˑ█ˑ█ˑ█ˑˑˑ█ˑ██╚╗ˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑ█ˑ██ˑˑˑ██
█ˑ█ˑˑˑˑˑ█ˑˑˑˑˑˑ██ˑ█ˑˑ██ˑˑˑˑˑˑ██ˑ█ˑˑˑˑˑˑ█ˑˑˑˑ█ˑ█ˑˑˑ█ˑˑˑˑˑˑ██ˑ██ˑˑˑˑˑˑˑˑˑˑˑˑ█ˑ█║ˑˑˑˑ███ˑ█ˑˑ█ˑˑˑ█ˑˑˑ██ˑˑ█
█ˑ██ˑ███ˑˑ█ˑˑ█ˑˑ█ˑˑ█ˑˑˑˑˑ█ˑˑˑ█ˑˑˑ██ˑ██ˑˑ█ˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑ█ˑ█ˑˑˑˑˑ█ˑ█ˑ█ˑˑ█ˑˑˑ█ˑ║ˑˑ███ˑˑˑ███ˑˑ█ˑˑˑˑˑˑˑ█ˑ█
█ˑ█ˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑ██ˑˑˑˑ█ˑˑˑˑ█ˑˑˑ█ˑˑ██ˑ█ˑˑˑˑˑˑˑˑˑ██ˑˑˑ█ˑ█ˑ██ˑˑ█ˑˑˑ██ˑ█ˑˑˑ█ˑˑ║█ˑˑˑ███ˑˑ█ˑ█ˑˑˑ█ˑˑˑˑ██ˑ█
█ˑ█████ˑ█ˑˑˑ███ˑˑˑ█ˑˑ█ˑ██ˑ█ˑˑ██ˑˑˑˑ█ˑˑ█ˑˑˑˑˑˑˑˑ█ˑ█ˑ██ˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑ║█ˑ███ˑˑˑ███ˑˑˑˑ██ˑ███ˑˑ█
█ˑˑ██ˑ█ˑ█ˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑˑˑˑˑ██ˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑ█ˑ█ˑ█ˑ█ˑˑ███ˑˑˑˑˑ██ˑˑˑˑ█ˑ█║ˑˑˑˑˑ█ˑˑ█ˑ█ˑˑ█ˑˑˑˑˑ█ˑ█ˑ█
████ˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑ████████ˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑ█ˑˑˑˑˑ██ˑˑˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑ╚═══╗█ˑ█ˑˑˑ█ˑˑˑ██ˑ██ˑˑˑˑ█
██ˑˑˑˑˑˑˑˑˑˑˑ███ˑˑˑˑˑ█ˑˑˑˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑˑˑˑˑˑˑ█ˑˑ█ˑˑˑˑˑ█ˑˑˑ███ˑˑˑ█ˑˑ█ˑˑˑ█╚╗ˑˑˑˑˑˑˑˑ█ˑˑˑˑˑ█ˑˑˑ█
█ˑˑ█ˑ█ˑˑˑ██ˑ█ˑ██ˑˑ██ˑˑˑ█ˑ█ˑˑ██ˑˑ█ˑˑˑˑˑ█ˑ███ˑˑ█ˑˑˑˑ██ˑˑ█ˑˑˑ█ˑ█ˑˑ█ˑˑˑˑˑ██ˑˑ█ˑˑ█ˑˑˑˑ█╚═════╗ˑ█████ˑ█ˑˑˑˑ█
█ˑˑˑˑ█ˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑˑˑ█ˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑˑ█ˑ██ˑˑˑˑˑ█ˑˑ██ˑ█ˑˑˑˑ█ˑ█ˑˑˑˑˑ██ˑ██ˑˑˑˑˑˑ██ˑˑˑˑˑ█╚═╗ˑˑˑˑ██ˑ█ˑ██
█ˑˑ█ˑ█ˑˑ█ˑˑ█ˑˑˑˑˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑˑ█ˑˑ████ˑ█ˑˑ██ˑˑˑˑˑ█ˑˑˑ██ˑ█ˑˑˑˑˑˑˑˑ█ˑˑ█ˑˑˑ█ˑˑˑˑˑˑˑ██ˑ█╚═══╗ˑˑˑˑˑˑ█
█ˑˑˑ█ˑˑˑˑ███ˑ███ˑ█ˑˑˑˑˑ█ˑ█ˑ█ˑˑˑˑˑˑˑˑˑˑˑ█ˑ█ˑ█ˑˑˑˑˑˑˑˑ█ˑ█ˑ█ˑˑˑˑ██ˑˑˑˑ█ˑˑ█ˑ█ˑ█ˑˑˑ███ˑ█ˑˑ█ˑˑˑˑ█ˑˑ█╚═════♥█
██████████████████████████████████████████████████████████████████████████████████████████████████████

```
