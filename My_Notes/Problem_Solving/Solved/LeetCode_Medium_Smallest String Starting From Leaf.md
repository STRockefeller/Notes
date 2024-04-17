# LeetCode:988:20240417:Go

tags: #problem_solve #DFS #golang #leetcode/medium 

[Reference](https://leetcode.com/problems/smallest-string-starting-from-leaf/description/)

## Question

You are given the `root` of a binary tree where each node has a value in the range `[0, 25]` representing the letters `'a'` to `'z'`.

Return _the **lexicographically smallest** string that starts at a leaf of this tree and ends at the root_.

As a reminder, any shorter prefix of a string is **lexicographically smaller**.

- For example, `"ab"` is lexicographically smaller than `"aba"`.

A leaf of a node is a node that has no children.

**Example 1:**

![](https://assets.leetcode.com/uploads/2019/01/30/tree1.png)

**Input:** root = [0,1,2,3,4,3,4]
**Output:** "dba"

**Example 2:**

![](https://assets.leetcode.com/uploads/2019/01/30/tree2.png)

**Input:** root = [25,1,3,1,3,0,2]
**Output:** "adz"

**Example 3:**

![](https://assets.leetcode.com/uploads/2019/02/01/tree3.png)

**Input:** root = [2,2,1,null,1,0,null,0]
**Output:** "abc"

**Constraints:**

- The number of nodes in the tree is in the range `[1, 8500]`.
- `0 <= Node.val <= 25`
## My Solution

### approach

Using [[Depth-First Search]] traversal and record the paths.

### 1st (misunderstood the problem)

```go
/**

 * Definition for a binary tree node.

 * type TreeNode struct {

 *     Val int

 *     Left *TreeNode

 *     Right *TreeNode

 * }

 */

func smallestFromLeaf(root *TreeNode) string {

    path := dfs(root)

    ba := make([]byte,len(path))

    for i,n:=range path{

        ba[i] = byte('a'+n)

    }

    return string(ba)

}

  

func dfs(node *TreeNode)(path []int){

    if node == nil{

        return nil

    }

    if node.Left == nil && node.Right==nil{

        // it is a leaf

        return []int{node.Val}

    }

    lp:=dfs(node.Left)

    rp:=dfs(node.Right)

    if lp == nil{

        return append(rp,node.Val)

    }

    if rp == nil{

        return append(lp,node.Val)

    }

    if len(rp)<len(lp){

        return append(rp,node.Val)

    }

    if len(lp)<len(rp){

        return append(lp,node.Val)

    }

    for i := 0; i<len(lp); i++{

        if lp[i]==rp[i]{

            continue

        }

        if lp[i]<rp[i]{

            return append(lp,node.Val)

        }

        return append(rp,node.Val)

    }

    return append(lp,node.Val)

}
```
![image](https://i.imgur.com/o8EPASq.png)

I misunderstood that shorter strings are preferred.
### 2nd (wrong answer)


```go
/**

 * Definition for a binary tree node.

 * type TreeNode struct {

 *     Val int

 *     Left *TreeNode

 *     Right *TreeNode

 * }

 */

func smallestFromLeaf(root *TreeNode) string {

    path := dfs(root)

    ba := make([]byte,len(path))

    for i,n:=range path{

        ba[i] = byte('a'+n)

    }

    return string(ba)

}

  

func dfs(node *TreeNode)(path []int){

    if node == nil{

        return nil

    }

    if node.Left == nil && node.Right==nil{

        // it is a leaf

        return []int{node.Val}

    }

    lp:=dfs(node.Left)

    rp:=dfs(node.Right)

    if lp == nil{

        return append(rp,node.Val)

    }

    if rp == nil{

        return append(lp,node.Val)

    }

    length := len(rp)

    if len(lp)>len(rp){

        length = len(lp)

    }

    for i := 0; i<length; i++{

        if i == len(lp){

            return append(lp,node.Val)

        }

        if i == len(rp){

            return append(rp,node.Val)

        }

        if lp[i]==rp[i]{

            continue

        }

        if lp[i]<rp[i]{

            return append(lp,node.Val)

        }

        return append(rp,node.Val)

    }

    return append(lp,node.Val)

}
```

![image](https://i.imgur.com/HIBMAxW.png)

I should also compare the current node.

### 3rd (wrong answer)

```go
/**

 * Definition for a binary tree node.

 * type TreeNode struct {

 *     Val int

 *     Left *TreeNode

 *     Right *TreeNode

 * }

 */

func smallestFromLeaf(root *TreeNode) string {

    path := dfs(root)

    ba := make([]byte,len(path))

    for i,n:=range path{

        ba[i] = byte('a'+n)

    }

    return string(ba)

}

  

func dfs(node *TreeNode)(path []int){

    if node == nil{

        return nil

    }

    if node.Left == nil && node.Right==nil{

        // it is a leaf

        return []int{node.Val}

    }

    lp:=dfs(node.Left)

    rp:=dfs(node.Right)

    if lp == nil{

        return append(rp,node.Val)

    }

    if rp == nil{

        return append(lp,node.Val)

    }

    length := len(rp)

    if len(lp)>len(rp){

        length = len(lp)

    }

    for i := 0; i<length; i++{

        if i == len(lp){

            if rp[i] < node.Val{

                return append(rp,node.Val)

            }

            return append(lp,node.Val)

        }

        if i == len(rp){

            if lp[i] < node.Val{

                return append(lp,node.Val)

            }

            return append(rp,node.Val)

        }

        if lp[i]==rp[i]{

            continue

        }

        if lp[i]<rp[i]{

            return append(lp,node.Val)

        }

        return append(rp,node.Val)

    }

    return append(lp,node.Val)

}
```

![image](https://i.imgur.com/kjs58uU.png)

Comparing the current node is not enough...

### 4th

```go
/**

 * Definition for a binary tree node.

 * type TreeNode struct {

 *     Val int

 *     Left *TreeNode

 *     Right *TreeNode

 * }

 */

func smallestFromLeaf(root *TreeNode) string {

    result := "{" // A character lexicographically greater than 'z'

    dfs(root, "", &result)

    return result

}

  

func dfs(node *TreeNode, path string, result *string) {

    if node == nil {

        return

    }

    currentPath := string(node.Val + 'a') + path

    if node.Left == nil && node.Right == nil {

        if currentPath < *result {

            *result = currentPath

        }

    }

    dfs(node.Left, currentPath, result)

    dfs(node.Right, currentPath, result)

}
```

![image](https://i.imgur.com/4DT1GSL.png)

Using strings comparison
## Better Solutions
