
### Summary of Dijkstra's Algorithm

Dijkstra's algorithm is a fundamental computational technique used to find the shortest path between nodes in a graph, which can consist of various points (vertices) connected by edges with assigned weights. 
The algorithm works by iteratively selecting the vertex with the smallest [[voc-tentative|tentative]] distance, updating the shortest path found so far for its neighboring vertices. 

- [[Dijkstra's algorithm-Concept and Principles|Concept and Principles]]
- [[Dijkstra's algorithm-Steps and Pseudocode|Steps and Pseudocode]]
- [[Dijkstra's algorithm-Complexity Analysis|Complexity Analysis]]
- [[Dijkstra's algorithm-Practical Applications|Practical Applications]]
- [[Dijkstra's algorithm-Variants and Extended Concepts|Variants and Extended Concepts]]

### Table: Key Terms and Concepts

| Term/Concept                                     | Definition                                                                                                       | Keywords          |
| ------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------- | ----------------- |
| Graph                                            | A collection of vertices (nodes) and edges connecting pairs of vertices.                                         | Data structures   |
| Vertex (Node)                                    | An individual point in a graph that may be connected to other vertices.                                          | Graph theory      |
| Edge                                             | A connection between two vertices in a graph, typically assigned a weight.                                       | Graph theory      |
| Weight                                           | A value that represents the cost or distance between two connected vertices.                                     | Graph theory      |
| Shortest Path                                    | The minimum distance or cost required to travel from one vertex to another.                                      | Algorithm output  |
| Tentative Distance                               | Initially set to infinity for all nodes except the starting point, which is zero; updated as paths are explored. | Algorithm process |
| [[Priority Queue (Heap)\|Priority Queue]] (Heap) | A data structure that helps select the next vertex with the smallest tentative distance efficiently.             | Data structures   |

### Glossary

- **Non-negative Weights**: A condition necessary for Dijkstra's algorithm to function correctly, ensuring there are no negative cycles in the graph.
- **Network Routing**: A primary application of Dijkstra's algorithm, used to find the optimal routing paths in network communications.
