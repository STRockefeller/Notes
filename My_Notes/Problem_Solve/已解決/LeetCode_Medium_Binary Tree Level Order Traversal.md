# LeetCode:102:20220920:C#

[Reference](https://leetcode.com/problems/binary-tree-level-order-traversal/)

## Question

Given the `root` of a binary tree, return *the level order traversal of its nodes' values*. (i.e., from left to right, level by level).

**Example 1:**

![](https://assets.leetcode.com/uploads/2021/02/19/tree1.jpg)

**Input:** root = [3,9,20,null,null,15,7]
**Output:** [[3],[9,20],[15,7]]

**Example 2:**

**Input:** root = [1]
**Output:** [[1]]

**Example 3:**

**Input:** root = []
**Output:** []

**Constraints:**

- The number of nodes in the tree is in the range `[0, 2000]`.
- `-1000 <= Node.val <= 1000`

## My Solution

辛苦花了半小時寫出來，才發現誤會了題目的意思orz

```csharp
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public int val;
 *     public TreeNode left;
 *     public TreeNode right;
 *     public TreeNode(int val=0, TreeNode left=null, TreeNode right=null) {
 *         this.val = val;
 *         this.left = left;
 *         this.right = right;
 *     }
 * }
 */
public class Solution {
    private Queue<Tuple<TreeNode?, TreeNode?>> tloQueue = new();
    public IList<IList<int>> LevelOrder(TreeNode root)
    {
        IList<IList<int>> res = new List<IList<int>>();
        if (root == null) return res;
        res.Add(new List<int>(){root.val});
        tloQueue.Enqueue(new Tuple<TreeNode?, TreeNode?>(root.left, root.right));
        while(tloQueue.Any())
        {
            List<int>? part = LevelOrderNext(tloQueue.Dequeue());
            if(part != null)
                res.Add(part);
        }

        return res;
    }
    private List<int>? LevelOrderNext(Tuple<TreeNode?, TreeNode?> nodes)
    {
        List<int> res = new();
        if (nodes.Item1 != null)
        {
            res.Add(nodes.Item1.val);
            tloQueue.Enqueue(new Tuple<TreeNode?, TreeNode?>(nodes.Item1.left, nodes.Item1.right));
        }
        if (nodes.Item2 != null)
        {
            res.Add(nodes.Item2.val);
            tloQueue.Enqueue(new Tuple<TreeNode?, TreeNode?>(nodes.Item2.left, nodes.Item2.right));
        }
        return res.Count() == 0 ? null : res;
    }
}
```

結果

![](https://i.imgur.com/V8vvjSI.png)

簡單來說，題目要的是把`同一層的`全部放一起，而不是左右node倆倆放一起。然後很不巧的是，所有的範例都沒辦法看出來，於是就造成了這個美麗的誤會。

---

如果直接拿這個寫法來改的話，最直接的做法就是在記錄資訊的時候多一個層數的資訊。

但總覺得這個寫法不夠優雅，再想想有沒有其他的做法...

好吧，想了很就都沒想到，先加上層數資訊來解答看看

```csharp
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public int val;
 *     public TreeNode left;
 *     public TreeNode right;
 *     public TreeNode(int val=0, TreeNode left=null, TreeNode right=null) {
 *         this.val = val;
 *         this.left = left;
 *         this.right = right;
 *     }
 * }
 */

internal class NodeTuple
{
    public Tuple<TreeNode?, TreeNode?> Nodes { get; set; }

    /// <summary>
    /// start from 0
    /// </summary>
    /// <value></value>
    public int Depth { get; set; }

    public NodeTuple(Tuple<TreeNode?, TreeNode?> nodes, int depth)
    {
        Nodes = nodes;
        Depth = depth;
    }

    public NodeTuple(TreeNode root, int depth)
    {
        Nodes = new Tuple<TreeNode?, TreeNode?>(root.left, root.right);
        Depth = depth;
    }
}

public class Solution
{
    private Queue<NodeTuple> tloQueue = new();
    public IList<IList<int>> LevelOrder(TreeNode root)
    {
        IList<IList<int>> res = new List<IList<int>>();
        if (root == null) return res;
        res.Add(new List<int>() { root.val });
        tloQueue.Enqueue(new NodeTuple(new Tuple<TreeNode?, TreeNode?>(root.left, root.right), 1));
        while (tloQueue.Any())
        {
            NodeTuple node = tloQueue.Dequeue();
            List<int>? part = LevelOrderNext(node);
            if (part != null)
            {
                if (node.Depth == res.Count)
                    res.Add(part);
                else
                    res[node.Depth] = res[node.Depth].Concat(part).ToList();
            }
        }

        return res;
    }
    private List<int>? LevelOrderNext(NodeTuple nodes)
    {
        List<int> res = new();
        if (nodes.Nodes.Item1 != null)
        {
            res.Add(nodes.Nodes.Item1.val);
            tloQueue.Enqueue(new NodeTuple(nodes.Nodes.Item1, nodes.Depth + 1));
        }
        if (nodes.Nodes.Item2 != null)
        {
            res.Add(nodes.Nodes.Item2.val);
            tloQueue.Enqueue(new NodeTuple(nodes.Nodes.Item2, nodes.Depth + 1));
        }
        return res.Count() == 0 ? null : res;
    }
}
```

成功解答出來了，但是成績不是很理想。

## Better Solutions

### Solution1

```python
def levelOrder(self, root):
    ans, level = [], [root]
    while root and level:
        ans.append([node.val for node in level])
        LRpair = [(node.left, node.right) for node in level]
        level = [leaf for LR in LRpair for leaf in LR if leaf]
    return ans
```

# 
