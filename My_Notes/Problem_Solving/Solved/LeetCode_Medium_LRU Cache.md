# LeetCode:146:20230718:cpp

tags: #problem_solve #leetcode/medium #cache #cpp #linked_list #hash_set

[Reference](https://leetcode.com/problems/lru-cache/)

## Question

Design a data structure that follows the constraints of a [Least Recently Used (LRU) cache](https://en.wikipedia.org/wiki/Cache_replacement_policies#LRU).

Implement the LRUCache class:

`LRUCache(int capacity)` Initialize the LRU cache with positive size capacity.
`int get(int key)` Return the value of the key if the key exists, otherwise return -1.
`void put(int key, int value)` Update the value of the key if the key exists. Otherwise, add the key-value pair to the cache. If the number of keys exceeds the capacity from this operation, evict the least recently used key.
The functions get and put must each run in O(1) average time complexity.

Example 1:

```text
Input
["LRUCache", "put", "put", "get", "put", "get", "put", "get", "get", "get"]
[[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]
Output
[null, null, null, 1, null, -1, null, -1, 3, 4]

Explanation
LRUCache lRUCache = new LRUCache(2);
lRUCache.put(1, 1); // cache is {1=1}
lRUCache.put(2, 2); // cache is {1=1, 2=2}
lRUCache.get(1);    // return 1
lRUCache.put(3, 3); // LRU key was 2, evicts key 2, cache is {1=1, 3=3}
lRUCache.get(2);    // returns -1 (not found)
lRUCache.put(4, 4); // LRU key was 1, evicts key 1, cache is {4=4, 3=3}
lRUCache.get(1);    // return -1 (not found)
lRUCache.get(3);    // return 3
lRUCache.get(4);    // return 4
```

Constraints:

1 <= capacity <= 3000
0 <= key <= $10^4$
0 <= value <= $10^5$
At most $2 * 10^5$ calls will be made to get and put.

## My Solution

```cpp
#include <iostream>
#include <unordered_map>
#include <list>

using namespace std;

class LRUCache
{
private:
    int capacity;
    unordered_map<int, pair<int, list<int>::iterator>> cache;
    list<int> lruList;

    void putNewItem(int key, int value)
    {
        if (cache.size() == capacity)
        {
            cache.erase(lruList.back());
            lruList.pop_back();
        }
        lruList.push_front(key);
        cache[key] = {value, lruList.begin()};
    }

    void putExistingItem(int key, int value)
    {
        lruList.erase(cache[key].second);
        lruList.push_front(key);
        cache[key] = {value, lruList.begin()};
    }

    void arrangeListAfterGet(int key)
    {
        lruList.erase(cache[key].second);
        lruList.push_front(key);
        cache[key].second = lruList.begin();
    }

public:
    LRUCache(int capacity)
    {
        this->capacity = capacity;
    }

    int get(int key)
    {
        if (cache.count(key) == 0)
        {
            return -1;
        }

        arrangeListAfterGet(key);

        return cache[key].first;
    }

    void put(int key, int value)
    {
        if (cache.count(key) == 0)
        {
            putNewItem(key, value);
            return;
        }

        putExistingItem(key, value);
    }
};

/**
 * Your LRUCache object will be instantiated and called as such:
 * LRUCache* obj = new LRUCache(capacity);
 * int param_1 = obj->get(key);
 * obj->put(key,value);
 */
 ```

result:

![image](https://i.imgur.com/rRK1WrS.png)

## Better Solutions
