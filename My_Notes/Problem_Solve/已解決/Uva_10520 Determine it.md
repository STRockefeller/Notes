# Uva:10520:20220309:dart

[Reference](https://onlinejudge.org/external/105/10520.pdf)



## Question

![](https://i.imgur.com/0vm65Rq.png)



### Input 

The input consists of several test cases. Each Test case consists of two integers n (0 < n < 20) and an,1 (0 < an,1 < 500). 

### Output

 For each test case your correct program should print the value of a1,n in a separate line. 

### Sample Input 

5 10 

4 1 

6 13 

### Sample Output

 1140 

42 

3770

## My Solution

這題目真難懂，總之先帶入一些數字進去看能不能看出甚麼

假設我要求a(0,0)，此時'i=j且j=0

在n=i=0的情況下(但是n>0，所以這個式子不符合條件)
$$
a_{0,0}=0+0=0
$$
在n>i也就是n>0的情況下
$$
a_{0,0}=max_{0<k\leq n}(a_{k,0}+a_{k,0})+0
$$
好吧不行，改從輸入來看，輸入 n 以及 a(n,1) 求 a(1,n)

假如這次輸入1 1，則
$$
n=1\\
a_{n,1}: i=n=1 \& j=1\\
a_{n,1}=0+max_{1\leq k<1}(a_{1,k}+a_{1,k})=0
$$
`1<=k<1`沒法算阿..

不行，改看範例輸入， 4 1 看起來比較簡單，就這了
$$
n=4\\
a_{n,1}=a_{4,1}=1\\
a_{4,1}=0+max_{1\leq k<1}(a_{4,k}+a_{4,k})\\
max_{1\leq k<1}(a_{4,k}+a_{4,k})=1
$$
不管怎樣都會有`1<=k<1`...好不管了繼續
$$
a_{1,4}=max_{1<k\leq 4}(a_{k,1}+a_{k,4})+max_{1\leq k<4}(a_{1,k}+a_{4,k})\\
=max((a_{2,1}+a_{2,4}),(a_{3,1}+a_{3,4}),(a_{4,1}+a_{4,4}))\\
+max((a_{1,1}+a_{4,1}),(a_{1,2}+a_{4,2}),(a_{1,3}+a_{4,3}))
$$


好，放棄

---

20220510 很閒，再回來看這題，看這次能不能順利避開`1<=k<j`

一樣看4 1 這組
$$
n=4\\
a_{n,1} = a_{4,1} = 1
$$
可以再推到最簡單的情況，當`i=n` `i>=j` `j=0`
$$
a_{n,0} = a_{4,0} = 0+0 = 0
$$


這是已知，接著整理一下公式

1. `i<j`
   $$
   a_{i,j}=max_{i\leq k<j}(a_{i,k}+a_{k+1,j})
   $$

2. `i>=j`

   1. `i<4`

      1. `j>0`
         $$
         a_{i,j}=max_{i<k\leq 4}(a_{k,1}+a_{k,j})+max_{1\leq k<j}(a_{i,k}+a_{4,k})
         $$
         

      2. `j=0`
         $$
         a_{i,0}=max_{i<k\leq 4}(a_{k,1}+a_{k,0})+0\\=max_{i<k\leq 4}(a_{k,1}+a_{k,0})
         $$
         

   2. `i=4`

      1. `j>0`
         $$
         a_{4,j}=max_{1\leq k<j}(a_{4,k}+a_{4,k})
         $$
         

      2. `j=0`
         $$
         a_{4,0}=0
         $$
         

      

---

公式整理完了，答案求的是(1,n)，除了n=0和n=1的case以外都屬於第一種情形`i<j`
$$
a_{1,4}=max_{1\leq k<4}(a_{1,k}+a_{k+1,4})
$$




現在從簡單的case開始看起

2.2.1 的情況下 `i>=j` `i=4` `j>0`，包含(4,1) (4,2) (4,3) (4,4) ，其中已知 (4,1) 的答案是1

先看(4,2)
$$
a_{4,2}=max_{1\leq k<2}(a_{4,k}+a_{4,k})\\
k\space must\space be\space1\\
a_{4,2}=2\cross a_{4,1}\\
=2\cross 1\\
=2
$$
然後可以推 (4,3)
$$
a_{4,3}=max_{1\leq k<3}(a_{4,k}+a_{4,k})
$$
在k=1和k=2中取大的，總之答案是4，2.2.1的情況都可以這樣推下去，對所有的x<=n來說a(n,x)都有解



我想這樣一直推下去應該可以得到解吧?總之先試試



寫完如下

```dart
class Uva10520 {
  List _ans = List.generate(20, (index) => List.generate(20, (index) => -1),
      growable: false);
  int _n = 0;

  Uva10520(int n, int an1) {
    _n = n;
    _ans[_n][1] = an1;
  }

  int find(int i, int j) {
    if (_ans[i][j] != -1) return _ans[i][j];

    int ans = -1;
    if (i < j) {
      ans = _iLTj(i, j);
    } else {
      ans = _frontPart(i, j) + _backPart(i, j);
    }

    _ans[i][j] = ans;
    return ans;
  }

  // i<j
  int _iLTj(int i, int j) {
    List<int> lst = List.empty(growable: true);
    for (int k = i; k < j; k++) {
      lst.add(find(i, k) + find(k + 1, j));
    }
    return _max(lst);
  }

  int _frontPart(int i, int j) {
    if (i == _n) return 0;
    List<int> lst = List.empty(growable: true);
    for (int k = i + 1; k <= _n; k++) {
      lst.add(find(k, 1) + find(k, j));
    }
    return _max(lst);
  }

  int _backPart(int i, int j) {
    if (j == 0) return 0;
    List<int> lst = List.empty(growable: true);
    for (int k = 1; k < j; k++) {
      lst.add(find(i, k) + find(_n, k));
    }
    return _max(lst);
  }

  int _max(List<int> lst) {
    int max = 0;
    for (int elem in lst) {
      max = elem > max ? elem : max;
    }
    return max;
  }
}

```

本來是想用map tuple -> int 的結構來記錄答案，不過dart的tuple要引用套件才能使用，用class作為key又怕作為參考型別的特性出問題。只好改用2D list



測試一下是否正確

```dart
void main() {
  print(new Uva10520(5, 10).find(1, 5)); //1140
  print(new Uva10520(4, 1).find(1, 4)); // 42
  print(new Uva10520(6, 13).find(1, 6)); //3770
}
```

挺好的，都對了



再來把可以優化的地方優化一下

首先，陣列的index 0 都沒用到，不過為了方便還是保留它，但是長度應該要改成21*21。

想省點空間，把長度改成根據給的n去動態生成長度為(n+1)*(n+1)的list

改一下建構式

```dart
Uva10520(int n, int an1) {
    _n = n;
    _initializeAnsList(an1);
  }

  void _initializeAnsList(int an1) {
    _ans = List.generate(
        _n + 1, (index) => List.generate(_n + 1, (index) => -1),
        growable: false);
    _ans[_n][1] = an1;
  }
	//...
}
```



改用BigInteger，可以處理比較大的數字

```dart
class Uva10520 {
  List<List<BigInt>> _ans = List.empty();
  int _n = 0;

  Uva10520(int n, int an1) {
    _n = n;
    _initializeAnsList(an1);
  }

  void _initializeAnsList(int an1) {
    _ans = List.generate(
        _n + 1, (index) => List.generate(_n + 1, (index) => BigInt.from(-1)),
        growable: false);
    _ans[_n][1] = BigInt.from(an1);
  }

  BigInt find(int i, int j) {
    if (_ans[i][j] != BigInt.from(-1)) return _ans[i][j];

    BigInt ans = BigInt.from(-1);
    if (i < j) {
      ans = _iLTj(i, j);
    } else {
      ans = _frontPart(i, j) + _backPart(i, j);
    }

    _ans[i][j] = ans;
    return ans;
  }

  // i<j
  BigInt _iLTj(int i, int j) {
    List<BigInt> lst = List.empty(growable: true);
    for (int k = i; k < j; k++) {
      lst.add(find(i, k) + find(k + 1, j));
    }
    return _max(lst);
  }

  BigInt _frontPart(int i, int j) {
    if (i == _n) return BigInt.zero;
    List<BigInt> lst = List.empty(growable: true);
    for (int k = i + 1; k <= _n; k++) {
      lst.add(find(k, 1) + find(k, j));
    }
    return _max(lst);
  }

  BigInt _backPart(int i, int j) {
    if (j == 0) return BigInt.zero;
    List<BigInt> lst = List.empty(growable: true);
    for (int k = 1; k < j; k++) {
      lst.add(find(i, k) + find(_n, k));
    }
    return _max(lst);
  }

  BigInt _max(List<BigInt> lst) {
    BigInt max = BigInt.zero;
    for (BigInt elem in lst) {
      max = elem > max ? elem : max;
    }
    return max;
  }
}

```







## Better Solutions

