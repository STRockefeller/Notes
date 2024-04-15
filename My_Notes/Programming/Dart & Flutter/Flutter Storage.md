# Flutter Storage

tags: #dart/flutter #storage #cache

I would like to introduce the following two packages:

- [get_storage](https://pub.dev/packages/get_storage)
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)

## Get Storage

[Get Storage](https://pub.dev/packages/get_storage) is a wrapper of [shared_preferences](https://pub.dev/packages/shared_preferences) package. It is a local storage for Flutter and Dart. It is a key-value store, and it has a simple API.

> A fast, extra light and synchronous key-value in memory, which backs up data to disk at each operation. It is written entirely in Dart and easily integrates with Get framework of Flutter.
>
> Supports Android, iOS, Web, Mac, Linux, and fuchsia and Windows**. Can store String, int, double, Map and List

### Usage

Initialize storage driver with await:

```dart
main() async {
  await GetStorage.init();
  runApp(App());
}
```

use GetStorage through an instance or use directly

```dart
GetStorage().read('key')
final box = GetStorage();
```

To write information you must use write :

```dart
box.write('quote', 'GetX is the best');
```

To read values you use read:

```dart
print(box.read('quote'));
// out: GetX is the best
```

To remove a key, you can use remove:

```dart
box.remove('quote');
```

To listen changes you can use listen:

```dart
Function? disposeListen;
disposeListen = box.listen((){
  print('box changed');
});
```

If you subscribe to events, be sure to dispose them when using:

```dart
disposeListen?.call();
```

To listen changes on key you can use listenKey:

```dart
box.listenKey('key', (value){
  print('new key is $value');
});
```

To erase your container:

```dart
box.erase();
```

If you want to create different containers, simply give it a name. You can listen to specific containers, and also delete them.

```dart
GetStorage g = GetStorage('MyStorage');
```

To initialize specific container:

```dart
await GetStorage.init('MyStorage');
```

## Flutter Secure Storage

[Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) is a wrapper of [Keychain](https://developer.apple.com/documentation/security/keychain_services) on iOS and [Keystore](https://developer.android.com/training/articles/keystore) on Android. It is a local storage for Flutter and Dart. It is a key-value store, and it has a simple API.

> A Flutter plugin to store data in secure storage:
>
> Keychain is used for iOS
> AES encryption is used for Android. AES secret key is encrypted with RSA and RSA key is stored in KeyStore
> With V5.0.0 we can use EncryptedSharedPreferences on Android by enabling it in the Android Options like so:
> AndroidOptions _getAndroidOptions() => const AndroidOptions(
> encryptedSharedPreferences: true,
> );
> For more information see the example app.
>
> libsecret is used for Linux.
> Note KeyStore was introduced in Android 4.3 (API level 18). The plugin wouldn't work for earlier versions.

### Usage

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage
final storage = new FlutterSecureStorage();

// Read value
String value = await storage.read(key: key);

// Read all values
Map<String, String> allValues = await storage.readAll();

// Delete value
await storage.delete(key: key);

// Delete all
await storage.deleteAll();

// Write value
await storage.write(key: key, value: value);
```

## Comparison

| Features | Get Storage | Flutter Secure Storage |
| :------: | :---------: | :--------------------: |
|  iOS/Android  |    ✅    |          ✅           |
|  Web/Mac/Linux/Windows  |    ✅    |          ✅           |
|  Fuchsia  |    ✅    |          ❌           |
|  Encrypted  |    ❌    |          ✅           |
|  Keychain  |    ❌    |          ✅           |
|  Keystore  |    ❌    |          ✅           |
|  Libsecret  |    ❌    |          ✅           |
|  AES encryption  |    ❌    |          ✅           |
|  EncryptedSharedPreferences  |    ❌    |          ✅           |
|  RSA encryption  |    ❌    |          ✅           |
|  KeyStore  |    ❌    |          ✅           |
|  AES secret key  |    ❌    |          ✅           |
|  RSA key  |    ❌    |          ✅           |

## References

- <https://pub.dev/packages/get_storage>
- <https://pub.dev/packages/flutter_secure_storage>
