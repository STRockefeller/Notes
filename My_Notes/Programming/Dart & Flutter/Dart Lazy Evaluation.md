# Lazy Evaluation in Dart

tags: #lazy_evaluation #dart

## Lazy Initialization

Lazy initialization is a way to postpone the creation of an object or the execution of a function until the moment it's actually needed. Dart provides a `late` keyword to declare variables that are initialized lazily. This is useful when deferring the initialization of a variable until it's used for the first time.

```dart
late String lazyText;

void main() {
  // The value of lazyText is not initialized until it's accessed here
  lazyText = 'Hello, Lazy Evaluation!';
  print(lazyText); // Now the value is initialized and printed
}
```

## Lazy Iterators

In Dart, lazy iterators can be used to avoid generating all elements of a collection at once. This is particularly useful when dealing with large datasets, as it allows generating elements on-the-fly while iterating over them, conserving memory and processing time.

```dart
Iterable<int> generateNumbers(int n) sync* {
  for (int i = 0; i < n; i++) {
    yield i; // Elements are generated only when requested
  }
}

void main() {
  final numbers = generateNumbers(5); // Doesn't generate all numbers at once

  for (var num in numbers) {
    print(num); // Numbers are generated as we iterate
  }
}
```

---
`where` method in [Iterable](https://dart.dev/codelabs/iterables) is a classic lazy iterator.

> `Iterable<int> where(bool Function(int) test)`
> Creates a new lazy `Iterable` with all elements that satisfy the predicate `test`.
> The matching elements have the same order in the returned iterable as they have in `iterator`.
> This method returns a view of the mapped elements. As long as the returned `Iterable` is not iterated over, the supplied function `test` will not be invoked. Iterating will not cache results, and thus iterating multiple times over the returned `Iterable` may invoke the supplied function `test` multiple times on the same element.

For example:

```dart
void main() {
  List<int> arr = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  arr.where((i) => i % 2 == 0).toList().forEach((i) {
    print(i);
    plusOne(arr);
  });
}

void plusOne(List<int> arr) {
  for (int i = 0; i < arr.length; i++) {
    arr[i]++;
  }
}
```

result:

```console
0
1
2
3
4
```

and if I remove `toList()`

```dart
void main() {
  List<int> arr = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  arr.where((i) => i % 2 == 0).forEach((i) {
    print(i);
    plusOne(arr);
  });
}

void plusOne(List<int> arr) {
  for (int i = 0; i < arr.length; i++) {
    arr[i]++;
  }
}
```

result:

```console
2
4
6
8
10
12
14
16
```

## Benefits of Lazy Evaluation

Lazy evaluation offers several benefits in Dart programming:

1. **Efficiency**: Lazy evaluation helps avoid unnecessary computations, saving processing time and memory.

2. **Performance**: By generating values only when needed, code performance can be improved, especially when dealing with large datasets.

3. **Resource Management**: Lazy evaluation contributes to better resource management, as resources are only allocated when actually required.

4. **Flexibility**: Lazy evaluation provides a flexible way to work with data that might not be fully available or ready for computation initially.
