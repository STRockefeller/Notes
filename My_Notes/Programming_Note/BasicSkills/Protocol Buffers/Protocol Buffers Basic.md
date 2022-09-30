# Protocol Buffers

https://developers.google.com/protocol-buffers/

https://ithelp.ithome.com.tw/articles/10250131

https://yami.io/protobuf/

Google

> Protocol buffers are Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data – think XML, but smaller, faster, and simpler. You define how you want your data to be structured once, then you can use special generated source code to easily write and read your structured data to and from a variety of data streams and using a variety of languages.

## Naming

protobuf 有自己的命名慣例

參考 https://developers.google.com/protocol-buffers/docs/style

命名會在生成程式碼的時候自動變成符合該語言規範的模樣

以golang為例

proto會預設結構中的field全部為exported。所以小寫開頭的命名生成出`.go`檔案時也會變成大寫

## Go

### Prerequisites

- **[Go](https://golang.org/)**, any one of the **three latest major** [releases of Go](https://golang.org/doc/devel/release.html).
  
  For installation instructions, see Go’s [Getting Started](https://golang.org/doc/install) guide.

- **[Protocol buffer](https://developers.google.com/protocol-buffers) compiler**, `protoc`, [version 3](https://developers.google.com/protocol-buffers/docs/proto3).
  
  For installation instructions, see [Protocol Buffer Compiler Installation](https://grpc.io/docs/protoc-installation/).

- **Go plugins** for the protocol compiler:
  
  1. Install the protocol compiler plugins for Go using the following commands:
     
     ```sh
     $ go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26
     $ go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1
     ```
  
  2. Update your `PATH` so that the `protoc` compiler can find the plugins:
     
     ```sh
     $ export PATH="$PATH:$(go env GOPATH)/bin"
     ```

該安裝的安裝完後，可以透過使用 go generate 來簡化指令

protogen.go

```go
package errors

//go:generate protoc --go_out=. code.proto
```

## C#

[Google](https://developers.google.com/protocol-buffers/docs/csharptutorial)

[MSDN](https://docs.microsoft.com/zh-tw/aspnet/core/grpc/?view=aspnetcore-5.0)

https://blog.yowko.com/csharp-protobuf-serialize-deserialize/

真的認為Microsoft的文件比google好懂多了。

### Prerequisites

Whether you’re using Windows, OS X, or Linux, you can follow this example by using either an IDE and its build tools, or by using the the .NET Core SDK command line tools.

First, make sure you have installed the [gRPC C# prerequisites](https://github.com/grpc/grpc/blob/v1.41.0/src/csharp/README.md#prerequisites). You will also need Git to download the sample code.

生成的指令和go差不多

```powershell
go:generate protoc --csharp_out=. code.proto
```

## Dart

### Prerequisites

- **[Dart](https://dart.dev/)** version 2.12 or higher, through the Dart or [Flutter](https://flutter.dev/) SDKs
  
  For installation instructions, see [Install Dart](https://dart.dev/install) or [Install Flutter](https://flutter.dev/docs/get-started/install).

- **[Protocol buffer](https://developers.google.com/protocol-buffers) compiler**, `protoc`, [version 3](https://developers.google.com/protocol-buffers/docs/proto3)
  
  For installation instructions, see [Protocol Buffer Compiler Installation](https://grpc.io/docs/protoc-installation/).

- **Dart plugin** for the protocol compiler:
  
  1. Install the protocol compiler plugin for Dart (`protoc-gen-dart`) using the following command:
     
     ```sh
     $ dart pub global activate protoc_plugin
     ```
  
  2. Update your `PATH` so that the `protoc` compiler can find the plugin:
     
     ```sh
     $ export PATH="$PATH:$HOME/.pub-cache/bin"
     ```

#### Note

Dart gRPC supports the Flutter and Server platforms.

生成同上改成`--dart_out`

## TypeScript

typescript 目前還不是官方有支援的語言(至少我在google的文件中沒看到。)不過有第三方的npm套件可以用，所以就來玩玩看了。

[ts-proto](https://github.com/stephenh/ts-proto)

- `npm install ts-proto`

- ```
  protoc --plugin=./node_modules/.bin/protoc-gen-ts_proto --ts_proto_out=. ./simple.proto
  ```
  
  - (Note that the output parameter name, `ts_proto_out`, is named based on the suffix of the plugin's name, i.e. "ts_proto" suffix in the `--plugin=./node_modules/.bin/protoc-gen-ts_proto` parameter becomes the `_out` prefix, per `protoc`'s CLI conventions.)
  - On Windows, use `protoc --plugin=protoc-gen-ts_proto=.\node_modules\.bin\protoc-gen-ts_proto.cmd --ts_proto_out=. ./simple.proto` (see [#93](https://github.com/stephenh/ts-proto/issues/93))
  - Ensure you're using a modern `protoc`, i.e. the original `protoc` `3.0.0` doesn't support the `_opt` flag

This will generate `*.ts` source files for the given `*.proto` types.

If you want to package these source files into an npm package to distribute to clients, just run `tsc` on them as usual to generate the `.js`/`.d.ts` files, and deploy the output as a regular npm package.

這邊有個要注意的點就是，前面`plugin`的flag必須要指到安裝的`protoc-gen-ts_proto.cmd`的位置，如果目前的終端機基準位置不是在專案跟目錄的話，必須跟著調整路徑，否則會找不到路徑

```bash
--ts_proto_out: protoc-gen-ts_proto: 系統找不到指定的路徑。
```

再來就是如果生成出來的東西紅紅的

![](https://i.imgur.com/iyrKNMQ.png)

![](C:\Users\rockefel\AppData\Roaming\Typora\typora-user-images\image-20220325112248570.png)

就按照上面的註解再生成一次即可。

![](https://i.imgur.com/Se8MDor.png)

至於隨便生一個enum都可以拿到`you must be kidding`的複雜度就...

![](https://i.imgur.com/b2jSWbU.png)





## Notes



### About -I flag



用來指定import路徑，會包含該目錄底下的所有檔案以及底下資料夾的所有檔案，以及底下資料夾底下資料夾的所有檔案...

預設為當前目錄。(`-I .`)

可以下多次。ex: `-I a/ -I b/c/`

比較要注意的是這個路徑也要包含目標proto本身，所以在跨目錄指定`.proto`的時候要特別注意下`-I` flag


