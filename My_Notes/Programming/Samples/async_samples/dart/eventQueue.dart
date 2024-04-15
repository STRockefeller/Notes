void eventQueueSample() {
  Future(() {
    print("<1> start");
    DateTime end = DateTime.now().add(Duration(seconds: 2));
    while (DateTime.now().isBefore(end));
    print("<1> end");
  });
  asyncFunction();
}

Future<void> asyncFunction() async {
  print("<2> start");
  await Future(() {
    print("<3> start");
    DateTime end = DateTime.now().add(Duration(seconds: 2));
    while (DateTime.now().isBefore(end));
    print("<3> end");
  });
  print("<2> end");
}