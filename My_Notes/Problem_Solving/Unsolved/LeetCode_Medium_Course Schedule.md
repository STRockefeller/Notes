# LeetCode:207:20230713:dart

tags: #problem_solve #leetcode/medium #graph #cycle_detection #directed_graph #DFS #dart

[Reference](https://leetcode.com/problems/course-schedule/)

## Question

There are a total of `numCourses` courses you have to take, labeled from 0 to `numCourses` - 1. You are given an array prerequisites where `prerequisites[i] = [ai, bi]` indicates that you must take course `bi` first if you want to take course `ai`.

For example, the pair `[0, 1]`, indicates that to take course 0 you have to first take course 1.
Return `true` if you can finish all courses. Otherwise, return `false`.

Example 1:

```text
Input: numCourses = 2, prerequisites = [[1,0]]
Output: true
Explanation: There are a total of 2 courses to take.
To take course 1 you should have finished course 0. So it is possible.
```

Example 2:

```text
Input: numCourses = 2, prerequisites = [[1,0],[0,1]]
Output: false
Explanation: There are a total of 2 courses to take.
To take course 1 you should have finished course 0, and to take course 0 you should also have finished course 1. So it is impossible.
```

Constraints:

1 <= `numCourses` <= 2000
0 <= `prerequisites.length` <= 5000
`prerequisites[i].length` == 2
0 <= `ai`, `bi` < numCourses
All the pairs `prerequisites[i]` are unique.

## My Solution

this problem is very similar to the problem I solved yesterday: [[LeetCode_Medium_Find Eventual Safe States]]

```dart
class Solution {
  bool canFinish(int numCourses, List<List<int>> prerequisites) {
    List<bool> visited = List.filled(numCourses, false);
    List<bool> recursionStack = List.filled(numCourses, false);

    List<List<int>> graph = List.filled(numCourses, []);
    prerequisites.forEach((element) {
      graph[element[0]].add(element[1]);
    });

    for (int i = 0; i < numCourses; i++) {
      if (!visited[i]) {
        if (_dfs(graph, i, visited, recursionStack)) {
          return false;
        }
      }
    }

    return true;
  }

  bool _dfs(List<List<int>> graph, int node, List<bool> visited,
      List<bool> recursionStack) {
    visited[node] = true;
    recursionStack[node] = true;

    for (int i = 0; i < graph[node].length; i++) {
      if (!visited[graph[node][i]]) {
        if (_dfs(graph, graph[node][i], visited, recursionStack)) {
          return true;
        }
      } else if (recursionStack[graph[node][i]]) {
        return true;
      }
    }

    recursionStack[node] = false;
    return false;
  }
}

```

## Better Solutions
