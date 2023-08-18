# LeetCode:86:20230815:C\#

tags: #problem_solve #leetcode/medium #c_sharp #linked_list

[Reference](https://leetcode.com/problems/partition-list/)

## Question

Given the `head` of a linked list and a value `x`, partition it such that all nodes **less than** `x` come before nodes **greater than or equal** to `x`.

You should **preserve** the original relative order of the nodes in each of the two partitions.

**Example 1:**

![](https://assets.leetcode.com/uploads/2021/01/04/partition.jpg)

**Input:** head = [1,4,3,2,5,2], x = 3
**Output:** [1,2,2,4,3,5]

**Example 2:**

**Input:** head = [2,1], x = 2
**Output:** [1,2]

**Constraints:**

- The number of nodes in the list is in the range `[0, 200]`.
- `-100 <= Node.val <= 100`
- `-200 <= x <= 200`

## My Solution

Approach:

- split the linked list to 2 parts, "less than the target" and "greater than or equal to the target"
- concatenate the 2 parts

```csharp
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public int val;
 *     public ListNode next;
 *     public ListNode(int val=0, ListNode next=null) {
 *         this.val = val;
 *         this.next = next;
 *     }
 * }
 */
public class Solution
{
    public ListNode Partition(ListNode head, int x)
    {
        Stack<int> lessPart = new Stack<int>();
        Stack<int> greaterOrEqualPart = new Stack<int>();

        for (ListNode node = head; node != null; node = node.next)
        {
            if (node.val < x)
                lessPart.Push(node.val);
            else
                greaterOrEqualPart.Push(node.val);
        }

        ListNode previousNode = null;
        while(greaterOrEqualPart.Count > 0)
        {
            ListNode node = new ListNode(greaterOrEqualPart.Pop());
            node.next = previousNode;
            previousNode = node;
        }
        while(lessPart.Count > 0)
        {
            ListNode node = new ListNode(lessPart.Pop());
            node.next = previousNode;
            previousNode = node;
        }
        return previousNode;
    }
}
```

result:

![image](https://i.imgur.com/5d8Nw8C.png)

it seems like a bad practice.

## Better Solutions
