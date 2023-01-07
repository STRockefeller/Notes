# Dart Convention

#dart #async

Reference:

<https://medium.com/flutter-community/flutter-best-practices-and-tips-7c2782c9ebb5>

## Naming convention

For other languages, refer to [[Naming Conventions]]

Classes, enums, typedefs, and extensions name should in `UpperCamelCase.`

```dart
class MainScreen { ... }
enum MainItem { .. }
typedef Predicate<T> = bool Function(T value);
extension MyList<T> on List<T> { ... }
```

Libraries, packages, directories, and source files name should be in `snake_case(lowercase_with_underscores).`

```dart
library firebase_dynamic_links;
import 'socket/socket_manager.dart';
```

Variables, constants, parameters, and named parameters should be in `lowerCamelCase.`

```dart
var item;
const bookPrice = 3.14;
final urlScheme = RegExp('^([a-z]+):');
void sum(int bookPrice) {
  // ...
}
```

## Use relative imports for files in `lib`

```dart

// Don't
import 'package:demo/src/utils/dialog_utils.dart';


// Do
import '../../../utils/dialog_utils.dart';
```

## Specify types for class member

```dart
//Don't
var item = 10;
final car = Car();
const timeOut = 2000;


//Do
int item = 10;
final Car bar = Car();
String name = 'john';
const int timeOut = 20;
```

## Avoid using `as` instead, use `is` operator

```dart

//Don't
(item as Animal).name = 'Lion';


//Do
if (item is Animal)
  item.name = 'Lion';
```

## Use `??`and `?.` operators

```dart
//Don't
v = a == null ? b : a;

//Do
v = a ?? b;


//Don't
v = a == null ? null : a.b;

//Do
v = a?.b;
```

## Use spread collections

```dart
//Don't
var y = [4,5,6];
var x = [1,2];
x.addAll(y);


//Do
var y = [4,5,6];
var x = [1,2,...y];
```

## Use Cascades Operator

```dart
// Don't
var path = Path();
path.lineTo(0, size.height);
path.lineTo(size.width, size.height);
path.lineTo(size.width, 0);
path.close();


// Do
var path = Path()
..lineTo(0, size.height)
..lineTo(size.width, size.height)
..lineTo(size.width, 0)
..close();
```

## Use raw string

```dart

//Don't
var s = 'This is demo string \\ and \$';


//Do
var s = r'This is demo string \ and $';
```

補充一下 raw string ， 我前面的筆記似乎沒寫到

![](https://www.educative.io/api/edpresso/shot/4508097395556352/image/4654289629741056)

## Don’t explicitly initialize variables `null`

```dart

//Don't
int _item = null;


//Do
int _item;
```

## Use expression function bodies

```dart
//Don't
get width {
  return right - left;
}
Widget getProgressBar() {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
  );
}


//Do
get width => right - left;
Widget getProgressBar() => CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
```

## Avoid `print()` calls

> `print()`and`debugPrint()`both are used for logging in to the console.
> If you are use `print()`and output is too much at once,
> then Android sometimes discards some log lines. To avoid this,
> use `debugPrint().` If you log data has too much data then use `dart:developer` `log().`
> This allows you to include a bit more granularity and information in the logging output.

簡單來說打包前記得把`print()`都刪掉

## Avoid using leading underscore for local identifiers that aren’t private

## Use interpolation to compose strings

Use interpolation to make string cleaner and shorter rather than long chains of `+` to build a string.

```dart

//Don’t
var description = 'Hello, ' + name + '! You are ' + (year - birth).toString() + ' years old.';


// Do
var description = 'Hello, $name! You are ${year - birth} years old.';
```

## Don’t create a lambda when a tear-off will do

> If we have a function that invokes a method with the same arguments as are passed to it, you don’t need to manually wrap the call in a lambda.

```dart
List<String> names=[]

// Don’t
names.forEach((name) {
  print(name);
});


// Do
names.forEach(print);
```

這邊可以寫地比起C#更加精簡，要特別注意

## Use async/await overusing futures callback

> Asynchronous code is hard to read and debug. The `async`/`await` syntax improves readability.

```dart
// Don’t
Future<int> countActiveUser() {
  return getActiveUser().then((users) {

    return users?.length ?? 0;

  }).catchError((e) {
    log.error(e);
    return 0;
  });
}


// Do
Future<int> countActiveUser() async {
  try {
    var users = await getActiveUser();

    return users?.length ?? 0;

  } catch (e) {
    log.error(e);
    return 0;
  }
}
```

For more information about async, refer to [[Dart Async]]
## Split widgets into sub Widgets

```dart
Scaffold(
  appBar: CustomAppBar(title: "Verify Code"), // Sub Widget
  body: Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TimerView( // Sub Widget
            key: _timerKey,
            resendClick: () {})
      ],
    ),
  ),
)
```

## Use ListView.builder for a long list

> When working with infinite lists or very large lists, it’s usually advisable to use a `ListView` builder in order to improve performance.
>
> Default `ListView` constructor builds the whole list at once. `ListView.builder` creates a lazy list and when the user is scrolling down the list, Flutter builds widgets on-demand.

## Use Const in Widgets

```dart
Container(
      padding: const EdgeInsets.only(top: 10),
      color: Colors.black,
      child: const Center(
        child: const Text(
          "No Data found",
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
      ),
    );
```

這個我記得VSCode會提示
