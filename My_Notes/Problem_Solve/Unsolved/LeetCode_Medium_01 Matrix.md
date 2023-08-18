# LeetCode:542:20230817:dart

tags: #problem_solve #leetcode/medium #dart #BFS

[Reference](https://leetcode.com/problems/01-matrix/)

## Question

Given an `m x n` binary matrix `mat`, return _the distance of the nearest_ `0` _for each cell_.

The distance between two adjacent cells is `1`.

**Example 1:**

![](https://assets.leetcode.com/uploads/2021/04/24/01-1-grid.jpg)

```text
**Input:** mat = [[0,0,0],[0,1,0],[0,0,0]]
**Output:** [[0,0,0],[0,1,0],[0,0,0]]
```

**Example 2:**

![](https://assets.leetcode.com/uploads/2021/04/24/01-2-grid.jpg)

```text
**Input:** mat = [[0,0,0],[0,1,0],[1,1,1]]
**Output:** [[0,0,0],[0,1,0],[1,2,1]]
```

**Constraints:**

- `m == mat.length`
- `n == mat[i].length`
- 1 <= m, n <= $10^4$
- 1 <= m * n <= $10^4$
- `mat[i][j]` is either `0` or `1`.
- There is at least one `0` in `mat`.

## My Solution

The problem is similar to [[CodeWars_5kyu_Bird Mountain]]

Approach: do bfs on each point

```dart
class Solution {
  List<List<int>> updateMatrix(List<List<int>> mat) {
    int m = mat.length;
    int n = mat[0].length;
    List<List<int>> ans =
        List.generate(m, (index) => List.generate(n, (index) => -1));
    List<Point> points = [];
    bool Function(Point) validate = _validate(0, m - 1, 0, n - 1);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        points.add(new Point(i, j));
      }
    }

    bool isAdjentToVisitedPoints(Point point) {
      return point
              .neighbors()
              .where((neighbor) =>
                  validate(neighbor) && ans[neighbor.x][neighbor.y] != -1)
              .length >
          0;
    }

    points.forEach((point) {
      if (mat[point.x][point.y] == 0) {
        ans[point.x][point.y] = 0;
      }
    });
    for (int distance = 1; points.length != 0; distance++) {
      points
          .where((point) =>
              ans[point.x][point.y] == -1 && isAdjentToVisitedPoints(point))
          .toList()
          .forEach((point) {
        ans[point.x][point.y] = distance;
        points = points.where((point) => ans[point.x][point.y] == -1).toList();
      });
    }

    return ans;
  }

  bool Function(Point) _validate(int xmin, int xmax, int ymin, int ymax) {
    bool fn(Point p) {
      return p.isValid(xmin, xmax, ymin, ymax);
    }

    return fn;
  }
}

class Point {
  int x;
  int y;
  Point(this.x, this.y);

  bool isValid(int xmin, int xmax, int ymin, int ymax) {
    return x >= xmin && x <= xmax && y >= ymin && y <= ymax;
  }

  int get hashCode => x ^ y;
  bool operator ==(other) => other is Point && x == other.x && y == other.y;

  bool equal(Point p) {
    return x == p.x && y == p.y;
  }

  Point _up() {
    return new Point(x - 1, y);
  }

  Point _down() {
    return new Point(x + 1, y);
  }

  Point _right() {
    return new Point(x, y + 1);
  }

  Point _left() {
    return new Point(x, y - 1);
  }

  List<Point> neighbors() {
    return [_up(), _down(), _left(), _right()];
  }
}
```

result:

![image](https://i.imgur.com/ntCWlXA.png)

---

Approach: fill the answer from outside

```dart
class Solution {
  List<List<int>> updateMatrix(List<List<int>> mat) {
    int m = mat.length;
    int n = mat[0].length;
    List<List<int>> ans =
        List.generate(m, (index) => List.generate(n, (index) => -1));
    List<Point> points = [];
    bool Function(Point) validate = _validate(0, m - 1, 0, n - 1);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        points.add(new Point(i, j));
      }
    }

    bool isAdjentToVisitedPoints(Point point) {
      return point
              .neighbors()
              .where((neighbor) =>
                  validate(neighbor) && ans[neighbor.x][neighbor.y] != -1)
              .length >
          0;
    }

    points.forEach((point) {
      if (mat[point.x][point.y] == 0) {
        ans[point.x][point.y] = 0;
      }
    });
    for (int distance = 1;
        points.where((point) => ans[point.x][point.y] == -1).length != 0;
        distance++) {
      points
          .where((point) =>
              ans[point.x][point.y] == -1 && isAdjentToVisitedPoints(point))
          .toList()
          .forEach((point) {
        ans[point.x][point.y] = distance;
      });
    }

    return ans;
  }

  bool Function(Point) _validate(int xmin, int xmax, int ymin, int ymax) {
    bool fn(Point p) {
      return p.isValid(xmin, xmax, ymin, ymax);
    }

    return fn;
  }
}

class Point {
  int x;
  int y;
  Point(this.x, this.y);

  bool isValid(int xmin, int xmax, int ymin, int ymax) {
    return x >= xmin && x <= xmax && y >= ymin && y <= ymax;
  }

  int get hashCode => x ^ y;
  bool operator ==(other) => other is Point && x == other.x && y == other.y;

  bool equal(Point p) {
    return x == p.x && y == p.y;
  }

  Point _up() {
    return new Point(x - 1, y);
  }

  Point _down() {
    return new Point(x + 1, y);
  }

  Point _right() {
    return new Point(x, y + 1);
  }

  Point _left() {
    return new Point(x, y - 1);
  }

  List<Point> neighbors() {
    return [_up(), _down(), _left(), _right()];
  }
}
```

result: timed out with the same case again

## Better Solutions
