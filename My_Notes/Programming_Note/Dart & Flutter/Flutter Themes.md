# Flutter Themes
#dart/flutter #themes

## References

[docs.flutter.dev](https://docs.flutter.dev/cookbook/design/themes)

## Abstract

One of the features that makes Flutter attractive is the ability to customize the look and feel of the app with themes. Themes are collections of colors, fonts, shapes, and other design elements that define the appearance of the app. In this note, I will explore how to use themes in Flutter, how to switch between different themes dynamically, and how to leverage some useful packages that simplify the process of creating and managing themes.

## Basic about themes

A theme in Flutter is represented by a ThemeData object, which contains properties for various aspects of the app's design, such as primaryColor, accentColor, textTheme, buttonTheme, iconTheme, and so on. You can create a ThemeData object by using its constructor or by using one of the predefined themes that Flutter provides, such as ThemeData.light() or ThemeData.dark().

To apply a theme to the entire app, you need to wrap your MaterialApp widget with a Theme widget and pass the ThemeData object to its data parameter. For example:

```dart
Theme(
    data: ThemeData.light(),
    child: MaterialApp(
        title: 'Flutter Themes Demo',
        home: HomePage(),
    ),
);
```

This will apply the light theme to all the widgets in the app. Alternatively, you can pass the ThemeData object directly to the theme parameter of MaterialApp:

```dart
MaterialApp(
    title: 'Flutter Themes Demo',
    theme: ThemeData.light(),
    home: HomePage(),
);
```

This will have the same effect as using the Theme widget.

To apply a theme to a specific widget or a subtree of widgets, you can use the Theme widget again and pass a different ThemeData object to its data parameter. For example:

```dart
Theme(
    data: ThemeData.dark(),
    child: Text('This text is dark'),
);
```

This will apply the dark theme only to the Text widget and its descendants(children).

### themeMode

`ThemeMode` is a property of the `MaterialApp` class in Flutter's material library. It determines which theme will be used by the application if both `theme` and `darkTheme` are provided. If set to `ThemeMode.system`, the choice of which theme to use will be based on the user's system preferences. If set to `ThemeMode.light`, the `theme` will always be used, regardless of the user's system preference. If set to `ThemeMode.dark`, the `darkTheme` will be used regardless of the user's system preference. If `darkTheme` is null then it will fallback to using `theme`. The default value is `ThemeMode.system`.

refer to [api.flutter.dev](https://api.flutter.dev/flutter/material/MaterialApp/themeMode.html)

## How to switch themes

Sometimes you may want to allow the user to switch between different themes in your app, such as light and dark modes. To do this, you need to use a StatefulWidget that can store the current theme data and update it when the user selects a different theme. For example:

```dart
class HomePage extends StatefulWidget {
    const HomePage({Key? key}) : super(key: key);

    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    // Define two theme data objects for light and dark modes
    final lightTheme = ThemeData.light();
    final darkTheme = ThemeData.dark();

    // Define a variable to store the current theme data
    ThemeData currentTheme = ThemeData.light();

    // Define a method to toggle between light and dark themes
    void toggleTheme() {
        setState(() {
            // If the current theme is light, switch to dark; otherwise switch to light
            currentTheme = currentTheme == lightTheme ? darkTheme : lightTheme;
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Flutter Themes Demo'),
                // Add an action button to toggle the theme
                actions: [
                    IconButton(
                        icon: Icon(Icons.brightness_6),
                        onPressed: toggleTheme,
                    ),
                ],
            ),
            body: Center(
                child: Text('This text changes color according to the theme'),
            ),
        );
    }
}
```

Now you can run your app and see how the theme changes when you tap on the brightness icon in the app bar.

other references:

- https://blog.logrocket.com/dynamic-theme-switcher-flutter/
- https://levelup.gitconnected.com/theme-switcher-with-provider-f84f947b9044

## Useful packages

Creating and managing themes in Flutter can be tedious and time-consuming, especially if you want to have more than two themes or customize them in detail. Fortunately, there are some packages that can help you with this task. Here are two examples:

### flex_color_scheme

[pub.dev](https://pub.dev/packages/flex_color_scheme)

flex_color_scheme is a package that allows you to create beautiful color schemes for your Flutter app with minimal code. It supports both light and dark modes, as well as custom themes based on primary and secondary colors. It also provides some predefined color schemes that are inspired by popular design systems, such as Material Design, Bootstrap, Tailwind CSS, and more.

To use flex_color_scheme, you need to add it as a dependency in your pubspec.yaml file:

```yaml
dependencies:
flex_color_scheme: ^4.0.0
```

Then you can import it in your Dart code:

```dart
import 'package:flex_color_scheme/flex_color_scheme.dart';
```

To create a color scheme with flex_color_scheme, you need to use its FlexColorScheme class and pass it some parameters, such as primary color, secondary color, mode (light or dark), surface style (material or branded), etc. For example:

```dart
final myColorScheme = FlexColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.pink,
).toScheme;
```

This will create a light color scheme with blue as primary color and pink as secondary color. You can also use one of the predefined color schemes by using FlexColorScheme presets:

```dart
final myColorScheme = FlexColorScheme.light(scheme: FlexScheme.blue).toScheme;
```

This will create a light color scheme based on Material Design's blue color scheme.

To apply a color scheme created with flex_color_scheme to your app, you need to use its FlexColorScheme.themedData method and pass it the color scheme object. For example:

```dart
MaterialApp(
    title: 'Flutter Themes Demo',
    theme: FlexColorScheme.themedData(myColorScheme),
    home: HomePage(),
);
```

This will apply the color scheme to your app's theme.

To switch between different color schemes dynamically with flex_color_scheme, you can use its FlexColorScheme.switchable method and pass it a list of color schemes. For example:

```dart
MaterialApp(
    title: 'Flutter Themes Demo',
    theme: FlexColorScheme.switchable(schemes: [
        FlexColorScheme.light(scheme: FlexScheme.blue).toScheme,
        FlexColorScheme.light(scheme: FlexScheme.green).toScheme,
        FlexColorScheme.light(scheme: FlexScheme.red).toScheme,
        FlexColorScheme.dark(scheme: FlexScheme.blue).toScheme,
        FlexColorScheme.dark(scheme: FlexScheme.green).toScheme,
        FlexColorScheme.dark(scheme: FlexScheme.red).toScheme,
    ]),
    home: HomePage(),
);
```

This will create six color schemes (three light and three dark) based on different primary colors. You can then use its scheme property to get or set the current scheme index:

```dart
// Get the current scheme index
final currentScheme = FlexColorScheme.of(context).scheme;

// Set a new scheme index
FlexColorScheme.of(context).changeTo(2);
```

You can also use its brightness property to get or set the current brightness mode (light or dark):

```dart
// Get the current brightness mode
final currentBrightness = FlexColorScheme.of(context).brightness;

// Set a new brightness mode
FlexColorScheme.of(context).changeToBrightness(Brightness.dark);
```

You can use these properties in combination with buttons or other widgets to allow the user to switch between different color schemes and brightness modes in your app.

### animated_theme_switcher

[pub.dev](https://pub.dev/packages/animated_theme_switcher)

animated_theme_switcher is a package that adds some animations and transitions when switching between themes in your Flutter app. It supports both light and dark modes, as well as custom themes.

To use animated_theme_switcher, you need to add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
animated_theme_switcher: ^1.0.1
```

Then you can import it in your Dart code:

```dart
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
```

To apply animated_theme_switcher to your app, you need to wrap your MaterialApp widget with an AnimatedThemeSwitcherWidget widget and pass it two ThemeData objects for light and dark modes. For example:

```dart
AnimatedThemeSwitcherWidget(
    lightTheme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    child: MaterialApp(
        // your app code here
    ),
);
```

This will automatically animate the theme change when the user toggles the system theme preference or when you call `ThemeSwitcher.of(context).changeTheme()` in your code.

You can also customize the animation duration, curve, and transition type by passing them as parameters to the AnimatedThemeSwitcherWidget widget. For example, you can use a fade transition with a 500 milliseconds duration and an ease-in curve:

```dart
AnimatedThemeSwitcherWidget(
    lightTheme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    duration: Duration(milliseconds: 500),
    curve: Curves.easeIn,
    transitionType: ThemeTransitionType.fade,
    child: MaterialApp(
        // your app code here
    ),
);
```

You can find more details and examples on how to use animated_theme_switcher in the [example](https://pub.dev/packages/animated_theme_switcher/example).
