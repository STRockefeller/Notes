# LeetCode:1361:20231017:dart

tags: #problem_solve #leetcode/medium #union_find #DFS #dart

[Reference](https://leetcode.com/problems/validate-binary-tree-nodes/)

## Question

You have `n` binary tree nodes numbered from `0` to `n - 1` where node `i` has two children `leftChild[i]` and `rightChild[i]`, return `true` if and only if **all** the given nodes form **exactly one** valid binary tree.

If node `i` has no left child then `leftChild[i]` will equal `-1`, similarly for the right child.

Note that the nodes have no values and that we only use the node numbers in this problem.

**Example 1:**

![](https://assets.leetcode.com/uploads/2019/08/23/1503_ex1.png)

**Input:** n = 4, leftChild = [1,-1,3,-1], rightChild = [2,-1,-1,-1]
**Output:** true

**Example 2:**

![](https://assets.leetcode.com/uploads/2019/08/23/1503_ex2.png)

**Input:** n = 4, leftChild = [1,-1,3,-1], rightChild = [2,3,-1,-1]
**Output:** false

**Example 3:**

![](https://assets.leetcode.com/uploads/2019/08/23/1503_ex3.png)

**Input:** n = 2, leftChild = [1,0], rightChild = [-1,-1]
**Output:** false

**Constraints:**

- `n == leftChild.length == rightChild.length`
- `1 <= n <= 10^4`
- `-1 <= leftChild[i], rightChild[i] <= n - 1`

## My Solution


### DFS

```dart
import "dart:collection";

class Solution {
  bool validateBinaryTreeNodes(
      int n, List<int> leftChild, List<int> rightChild) {
    final List<bool> visited = List.generate(n, (i) => false);
    final Queue<int> stack = Queue<int>();

    for (int i = 0; i < n; ++i) {
      if (leftChild[i] == -1 && rightChild[i] == -1) {
        continue;
      }
      visited[i] = true;
      if (leftChild[i] != -1) {
        stack.addLast(leftChild[i]);
      }
      if (rightChild[i] != -1) {
        stack.addLast(rightChild[i]);
      }
      break;
    }

    while (stack.isNotEmpty) {
      int point = stack.removeLast();
      if (visited[point]) {
        return false;
      }
      visited[point] = true;
      if (leftChild[point] != -1) {
        stack.addLast(leftChild[point]);
      }
      if (rightChild[point] != -1) {
        stack.addLast(rightChild[point]);
      }
    }
    return visited.every((v) => v == true);
  }
}
```

result:

failed with the following case

```text
4
[3,-1,1,-1]
[-1,-1,0,-1]
```

### store the parents

```dart
import "dart:collection";

class Solution {
  bool validateBinaryTreeNodes(
      int n, List<int> leftChild, List<int> rightChild) {
    List<int> parents = List.generate(n, (i) => -1);
    for (int i = 0; i < n ; i++){
      if (leftChild[i] != -1){
        if(parents[leftChild[i]] != -1){return false;}
        parents[leftChild[i]] = i;
      }
      if (rightChild[i] != -1){
        if(parents[rightChild[i]] != -1){return false;}
        parents[rightChild[i]] = i;
      }
    }
    return parents.where((p) => p==-1).length == 1;
  }
}
```

failed with the following case:

```text
4
[1,0,3,-1]
[-1,-1,-1,-1]
```

### store the parents and use union find

```dart
import "dart:collection";

class Solution {
  bool validateBinaryTreeNodes(
      int n, List<int> leftChild, List<int> rightChild) {
    List<int> parents = List.generate(n, (i) => -1);
    for (int i = 0; i < n ; i++){
      if (leftChild[i] != -1){
        if(parents[leftChild[i]] != -1){return false;}
        parents[leftChild[i]] = i;
      }
      if (rightChild[i] != -1){
        if(parents[rightChild[i]] != -1){return false;}
        parents[rightChild[i]] = i;
      }
    }
    final UnionFind uf = UnionFind(n);
    for (int i = 0; i < n; i++){
      if (parents[i] == -1){continue;}
      uf.join(i, parents[i]);
    }
    return parents.where((p) => p==-1).length == 1 && uf.union();
  }
}

class UnionFind {
  late List<int> _unionFind;
  UnionFind(int n){
    _unionFind = List.generate(n, (i) => i);
  }
  void join(int a, int b){
    _unionFind[a] = _unionFind[b];
  }
  bool union(){
    int t = find(_unionFind[0]);
    return _unionFind.every((e) => find(e) == t);
  }
  int find(int i) {
    while (_unionFind[i] != i) {
      i = _unionFind[i];
    }
    return i;
  }
}
```

result:

![image](https://i.imgur.com/9A5Ti6g.png)

## Better Solutions
