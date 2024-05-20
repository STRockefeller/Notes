
Dijkstra's algorithm is a classic technique used in computing to find the shortest path from a source node to all other nodes in a graph, which may represent, for example, road networks. 

This algorithm is predicated on the concept that the shortest path between two vertices in a graph can be determined by iteratively selecting the vertex with the smallest tentative distance, updating its neighbors' distances, and repeating the process for all vertices.

## Key Principles:

1. **Initialization**: Start by assigning a [[voc-tentative|tentative]] distance to every node: zero for the initial node and infinity for all other nodes. Set the initial node as current.
2. **Settling Nodes**: From the current node, consider all of its unsettled neighbors and calculate their tentative distances through the current node. Compare the newly calculated tentative distance to the current assigned value and assign the smaller one.
3. **Updating the Current Node**: Once all neighbors have been considered, mark the current node as settled and never check it again.
4. **Selecting the Next Node**: Move to the unsettled node with the smallest tentative distance; this node becomes the new current node.
5. **Repetition**: Repeat the process until all nodes have been settled.