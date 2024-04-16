### Steps and Pseudocode

The basic operations of a priority queue are insertion, deletion, and peeking at the element with the highest priority. Here's how these operations typically work:

1. **Insertion (`insert` or `enqueue`)**:
   - **Input:** Element `x` with priority `p`.
   - **Process:** Add `x` to the queue in a position that maintains the priority order.

2. **Deletion (`deleteMax` or `dequeue`)**:
   - **Process:** Remove the element with the highest priority from the queue and return it.

3. **Peek (`max` or `front`)**:
   - **Process:** Return the element with the highest priority without removing it from the queue.

**Pseudocode:**
```plaintext
class PriorityQueue
    function insert(x, p):
        find the correct position for x based on p
        insert x into that position

    function deleteMax():
        maxElement = find the element with the highest priority
        remove maxElement from the queue
        return maxElement

    function max():
        return the element with the highest priority
```

### implementations

- [[Priority Queue (Heap)-Implementation-golang|go]]