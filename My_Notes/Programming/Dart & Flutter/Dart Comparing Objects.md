# Comparing Objects in Dart

## References

- <https://api.dart.dev/stable/3.0.7/dart-core/Comparable/compare.html>
- <https://api.flutter.dev/flutter/dart-core/num/compareTo.html>
- <https://www.reddit.com/r/dartlang/comments/s86fna/hashmap_with_two_integers_as_keys/>

## Equality Operators

Dart has two equality operators using to compare objects:

1. `==`
2. `!=`

Dart compares two objects using the double equals operator (==). By default, the == operator compares the memory references of the two objects. If the two objects refer to the same instance in memory, the == operator returns true. Otherwise, it returns false.

For primitive immutable data types, Dart canonicalizes the same values to refer to the same object in the memory. This means that two objects with the same primitive value will always compare equal, even if they are created in different ways.

```dart
void main() {
  String a = "hello";
  String b = "hello";
  print(a == b); // true
  print(a.hashCode); // 268240859
  print(b.hashCode); // 268240859
}
```

For mutable data types, the == operator will return false if the two objects refer to different instances, even if they have the same values. This is because the values of mutable objects can change over time, so it is not possible to guarantee that two objects with the same values will always be equal.

```dart
class Obj{
  int value;
  Obj(this.value);
}

void main() {
  Obj a = Obj(123);
  Obj b = Obj(123);
  print(a == b); // false
  print(a.hashCode); // 77293858
  print(b.hashCode); // 167459382
}
```

f you need to compare two objects for equality based on their values, you can override the == operator in your class. To do this, you need to define a method called operator==(). This method should take two parameters, the first being the current object and the second being the object to compare it to. The method should return true if the two objects are equal and false otherwise.

You can also override the hashCode() method in your class. This method returns a hash code for the object. The hash code is used by hash-based collections, such as Set and Map, to determine the uniqueness of objects. If you override the hashCode() method, you should also override the operator==() method to ensure that the two methods are consistent.

```dart
class Obj {
  int value;
  Obj(this.value);

  @override
  bool operator ==(Object other) {
    if (other is Obj) {
      return value == other.value;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;
}

void main() {
  Obj a = Obj(123);
  Obj b = Obj(123);
  print(a == b); // true
  print(a.hashCode); // 123
  print(b.hashCode); // 123
}
```

## Comparison Methods

Dart classes can define their own comparison methods. These methods help you compare objects based on specific criteria. One commonly used comparison method is the `compareTo()` method ([reference](https://api.dart.dev/stable/3.0.7/dart-core/Comparable/compareTo.html)), often used for sorting objects.

Example:

```dart
class Person implements Comparable<Person> {
  String name;
  int age;

  Person(this.name, this.age);

  @override
  int compareTo(Person other) {
    return age.compareTo(other.age);
  }
}

void main() {
  var person1 = Person('Alice', 30);
  var person2 = Person('Bob', 25);

  print(person1.compareTo(person2)); // Output: 1
}
```

In this example, the `compareTo()` method compares `Person` objects based on their ages. If the current object's age is greater, it returns a positive value; if it's smaller, it returns a negative value; and if they're equal, it returns `0`.

Remember to define the `compareTo()` method when you want custom comparisons for your objects.

## Summary

Comparing objects in Dart involves using equality operators like `==` and `!=` to check for sameness or difference. For more complex comparisons, you can define your own comparison methods, such as `compareTo()`, within your classes. These tools help you effectively manage and compare objects in your Dart programs.
