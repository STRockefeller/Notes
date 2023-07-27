# LeetCode:688:20230727:dart

tags: #problem_solve #leetcode/medium #dart #dynamic_programming

[Reference](https://leetcode.com/problems/knight-probability-in-chessboard/)

## Question

On an `n x n` chessboard, a knight starts at the cell `(row, column)` and attempts to make exactly `k` moves. The rows and columns are **0-indexed**, so the top-left cell is `(0, 0)`, and the bottom-right cell is `(n - 1, n - 1)`.

A chess knight has eight possible moves it can make, as illustrated below. Each move is two cells in a cardinal direction, then one cell in an orthogonal direction.

![image](https://assets.leetcode.com/uploads/2018/10/12/knight.png)

Each time the knight is to move, it chooses one of eight possible moves uniformly at random (even if the piece would go off the chessboard) and moves there.

The knight continues moving until it has made exactly `k` moves or has moved off the chessboard.

Return _the probability that the knight remains on the board after it has stopped moving_.

**Example 1:**

**Input:** n = 3, k = 2, row = 0, column = 0
**Output:** 0.06250
**Explanation:** There are two moves (to (1,2), (2,1)) that will keep the knight on the board.
From each of those positions, there are also two moves that will keep the knight on the board.
The total probability the knight stays on the board is 0.0625.

**Example 2:**

**Input:** n = 1, k = 0, row = 0, column = 0
**Output:** 1.00000

**Constraints:**

- `1 <= n <= 25`
- `0 <= k <= 100`
- `0 <= row, column <= n - 1`

## My Solution

Approaches:

- dynamic programming
- use dp table to save the probabilities of the knight reaching a certain cell after a certain number of moves

```dart
class Solution {
  double knightProbability(int n, int k, int row, int column) {
    List<List<List<double>>> dp = List.generate(
      k + 1,
      (int i) => List.generate(
        n,
        (int j) => List.generate(
          n,
          (int k) => 0.0,
          growable: true,
        ),
        growable: true,
      ),
      growable: true,
    );

    dp[0][row][column] = 1;
    for (int moves = 0; moves < k; moves++) {
      for (int rows = 0; rows < n; rows++) {
        for (int cols = 0; cols < n; cols++) {
          if (dp[moves][rows][cols] == 0) {
            continue;
          }
          // eight points that a knight can reach in the next move
          [
            [rows + 1, cols + 2],
            [rows + 1, cols - 2],
            [rows - 1, cols + 2],
            [rows - 1, cols - 2],
            [rows + 2, cols + 1],
            [rows + 2, cols - 1],
            [rows - 2, cols + 1],
            [rows - 2, cols - 1],
          ]
              .where((element) =>
                  element[0] >= 0 &&
                  element[1] >= 0 &&
                  element[0] < n &&
                  element[1] < n)
              .forEach((element) {
            dp[moves + 1][element[0]][element[1]] +=
                dp[moves][rows][cols] * (1 / 8);
          });
        }
      }
    }

    double sum = 0.0;
    dp[k].forEach((row) {
      row.forEach((prob) {
        sum += prob;
      });
    });

    return sum;
  }
}
```

result

![image](https://i.imgur.com/ZzbdUKC.png)

## Better Solutions
