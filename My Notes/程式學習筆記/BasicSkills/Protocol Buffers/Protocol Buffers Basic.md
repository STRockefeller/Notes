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
