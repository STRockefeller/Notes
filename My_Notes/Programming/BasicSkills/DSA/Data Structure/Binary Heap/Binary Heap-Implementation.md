
### Steps and Pseudocode

The operations in a [[Binary Heap|binary heap]] typically include insertion, deletion, and finding the maximum or minimum element. Here is how these operations are typically implemented:

1. **Insertion**:
   - **Process:** Add the new element at the end of the heap and then "bubble up" this element to restore the heap property.

**Pseudocode:**
```plaintext
function insert(heap, element)
    heap.append(element)
    bubbleUp(heap, heap.size - 1)

function bubbleUp(heap, index)
    while index > 0 and heap[parent(index)] < heap[index]
        swap(heap[parent(index)], heap[index])
        index = parent(index)
```

2. **Deletion of Max/Min** (depending on heap type):
   - **Process:** Remove the root of the heap, replace it with the last element, and then "bubble down" this element to restore the heap property.

**Pseudocode:**
```plaintext
function deleteRoot(heap)
    maxElement = heap[0]
    heap[0] = heap[heap.size - 1]
    heap.removeLast()
    bubbleDown(heap, 0)
    return maxElement

function bubbleDown(heap, index)
    child = leftChild(index)
    if child < heap.size and heap[child] < heap[child + 1]
        child = child + 1
    while child < heap.size and heap[index] < heap[child]
        swap(heap[index], heap[child])
        index = child
        child = leftChild(index)
```

3. **Find Max/Min**:
   - **Process:** Simply return the element at the root of the heap, as it is either the maximum or minimum.

**Pseudocode:**
```plaintext
function findMaxMin(heap)
    return heap[0]
```

### Examples

- [Youtube-Data Structures: Heaps](https://www.youtube.com/watch?v=t0Cq6tVNRBA&ab_channel=HackerRank)