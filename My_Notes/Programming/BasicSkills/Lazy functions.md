# Lazy Functions

tags: #lazy_evaluation #dart #c_sharp

## References

- <https://stackoverflow.com/questions/33218987/how-to-do-lazy-evaluation-in-dart>
- <https://dev.to/pktintali/late-variables-in-dart-dart-learning-series-1-2opf>

## What are Lazy Functions?

Lazy functions, also known as lazy evaluation or deferred execution, are functions that postpone the execution of their code until the result is actually required. Instead of immediately performing the calculations or fetching data, lazy functions wait until the value is explicitly requested by the program.

## Why Use Lazy Functions?

Using lazy functions can lead to better performance and resource management. Consider scenarios where you have a list of values and you only need to process a few of them. Instead of processing the entire list upfront, a lazy function can calculate values on-the-fly, which can significantly reduce the processing time and memory usage.

## Lazy Functions in Dart

Refer to [[Dart Lazy Evaluation]] for more details.

In Dart, a lazy function can be created by using the `Lazy` constructor.

```dart
void main() {
  Lazy<int> lazyValue = Lazy(() => calculateValue());

  print("Before calculation");
  // The calculation is deferred until the value is accessed
  print(lazyValue.value);
  print("After calculation");
}

int calculateValue() {
  // Simulate a time-consuming calculation
  return 42;
}
```

## Lazy Functions in C\#

In C#, lazy evaluation can be achieved by using the `Lazy<T>` class from the `System` namespace.

```csharp
using System;

class Program
{
    static void Main()
    {
        Lazy<int> lazyValue = new Lazy<int>(() => CalculateValue());

        Console.WriteLine("Before calculation");
        // The calculation is deferred until the value is accessed
        Console.WriteLine(lazyValue.Value);
        Console.WriteLine("After calculation");
    }

    static int CalculateValue()
    {
        // Simulate a time-consuming calculation
        return 42;
    }
}
```

## Benefits of Lazy Functions

- **Efficiency**: Lazy functions help avoid unnecessary calculations or data fetching, which can improve the overall performance of your code.
- **Memory Optimization**: By calculating values only when needed, memory consumption can be reduced, especially when dealing with large datasets.
- **Flexibility**: Lazy functions provide flexibility in managing when and how calculations are performed, allowing for better control over resource usage.
