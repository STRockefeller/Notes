# CodeWars:Counting Change Combinations:20220302:C++

[Reference](https://www.codewars.com/kata/541af676b589989aed0009e7/cpp)

4kyu

## Question

Write a function that counts how many different ways you can make change for an amount of money, given an array of coin denominations. For example, there are 3 ways to give change for 4 if you have coins with denomination 1 and 2:

```
1+1+1+1, 1+1+2, 2+2.
```

The order of coins does not matter:

```
1+1+2 == 2+1+1
```

Also, assume that you have an infinite amount of coins.

Your function should take an amount to change and an array of unique denominations for the coins:

```cpp
  count_change(4, {1,2}) // => 3
  count_change(10, {5,2,3}) // => 4
  count_change(11, {5,7}) // => 0
```

## My Solution

用後面的數字組成目標值，題目很好懂，但又沒頭緒。

同樣先從範例找規律

```cpp
  count_change(4, {1,2}) // => 3
  count_change(10, {5,2,3}) // => 4
  count_change(11, {5,7}) // => 0
```

$$
4\\=1+1+1+1=1\times 4\\=1+1+2=1\times 2+2\\=2+2=2\times 2
$$

$$
10\\=2+2+2+2+2=2\times 4\\=2+2+3+3=2\times 2+3\times 2\\=2+3+5\\=5+5=5\times 2
$$

似乎可以用先決定一個硬幣來簡化問題，例如4,{1,2}的case，假如第一個選1，就會變成3,{1,2}的case，第一個選2則是2{1,2}

所以得到

```cpp
count_change(4, {1,2}) = count_change(3, {1,2}) + count_change(2, {1,2})
```

再接著拆

```cpp
count_change(3, {1,2}) + count_change(2, {1,2}) = count_change(2, {1,2}) + count_change(1, {1,2}) + count_change(1, {1,2}) + count_change(0, {1,2})
```

`count_change(0, {1,2})`目標是0答案為1種

答案為 2+1+1+1 = 5 種，很好，錯了

應該是順序的關係，先1再2應該和先2再1被視為一樣的情況才對，1+1+2,1+2+1,2+1+1被我視為三種，所以一共多了兩種。

問題是該如何知道哪些是多出來的。

假如我把順序記下，最後在把這些順序中有重複的部分去除

後面我把`count_change`簡化成`c`，不然寫起來好麻煩

c(4,{1,2}) => c(3,{1,2}) , arr=[1] and c(2,{1,2}) arr=[2]

=> c(2{1,2}) , arr=[1,1] and c(1{1,2}), arr = [1,2] and c(1,{1,2}) arr=[2,1] and c(0,{1,2}) arr=[2,2] => 0作為答案提出來 ans = [[2,2]]

=> ...



似乎，有搞頭。

先來試試

```cpp
#include <vector>
unsigned long long countChange(const unsigned int money, const std::vector<unsigned int>& coins) {
  // your code here
}

```

出師不利，先來查查`unsigned long long`是尛

[MSDN](https://docs.microsoft.com/zh-tw/cpp/cpp/data-type-ranges?view=msvc-170)

![](https://i.imgur.com/UWsEFPc.png)

簡單來說就是非常非常非常大的非負整數



```cpp
#include <vector>
#include <iostream>
using namespace std;

void printCombinations(vector<vector<unsigned int>> combinations)
{
    for (auto &combination : combinations)
    {
        for (auto &coin : combination)
        {
            cout << coin << " ";
        }
        cout << endl;
    }
}

unsigned long long parseCombinations(vector<vector<unsigned int>> combinations)
{
    printCombinations(combinations);
    return combinations.size();
}

vector<vector<unsigned int>> subCountChange(const unsigned int money, const vector<unsigned int> &coins, vector<unsigned int> history)
{
    vector<vector<unsigned int>> combinations;
    if (money == 0)
    {
        combinations.emplace_back(history);
        return combinations;
    }
    for (auto &coin : coins)
    {
        if (money >= coin)
        {
            history.emplace_back(coin);
            vector<vector<unsigned int>> subCombinations = subCountChange(money - coin, coins, history);
            combinations.emplace_back(subCombinations);
        }
    }
    return combinations;
}

unsigned long long countChange(const unsigned int money, const vector<unsigned int> &coins)
{
    vector<vector<unsigned int>> combinations;
    combinations = subCountChange(money, coins, vector<unsigned int>());

    return parseCombinations(combinations);
}

int main(void)
{
    vector<unsigned int> coins{2, 3, 5};
    countChange(10, coins);
    return 0;
}
```

先寫了一部份來測試，結果編譯出錯在參考的部分= =

![](https://i.imgur.com/4UnjSYr.png)



## Better Solutions

