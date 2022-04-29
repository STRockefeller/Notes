# CodeWars:Pick peaks:20220429:CPP

[Reference](https://www.codewars.com/kata/5279f6fe5ab7f447890006a7)



## Question

In this kata, you will write a function that returns the positions and the values of the "peaks" (or local maxima) of a numeric array.

For example, the array `arr = [0, 1, 2, 5, 1, 0]` has a peak at position `3` with a value of `5` (since `arr[3]` equals `5`).

The output will be returned as an object of type `PeakData` which has two members: `pos` and `peaks`. Both of these members should be `vector<int>`s. If there is no peak in the given array then the output should be a `PeakData` with an empty vector for both the `pos` and `peaks` members.

`PeakData` is defined in Preloaded as follows:

```cpp
struct PeakData {
  vector<int> pos, peaks;
};
```

Example: `pickPeaks([3, 2, 3, 6, 4, 1, 2, 3, 2, 1, 2, 3])` should return `{pos: [3, 7], peaks: [6, 3]}` (or equivalent in other languages)

All input arrays will be valid integer arrays (although it could still be empty), so you won't need to validate the input.

The first and last elements of the array will not be considered as peaks (in the context of a mathematical function, we don't know what is after and before and therefore, we don't know if it is a peak or not).

Also, beware of plateaus !!! `[1, 2, 2, 2, 1]` has a peak while `[1, 2, 2, 2, 3]` and `[1, 2, 2, 2, 2]` do not. In case of a plateau-peak, please only return the position and value of the beginning of the plateau. For example: `pickPeaks([1, 2, 2, 2, 1])` returns `{pos: [1], peaks: [2]}` (or equivalent in other languages)

Have fun!

## My Solution

感覺有種既視感，我可能有做過類似題?又或者也可能是老毛病發作，看啥都眼熟

不管，總之來抓個重點:

1. 頭尾不算peak
2. 等高取最左邊的位置



分析一下，我們只找peak，一定是先上升後下降，用一個flag去記錄上升過的狀態，下降時確認上升flag是否為true，就知道有peak了，抓到後再把flag還原

但是[1, 2, 2, 2, 1]的情況會在index3->4的時候才發現peak，就找不到題目想要的position了，先試著用一個變數紀錄最後數字變動的位置好了

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <vector>

using namespace std;

PeakData pick_peaks(const vector<int> &v)
{
    PeakData result;

    bool increaseFlag = false;
    int previousNum = v[0];
    int unchangedIndex = 0;

    for (int i = 0; i < v.size(); i++)
    {
        if (v[i] > previousNum)
        {
            increaseFlag = true;
            unchangedIndex = i;
        }
        else if (v[i] < previousNum)
        {
            if (increaseFlag)
            {
                // a peak here
                result.pos.push_back(unchangedIndex);
                result.peaks.push_back(v[unchangedIndex]);
                increaseFlag = false;
            }
            unchangedIndex = i;
        }
            previousNum = v[i];
    }
    return result;
}
```

一次過 easy game easy life

## Better Solutions

### Solution1

```cpp
#include <iostream>
#include <vector>
using namespace std;

PeakData pick_peaks(vector<int> v) {
  PeakData result;
  int i, t;
  for (t=0, i=1; i<v.size(); i++)
    if (v[i]>v[i-1]) t=i;
    else if (t && v[i]<v[i-1]) result.pos.push_back(t), result.peaks.push_back(v[t]), t=0;
  return result;
}
```

和我的寫法邏輯差不多 `t` 就相當於 `increaseFlag`，然後發現我的`previousNum`真的很多餘，直接`v[i-1]`多好啊。i的index從1開始，可以少進一次迴圈，讚讚。
