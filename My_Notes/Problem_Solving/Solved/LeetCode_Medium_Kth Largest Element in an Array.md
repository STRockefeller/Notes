# LeetCode:215:20230814:dart

tags: #problem_solve

[Reference](https://leetcode.com/problems/kth-largest-element-in-an-array/)

## Question

Given an integer array `nums` and an integer `k`, return _the_ `kth` _largest element in the array_.

Note that it is the `kth` largest element in the sorted order, not the `kth` distinct element.

Can you solve it without sorting?

**Example 1:**

**Input:** nums = [3,2,1,5,6,4], k = 2
**Output:** 5

**Example 2:**

**Input:** nums = [3,2,3,1,2,4,5,5,6], k = 4
**Output:** 4

**Constraints:**

- `1 <= k <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`

## My Solution

Approach:

- max heap
- sort
- quick select

### Max heap

```dart
class Solution {
  int findKthLargest(List<int> nums, int k) {
    MaxHeap heap = new MaxHeap();
    for (int i = 0; i < nums.length; i++) {
      heap.insert(nums[i]);
    }
    for (int i = 0; i < k - 1; i++) {
      heap.extractMax();
    }
    return heap.extractMax();
  }
}

class MaxHeap {
  late List<int> _heap;

  MaxHeap() {
    _heap = [];
  }

  void insert(int value) {
    _heap.add(value);
    _heapifyUp(_heap.length - 1);
  }

  int extractMax() {
    if (_heap.isEmpty) {
      throw StateError('Heap is empty');
    }

    final max = _heap[0];
    final last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _heapifyDown(0);
    }
    return max;
  }

  void _heapifyUp(int index) {
    while (index > 0) {
      final parentIndex = (index - 1) ~/ 2;
      if (_heap[parentIndex] < _heap[index]) {
        _swap(parentIndex, index);
        index = parentIndex;
      } else {
        break;
      }
    }
  }

  void _heapifyDown(int index) {
    final leftChildIndex = 2 * index + 1;
    final rightChildIndex = 2 * index + 2;
    int largestIndex = index;

    if (leftChildIndex < _heap.length &&
        _heap[leftChildIndex] > _heap[largestIndex]) {
      largestIndex = leftChildIndex;
    }

    if (rightChildIndex < _heap.length &&
        _heap[rightChildIndex] > _heap[largestIndex]) {
      largestIndex = rightChildIndex;
    }

    if (largestIndex != index) {
      _swap(index, largestIndex);
      _heapifyDown(largestIndex);
    }
  }

  void _swap(int i, int j) {
    final temp = _heap[i];
    _heap[i] = _heap[j];
    _heap[j] = temp;
  }

  bool isEmpty() {
    return _heap.isEmpty;
  }

  int size() {
    return _heap.length;
  }
}
```

results:

![image](https://i.imgur.com/hqBZwm1.png)

## Better Solutions
