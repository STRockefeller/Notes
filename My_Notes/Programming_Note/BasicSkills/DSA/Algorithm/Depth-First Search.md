# Depth-First Search

tags: #tree #graph #algorithms #DFS #golang

Depth-First Search (DFS) is an algorithm used to traverse or search in a [[Graph]] or [[Tree]] data structure. It explores as far as possible along each branch before backtracking. DFS starts at a specified node and recursively visits its adjacent nodes until it reaches a leaf node, then backtracks to explore the remaining unvisited nodes.

## Algorithm

The DFS algorithm can be summarized as follows:

1. Create a stack to store the nodes to be visited.
2. Push the starting node onto the stack.
3. Mark the starting node as visited.
4. While the stack is not empty, do the following:
   - Pop a node from the top of the stack.
   - Process the node (e.g., print its value or perform any desired operation).
   - Push all the unvisited adjacent nodes of the popped node onto the stack.
   - Mark the popped node as visited.
5. Repeat steps 4 until the stack is empty.

## Example

Consider the following graph:

```
    A----B
    |    |
    C----D
```

Starting from node A, the DFS algorithm would visit the nodes in the following order: A, B, D, C.

## Implementation in Go

Here's an example implementation of the DFS algorithm in Go:

```go
type Graph struct {
    adjacencyList map[string][]string
}

func (g *Graph) DFS(startNode string) {
    visited := make(map[string]bool)
    stack := []string{startNode}

    for len(stack) > 0 {
        node := stack[len(stack)-1]
        stack = stack[:len(stack)-1]

        if !visited[node] {
            fmt.Println(node)
            visited[node] = true

            for _, adjacentNode := range g.adjacencyList[node] {
                if !visited[adjacentNode] {
                    stack = append(stack, adjacentNode)
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

g.DFS("A")
```

The above code defines a `Graph` struct with an adjacency list representation. The `DFS` method performs the depth-first search starting from the specified node. It uses a stack and a visited map to keep track of the nodes to be visited and the visited nodes, respectively.

## Conclusion

Depth-First Search is a widely used algorithm for exploring or searching in graphs or trees. It traverses as deeply as possible before backtracking, making it useful for tasks such as detecting cycles, generating mazes, and solving puzzles. DFS is a fundamental algorithm in computer science and provides a powerful tool for graph and tree traversal.
