# LeetCode:135:20230913:dart

tags: #problem_solve

[Reference](https://leetcode.com/problems/candy/)

## Question

There are n children standing in a line. Each child is assigned a rating value given in the integer array ratings.

You are giving candies to these children subjected to the following requirements:

Each child must have at least one candy.
Children with a higher rating get more candies than their neighbors.
Return the minimum number of candies you need to have to distribute the candies to the children.

Example 1:

Input: ratings = [1,0,2]
Output: 5
Explanation: You can allocate to the first, second and third child with 2, 1, 2 candies respectively.
Example 2:

Input: ratings = [1,2,2]
Output: 4
Explanation: You can allocate to the first, second and third child with 1, 2, 1 candies respectively.
The third child gets 1 candy because it satisfies the above two conditions.

Constraints:

n == ratings.length
1 <= n <= 2 *$10^4$
0 <= ratings[i] <= 2* $10^4$

## My Solution

Approach:

- initialize an array with initial value : 1
- iterate from index 0 to end, add candies while the current child has rating higher then the previous one.
- iterate from end to first, and do the same things.

```dart
class Solution {
  int candy(List<int> childrenRating) {
        List<int> candies = List.generate(childrenRating.length, (index)=>1 );
        for(int i = 1; i < childrenRating.length ; i++){
            if (childrenRating[i] > childrenRating[i-1] && candies[i] <= candies[i-1]){
                candies[i] = candies[i-1] + 1;
            }
        }
        for(int i = childrenRating.length-2 ; i >= 0 ; i--){
            if (childrenRating[i] > childrenRating[i+1] && candies[i] <= candies[i+1]){
                candies[i] = candies[i+1] + 1;
            }
        }

        int sum = 0;
        for(int i = 0 ; i < candies.length ; i++){
            sum += candies[i];
        }

        return sum;
  }
}
```

result:
![image](https://i.imgur.com/15ShYzE.png)

hard?

## Better Solutions

### Solution 1

[reference](https://leetcode.com/problems/candy/solutions/4037646/99-20-greedy-two-one-pass/)

```go
func candy(ratings []int) int {
    if len(ratings) == 0 {
        return 0
    }

    ret, up, down, peak := 1, 0, 0, 0

    for i := 0; i < len(ratings) - 1; i++ {
        prev, curr := ratings[i], ratings[i+1]

        if prev < curr {
            up++
            down = 0
            peak = up
            ret += 1 + up
        } else if prev == curr {
            up, down, peak = 0, 0, 0
            ret += 1
        } else {
            up = 0
            down++
            ret += 1 + down
            if peak >= down {
                ret--
            }
        }
    }

    return ret
}
```