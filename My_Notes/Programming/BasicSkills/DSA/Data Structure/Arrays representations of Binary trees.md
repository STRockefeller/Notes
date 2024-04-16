tags: #data_structure #array #binary_tree #heap #priority_queue 

[[Binary Tree|Binary trees]] are fundamental structures in computer science, often used for organizing and managing data efficiently. They can be represented in various ways, including linked structures and arrays. Using arrays to represent binary trees can be particularly efficient in terms of memory and accessibility, especially for binary heaps or trees that are complete.

### Concept Explanation

In an array representation of a [[Binary Tree|binary tree]], each element of the array corresponds to a node of the tree. The relationships between the nodes (parent and children) are defined by their positions in the array rather than explicit pointers or references.

**Key rules for indexing**:
- For any node at index `i`:
  - The left child (if any) is at index `2i + 1`.
  - The right child (if any) is at index `2i + 2`.
  - The parent (if any) is at index `(i-1) / 2`, where `/` denotes integer division.

This representation is particularly suitable for complete binary trees, where all levels except possibly the last are completely filled, and all nodes are as far left as possible. This ensures that there are no gaps in the array, leading to efficient use of space.

### Learning Significance

The array representation of binary trees is significant because it eliminates the need for node pointers, thereby reducing memory usage and simplifying the structure. 
It's particularly advantageous in applications like [[Binary Heap|binary heaps]], used in [[Priority Queue (Heap)|priority queues]] and heap sort algorithms, because it facilitates quick access to parent and child nodes, which is essential for heap operations like insertions and deletions.

### Example

Consider a binary tree of integers represented in an array as follows:
```
Array: [10, 5, 15, 2, 7, 12, 20]
```
This represents the binary tree:
```
        10
       /  \
      5    15
     / \   / \
    2   7 12  20
```
Here, the root (10) is at index 0, its left child (5) is at index 1, and its right child (15) is at index 2. Similarly, the child of the node at index 1 (5) are at indices 3 (2) and 4 (7).

### Example Analysis

Using the array `[10, 5, 15, 2, 7, 12, 20]`:
- **Node 5** is at index 1:
  - Left child: Index `2*1 + 1 = 3` (value = 2)
  - Right child: Index `2*1 + 2 = 4` (value = 7)
- **Node 15** is at index 2:
  - Left child: Index `2*2 + 1 = 5` (value = 12)
  - Right child: Index `2*2 + 2 = 6` (value = 20)

This layout demonstrates how quickly relationships can be determined without traversing links, making the array-based representation ideal for direct access and manipulation based on index.

### Similar Problems

Here are three practice problems to deepen your understanding of array representations of binary trees:

1. **Given an array `[20, 10, 30, 5, 15, 25, 35]`, draw the corresponding binary tree.**
2. **For the binary tree represented by the array `[8, 4, 12, 2, 6, 10, 14]`, determine the parent node of the node containing the value 6.**
3. **If a node in a binary tree is at index 9 in an array representation, calculate the indices of its parent, left child, and right child.**
