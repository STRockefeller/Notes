# LeetCode:752:20240422:Go

tags: #problem_solve #BFS #golang #leetcode/medium 

[Reference](https://leetcode.com/problems/open-the-lock/description/)

## Question

You have a lock in front of you with 4 circular wheels. Each wheel has 10 slots: `'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'`. The wheels can rotate freely and wrap around: for example we can turn `'9'` to be `'0'`, or `'0'` to be `'9'`. Each move consists of turning one wheel one slot.

The lock initially starts at `'0000'`, a string representing the state of the 4 wheels.

You are given a list of `deadends` dead ends, meaning if the lock displays any of these codes, the wheels of the lock will stop turning and you will be unable to open it.

Given a `target` representing the value of the wheels that will unlock the lock, return the minimum total number of turns required to open the lock, or -1 if it is impossible.

**Example 1:**

**Input:** deadends = ["0201","0101","0102","1212","2002"], target = "0202"
**Output:** 6
**Explanation:** 
A sequence of valid moves would be "0000" -> "1000" -> "1100" -> "1200" -> "1201" -> "1202" -> "0202".
Note that a sequence like "0000" -> "0001" -> "0002" -> "0102" -> "0202" would be invalid,
because the wheels of the lock become stuck after the display becomes the dead end "0102".

**Example 2:**

**Input:** deadends = ["8888"], target = "0009"
**Output:** 1
**Explanation:** We can turn the last wheel in reverse to move from "0000" -> "0009".

**Example 3:**

**Input:** deadends = ["8887","8889","8878","8898","8788","8988","7888","9888"], target = "8888"
**Output:** -1
**Explanation:** We cannot reach the target without getting stuck.

**Constraints:**

- `1 <= deadends.length <= 500`
- `deadends[i].length == 4`
- `target.length == 4`
- target **will not be** in the list `deadends`.
- `target` and `deadends[i]` consist of digits only.

## My Solution

### Approach

- [[Breadth-First Search]]

### 1st

```go
func openLock(deadends []string, target string) int {

    de := make(map[string]bool, len(deadends))

    for _, end := range deadends{

        de[end] = true

    }

    type queueItem struct{

        value string

        depth int

    }

    queue := []queueItem{queueItem{

        value: "0000",

        depth: 0,

    }}

    attempt := func()int{

        current := queue[0]

        queue = queue[1:]

        if current.value == target{

            return current.depth

        }

        for i:=0;i<4;i++{

            if next:=increase(current.value, i); !de[next]{

                queue = append(queue, queueItem{

                    value: next,

                    depth: current.depth+1,

                })

            }

            if next:=decrease(current.value, i); !de[next]{

                queue = append(queue, queueItem{

                    value: next,

                    depth: current.depth+1,

                })

            }

        }

        de[current.value]=true

        return -1

    }

    for len(queue)>0{

        if res := attempt();res!=-1{

            return res

        }

    }

    return -1

}

  
  

// wheels is composed by 4 digits

// digit shows the index of the number in wheel

// ex: increase("0000", 1) will return "0100"

func increase(wheels string, digit int) string {

    // Convert the string to a slice of bytes for easier manipulation

    wheel := []byte(wheels)

    // Increment the digit at the specified index by 1

    if wheel[digit] == '9' {

        wheel[digit] = '0'

    }else{

        wheel[digit] = (wheel[digit]-'0'+1)%10 + '0'

    }

    // Convert the slice of bytes back to a string and return

    return string(wheel)

}

  

// wheels is composed by 4 digits

// digit shows the index of the number in wheel

// decrease 0 => 9

// ex: decrease("0000", 1) will return "0900"

func decrease(wheels string, digit int) string {

    wheel := []byte(wheels)

    // Decrement the digit at the specified index by 1

    if wheel[digit] == '0' {

        wheel[digit] = '9'

    } else {

        wheel[digit] = (wheel[digit]-'0'-1)%10 + '0'

    }

    return string(wheel)

}
```

result: timout

### 2nd

```go
func openLock(deadends []string, target string) int {

    if target == "0000"{

        return 0

    }

    visited := make(map[string]bool, len(deadends))

    for _, end := range deadends {

        visited[end] = true

    }

  

    start := "0000"

    if visited[start] || visited[target] {

        return -1

    }

  

    // Queue setup with initial position

    queue := []queueItem{{value: start, depth: 0}}

    visited[start] = true  // Mark the start as visited

  

    // BFS loop

    for len(queue) > 0 {

        current := queue[0]

        queue = queue[1:]

  

        // Generate and enqueue all possible next states

        for i := 0; i < 4; i++ {

            for _, next := range []string{increase(current.value, i), decrease(current.value, i)} {

                if next == target {

                    return current.depth + 1

                }

                if !visited[next] {

                    visited[next] = true

                    queue = append(queue, queueItem{value: next, depth: current.depth + 1})

                }

            }

        }

    }

  

    return -1

}

  

type queueItem struct {

    value string

    depth int

}

  

func increase(wheels string, digit int) string {

    wheel := []byte(wheels)

    if wheel[digit] == '9' {

        wheel[digit] = '0'

    } else {

        wheel[digit]++

    }

    return string(wheel)

}

  

func decrease(wheels string, digit int) string {

    wheel := []byte(wheels)

    if wheel[digit] == '0' {

        wheel[digit] = '9'

    } else {

        wheel[digit]--

    }

    return string(wheel)

}
```

![image](https://i.imgur.com/JEbiMFy.png)
## Better Solutions
