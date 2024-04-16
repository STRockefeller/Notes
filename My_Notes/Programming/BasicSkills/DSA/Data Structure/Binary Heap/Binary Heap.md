
tags: #heap #data_structure

### Binary Heap: Concept and Principles

#### Summary

A binary heap is a highly efficient data structure that embodies a complete [[Binary Tree|binary tree]], making it ideal for implementing [[Priority Queue (Heap)|priority queues]]. 
There are two main types of binary heaps: min-heaps and max-heaps.
In a min-heap, the smallest key is at the root, making it easy to extract the minimum quickly, whereas in a max-heap, the largest key is at the root, facilitating rapid maximum extraction.
Binary heaps support basic operations like insertion, deletion, and finding the maximum or minimum element, with these operations maintaining the heap property through adjustments known as "bubble up" and "bubble down" processes.

for more details:
- [[Binary Heap-Implementation|Implementations]]
- [[Binary Heap-Complexity Analysis|Complexity Analysis]]
- [[Binary Heap-Practical Applications|Practical Applications]]
- [[Binary Heap-Variants and Extended Concepts|Variants and Extended Concepts]]

#### Concepts and Definitions

| Term                | Definition | Keywords |
|---------------------|------------|----------|
| Binary Heap         | A complete binary tree-based data structure used primarily for implementing efficient priority queues. | Data structure |
| Min-Heap            | A type of binary heap where the key at each node is less than or equal to the keys of its children, and the minimum key is at the root. | Heap type |
| Max-Heap            | A type of binary heap where the key at each node is greater than or equal to the keys of its children, and the maximum key is at the root. | Heap type |
| Heap Property       | A characteristic of binary heaps where the relationship between parent nodes and children nodes determines the heap type (min or max). | Data structure |
| Insertion           | The operation of adding a new element to the heap that maintains the heap structure by placing the new element at the end and then adjusting its position upwards. | Heap operations |
| Bubble Up           | A method used during the insertion process to restore the heap property by moving the newly added element to its correct position in the heap. | Heap operations |
| Deletion of Max/Min | The process of removing the root element (maximum in max-heaps or minimum in min-heaps) and then restoring the heap property by repositioning the last element of the heap. | Heap operations |
| Bubble Down         | A method used during the deletion process to maintain the heap property by moving the root-replaced element down to its proper position. | Heap operations |
| Find Max/Min        | An operation that returns the element at the root of the heap because it represents either the maximum or minimum, depending on the heap type. | Heap operations |

#### Glossary

- **Complete Binary Tree**: A type of tree in which every level, except possibly the last, is completely filled, and all nodes are as far left as possible.
- **Array Representation**: The typical method of storing a binary heap because it leverages the properties of a complete binary tree efficiently.
- **Heap Sort**: A comparison-based sorting technique based on binary heap data structure.
- **Graph Algorithms**: Algorithms that deal with problems solved on graphs, such as shortest path finding, which often use heaps for efficient data handling and priority management.
- **D-ary Heap**: A variant of the binary heap where each node has `D` children instead of 2, potentially optimizing performance in certain scenarios.