# 題目來源:題號:解題日期:語言

tags: #problem_solve #leetcode/medium #monotonic_stack #golang #linked_list 

[Reference](https://leetcode.com/problems/remove-nodes-from-linked-list/description/)

## Question

You are given the `head` of a linked list.

Remove every node which has a node with a greater value anywhere to the right side of it.

Return _the_ `head` _of the modified linked list._

**Example 1:**

![](https://assets.leetcode.com/uploads/2022/10/02/drawio.png)

**Input:** head = [5,2,13,3,8]
**Output:** [13,8]
**Explanation:** The nodes that should be removed are 5, 2 and 3.
- Node 13 is to the right of node 5.
- Node 13 is to the right of node 2.
- Node 8 is to the right of node 3.

**Example 2:**

**Input:** head = [1,1,1,1]
**Output:** [1,1,1,1]
**Explanation:** Every node has value 1, so no nodes are removed.

**Constraints:**

- The number of the nodes in the given list is in the range `[1, 10^5]`.
- `1 <= Node.val <= 10^5`

## My Solution

想到使用monotonic stack來解。但對於如何在list上操作暫時想不到，只好先放到array來處理。

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func removeNodes(head *ListNode) *ListNode {
    nodes := []*ListNode{}
    for ;head != nil;head = head.Next{
        nodes = append(nodes, head)
    }
    stack := make([]*ListNode,0,len(nodes))
    for _, node := range nodes{
        for len(stack) != 0 && stack[len(stack)-1].Val < node.Val{
            stack = stack[:len(stack)-1]
        }
        stack = append(stack, node)
    }
    for i := 0 ; i< len(stack)-1; i++{
        stack[i].Next = stack[i+1]
    }
    return stack[0]
}
```

算是順利地解開了，但可想而知的效率不彰

![image](https://i.imgur.com/1utPUZz.png)

## Better Solutions

### Solution1

```cpp
class Solution {
public:
    ListNode* removeNodes(ListNode* head) {
        ListNode *prev = nullptr, *curr = head;
        while (curr != nullptr) {
            // ListNode* next = curr->next;
            // curr->next = prev;
            // prev = curr;
            // curr = next;
            swap(curr->next, prev);
            swap(prev, curr);
        }

        ListNode* dummyHead = new ListNode(-1);
        ListNode* tempPrev = dummyHead;
        curr = prev;

        while (curr != nullptr) {
            if (curr->val >= tempPrev->val) {
                tempPrev->next = curr;
                tempPrev = curr;
                curr = curr->next;
            } else {
                curr = curr->next;
            }
        }
        tempPrev->next = nullptr;

        ListNode *newPrev = nullptr, *newCurr = dummyHead->next;
        while (newCurr != nullptr) {
            // ListNode* next = newCurr->next;
            // newCurr->next = newPrev;
            // newPrev = newCurr;
            // newCurr = next;
            swap(newCurr->next, newPrev);
            swap(newPrev, newCurr);
        }

        return newPrev;
    }
};
```

| Process                              | Linked List           |
|--------------------------------------|-----------------------|
| Given Linked List                    | 5 -> 2 -> 13 -> 3 -> 8|
| Reverse it                           | 8 -> 3 -> 13 -> 2 -> 5|
| Remove Nodes smaller than Previous nodes | 8 -> 13              |
| Reverse it again                     | 13 -> 8               |

先反轉，移除比前一個小的節點，再轉回來，相當乾淨俐落的做法。