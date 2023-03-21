# Basic of Functional Programming

#functional_programming #golang

## References

- [Monads in go](https://levelup.gitconnected.com/using-monads-with-go-1-18-generics-part-1-maybe-bb42d3e09968)

## Abstract

For someone like me who has been immersed in OOP for many years, the field of FP seems like another world. However, after a superficial understanding of it, I found that many of the techniques inside have valuable insights worth borrowing.

In order to get started, I asked ChatGPT to help me organize some key concepts related to FP. I will try to understand these concepts one by one.
By the way, I plan to complete this note using Golang. Although I have also considered Haskell, after careful consideration, I think I should first understand the concepts before deciding whether to spend time learning a new programming language.

> - Immutable data structures: In functional programming, data is typically treated as immutable, meaning that it cannot be modified once it has been created. This is in contrast to object-oriented programming, where objects often have mutable state. Learning to work with immutable data structures is a fundamental skill in functional programming.
> - Higher-order functions: Higher-order functions are functions that take other functions as arguments or return functions as results. In functional programming, higher-order functions are used extensively to manipulate collections of data, compose functions, and abstract over common patterns.
> - Pure functions: Pure functions are functions that have no side effects and return the same result every time they are called with the same arguments. Pure functions are a key concept in functional programming because they make it easier to reason about code and avoid bugs related to mutable state.
> - Recursion: Recursion is a technique for solving problems by breaking them down into smaller sub-problems and solving them recursively. Recursion is a powerful technique in functional programming and is often used to implement higher-level abstractions like map, reduce, and filter.
> - Function composition: Function composition is the process of combining two or more functions to produce a new function. Function composition is a powerful technique in functional programming that allows you to build complex functions from simple building blocks.
> - Lazy evaluation: Lazy evaluation is a technique for delaying the evaluation of an expression until its value is needed. Lazy evaluation is often used in functional programming to implement infinite data structures, optimize performance, and enable more expressive programming constructs.
> - Monads: Monads are a programming construct that provide a way to sequence computations and manage effects in a functional way. Monads are a more advanced topic in functional programming, but they are widely used in functional programming languages like Haskell and Scala.

## Concepts

### Immutable

In functional programming, data is typically treated as immutable, meaning that it **cannot** be modified once it has been created.
This is in contrast to object-oriented programming, where objects often have mutable state.

Immutable data structures are an essential concept in functional programming because they allow you to write safer and more predictable code.
When data is immutable, you can be sure that it won't change unexpectedly and that it won't be modified by multiple threads or functions at the same time.

Immutable data structures offer several benefits, including:

- **Thread safety:** Immutable data structures can be safely shared between multiple threads because they cannot be modified after they are created.
- **Predictable behavior:** Because immutable data structures cannot be modified, they always have the same state. This makes it easier to reason about code and avoid bugs related to mutable state.
- **Easier to test:** With immutable data structures, you can write tests that rely on the data never changing, making it easier to test your code.

Some examples of immutable data structures include:

- Lists: In functional programming, lists are typically implemented as linked lists, where each element points to the next element in the list. Because linked lists are immutable, adding or removing elements from a list creates a new list rather than modifying the existing list.
- Tuples: Tuples are immutable collections of values. Once a tuple has been created, its values cannot be modified.
- Maps: Maps are immutable key-value stores. Once a key-value pair has been added to a map, it cannot be changed.

By using immutable data structures, you can write more concise and expressive code. For example, you can use the map function to transform a list of values without modifying the original list:

```go
// Create a list of numbers
numbers := []int{1, 2, 3, 4, 5}

// Use the map function to transform the list
doubledNumbers := map(numbers, func(n int) int {
    return n * 2
})

// The original list is unchanged
fmt.Println(numbers) // [1 2 3 4 5]

// The new list contains the transformed values
fmt.Println(doubledNumbers) // [2 4 6 8 10]

```

Immutable data structures also make it easier to reason about code and avoid bugs related to mutable state. By using immutable data structures, you can write code that is easier to test, maintain, and refactor.

### Higher-order functions

Higher-order functions are functions that take other functions as arguments or return functions as results. In functional programming, higher-order functions are used extensively to manipulate collections of data, compose functions, and abstract over common patterns.

Here are some examples of higher-order functions:

- **Map:** The `map` function applies a function to each element in a collection and returns a new collection with the results. For example, in Golang, you can use the `map` function on a slice of integers to add one to each element:

  ```go
    func addOne(x int) int {
        return x + 1
    }

    func main() {
        numbers := []int{1, 2, 3}
        // add 1 to each element using map
        newNumbers := Map(numbers, addOne)
        fmt.Println(newNumbers) // [2, 3, 4]
    }
  ```

- **Filter:** The `filter` function takes a collection and a function as arguments and returns a new collection containing only the elements that satisfy the predicate function. For example, in Golang, you can use the `filter` function on a slice of integers to get only the even numbers:

  ```go
    func isEven(x int) bool {
        return x%2 == 0
    }

    func main() {
        numbers := []int{1, 2, 3, 4, 5}
        // filter even numbers using filter
        evenNumbers := Filter(numbers, isEven)
        fmt.Println(evenNumbers) // [2, 4]
    }
  ```

- **Reduce:** The `reduce` function takes a collection, a function, and an initial value as arguments and returns a single value that is the result of applying the function to the elements in the collection. For example, in Golang, you can use the `reduce` function on a slice of integers to get the sum of all the elements:

    ```go
    func sum(x, y int) int {
        return x + y
    }

    func main() {
        numbers := []int{1, 2, 3}
        // get the sum using reduce
        sum := Reduce(numbers, sum, 0)
        fmt.Println(sum) // 6
    }
    ```

### Pure functions

Pure functions are functions that have no side effects and return the same result every time they are called with the same arguments. This means that the function only depends on its input, and does not modify any external state.

Pure functions have several advantages over impure functions. They are easier to reason about because they have no hidden state that can affect their behavior. They are also easier to test because they always produce the same output for a given input, making it easy to write automated tests. Finally, they are easier to parallelize because they can be executed independently of each other.

Here's an example of a pure function in Golang:

```go
func add(x, y int) int {
  return x + y
}
```

This function takes two integers as input and returns their sum. It has no side effects and always returns the same result for the same input.

### Recursion

Recursion is a technique for solving problems by breaking them down into smaller sub-problems and solving them recursively. In functional programming, recursion is often used to implement higher-level abstractions like map, reduce, and filter.

Here's an example of a recursive function in Golang that calculates the factorial of a number:

```go
func factorial(n int) int {
  if n == 0 {
    return 1
  }
  return n * factorial(n-1)
}
```

This function calculates the factorial of a number using recursion. If the input is 0, it returns 1. Otherwise, it multiplies the input by the result of calling itself with the input decremented by 1.

### Function composition

Function composition is the process of combining two or more functions to produce a new function. Function composition is a powerful technique in functional programming that allows you to build complex functions from simple building blocks.

Here's an example of function composition in Golang:

```go
func add(x, y int) int {
  return x + y
}

func multiply(x, y int) int {
  return x * y
}

func addAndMultiply(x, y, z int) int {
  return multiply(add(x, y), z)
}
```

In this example, we define two functions, add and multiply, that add and multiply two integers respectively. We then define a new function, addAndMultiply, that uses function composition to combine these two functions to produce a new function that adds two numbers and then multiplies the result by a third number.

### Lazy evaluation

Lazy evaluation is a technique for delaying the evaluation of an expression until its value is needed. Lazy evaluation is often used in functional programming to implement infinite data structures, optimize performance, and enable more expressive programming constructs.

Here's an example of lazy evaluation in Golang using a closure:

```go
func expensiveCalculation() int {
  fmt.Println("Doing an expensive calculation...")
  return 42
}

func calculateTwice(f func() int) (int, int) {
  return f(), f()
}

func main() {
  // This will print "Doing an expensive calculation..." twice
  calculateTwice(expensiveCalculation)

  // This will only print "Doing an expensive calculation..." once
  f := func() int {
    result := expensiveCalculation()
    f = func() int {
      return result
    }
    return result
  }
  calculateTwice(f)
}
```

In this example, we define a function expensiveCalculation that performs an expensive calculation.

### Monads

Monads are a programming construct that provide a way to sequence computations and manage effects in a functional way. They are widely used in functional programming languages like Haskell and Scala, and have become an important tool for building complex, maintainable software.

At a high level, a monad is a way to encapsulate a sequence of computations that may have side effects or may fail. A monad provides a set of operations that allow you to manipulate these computations in a safe and composable way. The key idea behind monads is to separate the description of the computation from its execution, which makes it easier to reason about the code and manage effects.

In functional programming, monads are often used to model computations that involve some kind of context or state, such as I/O operations, error handling, or non-determinism. By encapsulating these computations in a monad, you can ensure that they are executed in a safe and consistent way, and that the results are properly managed.

One of the most common examples of a monad is the Maybe monad, which is used to handle computations that may fail. The Maybe monad encapsulates a value that may or may not be present, and provides a set of operations for manipulating that value in a safe and composable way. Other examples of monads include the State monad, which is used to manage stateful computations, and the Reader monad, which is used to manage computations that depend on some external environment.

In Go, there is no built-in support for monads, but it is still possible to use them to some extent. There are several third-party libraries, such as Go-Monad, that provide support for monads in Go. However, because Go is not a pure functional language, using monads in Go can be more challenging than in languages like Haskell or Scala.

Overall, monads are a powerful tool for building maintainable, composable software in a functional style. Although they can be difficult to understand at first, mastering the use of monads can lead to more expressive and elegant code that is easier to reason about and maintain.
