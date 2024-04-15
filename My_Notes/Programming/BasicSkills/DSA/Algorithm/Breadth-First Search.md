# Breadth-First Search

tags: #tree #graph #algorithms #BFS #golang

Breadth-First Search (BFS) is an algorithm used to traverse or search in a [[Graph]] or [[Tree]] data structure. It explores all the vertices or nodes at the current level before moving to the next level. BFS starts at a specified node and systematically visits its adjacent nodes before moving to the next level of nodes.

## Algorithm

The BFS algorithm can be summarized as follows:

1. Create a queue to store the nodes to be visited.
2. Enqueue the starting node into the queue.
3. Mark the starting node as visited.
4. While the queue is not empty, do the following:
   - Dequeue a node from the front of the queue.
   - Process the node (e.g., print its value or perform any desired operation).
   - Enqueue all the unvisited adjacent nodes of the dequeued node.
   - Mark the dequeued node as visited.
5. Repeat steps 4 until the queue is empty.

## Example

Consider the following graph:

```
    A----B
    |    |
    C----D
```

Starting from node A, the BFS algorithm would visit the nodes in the following order: A, B, C, D.

## Implementation in Go

Here's an example implementation of the BFS algorithm in Go:

```go
type Graph struct {
    adjacencyList map[string][]string
}

func (g *Graph) BFS(startNode string) {
    visited := make(map[string]bool)
    queue := []string{startNode}

    for len(queue) > 0 {
        node := queue[0]
        queue = queue[1:]

        if !visited[node] {
            fmt.Println(node)
            visited[node] = true

            for _, adjacentNode := range g.adjacencyList[node] {
                if !visited[adjacentNode] {
                    queue = append(queue, adjacentNode)
                }
            }
        }
    }
}

// Usage
g := Graph{
    adjacencyList: map[string][]string{
        "A": {"B", "C"},
        "B": {"A", "D"},
        "C": {"A", "D"},
        "D": {"B", "C"},
    },
}

g.BFS("A")
```

The above code defines a `Graph` struct with an adjacency list representation. The `BFS` method performs the breadth-first search starting from the specified node. It uses a queue and a visited map to keep track of the nodes to be visited and the visited nodes, respectively.

## Conclusion

Breadth-First Search is a widely used algorithm for exploring or searching in graphs or trees. It guarantees that the shortest path will be found when searching for a goal node in an unweighted graph. BFS is an essential tool for various applications, including pathfinding, web crawling, and network traversal.
