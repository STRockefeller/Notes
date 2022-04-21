# Uva:10520:20220309:go

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
a_{0,0}=max_{0<k<=n}(a_{k,0}+a_{k,0})+0
$$
好吧不行，改從輸入來看，輸入 n 以及 a(n,1) 求 a(1,n)

假如這次輸入1 1，則
$$
n=1\\
a_{n,1}: i=n=1 \& j=1\\
a_{n,1}=0+max_{1<=k<1}(a_{1,k}+a_{1,k})=0
$$
`1<=k<1`沒法算阿..

不行，改看範例輸入， 4 1 看起來比較簡單，就這了
$$
n=4\\
a_{n,1}=a_{4,1}=1\\
a_{4,1}=0+max_{1<=k<1}(a_{4,k}+a_{4,k})\\
max_{1<=k<1}(a_{4,k}+a_{4,k})=1
$$
不管怎樣都會有`1<=k<1`...好不管了繼續
$$
a_{1,4}=max_{1<k<=4}(a_{k,1}+a_{k,4})+max_{1<=k<4}(a_{1,k}+a_{4,k})\\
=max((a_{2,1}+a_{2,4}),(a_{3,1}+a_{3,4}),(a_{4,1}+a_{4,4}))\\
+max((a_{1,1}+a_{4,1}),(a_{1,2}+a_{4,2}),(a_{1,3}+a_{4,3}))
$$


好，放棄





## Better Solutions

