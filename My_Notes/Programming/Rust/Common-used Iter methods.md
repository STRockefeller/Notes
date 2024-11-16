# Common-used Iter methods

tags: #rust #c_sharp/linq #iterator

### 1. Transformation Methods
- **`map`**: Apply a function to each element and collect the result.
  ```rust
  let v = vec![1, 2, 3];
  let mapped: Vec<_> = v.iter().map(|x| x * 2).collect(); // [2, 4, 6]
  ```
  **C# LINQ Equivalent**: `Select`
  ```csharp
  var v = new List<int> { 1, 2, 3 };
  var mapped = v.Select(x => x * 2).ToList(); // [2, 4, 6]
  ```

- **`filter`**: Retain elements that match a given condition.
  ```rust
  let v = vec![1, 2, 3, 4];
  let filtered: Vec<_> = v.iter().filter(|&&x| x % 2 == 0).collect(); // [2, 4]
  ```
  **C# LINQ Equivalent**: `Where`
  ```csharp
  var v = new List<int> { 1, 2, 3, 4 };
  var filtered = v.Where(x => x % 2 == 0).ToList(); // [2, 4]
  ```

- **`enumerate`**: Return an iterator of pairs, where each pair contains the index and the value.
  ```rust
  let v = vec!["a", "b", "c"];
  for (index, value) in v.iter().enumerate() {
      println!("Index: {}, Value: {}", index, value);
  }
  // Output:
  // Index: 0, Value: a
  // Index: 1, Value: b
  // Index: 2, Value: c
  ```
  **C# LINQ Equivalent**: `Select` with index
  ```csharp
  var v = new List<string> { "a", "b", "c" };
  var indexed = v.Select((value, index) => new { index, value });
  foreach (var item in indexed)
  {
      Console.WriteLine($"Index: {item.index}, Value: {item.value}");
  }
  ```

### 2. Consumption Methods
- **`collect`**: Gather all elements into a collection (like `Vec`, `HashSet`, etc.).
  ```rust
  let v = vec![1, 2, 3];
  let collected: Vec<_> = v.iter().collect(); // [1, 2, 3]
  ```
  **C# LINQ Equivalent**: `ToList`, `ToArray`
  ```csharp
  var v = new List<int> { 1, 2, 3 };
  var collected = v.ToList(); // [1, 2, 3]
  ```

- **`count`**: Count the number of elements.
  ```rust
  let v = vec![1, 2, 3];
  let count = v.iter().count(); // 3
  ```
  **C# LINQ Equivalent**: `Count`
  ```csharp
  var v = new List<int> { 1, 2, 3 };
  var count = v.Count(); // 3
  ```

- **`sum`**: Sum up all elements.
  ```rust
  let v = vec![1, 2, 3];
  let total: i32 = v.iter().sum(); // 6
  ```
  **C# LINQ Equivalent**: `Sum`
  ```csharp
  var v = new List<int> { 1, 2, 3 };
  var total = v.Sum(); // 6
  ```

- **`product`**: Multiply all elements.
  ```rust
  let v = vec![1, 2, 3];
  let product: i32 = v.iter().product(); // 6
  ```
  **C# LINQ Equivalent**: `Aggregate`
  ```csharp
  var v = new List<int> { 1, 2, 3 };
  var product = v.Aggregate(1, (acc, x) => acc * x); // 6
  ```

- **`for_each`**: Execute a function on each element.
  ```rust
  let v = vec![1, 2, 3];
  v.iter().for_each(|x| println!("{}", x));
  // Output: 1
  //         2
  //         3
  ```
  **C# LINQ Equivalent**: `ForEach` (on List)
  ```csharp
  var v = new List<int> { 1, 2, 3 };
  v.ForEach(x => Console.WriteLine(x));
  ```

### 3. Searching Methods
- **`find`**: Find the first element that matches a condition.
  ```rust
  let v = vec![1, 2, 3, 4];
  if let Some(found) = v.iter().find(|&&x| x == 3) {
      println!("Found: {}", found);
  }
  // Output: Found: 3
  ```
  **C# LINQ Equivalent**: `FirstOrDefault`
  ```csharp
  var v = new List<int> { 1, 2, 3, 4 };
  var found = v.FirstOrDefault(x => x == 3);
  if (found != 0)
  {
      Console.WriteLine($"Found: {found}");
  }
  ```

- **`position`**: Get the index of the first element that matches a condition.
  ```rust
  let v = vec![1, 2, 3, 4];
  let pos = v.iter().position(|&x| x == 3); // Some(2)
  ```
  **C# LINQ Equivalent**: `FindIndex`
  ```csharp
  var v = new List<int> { 1, 2, 3, 4 };
  var pos = v.FindIndex(x => x == 3); // 2
  ```

- **`any`**: Check if any elements match a condition.
  ```rust
  let v = vec![1, 2, 3];
  let has_even = v.iter().any(|&x| x % 2 == 0); // true
  ```
  **C# LINQ Equivalent**: `Any`
  ```csharp
  var v = new List<int> { 1, 2, 3 };
  var hasEven = v.Any(x => x % 2 == 0); // true
  ```

- **`all`**: Check if all elements match a condition.
  ```rust
  let v = vec![2, 4, 6];
  let all_even = v.iter().all(|&x| x % 2 == 0); // true
  ```
  **C# LINQ Equivalent**: `All`
  ```csharp
  var v = new List<int> { 2, 4, 6 };
  var allEven = v.All(x => x % 2 == 0); // true
  ```

### 4. Chaining and Combining
- **`chain`**: Combine two iterators into one.
  ```rust
  let v1 = vec![1, 2, 3];
  let v2 = vec![4, 5, 6];
  let chained: Vec<_> = v1.iter().chain(v2.iter()).collect(); // [1, 2, 3, 4, 5, 6]
  ```
  **C# LINQ Equivalent**: `Concat`
  ```csharp
  var v1 = new List<int> { 1, 2, 3 };
  var v2 = new List<int> { 4, 5, 6 };
  var chained = v1.Concat(v2).ToList(); // [1, 2, 3, 4, 5, 6]
  ```

- **`zip`**: Combine two iterators by pairing elements from each.
  ```rust
  let v1 = vec![1, 2, 3];
  let v2 = vec!["a", "b", "c"];
  let zipped: Vec<_> = v1.iter().zip(v2.iter()).collect(); // [(1, "a"), (2, "b"), (3, "c")]
  ```
  **C# LINQ Equivalent**: `Zip`
  ```csharp
  var v1 = new List<int> { 1, 2, 3 };
  var v2 = new List<string> { "a", "b", "c" };
  var zipped = v1.Zip(v2, (x, y) => (x, y)).ToList(); // [(1, "a"), (2, "b"), (3, "c")]
  ```

### 5. Slicing Methods
- **`take`**: Take a limited number of elements from the iterator.
  ```rust
  let v = vec![1, 2, 3, 4];
  let taken: Vec<_> = v.iter().take(2).collect(); // [1, 2]
  ```
  **C# LINQ Equivalent**: `Take`
  ```csharp
  var v = new List<int> { 1, 2, 3, 4 };
  var taken = v.Take(2).ToList(); // [1, 2]
  ```

- **`skip`**: Skip a certain number of elements.
  ```rust
  let v = vec![1, 2, 3, 4];
  let skipped: Vec<_> = v.iter().skip(2).collect(); // [3, 4]
  ```
  **C# LINQ Equivalent**: `Skip`
  ```csharp
  var v = new List<int> { 1, 2, 3, 4 };
  var skipped = v.Skip(2).ToList(); // [3, 4]
  ```

### 6. Accumulation Methods
- **`fold`**: Accumulate elements based on an initial value and a closure.
  ```rust
  let v = vec![1, 2, 3, 4];
  let sum = v.iter().fold(0, |acc, &x| acc + x); // 10
  ```
  **C# LINQ Equivalent**: `Aggregate`
  ```csharp
  var v = new List<int> { 1, 2, 3, 4 };
  var sum = v.Aggregate(0, (acc, x) => acc + x); // 10
  ```

- **`reduce`**: Similar to `fold`, but without an initial value.
  ```rust
  let v = vec![1, 2, 3, 4];
  let sum = v.iter().cloned().reduce(|acc, x| acc + x); // Some(10)
  ```
  **C# LINQ Equivalent**: `Aggregate` (without initial value)
  ```csharp
  var v = new List<int> { 1, 2, 3, 4 };
  var sum = v.Aggregate((acc, x) => acc + x); // 10
  ```

