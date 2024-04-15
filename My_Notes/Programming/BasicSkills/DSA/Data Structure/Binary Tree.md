# Binary Tree

tags: #data_structure #tree #binary_tree

A binary tree is a hierarchical data structure in computer science. It consists of nodes, where each node contains a value and has at most two child nodes, referred to as the left child and the right child. The tree starts from a special node called the root, and every other node in the tree is a descendant of the root.

## Properties

1. **Root**: The topmost node of the tree, which serves as the starting point for traversing the tree.
2. **Node**: Each element in the tree that contains a value and has at most two child nodes.
3. **Leaf**: A node that does not have any children, also known as a terminal node.
4. **Parent**: A node that has one or more child nodes.
5. **Child**: A node that is connected to a parent node.
6. **Sibling**: Nodes that have the same parent.
7. **Depth**: The depth of a node is the number of edges from the root to that node.
8. **Height**: The height of a tree is the maximum depth of any node in the tree.
9. **Binary Search Tree (BST)**: A binary tree in which the values of all nodes in the left subtree are less than the value of the node, and the values of all nodes in the right subtree are greater than the value of the node.

## Tree Traversal

Traversal refers to the process of visiting all the nodes in a [[Tree]]. There are three common methods of tree traversal:

1. **Inorder Traversal**: In this traversal, we first visit the left subtree, then the root node, and finally the right subtree. For a binary search tree, an inorder traversal will visit the nodes in ascending order.

   ```go
   func inorderTraversal(node *TreeNode) {
       if node != nil {
           inorderTraversal(node.Left)
           fmt.Println(node.Value)
           inorderTraversal(node.Right)
       }
   }
   ```

2. **Preorder Traversal**: In this traversal, we first visit the root node, then the left subtree, and finally the right subtree.

   ```go
   func preorderTraversal(node *TreeNode) {
       if node != nil {
           fmt.Println(node.Value)
           preorderTraversal(node.Left)
           preorderTraversal(node.Right)
       }
   }
   ```

3. **Postorder Traversal**: In this traversal, we first visit the left subtree, then the right subtree, and finally the root node.

   ```go
   func postorderTraversal(node *TreeNode) {
       if node != nil {
           postorderTraversal(node.Left)
           postorderTraversal(node.Right)
           fmt.Println(node.Value)
       }
   }
   ```

## Example

Consider the following binary tree:

```
       6
     /   \
    4     8
   / \   / \
  2   5 7   9
```

The inorder traversal of this tree will give us the values in ascending order: 2, 4, 5, 6, 7, 8, 9.

The preorder traversal will give us: 6, 4, 2, 5, 8, 7, 9.

The postorder traversal will give us: 2, 5, 4, 7, 9, 8, 6.

## Conclusion

Binary trees are fundamental data structures used in various algorithms and applications. They provide an efficient way to store and retrieve data in a hierarchical manner. Understanding binary trees and their traversal methods is crucial for any programmer or computer scientist.
