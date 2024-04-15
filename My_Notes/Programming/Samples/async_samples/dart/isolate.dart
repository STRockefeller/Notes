import 'dart:isolate';

void isolate() {
  // create an isolate
  Isolate.spawn(saySomething, "Hello");
}

Future<void> isolate2() async {
  // create an isolate with response
  final mainReceivePort = ReceivePort();
  await Isolate.spawn(responseSomething, mainReceivePort.sendPort);
  final message = await mainReceivePort.first;
  print(message);
}

Future<void> isolate3() async {
  final mainReceivePort = ReceivePort();
  await Isolate.spawn(repeatSomething, mainReceivePort.sendPort);
  mainReceivePort.listen((message) {
    if (message is SendPort) {
      message.send("Hello");
    }
    if (message is String) {
      print("main receive message: " + message);
    }
  });
}

void saySomething(String message) {
  print(message);
}

void responseSomething(SendPort mainSendPort) {
  mainSendPort.send("this is responseSomething isolate");
}

void repeatSomething(SendPort mainSendPort) {
  final repeatSomethingReceivePort = ReceivePort();
  mainSendPort.send(repeatSomethingReceivePort.sendPort);

  repeatSomethingReceivePort.listen((message) {
    if (message is String) {
      mainSendPort.send(message);
    }
  });
}
