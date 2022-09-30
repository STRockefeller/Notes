# LeetCode:496:20220914:Go

[Reference](https://leetcode.com/problems/next-greater-element-i/)

## Question

The **next greater element** of some element `x` in an array is the **first greater** element that is **to the right** of `x` in the same array.

You are given two **distinct 0-indexed** integer arrays `nums1` and `nums2`, where `nums1` is a subset of `nums2`.

For each `0 <= i < nums1.length`, find the index `j` such that `nums1[i] == nums2[j]` and determine the **next greater element** of `nums2[j]` in `nums2`. If there is no next greater element, then the answer for this query is `-1`.

Return *an array* `ans` *of length* `nums1.length` *such that* `ans[i]` *is the **next greater element** as described above.*

**Example 1:**

**Input:** nums1 = [4,1,2], nums2 = [1,3,4,2]
**Output:** [-1,3,-1]
**Explanation:** The next greater element for each value of nums1 is as follows:

- 4 is underlined in nums2 = [1,3,<u>4</u>,2]. There is no next greater element, so the answer is -1.
- 1 is underlined in nums2 = [<u>1</u>,3,4,2]. The next greater element is 3.
- 2 is underlined in nums2 = [1,3,4,<u>2</u>]. There is no next greater element, so the answer is -1.

**Example 2:**

**Input:** nums1 = [2,4], nums2 = [1,2,3,4]
**Output:** [3,-1]
**Explanation:** The next greater element for each value of nums1 is as follows:

- 2 is underlined in nums2 = [1,<u>2</u>,3,4]. The next greater element is 3.
- 4 is underlined in nums2 = [1,2,3,<u>4</u>]. There is no next greater element, so the answer is -1.

**Constraints:**

- `1 <= nums1.length <= nums2.length <= 1000`
- `0 <= nums1[i], nums2[i] <= 10^4`
- All integers in `nums1` and `nums2` are **unique**.
- All the integers of `nums1` also appear in `nums2`.

**Follow up:** Could you find an `O(nums1.length + nums2.length)` solution?

## My Solution

這題很簡單，但我寫了很多次數度都提不上去。所以這邊還是紀錄一下

以下包含各種版本的解法以及測試

```go
func Test_nextGreaterElement(t *testing.T) {
    assert := assert.New(t)

    assert.Equal([]int{-1, 3, -1}, nextGreaterElementV6([]int{4, 1, 2}, []int{1, 3, 4, 2}))
    assert.Equal([]int{3, -1}, nextGreaterElementV6([]int{2, 4}, []int{1, 2, 3, 4}))
    assert.Equal([]int{-1, 2, 3}, nextGreaterElementV6([]int{4, 1, 2}, []int{1, 2, 3, 4}))
}

func BenchmarkV1(b *testing.B) {
    for i := 0; i < b.N; i++ {
        nextGreaterElementV1([]int{4, 1, 2}, []int{1, 2, 3, 4})
        nextGreaterElementV1([]int{4, 1, 2, 5, 8, 7, 9}, []int{1, 2, 9, 7, 8, 5, 3, 4})
    }
}

func BenchmarkV2(b *testing.B) {
    for i := 0; i < b.N; i++ {
        nextGreaterElementV2([]int{4, 1, 2}, []int{1, 2, 3, 4})
        nextGreaterElementV2([]int{4, 1, 2, 5, 8, 7, 9}, []int{1, 2, 9, 7, 8, 5, 3, 4})
    }
}

func BenchmarkV3(b *testing.B) {
    for i := 0; i < b.N; i++ {
        nextGreaterElementV3([]int{4, 1, 2}, []int{1, 2, 3, 4})
        nextGreaterElementV3([]int{4, 1, 2, 5, 8, 7, 9}, []int{1, 2, 9, 7, 8, 5, 3, 4})
    }
}

func BenchmarkV4(b *testing.B) {
    for i := 0; i < b.N; i++ {
        nextGreaterElementV4([]int{4, 1, 2}, []int{1, 2, 3, 4})
        nextGreaterElementV4([]int{4, 1, 2, 5, 8, 7, 9}, []int{1, 2, 9, 7, 8, 5, 3, 4})
    }
}

func BenchmarkV5(b *testing.B) {
    for i := 0; i < b.N; i++ {
        nextGreaterElementV5([]int{4, 1, 2}, []int{1, 2, 3, 4})
        nextGreaterElementV5([]int{4, 1, 2, 5, 8, 7, 9}, []int{1, 2, 9, 7, 8, 5, 3, 4})
    }
}

func BenchmarkV6(b *testing.B) {
    for i := 0; i < b.N; i++ {
        nextGreaterElementV6([]int{4, 1, 2}, []int{1, 2, 3, 4})
        nextGreaterElementV6([]int{4, 1, 2, 5, 8, 7, 9}, []int{1, 2, 9, 7, 8, 5, 3, 4})
    }
}

type stack struct {
    elements []int
}

func (s stack) peek() int {
    if s.isEmpty() {
        return 0
    }
    return s.elements[0]
}

func (s *stack) push(num int) {
    s.elements = append([]int{num}, s.elements...)
}

func (s *stack) pop() int {
    res := s.peek()
    s.elements = s.elements[1:]
    return res
}

func (s stack) isEmpty() bool {
    return len(s.elements) == 0
}

func nextGreaterElementV6(n1, n2 []int) []int {
    m := make(map[int]int)
    var s stack
    for _, elem := range n2 {
        for !s.isEmpty() && s.peek() < elem {
            m[s.pop()] = elem
        }
        s.push(elem)
    }

    for i := range n1 {
        if v, ok := m[n1[i]]; ok {
            n1[i] = v
        } else {
            n1[i] = -1
        }
    }

    return n1
}

func nextGreaterElementV5(n1, n2 []int) []int {
    res := make([]int, len(n1))
    nextGreaterElementInN2 := make(map[int]int)

    for i, elem := range n2 {
        for j, nextElem := range n2 {
            if _, ok := nextGreaterElementInN2[elem]; !ok && j > i && nextElem > elem {
                nextGreaterElementInN2[elem] = nextElem
            }
        }
        if _, ok := nextGreaterElementInN2[elem]; !ok {
            nextGreaterElementInN2[elem] = -1
        }
    }

    for i, elem := range n1 {
        res[i] = nextGreaterElementInN2[elem]
    }

    return res
}

func nextGreaterElementV4(n1, n2 []int) []int {
    res := make([]int, len(n1))
    for i := range res {
        res[i] = -1
    }

    indexesInN2 := make([]int, len(n1))
    copy(indexesInN2, res)

    for i, n := range n1 {
        for j, m := range n2 {
            if n == m {
                indexesInN2[i] = j
            }
            if res[i] == -1 && indexesInN2[i] != -1 && m > n && j > indexesInN2[i] {
                res[i] = m
            }
        }
    }

    return res
}

func nextGreaterElementV3(n1, n2 []int) []int {
    res := make([]int, len(n1))
    for i := range res {
        res[i] = -1
    }

    indexesInN2 := make([]int, len(n1))

    for i, n := range n1 {
        for j, m := range n2 {
            if n == m {
                indexesInN2[i] = j
            }
        }
    }

    for i := 0; i < len(n2); i++ {
        for j, n := range n1 {
            if d := n2[i]; res[j] == -1 && d > n && i > indexesInN2[j] {
                res[j] = d
            }
        }
    }

    return res
}

func nextGreaterElementV2(n1, n2 []int) []int {
    res := make([]int, len(n1))
    for i := range res {
        res[i] = -1
    }

    for i, n := range n1 {
        for j, m := range n2 {
            if n == m {
                for k := j + 1; k < len(n2); k++ {
                    if n2[k] > n {
                        res[i] = n2[k]
                        break
                    }
                }
            }
        }
    }

    return res
}

type index struct {
    inNums1, inNums2 int
}

func nextGreaterElementV1(nums1 []int, nums2 []int) []int {
    res := make([]int, len(nums1))
    for i := range res {
        res[i] = -1
    }
    indexMap := make(map[int]index)
    for i, num := range nums1 {
        indexMap[num] = index{inNums1: i}
    }

    for i, num := range nums2 {
        if _, ok := indexMap[num]; ok {
            indexMap[num] = index{
                inNums1: indexMap[num].inNums1,
                inNums2: i,
            }
        }
    }

    for key, val := range indexMap {
        for i := val.inNums2 + 1; i < len(nums2); i++ {
            if nums2[i] > key {
                res[val.inNums1] = nums2[i]
                break
            }
        }
    }

    return res
}
```

benchmark結果如下

```bash
goos: windows
goarch: amd64
pkg: gitlab.kenda.com.tw/kenda/mcom/impl/orm/models
cpu: Intel(R) Core(TM) i7-9700 CPU @ 3.00GHz
BenchmarkV1-8        1740058           677.9 ns/op         184 B/op           6 allocs/op
BenchmarkV2-8        8888019           129.6 ns/op          88 B/op           2 allocs/op
BenchmarkV3-8        5724950           211.4 ns/op         176 B/op           4 allocs/op
BenchmarkV4-8        6639661           176.8 ns/op         176 B/op           4 allocs/op
BenchmarkV5-8        1291465           925.0 ns/op          88 B/op           2 allocs/op
BenchmarkV6-8        2531091           472.9 ns/op         216 B/op          17 allocs/op
PASS
```

其中 V2 是暴力解法，V6是我最後受不了去抄了討論區的O(n)解，然後用golang重寫的版本。

是的沒錯，最快的竟然是暴力解法( O(n^3) )。其他解法，包含抄來的都沒它快，完全搞不懂為什麼。丟到leetcode測試也是一樣的結果。



## Better Solutions



### Solution1

O(n)解，只能說真的精采，不過我用golang重寫之後不知道為啥速度上不去

以下原文

Suppose we have a decreasing sequence followed by a greater number  
For example `[5, 4, 3, 2, 1, 6]` then the greater number `6` is the next greater element for all previous numbers in the sequence

We use a stack to keep a **decreasing** sub-sequence, whenever we see a number `x` greater than `stack.peek()` we pop all elements less than `x` and for all the popped ones, their next greater element is `x`  
For example `[9, 8, 7, 3, 2, 1, 6]`  
The stack will first contain `[9, 8, 7, 3, 2, 1]` and then we see `6` which is greater than `1` so we pop `1 2 3` whose next greater element should be `6`

```java
    public int[] nextGreaterElement(int[] findNums, int[] nums) {
        Map<Integer, Integer> map = new HashMap<>(); // map from x to next greater element of x
        Stack<Integer> stack = new Stack<>();
        for (int num : nums) {
            while (!stack.isEmpty() && stack.peek() < num)
                map.put(stack.pop(), num);
            stack.push(num);
        }   
        for (int i = 0; i < findNums.length; i++)
            findNums[i] = map.getOrDefault(findNums[i], -1);
        return findNums;
    }
```



拿它的例子來看 `[9, 8, 7, 3, 2, 1, 6]`，stack的情況演譯如下

1. 到index 5 為止都是遞減的，所以直接push到stack中
   
   ![](https://i.imgur.com/lbKgkzT.png)

2. 到index 6 時，應為 peek 出來的 1 < 6，於是這邊就利用pop迴圈把next greater element 是 6 的找出來。(1, 2, 3)
   
   ![](https://i.imgur.com/RHcb6tN.png)
   
   接著還是要把6加上去。
   
   ![](https://i.imgur.com/Qtha5W0.png)

3. 照這些步驟做完之後，有被pop出來的都有找到next greater element了，剩下都是找不到的。






