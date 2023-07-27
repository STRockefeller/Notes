# LeetCode:852:20230725:dart

tags: #problem_solve #dart #binary_search #leetcode/medium

[Reference](https://leetcode.com/problems/peak-index-in-a-mountain-array/)

## Question

An array arr a mountain if the following properties hold:

- arr.length >= 3
- There exists some i with 0 < i < arr.length - 1 such that:
  - arr[0] < arr[1] < ... < arr[i - 1] < arr[i]
  - arr[i] > arr[i + 1] > ... > arr[arr.length - 1]

Given a mountain array arr, return the index i such that arr[0] < arr[1] < ... < arr[i - 1] < arr[i] > arr[i + 1] > ... > arr[arr.length - 1].

You must solve it in O(log(arr.length)) time complexity.

Example 1:

```text
Input: arr = [0,1,0]
Output: 1
```

Example 2:

```text
Input: arr = [0,2,1,0]
Output: 1
```

Example 3:

```text
Input: arr = [0,10,5,2]
Output: 1
```

Constraints:

3 <= arr.length <= $10^5$
0 <= arr[i] <= $10^6$
arr is guaranteed to be a mountain array.

## My Solution

### Approaches

If I have a mountain like ![image](https://i.imgur.com/sr77Zc7.png)

In the 1st step, I will check if the mid index is peak.

![image](https://i.imgur.com/U7I1pHk.png)

Unfortunately, it's not.

In the 2nd step, I will have a new mountain according to the higher point of arr[mid-1] and arr[mid+1].

![image](https://i.imgur.com/20HcriC.png)

and then loop the steps.

### Solution

```dart
class Solution {
  int peakIndexInMountainArray(List<int> arr) {
    int left = 0;
    int right = arr.length - 1;
    while (left <= right) {
      int mid = left + ((right - left) ~/ 2);
      PeakValidation validation = _peakValidate(arr, mid);
      switch (validation) {
        case PeakValidation.Peak:
          return mid;
        case PeakValidation.LeftHigher:
          right = mid - 1;
          break;
        default:
          left = mid + 1;
          break;
      }
    }

    // never
    return -1;
  }

  PeakValidation _peakValidate(List<int> arr, int index) {
    int left = index == 0 ? 0 : arr[index - 1];
    int right = index == arr.length - 1 ? 0 : arr[index + 1];
    if (arr[index] > left && arr[index] > right) {
      return PeakValidation.Peak;
    }
    if (left > arr[index]) {
      return PeakValidation.LeftHigher;
    }
    return PeakValidation.RightHigher;
  }
}

enum PeakValidation { LeftHigher, RightHigher, Peak }
```

result

![image](https://i.imgur.com/5hJIaNl.png)

## Better Solutions

### Solution1

```cpp
class Solution {
public:
    int peakIndexInMountainArray(vector<int>& arr) {
        int left = 0;
        int right = arr.size() - 1;
        int mid;

        while (left <right) {
            mid = (left + right) / 2;
            if (arr[mid] < arr[mid + 1])
                left = mid + 1;
            else
                right = mid;
        }

        return left;
    }
};
```
