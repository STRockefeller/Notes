
The `union` function merges the sets containing `x` and `y`. It utilizes union by rank to maintain a balanced tree:
```plaintext
function union(x, y):
    rootX = find(x)
    rootY = find(y)
    if rootX != rootY:
        if rank[rootX] > rank[rootY]:
            parent[rootY] = rootX
        elif rank[rootX] < rank[rootY]:
            parent[rootX] = rootY
        else:
            parent[rootY] = rootX
            rank[rootX] += 1
```
`rank` keeps track of the depth of trees rooted at each node. Initially, all ranks are zero.