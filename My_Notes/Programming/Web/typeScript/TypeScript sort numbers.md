# Sort Numbers

陷阱，記一下。[參考](https://stackoverflow.com/questions/7000851/how-to-sort-numbers-correctly-with-array-sort)

正常情況

```typescript
var nums:number[] = [1,3,5,2,4,6];
nums.sort(); //  [1,2,3,4,5,6]
```

???

```typescript
var nums:number[] = [1,3,5,2,4,6,-1,-4];
nums.sort(); //  [-1,-4,1,2,3,4,5,6]
```



簡單來說，即是是拿number[]去做排序，ts/js還是會把他排成string的樣子。



解法是再放一個function進去

```typescript
var nums:number[] = [1,3,5,2,4,6,-1,-4];
nums.sort(function (a, b): number {
    return a - b;
  }); //  [-4,-1,1,2,3,4,5,6]
```



