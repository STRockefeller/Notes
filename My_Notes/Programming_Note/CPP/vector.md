# Vector

#cpp

References:

<https://www.programiz.com/cpp-programming/vectors>

<https://mropengate.blogspot.com/2015/07/cc-vector-stl.html>

<https://www.gushiciku.cn/pl/gxZH/zh-tw>

## Abstract

早先有針對這個部分寫過筆記，但實在不是很齊全，只能說是堪用。

再次閱讀發現細節部分相當的模糊，因此決定重新學習並且記錄一遍。

> In C++, vectors are used to store elements of similar data types. However, unlike arrays, the size of a vector can grow dynamically.
>
> That is, we can change the size of the vector during the execution of a program as per our requirements.

## Include

Vectors are part of the C++ Standard Template Library. To use vectors, we need to include the `vector` header file in our program.

```cpp
#include <vector>
```

## Declaration

```cpp
std::vector<T> vector_name;
```

ex

```cpp
vector<int> nums;
```

宣告的時候無須指定size，因為這個結構會動態增長size，可以想像成跟C#的List或Golang的Slice類似的情況。

## Initialization

```cpp
vector<int> nums = {1, 2, 3};
```

```cpp
vector<int> nums {1, 2, 3};
```

```cpp
vector<int> nums(3,5);
```

第一個參數是size，第二個是初始值，最後會得到 `{5, 5, 5}`

這幾種算是比較常用的。當然也會有比較不常用的，不過還是都記錄下來。

在[官方文件(?)](https://www.cplusplus.com/reference/vector/vector/vector/)中找到vector的建構子說明，基本上可以從範例中很清楚地了解到各個建構子的用法。

```cpp
// constructing vectors
#include <iostream>
#include <vector>

int main ()
{
  // constructors used in the same order as described above:
  std::vector<int> first;                                // empty vector of ints
  std::vector<int> second (4,100);                       // four ints with value 100
  std::vector<int> third (second.begin(),second.end());  // iterating through second
  std::vector<int> fourth (third);                       // a copy of third

  // the iterator constructor can also be used to construct from arrays:
  int myints[] = {16,2,77,29};
  std::vector<int> fifth (myints, myints + sizeof(myints) / sizeof(int) );

  std::cout << "The contents of fifth are:";
  for (std::vector<int>::iterator it = fifth.begin(); it != fifth.end(); ++it)
    std::cout << ' ' << *it;
  std::cout << '\n';

  return 0;
}
```

## Methods

常用方法速記表

* `vec[i]`- 存取索引值為 i 的元素值。
* `vec.at(i)`- 存取索引值為 i 的元素的值，
* `vec.front()`- 回傳 vector 第一個元素的值。
* `vec.back()`- 回傳 vector 最尾元素的值。
* `vec.push_back()`- 新增元素至 vector 的尾端，必要時會進行記憶體配置。
* `vec.pop_back()`- 刪除 vector 最尾端的元素。
* `vec.insert()`- 插入一個或多個元素至 vector 內的任意位置。
* `vec.erase()`- 刪除 vector 中一個或多個元素。
* `vec.clear()`- 清空所有元素。
* `vec.empty()`- 如果 vector 內部為空，則傳回 true 值。
* `vec.size()`- 取得 vector 目前持有的元素個數。
* `vec.resize()`- 改變 vector 目前持有的元素個數。
* `vec.capacity()`- 取得 vector 目前可容納的最大元素個數。這個方法與記憶體的配置有關，它通常只會增加，不會因為元素被刪減而隨之減少。
* `vec.reserve()`- 如有必要，可改變 vector 的容量大小（配置更多的記憶體）。在眾多的 STL 實做，容量只能增加，不可以減少。
* `vec.begin()`- 回傳一個 iterator，它指向 vector 第一個元素。
* `vec.end()`- 回傳一個 iterator，它指向 vector 最尾端元素的下一個位置（請注意：它不是最末元素）。
* `vec.rbegin()`- 回傳一個反向 iterator，它指向 vector 最尾端元素的。
* `vec.rend()`- 回傳一個 iterator，它指向 vector 的第一個元素。

### emplace_back() vs push_back()

參考這邊<https://www.gushiciku.cn/pl/gxZH/zh-tw>
