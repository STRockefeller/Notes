# LeetCode:735:20230720:C\#

tags: #problem_solve #leetcode/medium #c_sharp #stack

[Reference](https://leetcode.com/problems/asteroid-collision/)

## Question

We are given an array asteroids of integers representing asteroids in a row.

For each asteroid, the absolute value represents its size, and the sign represents its direction (positive meaning right, negative meaning left). Each asteroid moves at the same speed.

Find out the state of the asteroids after all collisions. If two asteroids meet, the smaller one will explode. If both are the same size, both will explode. Two asteroids moving in the same direction will never meet.

Example 1:

```text
Input: asteroids = [5,10,-5]
Output: [5,10]
Explanation: The 10 and -5 collide resulting in 10. The 5 and 10 never collide.
```

Example 2:

```text
Input: asteroids = [8,-8]
Output: []
Explanation: The 8 and -8 collide exploding each other.
```

Example 3:

```text
Input: asteroids = [10,2,-5]
Output: [10]
Explanation: The 2 and -5 collide resulting in -5. The 10 and -5 collide resulting in 10.
```

Constraints:

2 <= asteroids.length <= $10^4$
-1000 <= asteroids[i] <= 1000
asteroids[i] != 0

## My Solution

Approach:

- collision condition: positive one -> <- negative one
- Using a Stack to store asteroids.

for example: `[10,2,-5]`

1. list: 2 -5 , stack: , move: 10
2. list: -5 , stack: 10 , move: 2
3. list:, stack: 10 2 , move: -5 (has a collision with the top of the stack)
4. list:, stack 10, move: -5 (has a collision with the top of the stack)
5. list:, stack: 10,move:

```Csharp
using System.Collections.Generic;

public class Solution
{
    public int[] AsteroidCollision(int[] asteroids)
    {
        Stack<int> afterCollisions = new Stack<int>();
        foreach (int asteroid in asteroids)
        {
            if (afterCollisions.Count == 0)
            {
                afterCollisions.Push(asteroid);
                continue;
            }

            if (asteroid > 0)
            {
                afterCollisions.Push(asteroid);
                continue;
            }

            while (afterCollisions.Count > 0)
            {
                if (afterCollisions.Peek() < 0)
                {
                    afterCollisions.Push(asteroid);
                    break;
                }
                int positiveOne = afterCollisions.Pop();
                if (positiveOne + asteroid > 0)
                {
                    afterCollisions.Push(positiveOne);
                    break;
                }

                if (positiveOne + asteroid == 0)
                    break;

                if (afterCollisions.Count == 0)
                {
                    afterCollisions.Push(asteroid);
                    break;
                }
            }
        }
        int[] res = new int[afterCollisions.Count];
        for (int i = res.Length - 1; i >= 0; i--)
        {
            res[i] = afterCollisions.Pop();
        }

        return res;
    }
}
```

result:

![image](https://i.imgur.com/apdPojd.png)

## Better Solutions
