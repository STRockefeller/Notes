# LeetCode:15:20220422:TypeScript

[Reference](https://leetcode.com/problems/3sum/)



## Question

Given an integer array nums, return all the triplets `[nums[i], nums[j], nums[k]]` such that `i != j`, `i != k`, and `j != k`, and `nums[i] + nums[j] + nums[k] == 0`.

Notice that the solution set must not contain duplicate triplets.

 

**Example 1:**

```
Input: nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]
```

**Example 2:**

```
Input: nums = []
Output: []
```

**Example 3:**

```
Input: nums = [0]
Output: []
```

 

**Constraints:**

- `0 <= nums.length <= 3000`
- `-105 <= nums[i] <= 105`

## My Solution

### n^3 (timeout)

雖然題目沒有提及要怎麼排列，但根據Example1來看，應該是數字由小到大排。

最先想到的是任意兩數字相加，然後從剩下的數字找對應的數，感覺應該快不起來，不過暫時沒想到其他的，先試試。



```typescript
function threeSum(nums: number[]): number[][] {
    var res = Array<number[]>();
    for (let i = 0; i < nums.length; i++) {
        for (let j = i + 1; j < nums.length; j++) {
            const temp = parseNums(i, j, [...nums]);
            if (temp === false) {
                continue;
            }
            res.push(<number[]>temp);
        }
    }
    return distinctArray([...res]);
}

function parseNums(i: number, j: number, nums: number[]): number[] | boolean {
    const firstNum = nums[i];
    const secondNum = nums[j];
    const newNum = firstNum + secondNum;
    nums.splice(j, 1);
    nums.splice(i, 1);
    // nums.forEach((num) => {
    //   if (num === -1 * newNum) {
    //     return [firstNum, secondNum, newNum * -1].sort();
    //   }
    // });
    for (let i = 0; i < nums.length; i++) {
        if (nums[i] === -1 * newNum) {
            return [firstNum, secondNum, newNum * -1].sort();
        }
    }
    return false;
}

function distinctArray(nums: number[][]): number[][] {
    var set = new Set<string>();
    var res = new Array<number[]>();
    for (let i = 0; i < nums.length; i++) {
        if (!set.has(nums[i].toString())) {
            res.push(nums[i]);
        }
        set.add(nums[i].toString());
    }
    return res;
}

```

超過n^3的複雜度，不意外的time out

不過倒是學到不少東西。

* ts 的 array 屬於傳址，不想動到原array的話要記得clone
* 承上，參考型別的array無論使用 index of或者作為map的key都無法發揮預期的效果，distinct特別麻煩，找老半天找不到適合的，只好自己重頭寫。
* 小心forEach的陷阱(裡面寫return會做為內部方法的return)，很容易忽略，剛大大的踩了一下，把它註解起來留作警惕。



---

### n^2logn ?(timeout)

這次試著先整理資料

先拿example1來看

`[-1,0,1,2,-1,-4]` =>`[-4,-1,-1,0,1,2]`

由左往右看，先取第一個`-4`，接著剩下兩個數字相加必須要是`4`。

下一個數字為`-1`，`-1`要組成`4`必須要有一個`5`，往右找發現沒有`5`。

再接著下去

`-1`找不到`5`

`0`找不到`4`

`1`找不到`3`

`2`找不到另一個`2`

=>得知沒有包含`-4`的答案

接著以`[-1,-1,0,1,2]`繼續上一步。



然後來看看這個做法有甚麼好處:

* 不用排序答案，最開始就進行過排序了
* 不用做distinct
* 在一個排序過的array去找特定的值==>binary search



大致上會像是這樣(先隨便寫寫)

```C#
for(int i = 0; i <nums.Length; i++){
   firstNum = nums[i] ;
   for(int j = i+1; j<nums.Length; j++){
        secondNum = nums[j];
   		rest = nums.Skip(j+1);
   		// binary search rest.Contains(-firstNum-secondNum)
   }
}
```



光這邊就是兩個迴圈(接近n^2)再乘上binary search(logn)複雜度，似乎比第一次好一點點，總之先試試。



初版如下

```typescript
function search(arr: number[], target: number): boolean {
  var left = 0;
  var right = arr.length - 1;
  while (left <= right) {
    var m = Math.floor((left + right) / 2);
    switch (arr[m] === target) {
      case true:
        return true;
      case false:
        left = arr[m] < target ? m + 1 : left;
        right = arr[m] > target ? m - 1 : right;
        break;
    }
  }
  return false;
}

function threeSum(nums: number[]): number[][] {
  var res = new Array<number[]>();
  nums = nums.sort(function (a, b): number {
    return a - b;
  });
  console.log(nums);
  var first: number, second: number, third: number;
  var rest: number[];
  for (var i = 0; i < nums.length; i++) {
    first = nums[i];
    console.log("first", first);
    for (var j = i + 1; j < nums.length; j++) {
      second = nums[j];
      console.log("second", second);
      rest = Object.assign([], nums);
      rest.splice(0, j + 1); //hello
      third = -first - second;
      // binary search
      if (search(rest, third)) {
        res.push([first, second, third]);
        console.log("third", third);
      }
    }
  }
  return res;
}
```

邊寫邊發現還有一些可以優化的地方:

1. 排除重複的答案:比如`[-4,-1,-1,0,1,2]`取index 2和3作為第一個數字，都會找到-1,0,1的答案。
2. 省略確定找不到的搜尋動作，比如前兩個數字分別是-1,1接著要往右找0顯然是多此一舉。

完成如下

```typescript
function search(arr: number[], target: number): boolean {
    var left = 0;
    var right = arr.length - 1;
    while (left <= right) {
      var m = Math.floor((left + right) / 2);
      switch (arr[m] === target) {
        case true:
          return true;
        case false:
          left = arr[m] < target ? m + 1 : left;
          right = arr[m] > target ? m - 1 : right;
          break;
      }
    }
    return false;
  }
  
  function threeSum(nums: number[]): number[][] {
    var res = new Array<number[]>();
    nums = nums.sort(function (a, b): number {
      return a - b;
    });
    var first: number, second: number, third: number;
    var rest: number[];
    var previousFirst: number = nums[0] - 1;
    for (var i = 0; i < nums.length; i++) {
      first = nums[i];
      if (first === previousFirst || first > 0) {
        continue;
      }
      previousFirst = first;
      var previousSecond: number = nums[0] - 1;
      for (var j = i + 1; j < nums.length; j++) {
        second = nums[j];
        if (second === previousSecond) {
          continue;
        }
        previousSecond = second;
        rest = Object.assign([], nums);
        rest.splice(0, j + 1); //hello
        third = -first - second;
        if (third < second) {
          continue;
        }
        // binary search
        if (search(rest, third)) {
          res.push([first, second, third]);
        }
      }
    }
    return res;
  }
```

依然是timeout

難道要自己實作排序?

反正想不到怎麼搞，不如試試

### bucket sort(wrong)

選擇用空間省時間的bucket sort，根據題目`-105<nums[i]<105`，我只要做兩百多個bucket就OK了，妥妥的

```typescript
function search(arr: number[], target: number): boolean {
  let left = 0;
  let right = arr.length - 1;
  while (left <= right) {
    const m = Math.floor((left + right) / 2);
    switch (arr[m] === target) {
      case true:
        return true;
      case false:
        left = arr[m] < target ? m + 1 : left;
        right = arr[m] > target ? m - 1 : right;
        break;
    }
  }
  return false;
}

function threeSum(nums: number[]): number[][] {
  const res = new Array<number[]>();
  nums = bucketSort(nums);
  let first: number, second: number, third: number;
  let rest: number[];
  let previousFirst: number = nums[0] - 1;
  for (let i = 0; i < nums.length; i++) {
    first = nums[i];
    if (first === previousFirst || first > 0) {
      continue;
    }
    previousFirst = first;
    let previousSecond: number = nums[0] - 1;
    for (let j = i + 1; j < nums.length; j++) {
      second = nums[j];
      if (second === previousSecond) {
        continue;
      }
      previousSecond = second;
      rest = Object.assign([], nums);
      rest.splice(0, j + 1); //hello
      third = -first - second;
      if (third < second) {
        continue;
      }
      // binary search
      if (search(rest, third)) {
        res.push([first, second, third]);
      }
    }
  }
  return res;
}

function bucketSort(nums: number[]): number[] {
  const buckets: number[] = new Array<number>(211).fill(0); //-105~105
  for (let i = 0; i < nums.length; i++) {
    buckets[nums[i] + 105]++;
  }
  const res: number[] = new Array<number>();
  for (let i = 0; i < buckets.length; i++) {
    for (let j = 0; j < buckets[i]; j++) {
      res.push(i - 105)
    }
  }
  return res
}
```

結果

![](https://i.imgur.com/IcKcZaw.png)

???

重看發現題目寫的是10^5而不是105![](https://i.imgur.com/aCkXan9.png)markdown 複製貼上格式跑掉...orz

+-10^5的話顯然bucket sort 就不再適合了。

---

### merge sort(timeout)

排除掉bucket sort 以及一狗票 n^2 複查度的演算法，我比較熟的大概就剩merge sort了吧。再不行只能另尋出路了。

```typescript
function search(arr: number[], target: number): boolean {
  let left = 0;
  let right = arr.length - 1;
  while (left <= right) {
    const m = Math.floor((left + right) / 2);
    switch (arr[m] === target) {
      case true:
        return true;
      case false:
        left = arr[m] < target ? m + 1 : left;
        right = arr[m] > target ? m - 1 : right;
        break;
    }
  }
  return false;
}

function threeSum(nums: number[]): number[][] {
  const res = new Array<number[]>();
  nums = mergeSort(nums);
  let first: number, second: number, third: number;
  let rest: number[];
  let previousFirst: number = nums[0] - 1;
  for (let i = 0; i < nums.length; i++) {
    first = nums[i];
    if (first === previousFirst || first > 0) {
      continue;
    }
    previousFirst = first;
    let previousSecond: number = nums[0] - 1;
    for (let j = i + 1; j < nums.length; j++) {
      second = nums[j];
      if (second === previousSecond) {
        continue;
      }
      previousSecond = second;
      rest = Object.assign([], nums);
      rest.splice(0, j + 1); //hello
      third = -first - second;
      if (third < second) {
        continue;
      }
      // binary search
      if (search(rest, third)) {
        res.push([first, second, third]);
      }
    }
  }
  return res;
}

function merge(a: number[], b: number[]): number[] {
  const res: number[] = new Array<number>();
  let i = 0;
  let j = 0;
  while (!(i === a.length && j === b.length)) {
    if (i === a.length) {
      res.push(b[j]);
      j++;
      continue;
    }
    if (j === b.length) {
      res.push(a[i]);
      i++;
      continue;
    }
    if (a[i] < b[j]) {
      res.push(a[i]);
      i++;
    } else {
      res.push(b[j]);
      j++;
    }
  }
  return res;
}

function mergeSort(nums: number[]): number[] {
  if (nums.length <= 1)
    return nums;
  const middle = Math.floor(nums.length / 2);
  const left = nums.slice(0, middle);
  const right = nums.slice(middle, nums.length);
  return merge(mergeSort(left), mergeSort(right));
}
```

依然沒辦法在時限內完成執行。

----

### two pointer (PASS)

去問了點提示，得到一個方向，試著從這點開始突破看看。

最開始和前一種做法差不多，首先要先sort，畢竟two pointer 也需要已排序的資料

接著第一個數字的選用，一樣由左而右，大於0的不要。

同樣拿第一個範例來參考`[-1,0,1,2,-1,-4]`排序後變為`[-4,-1-1,0,1,2]`

* 第一個數字抓-4，剩下兩個數字要求和為4
  * 指針分別指向 -1以及2，相加為1，左指針右移
  * -1,2，再右移
  * 0,2->1,2->找不到
* 第一個數字抓-1
  * -1,2-->ans
  * 0,1-->ans
* 第一個數字抓-1--->抓過了
* 第一個數字抓0
  * 1,2->找不到



```typescript
function search(arr: number[], target: number): boolean {
  let left = 0;
  let right = arr.length - 1;
  while (left <= right) {
    const m = Math.floor((left + right) / 2);
    switch (arr[m] === target) {
      case true:
        return true;
      case false:
        left = arr[m] < target ? m + 1 : left;
        right = arr[m] > target ? m - 1 : right;
        break;
    }
  }
  return false;
}

function threeSum(nums: number[]): number[][] {
  const res = new Array<number[]>();
  nums = mergeSort(nums);
  let first: number, second: number, third: number;
  let left = 0;
  let right = nums.length;
  let target = 0;
  let previousFirst: number = nums[0] - 1;
  let previousSecond: number, previousThird: number;
  for (let i = 0; i < nums.length && nums[i] <= 0; i++) {
    first = nums[i];
    if (first === previousFirst) {
      continue;
    }
    previousFirst = first;
    left = i + 1;
    right = nums.length;
    target = -first;
    while (left < right) {
      second = nums[left];
      third = nums[right];
      if (second + third === target) {
        if (second !== previousSecond || third !== previousThird)
          res.push([first, second, third]);
        left++;
        right--;
        previousSecond = second;
        previousThird = third;
      } else if (second + third < target) {
        left++;
      } else {
        right--;
      }
    }
  }
  return res;
}

function merge(a: number[], b: number[]): number[] {
  const res: number[] = new Array<number>();
  let i = 0;
  let j = 0;
  while (!(i === a.length && j === b.length)) {
    if (i === a.length) {
      res.push(b[j]);
      j++;
      continue;
    }
    if (j === b.length) {
      res.push(a[i]);
      i++;
      continue;
    }
    if (a[i] < b[j]) {
      res.push(a[i]);
      i++;
    } else {
      res.push(b[j]);
      j++;
    }
  }
  return res;
}

function mergeSort(nums: number[]): number[] {
  if (nums.length <= 1)
    return nums;
  const middle = Math.floor(nums.length / 2);
  const left = nums.slice(0, middle);
  const right = nums.slice(middle, nums.length);
  return merge(mergeSort(left), mergeSort(right));
}

```

![](https://i.imgur.com/5VH9RGH.png)

終於...

應該還有不少優化的空間，不過累了，有機會再回來看看

## Better Solutions

