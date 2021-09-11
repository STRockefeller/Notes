# CodeWars:Path Finder #2: shortest path:20210911:C#

[Reference](https://www.codewars.com/kata/57658bfa28ed87ecfa00058a)



## Question

### Task

You are at position `[0, 0]` in maze NxN and you can **only** move in one of the four cardinal directions (i.e. North, East, South, West). Return the minimal number of steps to exit position `[N-1, N-1]` *if* it is possible to reach the exit from the starting position. Otherwise, return `-1`.

Empty positions are marked `.`. Walls are marked `W`. Start and exit positions are guaranteed to be empty in all test cases.

### Path Finder Series:

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

---

好吧，我承認這題沒想像中的簡單，來想想新的遞迴模式吧

* 多傳入方向，不走回頭路==>不行，形成環形loop就走不出去了
* 走完之後移除這次的標記==>可以考慮





## Better Solutions

