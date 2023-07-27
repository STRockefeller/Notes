# LeetCode:445:20230717:dart

tags: #problem_solve

Reference

## Question

You are given two non-empty linked lists representing two non-negative integers. The most significant digit comes first and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

Example 1:

![image](https://assets.leetcode.com/uploads/2021/04/09/sumii-linked-list.jpg)

```text
Input: l1 = [7,2,4,3], l2 = [5,6,4]
Output: [7,8,0,7]
```

Example 2:

```text
Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [8,0,7]
```

Example 3:

```text
Input: l1 = [0], l2 = [0]
Output: [0]
```

Constraints:

The number of nodes in each linked list is in the range [1, 100].
0 <= Node.val <= 9
It is guaranteed that the list represents a number that does not have leading zeros.

Follow up: Could you solve it without reversing the input lists?

## My Solution

I have no idea to solve this problem without reversing the lists.

```dart
class Solution {
  ListNode? addTwoNumbers(ListNode? l1, ListNode? l2) {
    ListNode? rl2 = reverseLinkedList(l2 ?? ListNode());
    ListNode? rl1 = reverseLinkedList(l1 ?? ListNode());
    List<int> rResList = [];

    int carry = 0;
    while (rl1 != null || rl2 != null || carry != 0) {
      rl1 = rl1 ?? ListNode();
      rl2 = rl2 ?? ListNode();
      int sum = rl1.val + rl2.val + carry;
      carry = sum ~/ 10;
      rResList.add(sum % 10);

      rl1 = rl1.next;
      rl2 = rl2.next;
    }

    return reverseLinkedList(convertNodesToList(rResList));
  }
}

ListNode reverseLinkedList(ListNode head) {
  ListNode? current = head;
  ListNode? previous = null;

  while (current != null) {
    ListNode? next = current.next;
    current.next = previous;
    previous = current;
    current = next;
  }

  return previous!;
}

ListNode convertNodesToList(List<int> values) {
  ListNode? head;
  ListNode? current;

  for (int val in values) {
    ListNode newNode = ListNode(val);

    if (head == null) {
      head = newNode;
      current = newNode;
    } else {
      current!.next = newNode;
      current = newNode;
    }
  }

  return head!;
}
```

result

![image](https://i.imgur.com/FqHQugI.png)

## Better Solutions
