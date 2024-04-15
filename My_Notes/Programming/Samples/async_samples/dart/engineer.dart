import './job.dart';
import 'dart:io';

abstract class IEngineer {
  void doTask(Job job);
  void doTaskAsync(Job job);
}

class DBEngineer extends IEngineer {
  void doTask(Job job) {
    print("db task start");
    sleep(Duration(seconds: job.db));
    print("db task complete");
  }

  Future<void> doTaskAsync(Job job) async {
    print("db task start");
    await Future.delayed(Duration(seconds: job.db));
    print("db task complete");
  }
}

class UIEngineer extends IEngineer {
  void doTask(Job job) {
    print("ui task start");
    sleep(Duration(seconds: job.ui));
    print("ui task complete");
  }

  Future<void> doTaskAsync(Job job) async {
    print("ui task start");
    await Future.delayed(Duration(seconds: job.ui));
    print("ui task complete");
  }
}

class APIEngineer extends IEngineer {
  void doTask(Job job) {
    print("api task start");
    sleep(Duration(seconds: job.api));
    print("api task complete");
  }

  Future<void> doTaskAsync(Job job) async {
    print("api task start");
    await Future.delayed(Duration(seconds: job.api));
    print("api task complete");
  }
}
