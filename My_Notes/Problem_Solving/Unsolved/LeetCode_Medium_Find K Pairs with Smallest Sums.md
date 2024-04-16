# LeetCode:373:20230627:dart

tags: #problem_solve #dart #algorithms #priority_queue #heap #leetcode/medium 

[Reference](https://leetcode.com/problems/find-k-pairs-with-smallest-sums/)

## Question

You are given two integer arrays `nums1` and `nums2` sorted in **ascending order** and an integer `k`.

Define a pair `(u, v)` which consists of one element from the first array and one element from the second array.

Return _the_ `k` _pairs_ `(u1, v1), (u2, v2), ..., (uk, vk)` _with the smallest sums_.

**Example 1:**

**Input:** nums1 = [1,7,11], nums2 = [2,4,6], k = 3
**Output:** [[1,2],[1,4],[1,6]]
**Explanation:** The first 3 pairs are returned from the sequence: [1,2],[1,4],[1,6],[7,2],[7,4],[11,2],[7,6],[11,4],[11,6]

**Example 2:**

**Input:** nums1 = [1,1,2], nums2 = [1,2,3], k = 2
**Output:** [[1,1],[1,1]]
**Explanation:** The first 2 pairs are returned from the sequence: [1,1],[1,1],[1,2],[2,1],[1,2],[2,2],[1,3],[1,3],[2,3]

**Example 3:**

**Input:** nums1 = [1,2], nums2 = [3], k = 3
**Output:** [[1,3],[2,3]]
**Explanation:** All possible pairs are returned from the sequence: [1,3],[2,3]

**Constraints:**

- `1 <= nums1.length, nums2.length <= 10^5`
- `-10^9 <= nums1[i], nums2[i] <= 10^9`
- `nums1` and `nums2` both are sorted in **ascending order**.
- `1 <= k <= 10^4`

## My Solution

Use a simplified [[Priority Queue (Heap)|priority queue]] to solve it.

```dart
class Solution {
  List<List<int>> kSmallestPairs(List<int> nums1, List<int> nums2, int k) {
    MinHeap heap = new MinHeap();
    nums1.forEach((u) {
      nums2.forEach((v) {
        heap.insert(Node([u, v]));
      });
    });
    return heap.outPut(k).map((e) => e.pair).toList();
  }
}

class Node {
  late int sum;
  List<int> pair;
  Node(this.pair) {
    sum = this.pair.reduce((value, element) => value + element);
  }
}

class MinHeap {
  // index 0 is not used
  List<Node> heapList = [Node([9999999999,9999999999])];

  void insert(Node node) {
    heapList.add(node);
    _bubbleUp(heapList.length - 1); // from the last one
  }

  void _bubbleUp(int currentIndex) {
    if (currentIndex <= 1) {
      return;
    }

    int parentIndex = currentIndex ~/ 2;
    if (heapList[parentIndex].sum > heapList[currentIndex].sum) {
      // swap them
      Node temp = heapList[parentIndex];
      heapList[parentIndex] = heapList[currentIndex];
      heapList[currentIndex] = temp;

      _bubbleUp(parentIndex);
    }
  }

  List<Node> outPut(int elementCount) {
    return heapList.sublist(1).take(elementCount).toList();
  }
}

```

failed with following case:

```
Input

nums1 =

[1,2,4,5,6]

nums2 =

[3,5,7,9]

k =

3

Use Testcase

Output

[[1,3],[2,3],[2,5]]

Expected

[[1,3],[2,3],[1,5]]
```

---

I forgot to implement the remove method of the heap...

```dart
class Solution {
  List<List<int>> kSmallestPairs(List<int> nums1, List<int> nums2, int k) {
    MinHeap heap = new MinHeap();
    nums1.forEach((u) {
      nums2.forEach((v) {
        heap.insert(Node([u, v]));
      });
    });
    return heap.dequeueItems(k).map((e) => e.pair).toList();
  }
}

class Node {
  late int sum;
  List<int> pair;
  Node(this.pair) {
    sum = this.pair.reduce((value, element) => value + element);
  }
}

class MinHeap {
  // index 0 is not used
  List<Node> _heapList = [
    Node([9999999999, 9999999999])
  ];

  void insert(Node node) {
    _heapList.add(node);
    _bubbleUp(_heapList.length - 1); // from the last one
  }

  void _bubbleUp(int currentIndex) {
    if (currentIndex <= 1) {
      return;
    }

    int parentIndex = currentIndex ~/ 2;
    if (_heapList[parentIndex].sum > _heapList[currentIndex].sum) {
      // swap them
      Node temp = _heapList[parentIndex];
      _heapList[parentIndex] = _heapList[currentIndex];
      _heapList[currentIndex] = temp;

      _bubbleUp(parentIndex);
    }
  }

  Node removeMin() {
    if (_heapList.length <= 1) {
      throw Exception("empty heap");
    }

    Node minValue = _heapList[1];
    Node lastValue = _heapList.removeLast();

    if (_heapList.length > 1) {
      _heapList[1] = lastValue;
      _bubbleDown(1);
    }

    return minValue;
  }

  void _bubbleDown(int currentIndex) {
    int leftChildIndex = currentIndex * 2;
    int rightChildIndex = currentIndex * 2 + 1;

    int smallestIndex = currentIndex;

    if (leftChildIndex < _heapList.length &&
        _heapList[leftChildIndex].sum < _heapList[smallestIndex].sum) {
      smallestIndex = leftChildIndex;
    }

    if (rightChildIndex < _heapList.length &&
        _heapList[rightChildIndex].sum < _heapList[smallestIndex].sum) {
      smallestIndex = rightChildIndex;
    }

    if (smallestIndex != currentIndex) {
      // swap them
      Node temp = _heapList[currentIndex];
      _heapList[currentIndex] = _heapList[smallestIndex];
      _heapList[smallestIndex] = temp;

      _bubbleDown(smallestIndex);
    }
  }

  List<Node> dequeueItems(int elementCount) {
    List<Node> res = [];
    for (int i = 0; i < elementCount && _heapList.length > 1; i++) {
      res.add(removeMin());
    }
    return res;
  }
}

```

this version got output limit exceeded

![output limit exceeded](https://i.imgur.com/DPhFGgq.png)

## Better Solutions
