# LeetCode:107:20221004:C#

[Reference](https://leetcode.com/problems/binary-tree-level-order-traversal-ii/)

## Question

Given the `root` of a binary tree, return *the bottom-up level order traversal of its nodes' values*. (i.e., from left to right, level by level from leaf to root).

**Example 1:**

![](https://assets.leetcode.com/uploads/2021/02/19/tree1.jpg)

**Input:** root = [3,9,20,null,null,15,7]
**Output:** [[15,7],[9,20],[3]]

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

跟第一題的相似度極高，所以我就偷懶直接拿第一題的答案做reverse

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
internal record NodeTuple
{
    internal Tuple<TreeNode?, TreeNode?> Nodes { get; }
    /// <summary>
    /// start from 0
    /// </summary>
    /// <value></value>
    internal int Depth { get; }
    internal NodeTuple(Tuple<TreeNode?, TreeNode?> nodes, int depth)
    {
        Nodes = nodes;
        Depth = depth;
    }
    internal NodeTuple(TreeNode root, int depth)
    {
        Nodes = new Tuple<TreeNode?, TreeNode?>(root.left, root.right);
        Depth = depth;
    }
}

public class Solution {
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
    public IList<IList<int>> LevelOrderBottom(TreeNode root) => this.LevelOrder(root).Reverse().ToList();
}
```

想當然爾，成績不是很理想。

![](https://i.imgur.com/ngesDER.png)

再找時間認真來解解看吧，其他人的解答也先不看了。

## Better Solutions
