### Complexity Analysis

The time complexity of operations in a priority queue depends on the underlying data structure used, such as a heap, balanced tree, or list:

- **Insertion:** Complexity can vary from O(1) to O(log n), where `n` is the number of elements in the queue.
- **Deletion:** Typically O(log n) if a heap is used, due to the need to reheapify after removal.
- **Peeking:** Constant time, O(1), since it only requires returning the top or root element.