tags: #heap #priority_queue #data_structure

### Priority Queue: Concept and Principles

#### Summary

A priority queue is a specialized data structure that enhances the traditional queue by associating each element with a priority level, allowing elements to be served based on priority rather than their order of arrival.

**Key Characteristics:**
1. **Priority Assignment:** Each element in the priority queue has a priority level assigned, either at the time of insertion or based on inherent characteristics.
2. **Priority Serving:** The element with the highest priority (or lowest, depending on the implementation) is removed from the queue first.
3. **Dynamic Adjustment:** New elements can be added at any time, and they are automatically ordered by priority.

For more details:
- [[Priority Queue (Heap)-Implementation|Implementations]]
- [[Priority Queue (Heap)-Practical Applications|Practical Applications]]
- [[Priority Queue (Heap)-Variants and Extended Concepts|Variants and Extended Concepts]]
#### Concepts and Definitions

| Term                                | Definition                                                                                                                                 | Keywords         |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| Priority Queue                      | An abstract data type where each element is associated with a priority, and elements are served based on their priority.                   | Data structure   |
| Priority Assignment                 | The process of assigning a priority to an element either at the time of its insertion into the queue or based on inherent characteristics. | Queue operations |
| Priority Serving                    | A queue operation where the element with the highest (or lowest, depending on configuration) priority is removed first.                    | Queue operations |
| Dynamic Adjustment                  | The ability to add new elements to the queue at any time, with these elements being automatically ordered by priority.                     | Queue operations |
| Insertion (`insert` or `enqueue`)   | Adding an element with a specified priority into the queue in a position that maintains the correct priority order.                        | Queue operations |
| Deletion (`deleteMax` or `dequeue`) | Removing and returning the highest priority element from the queue.                                                                        | Queue operations |
| Peek (`max` or `front`)             | Viewing the highest priority element without removing it from the queue.                                                                   | Queue operations |
| Heap                                | A common data structure used to implement priority queues, allowing efficient priority management.                                         | Data structure   |
| [[Binary Heap]]                     | A type of heap that is simple and effective for implementing priority queues with good performance metrics.                                | Heap type        |
| Fibonacci Heap                      | An advanced heap variant with better amortized time complexities, suitable for applications like network optimization.                     | Heap type        |
| Binomial Heap                       | A heap variant that is efficient for merging two heaps, often used in complex queue management systems.                                    | Heap type        |

#### Glossary

- **Priority Queue Operations**: Insertion, deletion, peeking.
- **Heapify**: The process of rearranging a heap to maintain its characteristic properties, usually after insertion or deletion.