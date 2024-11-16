# Typical mistakes with ownership and borrow checking system

tags: #rust #borrow_checker #garbage_collect #ownership

### 1. Mutable and Immutable Borrow Conflicts

- **Mistake**: Attempting to borrow a value both mutably and immutably at the same time.
  - **Example**:
    ```rust
        let mut v = vec![1, 2, 3];
        let immutable_borrow = &v;
        let mutable_borrow = &mut v;
        mutable_borrow.push(4);
        println!("{:?}", immutable_borrow);
    ```
    [playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=8d93b48b3c57189b846728f4195413a6)
    ```rust
    let mut v = vec![1, 2, 3];
    let immutable_borrow = &v;
    println!("{:?}", immutable_borrow); // Use immutable borrow here
    let mutable_borrow = &mut v; // Now we can borrow mutably after the immutable borrow goes out of scope
    mutable_borrow.push(4);
    ```
    [playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=9b867b134715ec572ad7fa8b78c9dbc2)
  - **Reason**: Rust enforces either multiple immutable borrows or a single mutable borrow, but not both simultaneously to prevent data races.

### 2. Dangling References

- **Mistake**: Creating references to data that goes out of scope.
  - **Example**:
    ```rust
    let r;
    {
        let x = 5;
        r = &x; // Error: `x` does not live long enough.
    }
    // `r` now points to an invalid value.
    ```
  - **Reason**: Rust prevents references to data that no longer exists to ensure memory safety.

### 3. Partial Borrow Issues

- **Mistake**: Borrowing part of a structure mutably while trying to access another part immutably.
- **Example**:
    ```rust
    struct MyStruct {
        values: Vec<i32>,
    }

    fn main() {
        let mut s = MyStruct {
            values: vec![1, 2, 3],
        };

        let first = &s.values[0]; // Immutable borrow of `s.values[0]`

        s.values.push(4); // Attempt to mutate `s.values`

        println!("First value: {}", first);
    }

    ```
    [playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=d858284b4a97572ee470003fe03ddfb3)
- Explanation:

    - Immutable Borrow: We create an immutable reference to the first element of `s.values` using `let first = &s.values[0]`;.
    - Mutable Mutation: We then attempt to mutate `s.values` by pushing a new element using `s.values.push(4);`.
    - Borrow Conflict: Rust's borrow checker sees that s.values is immutably borrowed (through `first`) and is also being mutably borrowed (through `s.values.push(4)`), which violates Rust's rule that you cannot have simultaneous mutable and immutable borrows of the same data.

### 4. Iterator Borrow Issues

- **Mistake**: Borrowing a value while iterating over it in a loop.
  - **Example**:
    ```rust
    let mut vec = vec![1, 2, 3];
    for val in &vec {
        vec.push(*val); // Error: cannot borrow `vec` as mutable because it is also borrowed as immutable.
    }
    ```
    [playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=a6c93973cf32a5c21b87c4cd03b3543c)
  - **Reason**: You cannot modify a collection while iterating over it because it could invalidate the iterator.

### 5. Reborrowing Mutably After Immutable Borrow

- **Mistake**: Trying to borrow a value mutably after it has already been borrowed immutably.
  - **Example**:
    ```rust
    let mut s = String::from("hello");
    let r1 = &s;
    let r2 = &mut s; // Error: cannot borrow `s` as mutable because it is also borrowed as immutable.
    println!("{}", r1);
    ```
    [playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=c6d4542831ac86e9dc2671023e6b58e2)
  - **Reason**: An immutable borrow prevents further mutable borrowing until it goes out of scope.

### 6. Borrowing Ownership Transfers

- **Mistake**: Trying to use a value after it has been moved.
  - **Example**:
    ```rust
    let s1 = String::from("hello");
    let s2 = s1; // `s1` is moved here.
    println!("{}", s1); // Error: value borrowed here after move.
    ```
    [playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=f7ab86ca3777ae6814581992f64fef92)
  - **Reason**: Moving a value transfers ownership, meaning the original value is no longer accessible.

### 7. Returning References to Local Variables

- **Mistake**: Returning a reference to a variable that goes out of scope.
  - **Example**:
    ```rust
    fn get_ref() -> &i32 {
        let x = 10;
        &x // Error: `x` does not live long enough.
    }
    ```
    [playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=da1fc32a4f44529d98ff82924a73e287)
  - **Reason**: The reference would point to invalid memory since `x` is dropped when the function ends.

### 8. Lifetime Mismanagement

- **Mistake**: Incorrectly managing lifetimes for borrowed values, leading to confusing errors.
  - **Example**:
    ```rust
    fn main() {
    let string1 = String::from("Hello");
    let result;
    {
        let string2 = String::from("Rust");
        result = longest(string1.as_str(), string2.as_str());
    }
        println!("The longest string is {}", result);
    }

    fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
        if x.len() > y.len() { x } else { y }
    }
    ```
    [playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=06dba437b66d661f161d6d54dfd69288)
  - **Reason**: Lifetimes tell the compiler how long references are valid. Incorrect or missing lifetimes can lead to compile-time errors.

### 9. Confusion with `&mut` and `&` Usage

- **Mistake**: Not understanding when to use mutable vs. immutable references.
  - **Example**:
    ```rust
    let mut data = vec![1, 2, 3];
    let r = &data; // Immutable borrow
    data.push(4);  // Error: cannot borrow `data` as mutable because it is also borrowed as immutable.
    ```
  - **Reason**: Rust enforces borrowing rules to prevent simultaneous mutable and immutable access, ensuring data consistency.

### 10. Using `RefCell` Incorrectly

- **Mistake**: Using `RefCell` for interior mutability without considering runtime borrow checking.
  - **Example**:
    ```rust
    use std::cell::RefCell;

    let data = RefCell::new(5);
    let r1 = data.borrow();
    let r2 = data.borrow_mut(); // Panics at runtime: already borrowed.
    ```
  - **Reason**: Unlike compile-time borrow checking, `RefCell` enforces borrowing rules at runtime, and multiple mutable or immutable/mutable conflicts will lead to a runtime panic.

### Tips for Avoiding Borrow Checker Mistakes:

1. **Start with Small Programs**: Practice small examples to get comfortable with Rust’s borrowing and ownership.
2. **Understand Ownership Rules**: Clearly understand when ownership is transferred, borrowed, or shared.
3. **Scope Awareness**: Be mindful of the scope of your variables. Ensure references do not outlive the data they point to.
4. **Use Compiler Errors**: The Rust compiler provides helpful error messages. Read them carefully to understand what the issue is and how to fix it.
5. **Prefer Cloning When Needed**: If borrowing rules become cumbersome and performance is not a concern, using `.clone()` can simplify ownership issues by making explicit copies.

With practice, the borrow checker will become more intuitive, and these common pitfalls will become less of an obstacle. The learning curve might be steep, but it greatly helps in writing memory-safe and concurrent code.
