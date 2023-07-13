# Graph

tags: #data_structure #graph

## Reference

[GeeksforGeeks](https://www.geeksforgeeks.org/graph-data-structure-and-algorithms/)

[SecondRound](http://alrightchiu.github.io/SecondRound/graph-introjian-jie.html)

## Basic

### Definition

> A Graph consists of a finite set of vertices(or nodes) and set of Edges which connect a pair of nodes.

![](https://www.geeksforgeeks.org/wp-content/uploads/undirectedgraph.png)

- **vertex**：稱每一個「資料節點」為vertex(或是node)，並定義所有的vertex所形成之集合(Set)為VV或V(G)V(G)；
- **edge**：稱每一個「線段(箭號)」為edge(實際上是用一對vertex表示edge，例如(Vi,Vj)(Vi,Vj)即為連結Vi與Vj的edge)，並定義所有的edge所形成之集合(Set)為EE或E(G)E(G)；

則Graph定義為VV與EE所形成的集合，表示成G(V,E)G(V,E)。

再根據edge是否具有「方向性」，可以將Graph分成「directed graph(有向圖)」與「undirected graph(無向圖)」：

- directed graph(有向圖)

  ：edge的方向性表示資料間的關係，若vertex(A)與vertex(B)之關係是「單向的」，那麼連結vertex(A)與vertex(B)的edge即具有方向性。

- undirected graph(無向圖)

  ：edge的方向性表示資料間的關係，若vertex(A)與vertex(B)的關係是「雙向的」，那麼連結vertex(A)與vertex(B)之edge就不具有方向性。

![](https://github.com/alrightchiu/SecondRound/blob/master/content/Algorithms%20and%20Data%20Structures/Graph%20series/Intro_fig/f3.png?raw=true)

![](https://github.com/alrightchiu/SecondRound/blob/master/content/Algorithms%20and%20Data%20Structures/Graph%20series/Intro_fig/f4.png?raw=true)

其他名詞

- **path**：兩個Vertices之間的走法。
- **length/ distance**: length(或distance)即是path中的edge數。
- **simple path**：若一條path中，除了起點vertex與終點vertex之外，沒有vertex被重複經過，則稱這條path為simple path。

- **cycle**：若有ㄧ條「simple path」的起點vertex與終點vertex相同，則稱這條path為cycle。
- **acyclic graph**：若graph中不存在cycle，則稱這個graph為acyclic graph

- **weight：若要表示兩個地理位置之間的「距離」或是運送「成本」，可以在edge上加上weight，這樣的graph又稱為weighted graph
- **connected**：若存在從vertex(A)指向vertex(B)、以及從vertex(B)指向vertex(A)的edge(若是在directed graph中，需要兩條edge；若是undirected graph只需要一條edge)，則稱vertex(A)與vertex(B)為connected。
- **connected in undirected graph** : undirected  graph 中 任意兩點都可以找到 path
- **connected component**：若在一個undirected graph中，存在某一個subgraph是connected，而且沒有任何vertex、edge再加入這個subgraph之集合後仍能使得這個subgraph維持connected特性，則稱此subgraph為connected component(最大集合的connected subgraph)
- **strongly connected in directed graph**：若在directed graph中，對任意兩個vertex(A)與vertex(B)同時存在「從vertex(A)走到vertex(B)」以及「從vertex(B)走到vertex(A)」的path，則稱此directed graph是strongly connected。
- **strongly connected component**：若在一個directed graph中，存在某一個subgraph是strongly connected，而且沒有任何vertex、edge再加入這個subgraph之集合後仍能使得這個subgraph維持strongly connected特性，則稱此subgraph為strongly connected component(最大集合的strongly connected subgraph)。
- **self-loop(自我迴圈)**：若有edge從vertex(A)指向vertex(A)，即稱為self-edge或是self-loop。
- **multigraph(多邊圖)**：若在graph中相同的edge重複出現多次，則稱此圖為multigraph。

### Representation

1. Adjacency Matrix(相鄰矩陣)

   ：一個二維矩陣，若從vertex(A)到vertex(B)有edge，則矩陣位置`[A][B]`值為1，反之，則為0。

   - 在directed graph中，有從vertex(X)指向vertex(Y)的edge，則矩陣位置`[X][Y]`之值為1，但是沒有反向的edge，因此矩陣位置`[Y][X]`之值為0。

2. Adjacency List(相鄰串列)

   ：先以一個一維陣列列出所有的vertex，再以Linked list表示所有與vertex相連的vertex。

   (vertex接進Linked list的順序不重要，因為是Graph是定義成Set。)

![](https://github.com/alrightchiu/SecondRound/blob/master/content/Algorithms%20and%20Data%20Structures/Graph%20series/Intro_fig/f_5.png?raw=true)
