# LeetCode:239:20230816:go

tags: #problem_solve

[Reference](https://leetcode.com/problems/sliding-window-maximum/)

## Question

You are given an array of integers `nums`, there is a sliding window of size `k` which is moving from the very left of the array to the very right. You can only see the `k` numbers in the window. Each time the sliding window moves right by one position.

Return _the max sliding window_.

**Example 1:**

**Input:** nums = [1,3,-1,-3,5,3,6,7], k = 3
**Output:** [3,3,5,5,6,7]
**Explanation:**
Window position                Max
---------------               -----
[1  3  -1] -3  5  3  6  7       **3**
 1 [3  -1  -3] 5  3  6  7       **3**
 1  3 [-1  -3  5] 3  6  7       **5**
 1  3  -1 [-3  5  3] 6  7       **5**
 1  3  -1  -3 [5  3  6] 7       **6**
 1  3  -1  -3  5 [3  6  7]      **7**

**Example 2:**

**Input:** nums = [1], k = 1
**Output:** [1]

**Constraints:**

- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`
- `1 <= k <= nums.length`

## My Solution

Approach: max heap

```go
package main

import (
	"container/heap"
)

type NumIndex struct {
	num   int // Value of the number
	index int // Index of the number in the original array
}

type MaxHeap []NumIndex

func (h MaxHeap) Len() int           { return len(h) }
func (h MaxHeap) Less(i, j int) bool { return h[i].num > h[j].num }
func (h MaxHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *MaxHeap) Push(x interface{}) {
	*h = append(*h, x.(NumIndex))
}

func (h *MaxHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}

func maxSlidingWindow(nums []int, k int) []int {
	n := len(nums)
	maxHeap := &MaxHeap{}

	result := make([]int, n-k+1)
	for i := 0; i < k; i++ {
		heap.Push(maxHeap, NumIndex{num: nums[i], index: i})
	}

	result[0] = (*maxHeap)[0].num
	for i := k; i < n; i++ {
		for len(*maxHeap) > 0 && (*maxHeap)[0].index <= i-k {
			heap.Pop(maxHeap)
		}
		heap.Push(maxHeap, NumIndex{num: nums[i], index: i})
		result[i-k+1] = (*maxHeap)[0].num
	}

	return result
}
```

result:

![image](https://i.imgur.com/QvX2QIH.png)

## Better Solutions

### Solution 1

deque

```cpp
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        int n=nums.size();
        deque<int> max_idx;//Double-ended queue storing index for max
        vector<int> ans(n-k+1);

        for(int i=0; i<n; i++){
            while(!max_idx.empty() && nums[i]>=nums[max_idx.back()])
                max_idx.pop_back();// pop back the indexes for smaller ones
            max_idx.push_back(i);  // push back the index for larger one

            if (max_idx.front()==i-k) // index=i-k should not in the window
                max_idx.pop_front();
            if (i>=k-1)
                ans[i-k+1]=nums[max_idx.front()]; //Max element for this window
        }
        return ans;
    }
};
```

### Solution 2

```cpp
class Solution {
public:
    int n;
    vector<int> max_idx;//array storing index for max
    int left=0;
    void print(){
        cout<<"[";
        for(int i=left; i<max_idx.size(); i++)
            cout<<max_idx[i]<<",";
        cout<<"]\n";
    }
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        n=nums.size();
        vector<int> ans(n-k+1);

        for(int i=0; i<n; i++){
            // max_idx using elements from index=left on
            while(max_idx.size()>left && nums[i]>=nums[max_idx.back()])
                max_idx.pop_back();// pop back the indexes for smaller ones
            max_idx.push_back(i);  // push back the index for larger one

            if (max_idx[left]==i-k) // index=i-k should not in the window
                left++;  //move left
        //    cout<<left;
        //    print();
            if (i>=k-1){
                ans[i-k+1]=nums[max_idx[left]]; //Max element for this window
        //        cout<<"->"<<ans[i-k+1]<<endl;
            }
        }
        return ans;
    }
};
```
