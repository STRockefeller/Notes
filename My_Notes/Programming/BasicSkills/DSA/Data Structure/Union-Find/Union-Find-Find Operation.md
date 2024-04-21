
The `find` function is used to locate the root of the set containing the element `x`. With path compression, it works as follows:
```plaintext
function find(x):
    if parent[x] != x:
        parent[x] = find(parent[x])  # Path compression
    return parent[x]
```
Here, `parent` is an array where `parent[i]` points to the parent of `i`, or to `i` itself if it is a root node.

[[Union-Find-Simplifying Rank in the Find Method]]