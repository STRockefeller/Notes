# Shortest-Path Algorithm

tags: #algorithms #the_shortest_path_algorithm #BFS #dijkstra_algorithm

In computer science, the **shortest-path algorithm** is a fundamental concept used to find the shortest path between two points in a graph or network. This document provides an overview of the shortest-path algorithm in both directed and undirected graphs, as well as in weighted and unweighted graphs.

## References

- <http://alrightchiu.github.io/SecondRound/shortest-pathintrojian-jie.html>
- <https://en.wikipedia.org/wiki/Shortest_path_problem>
- <https://www.cs.cornell.edu/courses/JavaAndDS/shortestPath/shortestPath.html>

## Directed Graphs

### Unweighted Directed Graphs

In an unweighted directed graph, each edge has no associated weight. To find the shortest path between two nodes, we can use the [[Breadth-First Search]] algorithm.

```go
func ShortestPathBFS(graph map[int][]int, start, end int) int {
    visited := make(map[int]bool)
    queue := []int{start}
    distance := 0

    for len(queue) > 0 {
        node := queue[0]
        queue = queue[1:]

        if node == end {
            return distance
        }

        if !visited[node] {
            visited[node] = true
            for _, neighbor := range graph[node] {
                if !visited[neighbor] {
                    queue = append(queue, neighbor)
                }
            }
            distance++
        }
    }

    return -1 // No path found
}
```

### Weighted Directed Graphs

In a weighted directed graph, each edge has a weight associated with it. The **Dijkstra's algorithm** is commonly used to find the shortest path in such graphs. Here's a Go code example:

```go
type Edge struct {
    Destination int
    Weight      int
}

func ShortestPathDijkstra(graph map[int][]Edge, start, end int) int {
    distances := make(map[int]int)
    visited := make(map[int]bool)

    for node := range graph {
        distances[node] = math.MaxInt32
    }
    distances[start] = 0

    for i := 0; i < len(graph); i++ {
        minNode := -1
        for node, _ := range graph {
            if !visited[node] && (minNode == -1 || distances[node] < distances[minNode]) {
                minNode = node
            }
        }

        if distances[minNode] == math.MaxInt32 {
            break
        }

        for _, edge := range graph[minNode] {
            if distances[minNode]+edge.Weight < distances[edge.Destination] {
                distances[edge.Destination] = distances[minNode] + edge.Weight
            }
        }

        visited[minNode] = true
    }

    return distances[end]
}
```

## Undirected Graphs

### Unweighted Undirected Graphs

In an unweighted undirected graph, each edge has no associated weight. To find the shortest path between two nodes, we can again use the [[Breadth-First Search]] algorithm, as shown in the earlier example for unweighted directed graphs.

### Weighted Undirected Graphs

In a weighted undirected graph, each edge has a weight associated with it. The **Prim's algorithm** or **Kruskal's algorithm** is often used to find the minimum spanning tree, which can be used to find the shortest path between nodes. Here's a Go code example using Prim's algorithm:

```go
type Edge struct {
    Destination int
    Weight      int
}

func ShortestPathPrim(graph map[int][]Edge) int {
    visited := make(map[int]bool)
    minDistances := make(map[int]int)

    for node := range graph {
        minDistances[node] = math.MaxInt32
    }

    startNode := 0
    minDistances[startNode] = 0

    for i := 0; i < len(graph); i++ {
        minNode := -1
        for node, _ := range graph {
            if !visited[node] && (minNode == -1 || minDistances[node] < minDistances[minNode]) {
                minNode = node
            }
        }

        visited[minNode] = true

        for _, edge := range graph[minNode] {
            if !visited[edge.Destination] && edge.Weight < minDistances[edge.Destination] {
                minDistances[edge.Destination] = edge.Weight
            }
        }
    }

    totalWeight := 0
    for _, weight := range minDistances {
        totalWeight += weight
    }

    return totalWeight
}
```

These algorithms are powerful tools for solving various real-world problems, such as finding the shortest route in a road network or the optimal path in a computer network. Understanding their application can be valuable in many fields of computer science and engineering.
