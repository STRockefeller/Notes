# CodeWars:Path Finder #3: the Alpinist:20210922:C#

[Reference](https://www.codewars.com/kata/576986639772456f6f00030c)



## Question

### Task

You are at start location `[0, 0]` in mountain area of NxN and you can **only** move in one of the four cardinal directions (i.e. North, East, South, West). Return minimal number of `climb rounds` to target location `[N-1, N-1]`. Number of `climb rounds` between adjacent locations is defined as difference of location altitudes (ascending or descending).

Location altitude is defined as an integer number (0-9).

### Path Finder Series:

- [#1: can you reach the exit?](https://www.codewars.com/kata/5765770e190b1472ec0022a2)
- [#2: shortest path](https://www.codewars.com/kata/57657bfa27ed77ecfa00057a)
- [#3: the Alpinist](https://www.codewars.com/kata/576976639772456f6f00030c)
- [#4: where are you?](https://www.codewars.com/kata/5a0573c446d7435b7e00009f)
- [#5: there's someone here](https://www.codewars.com/kata/5a05969cba2a14e541000129)

## My Solution

第二關的時候使用第一關的解答進行修改反而好像增加了難度，這次就不管上一次寫了甚麼，當作一個全新的挑戰吧。

首先比起之前，這次不再是牆壁和空地這麼單純了，在此之上加入了高度系統，無論高度相差多少都可以前進，目標則改成找最短的垂直路徑。

上次的解答已經遊走在超時的邊緣了，這次更是必須注意壓縮執行時間。



先考慮目前想得到的極端情況，走S型最短，例如

```
010001
010101
010101
010101
010101
000100
```

或者

```
77777
00007
77777
70000
77777
```



先以區塊的角度下去考慮，將同高度的相鄰格視作一個區塊

* 區塊的結構

  * 區塊高度(int)
  * 區塊中內涵的座標點(hash set?)
  * 相鄰的區塊(指標?)
  * 是否包含終點(bool)

* 區塊的劃分

  * 先以一個hash set 紀錄未劃分區塊
  * 按順序(可能是從左上到右下之類的)把區塊找出來

* 找相鄰的區塊

* 路徑

  * 找到每個區塊之間移動得最短路徑，例如

    ```
    A(0)-->C(2)-->B(1) ==>3
    A(0)-->B(1) ==>1
    
    則區塊A到區塊B最短路徑為1
    ```

  * 取包含起點的區塊和包含終點的區塊的最短路徑回傳



雛形是有了，但感覺難度不低，雖然細節還沒想好，不過先寫寫看吧

---

找最短路徑的部分有點卡關，先想個較為複雜的案例來解看看

假設要找左上到右下區塊的最短距離

```
0777759
0123555
0006655
```

路徑分別是

* 0-7-5==>9
* 0-1-2-3-5==>5
* 0-2-3-5==>5
* 0-6-5==>7

刻意將最短路徑設計在非最少經過區塊的路徑上

也就是如果從相鄰的路徑一次次找的話，再全部路徑走完前依然無法確認最短路徑

---

不管怎麼說，歷遍都是最終手段，能避免最好

沿用剛剛想得例子

自己跟相鄰的區塊以外集合成"需要找最短路徑的區塊"

```
-----59
---3555
-----55
```

然後再把被"不需要找路徑區塊"包圍住的區塊移除(這個例子中沒有)

然後先處理"相鄰區塊只剩一個需要找路徑的區塊"(就是中間的3)

找到他的最短路徑是3

重複這個流程

---

測試失敗

```
010
101
010
```

無解

因為找不到"相鄰區塊只剩一個需要找路徑的區塊"，試試放寬條件吧...

---

第一版完成，於電腦跑基礎測試14ms

```C#
public static int PathFinder(string maze)
        {
            string[] mazeLines = maze.Split('\n');
            int n = mazeLines.Length;
            char[][] mazeCharArr = new char[n][];
            Group origin;
            Group final = new Group(0);
            HashSet<(int, int)> notGrouped = new HashSet<(int, int)>();
            for (int i = 0; i < n; i++)
            {
                mazeCharArr[i] = mazeLines[i].ToCharArray();
                for (int j = 0; j < n; j++)
                    notGrouped.Add((i, j));
            }
            List<Group> groups = new List<Group>();
            for (int i = 0; i < n; i++)
                for (int j = 0; j < n; j++)
                    if (notGrouped.Contains((i, j)))
                        GroupMaze((i, j));

            origin = groups[0];
            if (origin == final)
                return 0;

            foreach (Group g in groups)
                foreach (Group gn in g.neibghors)
                    gn.neibghors.Add(g);
            foreach (Group g in groups)
                foreach (Group gn in g.neibghors)
                    if (!g.shortestPath.ContainsKey(gn))
                        g.shortestPath.Add(gn, Math.Abs(gn.height - g.height));

            if (origin.neibghors.Contains(final))
            {
                origin.shortestPath.TryGetValue(final, out int res);
                return res;
            }

            HashSet<Group> toFindPath = new HashSet<Group>();
            foreach (Group g in groups)
                if (g != origin && !origin.neibghors.Contains(g))
                    toFindPath.Add(g);
            while (toFindPath.Count != 0)
            {
                //toFindPath.RemoveWhere(g => g.neibghors.All(gn => !toFindPath.Contains(gn)) && g != final);
                HashSet<Group> toParse = toFindPath.Where(g=>g.neibghors.All(gn=>!toFindPath.Contains(gn))).ToHashSet();
                if (toParse.Count() == 0)
                {
                    toParse = toFindPath.Where(g => g.neibghors.Where(gn => toFindPath.Contains(gn)).Count() == 1).ToHashSet();
                    toParse.Remove(final);
                }
                if (toParse.Count() == 0)
                {
                    toParse = toFindPath.Where(g => g.neibghors.Where(gn => toFindPath.Contains(gn)).Count() == 2).ToHashSet();
                    toParse.Remove(final);
                }
                if (toParse.Count() == 0)
                    break;
                foreach (Group g in toParse)
                {
                    int shortest = int.MaxValue;
                    foreach (Group gn in g.neibghors)
                    {
                        if (toFindPath.Contains(gn))
                            continue;
                        origin.shortestPath.TryGetValue(gn, out int path1);
                        g.shortestPath.TryGetValue(gn, out int path2);
                        int path = path1 + path2;
                        shortest = path < shortest ? path : shortest;
                    }
                    if (shortest == int.MaxValue)
                        continue;
                    if (g == final)
                        return shortest;
                    origin.shortestPath.Add(g, shortest);
                    toFindPath.Remove(g);
                }
            }

            void GroupMaze((int x, int y) point)
            {
                Group group = new Group(mazeCharArr[point.x][point.y]);
                FindGroupPoints(point, group);
                groups.Add(group);
            }
            void FindGroupPoints((int x, int y) point, Group group)
            {
                notGrouped.Remove(point);
                group.points.Add(point);
                if (point.x == n - 1 && point.y == n - 1)
                    final = group;
                if (point.x > 0)
                    parsePoint((point.x - 1, point.y));
                if (point.x < n - 1)
                    parsePoint((point.x + 1, point.y));
                if (point.y > 0)
                    parsePoint((point.x, point.y - 1));
                if (point.y < n - 1)
                    parsePoint((point.x, point.y + 1));

                void parsePoint((int x, int y) p)
                {
                    if (notGrouped.Contains(p))
                    {
                        if (mazeCharArr[p.x][p.y] == group.height)
                            FindGroupPoints(p, group);
                    }
                    else if (!group.points.Contains(p))
                        group.neibghors.Add(groups.Where(g => g.points.Contains(p)).Single());
                }
            }

            return -1;
        }
```

```C#
    internal class Group
    {
        internal int height;
        internal HashSet<(int, int)> points;
        internal HashSet<Group> neibghors;

        internal Dictionary<Group, int> shortestPath;

        internal Group(int height)
        {
            points = new HashSet<(int, int)>();
            neibghors = new HashSet<Group>();
            shortestPath = new Dictionary<Group, int>();
            shortestPath.Add(this, 0);
            this.height = height;
        }
    }
```

基本測試花了2095ms，隨機測試沒過

![](https://i.imgur.com/xQqIfm2.png)

但是這題沒有給測試案例，所以也不知道怎麼錯的







## Better Solutions

