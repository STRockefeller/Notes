# CodeWars:URL shortener:20230214:Dart

tags: #problem_solve #dart #codewars/5kyu

[Reference](https://www.codewars.com/kata/5fee4559135609002c1a1841/dart)

## Question

### Background Information

### When do we use an URL shortener?

In your PC life you have probably seen URLs like this before:

-   [https://bit.ly/3kiMhkU](https://bit.ly/3kiMhkU)

If we want to share a URL we sometimes have the problem that it is way too long, for example this URL:

-   [https://www.google.com/search?q=codewars&tbm=isch&ved=2ahUKEwjGuLOJjvjsAhXNkKQKHdYdDhUQ2-cCegQIABAA&oq=codewars&gs_lcp=CgNpbWcQAzICCAAyBAgAEB4yBAgAEB4yBAgAEB4yBAgAEB4yBAgAEB4yBAgAEB4yBAgAEB4yBAgAEB4yBggAEAUQHlDADlibD2CjEGgAcAB4AIABXIgBuAGSAQEymAEAoAEBqgELZ3dzLXdpei1pbWfAAQE&sclient=img&ei=RJmqX8aGHM2hkgXWu7ioAQ&bih=1099&biw=1920#imgrc=Cq0ZYnAGP79ddM](https://www.google.com/search?q=codewars&tbm=isch&ved=2ahUKEwjGuLOJjvjsAhXNkKQKHdYdDhUQ2-cCegQIABAA&oq=codewars&gs_lcp=CgNpbWcQAzICCAAyBAgAEB4yBAgAEB4yBAgAEB4yBAgAEB4yBAgAEB4yBAgAEB4yBAgAEB4yBAgAEB4yBggAEAUQHlDADlibD2CjEGgAcAB4AIABXIgBuAGSAQEymAEAoAEBqgELZ3dzLXdpei1pbWfAAQE&sclient=img&ei=RJmqX8aGHM2hkgXWu7ioAQ&bih=1099&biw=1920#imgrc=Cq0ZYnAGP79ddM)

In such cases a URL shortener is very useful.

#### How does it work?

The URL shortener is given a long URL, which is then converted into a shorter one. Both URLs are stored in a database. It is important that each long URL is assigned a unique short URL.

If a user then calls up the short URL, the database is checked to see which long URL belongs to this short URL and you are redirected to the original/long URL.

**Important Note:** Some URLs such as `www.google.com` are used very often. It can happen that two users want to shorten the same URL, so you have to check if this URL has been shortened before to save memory in your database.

### Task

#### URL Shortener

**Note:** `short.ly/` is not a valid short URL.

#### Redirect URL

### Performance

There are `475_000` random tests. You don't need a complicated algorithm to solve this kata, but iterating each time through the whole database to check if a URL was used before or generating short URLs based on randomness, won't pass.

## My Solution

### Solution1

```dart
class UrlShortener {
  Map _m = new Map();
  String? shorten(String? longURL) {
    if (longURL == null) return null;
    List<String> sr = _httpSplit(longURL);
    String enc = _encode(sr[1]);

    while (_m.containsKey(sr[0] + enc)) {
      if (_m[sr[0] + enc] == longURL) return sr[0] + enc;
      enc = _encode(enc);
    }

    _m[sr[0] + enc] = longURL;

    return sr[0] + enc;
  }

  String? redirect(String? shortURL) {
    if (shortURL == null) return null;
    return _m[shortURL];
  }

  // return http:// or https:// + other string
  List<String> _httpSplit(String url) {
    final res = url.split("://");
    return [res[0] + "://short.ly/", res[1]];
  }

  String _encode(String str) {
    final bytes = utf8.encode(str);
    final enc = base64.encode(bytes);
    return enc.substring(0, 10);
  }
}

```

It was not until after testing that I realized the prompt did not require the prefix "http://" or "https://" and it should also end with 1~4 lowercase letters.

```dart
void testFormat(string) {
  expect(RegExp(r"^short.ly\/[a-z]{1,4}$").hasMatch(string), equals(true));
}
```

### Solution2

```dart
class UrlShortener {
  Map _m = new Map();
  String prefix = "short.ly/";
  String? shorten(String? longURL) {
    if (longURL == null) return null;
    String enc = _encode(longURL);

    while (_m.containsKey(prefix + enc)) {
      if (_m[prefix + enc] == longURL) return prefix + enc;
      enc = _encode(enc);
    }
    _m[prefix + enc] = longURL;
    return prefix + enc;
  }

  String? redirect(String? shortURL) {
    if (shortURL == null) return null;
    return _m[shortURL];
  }

  String _encode(String str) {
    final pattern = RegExp(r"[^a-zA-Z]");
    str = str.replaceAll(pattern, '');
    final alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final shift = 6;
    final rotatedAlphabet = alphabet.split('').map((c) {
      final index = alphabet.indexOf(c);
      final newIndex = (index + shift) % alphabet.length;
      return alphabet[newIndex];
    }).join();

    str = str.split('').map((c) {
      final index = alphabet.indexOf(c);
      if (index == -1) {
        return c;
      }
      return rotatedAlphabet[index];
    }).join();
    return str.substring(0, 4).toLowerCase();
  }
}
```

I attempted to use 'rot6' instead of 'base64 encoding', but the execution timed out.

![result](https://i.imgur.com/saayIw7.png)

### Solution3

```dart
import 'dart:collection';
import 'dart:convert';

class UrlShortener {
  HashMap<String, String> _m = new HashMap();
  String _prefix = "short.ly/";
  String _alphabet = 'abcdefghijklmnopqrstuvwxyz';
  String _rotatedAlphabet = "";

  UrlShortener() {
    this._rotatedAlphabet = _alphabet.split('').map((c) {
      final index = _alphabet.indexOf(c);
      final newIndex = (index + 6) % _alphabet.length;
      return _alphabet[newIndex];
    }).join();
  }

  String? shorten(String? longURL) {
    if (longURL == null) return null;
    var hash = _hash(longURL);

    while (_m.containsKey(_prefix + hash)) {
      if (_m[_prefix + hash] == longURL) return _prefix + hash;
      hash = _hash(hash);
    }
    _m[_prefix + hash] = longURL;
    return _prefix + hash;
  }

  String? redirect(String? shortURL) {
    if (shortURL == null) return null;
    return _m[shortURL];
  }

  String _hash(String str) {
    final bytes = utf8.encode(str);
    final pattern = RegExp(r"[^a-z]");
    str = base64.encode(bytes).toLowerCase().replaceAll(pattern, 'a');
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final c = str[i];
      final index = _alphabet.indexOf(c);
      if (index == -1) {
        buffer.write(c);
      } else {
        buffer.write(_rotatedAlphabet[index]);
      }
    }
    return buffer.toString().substring(0, 4);
  }
}
```

I tried to make optimizations, but there was no change in the outcome.

### Solution4

```dart
import 'dart:collection';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class UrlShortener {
  HashMap<String, String> _m = new HashMap();
  String _prefix = "short.ly/";

  String? shorten(String? longURL) {
    if (longURL == null) return null;
    var hash = _hash(longURL);

    while (_m.containsKey(_prefix + hash)) {
      if (_m[_prefix + hash] == longURL) return _prefix + hash;
      hash = _hash(hash);
    }
    _m[_prefix + hash] = longURL;
    return _prefix + hash;
  }

  String? redirect(String? shortURL) {
    if (shortURL == null) return null;
    return _m[shortURL];
  }

  String _hash(String str) {
    final bytes = utf8.encode(str);
    final hash = md5.convert(bytes).toString();
    final pattern = RegExp(r"[^a-z]");
    final alphabet = 'abcdefghijklmnopqrstuvwxyz';
    String result = '';

    for (int i = 0; i < 4; i++) {
      final index = int.parse(hash[i * 2] + hash[i * 2 + 1], radix: 16) % 26;
      result += alphabet[index];
    }

    return result;
  }
}
```

I rewrote the hash function but again received a timeout error.

### Solution 5

```dart
import 'dart:collection';
import 'dart:convert';

class UrlShortener {
  HashMap<String, String> _m = new HashMap();
  String _prefix = "short.ly/";
  String _alphabet = 'abcdefghijklmnopqrstuvwxyz';
  String _rotatedAlphabet = "";

  UrlShortener() {
    this._rotatedAlphabet = _alphabet.split('').map((c) {
      final index = _alphabet.indexOf(c);
      final newIndex = (index + 6) % _alphabet.length;
      return _alphabet[newIndex];
    }).join();
  }

  String? shorten(String? longURL) {
    if (longURL == null) return null;
    var hash = _hash(longURL);

    while (_m.containsKey(_prefix + hash)) {
      if (_m[_prefix + hash] == longURL) return _prefix + hash;
      hash = _hash(hash);
    }
    _m[_prefix + hash] = longURL;
    return _prefix + hash;
  }

  String? redirect(String? shortURL) {
    if (shortURL == null) return null;
    return _m[shortURL];
  }

  String _hash(String str) {
    final a = _asciiNumberSum(str);
    return _toLowercaseCharacters(a);
  }

  int _asciiNumberSum(String str) {
    int sum = 0;
    for (int i = 0; i < str.length; i++) {
      sum += str.codeUnitAt(i);
    }
    return sum;
  }

  String _toLowercaseCharacters(int i) {
    String result = '';
    while (i > 0) {
      int index = i % 26;
      result = String.fromCharCode(index + 97) + result;
      i = (i / 26).floor();
    }
    while (result.length < 4) {
      result = 'a' + result;
    }
    return result;
  }
}

```

DIY hash funciton but still timed out.

## Better Solutions
