# LeetCode:1514:20230628:dart

tags: #problem_solve #leetcode/medium #dart #dijkstra_algorithm

[Reference](https://leetcode.com/problems/path-with-maximum-probability/)

## Question

You are given an undirected weighted graph of n nodes (0-indexed), represented by an edge list where edges[i] = [a, b] is an undirected edge connecting the nodes a and b with a probability of success of traversing that edge succProb[i].

Given two nodes start and end, find the path with the maximum probability of success to go from start to end and return its success probability.

If there is no path from start to end, return 0. Your answer will be accepted if it differs from the correct answer by at most 1e-5.

Example 1:

Input: `n = 3, edges = [[0,1],[1,2],[0,2]], succProb = [0.5,0.5,0.2], start = 0, end = 2`
Output: 0.25000
Explanation: There are two paths from start to end, one having a probability of success = 0.2 and the other has 0.5 * 0.5 = 0.25.
Example 2:

Input: `n = 3, edges = [[0,1],[1,2],[0,2]], succProb = [0.5,0.5,0.3], start = 0, end = 2`
Output: 0.30000
Example 3:

Input: n = 3, edges = [[0,1]], succProb = [0.5], start = 0, end = 2
Output: 0.00000
Explanation: There is no path between 0 and 2.

Constraints:

- 2 <= n <= 10^4
- 0 <= start, end < n
- start != end
- 0 <= a, b < n
- a != b
- 0 <= succProb.length == edges.length <= 2*10^4
- 0 <= succProb[i] <= 1
- There is at most one edge between every two nodes.

## My Solution

```dart
class Solution {
  late List<Path> _paths;
  late List<Dijkstra> _dijTable;

  int _start = -1;

  double maxProbability(
      int n, List<List<int>> edges, List<double> succProb, int start, int end) {
    _start = start;

    _initialDijTable(n);

    _paths = parsePaths(edges, succProb);
    _paths
        .where((element) => element.points.contains(start))
        .forEach((element) {
      int pairPoint = element.points.anotherOne(start);
      _updateDijTable(pairPoint, start, element.prob);
    });

    while (!_dijTable[end].visited) {
      int targetIndex = -1;
      Dijkstra targetStatus = Dijkstra();
      for (int i = 0; i < _dijTable.length; i++) {
        // skip unreachable or visited nodes
        if (_dijTable[i].visited) {
          continue;
        }
        if (_dijTable[i].prob > targetStatus.prob) {
          targetIndex = i;
          targetStatus = _dijTable[i];
        }
      }
      if (targetIndex == -1) {
        break;
      }
      _visitNode(targetIndex);
    }

    return _dijTable[end].prob;
  }

  void _visitNode(int target) {
    _paths
        .where((element) => element.points.contains(target))
        .forEach((element) {
      final int pairPoint = element.points.anotherOne(target);
      final double newProb = element.prob * _dijTable[target].prob;
      if (_dijTable[pairPoint].prob >= newProb) {
        return;
      }
      _updateDijTable(pairPoint, target, newProb);
    });
    _dijTable[target].visited = true;
  }

  void _initialDijTable(int counts) {
    _dijTable = [];

    for (int i = 0; i < counts; i++) {
      _dijTable.add(Dijkstra());
    }
    _dijTable[_start].visited = true;
    _dijTable[_start].prob = 1;
  }

  void _updateDijTable(int index, int path, double prob, [bool? visited]) {
    _dijTable[index].visited = visited ?? _dijTable[index].visited;
    _dijTable[index].prob = prob;
  }
}

class Dijkstra {
  bool visited = false;
  double prob = 0;
}

List<Path> parsePaths(List<List<int>> edges, List<double> succProb) {
  if (edges.length != succProb.length) {
    throw "conditions not match";
  }

  List<Path> res = [];
  for (int i = 0; i < edges.length; i++) {
    res.add(Path(Tuple(edges[i][0], edges[i][1]), succProb[i]));
  }
  return res;
}

class Path {
  late Tuple<int> points;
  double prob = 0;
  Path(this.points, this.prob) {}
}

class Tuple<T> {
  late T _element1;
  late T _element2;
  Tuple(this._element1, this._element2) {
    if (_element1 == _element2) {
      throw "unexpected tuple values";
    }
  }

  bool contains(T target) => target == _element1 || target == _element2;

  // should validate contains first
  T anotherOne(T target) => _element1 == target ? _element2 : _element1;
}
```

result: timed out

## Better Solutions
