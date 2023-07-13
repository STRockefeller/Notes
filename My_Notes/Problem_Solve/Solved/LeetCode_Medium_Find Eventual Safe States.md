# LeetCode:802:20230712:dart

tags: #problem_solve #leetcode/medium #dart #graph #cycle_detection #DFS

[Reference](https://leetcode.com/problems/find-eventual-safe-states/)

## Question

There is a directed graph of n nodes with each node labeled from 0 to n - 1. The graph is represented by a 0-indexed 2D integer array graph where `graph[i]` is an integer array of nodes adjacent to node i, meaning there is an edge from node i to each node in `graph[i]`.

A node is a terminal node if there are no outgoing edges. A node is a safe node if every possible path starting from that node leads to a terminal node (or another safe node).

Return an array containing all the safe nodes of the graph. The answer should be sorted in ascending order.

Example 1:

![Illustration of graph](https://s3-lc-upload.s3.amazonaws.com/uploads/2018/03/17/picture1.png)

```text
Input: graph = [[1,2],[2,3],[5],[0],[5],[],[]]
Output: [2,4,5,6]
Explanation: The given graph is shown above.
Nodes 5 and 6 are terminal nodes as there are no outgoing edges from either of them.
Every path starting at nodes 2, 4, 5, and 6 all lead to either node 5 or 6.
```

Example 2:

```text
Input: graph = [[1,2,3,4],[1,2],[3,4],[0,4],[]]
Output: [4]
Explanation:
Only node 4 is a terminal node, and every path starting at node 4 leads to node 4.
```

Constraints:

n == `graph.length`
1 <= n <= $10^4$
0 <= `graph[i].length` <= n
0 <= `graph[i][j]` <= n - 1
`graph[i]` is sorted in a strictly increasing order.
The graph may contain self-loops.
The number of edges in the graph will be in the range $[1, 4 * 10^4]$.

## My Solution

```dart
import 'dart:collection';

enum NodeStatus {
  unknown,
  safe,
  unsafe,
}

class Solution {
  List<int> eventualSafeNodes(List<List<int>> graph) {
    List<NodeStatus> status = List.filled(graph.length, NodeStatus.unknown);
    Set<int> result = {};

    for (int i = 0; i < graph.length; i++) {
      if (status[i] != NodeStatus.unknown) {
        continue;
      }
      List<bool> visited = List.filled(graph.length, false);
      Queue<int> stack = Queue<int>();
      stack.addFirst(i);
      while (!stack.isEmpty) {
        int index = stack.removeFirst();
        if (visited[index] || status[index] == NodeStatus.unsafe) {
          status[i] = NodeStatus.unsafe;
          break;
        }
        if (graph[index].isEmpty) {
          status[index] = NodeStatus.safe;
          result.add(index);
          continue;
        }
        List<int> notSafeNodes = graph[index]
            .where((element) => status[element] != NodeStatus.safe)
            .toList();
        if (notSafeNodes.isEmpty) {
          status[index] = NodeStatus.safe;
          result.add(index);
          continue;
        }
        visited[index] = true;
        notSafeNodes.forEach((element) {
          stack.addFirst(element);
        });
      }

      if (status[i] != NodeStatus.unsafe) {
        status[i] = NodeStatus.safe;
        result.add(i);
      }
    }

    List<int> res = result.toList();
    res.sort();
    return res;
  }
}

```

failed on `graph = [[3,4,5,7,9],[4,7,8,9],[3,4,5,6,8,9],[5],[5,6,8,9],[6,7,9],[],[8,9],[],[]]`

---

rewrite after reading [this article](https://www.geeksforgeeks.org/detect-cycle-in-a-graph/).

```dart
import 'dart:collection';

class Solution {
  List<List<int>> graph = [];
  List<int> eventualSafeNodes(List<List<int>> graph) {
    this.graph = graph;
    List<int> result = [];

    List<bool> visited = List<bool>.filled(graph.length, false);
    List<bool> recursionStack = List<bool>.filled(graph.length, false);
    List<bool> unsafe = List<bool>.filled(graph.length, false);

    for (int i = 0; i < graph.length; i++) {
      if (isCyclicUtil(i, visited, recursionStack, unsafe)) {
        unsafe[i] = true;
      }
    }

    for (int i = 0; i < unsafe.length; i++) {
      if (unsafe[i] == false) {
        result.add(i);
      }
    }
    return result;
  }

  bool isCyclicUtil(int nodeIndex, List<bool> visited,
      List<bool> recursionStack, List<bool> unsafe) {
    if (recursionStack[nodeIndex]) {
      return true;
    }
    if (visited[nodeIndex]) {
      return false;
    }

    recursionStack[nodeIndex] = true;
    visited[nodeIndex] = true;

    for (int adjacentVertex in graph[nodeIndex]) {
      if (isCyclicUtil(adjacentVertex, visited, recursionStack, unsafe)) {
        return true;
      }
    }

    recursionStack[nodeIndex] = false;
    return false;
  }
}
```

## Better Solutions

### Solution 1

```dart
class Solution {
  List<int> eventualSafeNodes(List<List<int>> graph) {
    List<bool> visited = List.filled(graph.length, false);
    List<bool> pathVisited = List.filled(graph.length, false);
    List<int> result = [];
    List<bool> safeNodes = List.filled(graph.length, false);

    for (int i = 0; i < graph.length; i++) {
      if (!visited[i]) {
        dfs(i, graph, visited, pathVisited, safeNodes);
      }
    }

    for (int i = 0; i < safeNodes.length; i++) {
      if (safeNodes[i]) {
        result.add(i);
      }
    }

    return result;
  }

  bool dfs(
    int node,
    List<List<int>> graph,
    List<bool> visited,
    List<bool> pathVisited,
    List<bool> safeNodes,
  ) {
    visited[node] = true;
    pathVisited[node] = true;
    safeNodes[node] = false;

    for (int i in graph[node]) {
      if (!visited[i]) {
        if (dfs(i, graph, visited, pathVisited, safeNodes)) {
          return true;
        }
      }
      if (pathVisited[i]) {
        return true;
      }
    }

    pathVisited[node] = false;
    safeNodes[node] = true;
    return false;
  }
}
```

358ms solution (mine cost 400ms).
