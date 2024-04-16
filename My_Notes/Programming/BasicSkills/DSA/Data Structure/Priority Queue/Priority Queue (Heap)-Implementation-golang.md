
### with container/heap

[playground](https://goplay.tools/snippet/apAHdcDoT1m)

```go
package main

import (
    "container/heap"
    "fmt"
)

// An Item is something we manage in a priority queue.
type Item struct {
    value    string // The value of the item; arbitrary.
    priority int    // The priority of the item in the queue.
    index    int    // The index of the item in the heap, maintained by the heap.Interface methods.
}

// A PriorityQueue implements heap.Interface and holds Items.
type PriorityQueue []*Item

func (pq PriorityQueue) Len() int { return len(pq) }

func (pq PriorityQueue) Less(i, j int) bool {
    // We want Pop to give us the lowest, not highest, priority so we use less than here.
    return pq[i].priority < pq[j].priority
}

func (pq PriorityQueue) Swap(i, j int) {
    pq[i], pq[j] = pq[j], pq[i]
    pq[i].index = i
    pq[j].index = j
}

func (pq *PriorityQueue) Push(x interface{}) {
    n := len(*pq)
    item := x.(*Item)
    item.index = n
    *pq = append(*pq, item)
}

func (pq *PriorityQueue) Pop() interface{} {
    old := *pq
    n := len(old)
    item := old[n-1]
    old[n-1] = nil  // avoid memory leak
    item.index = -1 // for safety
    *pq = old[0 : n-1]
    return item
}

// Peek returns the item with the highest priority (lowest value) without removing it from the queue.
func (pq *PriorityQueue) Peek() *Item {
    if pq.Len() == 0 {
        return nil
    }
    return (*pq)[0]
}

// update modifies the priority and value of an Item in the queue.
func (pq *PriorityQueue) update(item *Item, value string, priority int) {
    item.value = value
    item.priority = priority
    heap.Fix(pq, item.index)
}

func main() {
    // Some items and their priorities.
    items := map[string]int{
        "banana": 3, "apple": 2, "pear": 4,
    }

    // Create a priority queue, put the items in it, and establish the priority queue (heap) invariants.
    pq := make(PriorityQueue, len(items))
    i := 0
    for value, priority := range items {
        pq[i] = &Item{
            value:    value,
            priority: priority,
            index:    i,
        }
        i++
    }
    heap.Init(&pq)

    // Insert a new item and then modify its priority.
    item := &Item{
        value:    "orange",
        priority: 1,
    }
    heap.Push(&pq, item)
    pq.update(item, item.value, 5)

    // Peek at the item with the highest priority
    peekedItem := pq.Peek()
    if peekedItem != nil {
        fmt.Printf("Peeked at: %s with priority %d\n", peekedItem.value, peekedItem.priority)
    }

    // Take the items out; they arrive in increasing priority order.
    for pq.Len() > 0 {
        item := heap.Pop(&pq).(*Item)
        fmt.Printf("%.2d:%s ", item.priority, item.value)
    }
}

```

### without container/heap

[playground](https://goplay.tools/snippet/apAHdcDoT1m)

```go
package main

import (
	"fmt"
)

// Item stores the elements in the queue, along with their priority.
type Item struct {
	value    string
	priority int
}

// PriorityQueue represents the queue structure.
type PriorityQueue []*Item

// NewPriorityQueue initializes a new PriorityQueue.
func NewPriorityQueue() *PriorityQueue {
	return &PriorityQueue{}
}

// Push adds an item to the queue.
func (pq *PriorityQueue) Push(item *Item) {
	*pq = append(*pq, item)
	pq.up(len(*pq) - 1)
}

// Pop removes and returns the item with the highest priority (lowest number).
func (pq *PriorityQueue) Pop() *Item {
	if pq.Len() == 0 {
		return nil
	}
	n := pq.Len() - 1
	pq.swap(0, n)
	item := (*pq)[n]
	*pq = (*pq)[:n]
	pq.down(0, n)
	return item
}

// Peek returns the item with the highest priority without removing it.
func (pq *PriorityQueue) Peek() *Item {
	if pq.Len() == 0 {
		return nil
	}
	return (*pq)[0]
}

// up maintains the heap condition after inserting an element.
func (pq *PriorityQueue) up(index int) {
	for {
		parent := (index - 1) / 2
		if index == 0 || (*pq)[parent].priority <= (*pq)[index].priority {
			break
		}
		pq.swap(parent, index)
		index = parent
	}
}

// down maintains the heap condition after removing an element.
func (pq *PriorityQueue) down(index, n int) {
	for {
		left := 2*index + 1
		right := 2*index + 2
		smallest := index
		if left < n && (*pq)[left].priority < (*pq)[smallest].priority {
			smallest = left
		}
		if right < n && (*pq)[right].priority < (*pq)[smallest].priority {
			smallest = right
		}
		if smallest == index {
			break
		}
		pq.swap(index, smallest)
		index = smallest
	}
}

// swap swaps two elements in the queue.
func (pq *PriorityQueue) swap(i, j int) {
	(*pq)[i], (*pq)[j] = (*pq)[j], (*pq)[i]
}

// Len returns the number of elements in the queue.
func (pq *PriorityQueue) Len() int {
	return len(*pq)
}

func main() {
	pq := NewPriorityQueue()
	pq.Push(&Item{value: "banana", priority: 3})
	pq.Push(&Item{value: "apple", priority: 2})
	pq.Push(&Item{value: "pear", priority: 4})
	pq.Push(&Item{value: "orange", priority: 1})

	fmt.Println("Peek:", pq.Peek().value) // Peek at the item with the highest priority

	// Remove items in priority order
	for pq.Len() > 0 {
		item := pq.Pop()
		fmt.Printf("%s ", item.value)
	}
}

```