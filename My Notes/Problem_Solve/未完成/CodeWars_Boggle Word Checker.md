# CodeWars:Boggle Word Checker:20211117:C#

[Reference](https://www.codewars.com/kata/57680d0128ed87c94f000bfd/csharp)



## Question

Write a function that determines whether a string is a valid guess in a Boggle board, as per the rules of Boggle. A Boggle board is a 2D array of individual characters, e.g.:

```javascript
[ ["I","L","A","W"],
  ["B","N","G","E"],
  ["I","U","A","O"],
  ["A","S","R","L"] ]
```

Valid guesses are strings which can be formed by connecting adjacent cells (horizontally, vertically, or diagonally) without re-using any previously used cells.

For example, in the above board "BINGO", "LINGO", and "ILNBIA" would all be valid guesses, while "BUNGIE", "BINS", and "SINUS" would not.

Your function should take two arguments (a 2D array and a string) and return true or false depending on whether the string is found in the array as per Boggle rules.

Test cases will provide various array and string sizes (squared arrays up to 150x150 and strings up to 150 uppercase letters). You do not have to check whether the string is a real word or not, only if it's a valid guess.

## My Solution

4 kyu 。 查了一下 [Boggle](https://en.wikipedia.org/wiki/Boggle)，簡單來說是一種桌遊，道具是多個上方印有英文字母的骰子，擲玩骰子後將其排列為矩形，接著玩家在相鄰的骰子間找單字的遊戲

題目算是依循了Boggle的規則但有所簡化:

1. 從矩形已經排列完成的階段開始
2. Q != QU
3. *相鄰* 代表上下左右以及斜方向
4. 不可以使用重複的字母
5. 題目不判斷是不是單字，僅判斷是否找得到



重點應該在於快速查找字母所在的位置，把矩陣整理成 字母=>座標 的map可能是個不錯的主意



### Solution version 1 timeout

```C#
public class Boggle
    {
        private readonly string word;
        private readonly Dictionary<char, List<(int, int)>> letterLocationMap;
        private readonly char[][] board;

        public Boggle(char[][] board, string word)
        {
            this.board = board;
            this.word = word;
            letterLocationMap = new Dictionary<char, List<(int, int)>>();
            for (int i = 0; i < board.Length; i++)
                for (int j = 0; j < board[i].Length; j++)
                {
                    if (!letterLocationMap.ContainsKey(board[i][j]))
                        letterLocationMap[board[i][j]] = new List<(int, int)>();
                    letterLocationMap[board[i][j]].Add((i, j));
                }
        }

        public bool Check()
        {
            char[] charArr = word.ToCharArray();
            if (!letterLocationMap.ContainsKey(word[0])) { return false; }
            if (word.Length == 1) { return true; }
            bool res = false;
            foreach ((int, int) position in letterLocationMap[word[0]])
            {
                res = res || FindNextChar(1, letterLocationMap.ToDictionary(e => e.Key, e => e.Value.ToList()), position);
                if (res) { break; }
            }
            return res;
        }

        private bool FindNextChar(int nextCharIndex, Dictionary<char, List<(int, int)>> dictionary, (int x, int y) currentPosition)
        {
            bool res = false;
            char currentChar = board[currentPosition.x][currentPosition.y];
            bool ok = dictionary[currentChar].Remove(currentPosition);
            if (nextCharIndex == word.Length) { return true; }
            dictionary[word[nextCharIndex]].Where(node => Math.Abs(node.Item1 - currentPosition.x) <= 1 && Math.Abs(node.Item2 - currentPosition.y) <= 1).
                ToList().ForEach(position => res = res || FindNextChar(nextCharIndex + 1, dictionary.ToDictionary(e => e.Key, e => e.Value.ToList()), position));
            return res;
        }
    }
```

幾乎是一氣呵成寫完的，有修改的只有兩個部分:

1. CodeWars目前還沒有支援C#9.0的`new()`寫法，所以最後還是把建構式的類別補上了
2. dictionary複製一開始沒寫好。寫成`letterLocationMap.ToDictionary(e => e.Key, e => e.Value)`，完全忘記我的value也是參考型別的`List`，導致我複製出來的Dictionary的Value都指向同樣的List...

然後進階測試又是喜聞樂見的Timeout



抱著僥倖的心態，稍微修改試試

把`FindNextChar`裡面的foreach改成有成功就直接回傳，雖然時間複雜度沒變，但是多少還是會省點時間

```C#
    public class Boggle
    {
        private readonly string word;
        private readonly Dictionary<char, List<(int, int)>> letterLocationMap;
        private readonly char[][] board;

        public Boggle(char[][] board, string word)
        {
            this.board = board;
            this.word = word;
            letterLocationMap = new Dictionary<char, List<(int, int)>>();
            for (int i = 0; i < board.Length; i++)
                for (int j = 0; j < board[i].Length; j++)
                {
                    if (!letterLocationMap.ContainsKey(board[i][j]))
                        letterLocationMap[board[i][j]] = new List<(int, int)>();
                    letterLocationMap[board[i][j]].Add((i, j));
                }
        }

        public bool Check()
        {
            char[] charArr = word.ToCharArray();
            if (!letterLocationMap.ContainsKey(word[0])) { return false; }
            if (word.Length == 1) { return true; }
            bool res = false;
            foreach ((int, int) position in letterLocationMap[word[0]])
            {
                res = res || FindNextChar(1, letterLocationMap.ToDictionary(e => e.Key, e => e.Value.ToList()), position);
                if (res) { break; }
            }
            return res;
        }

        private bool FindNextChar(int nextCharIndex, Dictionary<char, List<(int, int)>> dictionary, (int x, int y) currentPosition)
        {
            bool res = false;
            char currentChar = board[currentPosition.x][currentPosition.y];
            bool ok = dictionary[currentChar].Remove(currentPosition);
            if (nextCharIndex == word.Length) { return true; }
            List<(int, int)> positionList = dictionary[word[nextCharIndex]].
                Where(node => Math.Abs(node.Item1 - currentPosition.x) <= 1 && Math.Abs(node.Item2 - currentPosition.y) <= 1).ToList();
            foreach ((int,int)position in positionList)
            {
                res = res || FindNextChar(nextCharIndex + 1, dictionary.ToDictionary(e => e.Key, e => e.Value.ToList()), position);
                if (res) { return true; }
            }
            return res;
        }
    }
```

依然Timeout



### Solution version 2 timeout

認命重寫吧，首先先找出第一版最費時的部分，然後看看能不能避免:

1. 歷遍矩陣然後把值塞到Dictionary裡面
2. 多次的dictionary複製，並且裡面還有List.ToList()



第一點把值塞到Dictionary後另查詢效率增加了不少，我想應該有功過相抵，就先不動它了

至於第二點...

複製的原因-->因為會動到Dictionary並且會有重複執行的路徑，不希望前面的嘗試汙染到Dictionary進而影響後面的結果。

為何要動Dictionary?-->把走過的路線刪掉，避免重複走

是否有可以避免重複走又不用動到Dictionary的方法?



改用一個HashSet去記錄走過的路徑，雖然還是要每回複製，但大小比較小，不過同時也多了判斷座標是否在HashSet裡面的時間

總之試試看

```C#
   public class Boggle
    {
        private readonly string word;
        private readonly Dictionary<char, List<(int, int)>> letterLocationMap;
        private readonly char[][] board;

        public Boggle(char[][] board, string word)
        {
            this.board = board;
            this.word = word;
            letterLocationMap = new Dictionary<char, List<(int, int)>>();
            for (int i = 0; i < board.Length; i++)
                for (int j = 0; j < board[i].Length; j++)
                {
                    if (!letterLocationMap.ContainsKey(board[i][j]))
                        letterLocationMap[board[i][j]] = new List<(int, int)>();
                    letterLocationMap[board[i][j]].Add((i, j));
                }
        }

        public bool Check()
        {
            if (!letterLocationMap.ContainsKey(word[0])) { return false; }
            if (word.Length == 1) { return true; }
            bool res = false;
            foreach ((int, int) position in letterLocationMap[word[0]])
            {
                res = res || FindNextChar(1, position, new HashSet<(int, int)>());
                if (res) { break; }
            }
            return res;
        }

        private bool FindNextChar(int nextCharIndex, (int x, int y) currentPosition, HashSet<(int, int)> passedPositions)
        {
            if (nextCharIndex == word.Length) { return true; }
            passedPositions.Add(currentPosition);
            bool res = false;
            char currentChar = board[currentPosition.x][currentPosition.y];
            List<(int, int)> positionList = letterLocationMap[word[nextCharIndex]].
                Where(node => Math.Abs(node.Item1 - currentPosition.x) <= 1 && Math.Abs(node.Item2 - currentPosition.y) <= 1 && !passedPositions.Contains(node)).
                ToList();
            foreach ((int, int) position in positionList)
            {
                res = res || FindNextChar(nextCharIndex + 1, position, new HashSet<(int, int)>(passedPositions));
                if (res) { return true; }
            }
            return res;
        }
    }
```

還是timeout



### Solution version 3 random test failed

如果說，只存會用到的字母呢?

比如要找"AT"

A在p1和p2兩點

T在p3 p4 p5

我就存成{{p1,p2},{p3,p4,p5}}，如果某個字完全找不到出現空集合也可以提早結束

再來就是重複字的處理，目前還是只想得到在執行階段處理，就維持不變吧。

```C#
    public class Boggle
    {
        private readonly string word;
        private readonly Dictionary<char, List<(int, int)>> letterLocationMap;
        private readonly List<List<(int, int)>> charPositionList;

        public Boggle(char[][] board, string word)
        {
            charPositionList = new List<List<(int, int)>>();
            letterLocationMap = new Dictionary<char, List<(int, int)>>();
            for (int i = 0; i < board.Length; i++)
                for (int j = 0; j < board[i].Length; j++)
                {
                    if (!letterLocationMap.ContainsKey(board[i][j]))
                        letterLocationMap[board[i][j]] = new List<(int, int)>();
                    letterLocationMap[board[i][j]].Add((i, j));
                }
            this.word = word;
        }

        public bool Check()
        {
            foreach (char c in word)
            {
                if(!letterLocationMap.ContainsKey(c))
                    return false;
                List<(int, int)> charPosition = letterLocationMap[c];
                if (!(charPosition?.Any() ?? false)) { return false; }
                charPositionList.Add(charPosition);
            }
            if (word.Length == 1) { return true; }
            return FindNextChar();
        }

        private bool FindNextChar()
        {
            foreach ((int, int) position in charPositionList[0])
                if (FindNextChar(1, position, new List<(int, int)>()))
                    return true;
            return false;
        }

        private bool FindNextChar(int nextCharIndex, (int, int) currentPosition, List<(int, int)> passedPosition)
        {
            if (nextCharIndex == word.Length) { return true; }
            List<(int, int)> nextPositionList = charPositionList[nextCharIndex].Where(node => Math.Abs(node.Item1 - currentPosition.Item1) <= 1 && Math.Abs(node.Item2 - currentPosition.Item2) <= 1 && !passedPosition.Contains(node)).ToList();
            foreach ((int, int) position in nextPositionList)
                if (FindNextChar(nextCharIndex + 1, position, passedPosition.Append(currentPosition).ToList()))
                    return true;
            return false;
        }
    }
```

我還滿喜歡這個版本的，閱讀上簡潔扼要了許多，執行速度應該也有比較快一點，但可惜random test沒過，再慢慢來找原因吧。



### Solution version 4 timeout

找到錯誤了，是自己那格，`Math.Abs(node.Item1 - currentPosition.Item1) <= 1 && Math.Abs(node.Item2 - currentPosition.Item2) <= 1`沒有把原本的位置過濾掉!!

```C#
public class Boggle
{
    private readonly string word;
    private readonly Dictionary<char, List<(int, int)>> letterLocationMap;
    private readonly List<List<(int, int)>> charPositionList;

    public Boggle(char[][] board, string word)
    {
        charPositionList = new List<List<(int, int)>>();
        letterLocationMap = new Dictionary<char, List<(int, int)>>();
        for (int i = 0; i < board.Length; i++)
            for (int j = 0; j < board[i].Length; j++)
            {
                if (!letterLocationMap.ContainsKey(board[i][j]))
                    letterLocationMap[board[i][j]] = new List<(int, int)>();
                letterLocationMap[board[i][j]].Add((i, j));
            }
        this.word = word;
    }

    public bool Check()
    {
        foreach (char c in word)
        {
            if (!letterLocationMap.ContainsKey(c)) { return false; }
            List<(int, int)> charPosition = letterLocationMap[c];
            if (!(charPosition?.Any() ?? false)) { return false; }
            charPositionList.Add(charPosition);
        }
        if (word.Length == 1) { return true; }
        return FindNextChar();
    }

    private bool FindNextChar()
    {
        foreach ((int, int) position in charPositionList[0])
            if (FindNextChar(1, position, new List<(int, int)>()))
                return true;
        return false;
    }

    private bool FindNextChar(int nextCharIndex, (int, int) currentPosition, List<(int, int)> passedPosition)
    {
        passedPosition.Add(currentPosition);
            List<(int, int)> nextPositionList = charPositionList[nextCharIndex].Where(node => Math.Abs(node.Item1 - currentPosition.Item1)<= 1 && Math.Abs(node.Item2 - currentPosition.Item2) <= 1 && !passedPosition.Contains(node)).ToList();
        if (!nextPositionList.Any()) { return false; }
        if (nextCharIndex == word.Length - 1) { return true; }
        foreach ((int, int) position in nextPositionList)
            if (FindNextChar(nextCharIndex + 1, position, passedPosition.ToList()))
                return true;
        return false;
    }
}
```

為什麼還是timeout，都可以執行到random test了...

掙扎下把`passedPosition`改成HashSet，看能不能過

```C#
public class Boggle
{
    private readonly string word;
    private readonly Dictionary<char, List<(int, int)>> letterLocationMap;
    private readonly List<List<(int, int)>> charPositionList;

    public Boggle(char[][] board, string word)
    {
        charPositionList = new List<List<(int, int)>>();
        letterLocationMap = new Dictionary<char, List<(int, int)>>();
        for (int i = 0; i < board.Length; i++)
            for (int j = 0; j < board[i].Length; j++)
            {
                if (!letterLocationMap.ContainsKey(board[i][j]))
                    letterLocationMap[board[i][j]] = new List<(int, int)>();
                letterLocationMap[board[i][j]].Add((i, j));
            }
        this.word = word;
    }

    public bool Check()
    {
        foreach (char c in word)
        {
            if (!letterLocationMap.ContainsKey(c)) { return false; }
            List<(int, int)> charPosition = letterLocationMap[c];
            if (!(charPosition?.Any() ?? false)) { return false; }
            charPositionList.Add(charPosition);
        }
        if (word.Length == 1) { return true; }
        return FindNextChar();
    }

    private bool FindNextChar()
    {
        foreach ((int, int) position in charPositionList[0])
            if (FindNextChar(1, position, new HashSet<(int, int)>()))
                return true;
        return false;
    }

    private bool FindNextChar(int nextCharIndex, (int, int) currentPosition, HashSet<(int, int)> passedPosition)
    {
        passedPosition.Add(currentPosition);
            List<(int, int)> nextPositionList = charPositionList[nextCharIndex].Where(node => Math.Abs(node.Item1 - currentPosition.Item1)<= 1 && Math.Abs(node.Item2 - currentPosition.Item2) <= 1 && !passedPosition.Contains(node)).ToList();
        if (!nextPositionList.Any()) { return false; }
        if (nextCharIndex == word.Length - 1) { return true; }
        foreach ((int, int) position in nextPositionList)
            if (FindNextChar(nextCharIndex + 1, position, passedPosition.ToHashSet()))
                return true;
        return false;
    }
}
```

結果是依然不行

改用`Any()`，減少一次`ToList()`，其實我並不確定這樣做會不會比較快，因為我不曉得`Any()`的實作邏輯是不是只要找到第一個true就會回傳，還是要等到全部跑一遍才判斷。

```C#
public class Boggle
{
    private readonly string word;
    private readonly Dictionary<char, List<(int, int)>> letterLocationMap;
    private readonly List<List<(int, int)>> charPositionList;

    public Boggle(char[][] board, string word)
    {
        charPositionList = new List<List<(int, int)>>();
        letterLocationMap = new Dictionary<char, List<(int, int)>>();
        for (int i = 0; i < board.Length; i++)
            for (int j = 0; j < board[i].Length; j++)
            {
                if (!letterLocationMap.ContainsKey(board[i][j]))
                    letterLocationMap[board[i][j]] = new List<(int, int)>();
                letterLocationMap[board[i][j]].Add((i, j));
            }
        this.word = word;
    }

    public bool Check()
    {
        foreach (char c in word)
        {
            if (!letterLocationMap.ContainsKey(c)) { return false; }
            charPositionList.Add(letterLocationMap[c]);
        }
        if (word.Length == 1) { return true; }
        return charPositionList[0].Any(node => FindNextChar(1, node, new HashSet<(int, int)>()));
    }

    private bool FindNextChar(int nextCharIndex, (int, int) currentPosition, HashSet<(int, int)> passedPosition)
    {
        passedPosition.Add(currentPosition);
        if (nextCharIndex == word.Length) { return true; }
            return charPositionList[nextCharIndex].Where(node => Math.Abs(node.Item1 - currentPosition.Item1) <= 1 && Math.Abs(node.Item2 - currentPosition.Item2) <= 1 && !passedPosition.Contains(node)).Any(node => FindNextChar(nextCharIndex + 1, node, passedPositionToHashSet()));
    }
}
```

linq變長了，開心，但還是timeout



### Solution version 5 timeout

```C#
public class Boggle
{
    private readonly string word;
    private readonly Dictionary<char, List<(int, int)>> letterLocationMap;

    public Boggle(char[][] board, string word)
    {
        letterLocationMap = new Dictionary<char, List<(int, int)>>();
        for (int i = 0; i < board.Length; i++)
            for (int j = 0; j < board[i].Length; j++)
            {
                if (!word.Contains(board[i][j])) { continue; }
                if (!letterLocationMap.ContainsKey(board[i][j]))
                    letterLocationMap[board[i][j]] = new List<(int, int)>();
                letterLocationMap[board[i][j]].Add((i, j));
            }
        this.word = word;
    }

    public bool Check()
    {
        foreach (char c in word)
            if (!letterLocationMap.ContainsKey(c)) { return false; }
        if (word.Length == 1) { return true; }
        return letterLocationMap[word[0]].Any(node => FindNextChar(1, node, new HashSet<(int, int)>()));
    }

    private bool FindNextChar(int nextCharIndex, (int, int) currentPosition, HashSet<(int, int)> passedPosition)
    {
        passedPosition.Add(currentPosition);
        if (nextCharIndex == word.Length) { return true; }
            return letterLocationMap[word[nextCharIndex]].Where(node => Math.Abs(node.Item1 - currentPosition.Item1) <= 1 && Math.Abs(node.Item2 - currentPosition.Item2) <= 1 && !passedPosition.Contains(node)).Any(node => FindNextChar(nextCharIndex + 1, node,passedPosition.ToHashSet()));
    }
}
```



## Better Solutions





