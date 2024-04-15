import 'dart:io';
import './job.dart';
import './engineer.dart';

void async1(){
  Job job = Job(3, 1, 2);
  DBEngineer dbEngineer = DBEngineer();
  APIEngineer apiEngineer = APIEngineer();
  UIEngineer uiEngineer = UIEngineer();
  Future<void> task1 = dbEngineer.doTaskAsync(job);
  Future<void> task2 = apiEngineer.doTaskAsync(job);
  Future<void> task3 = uiEngineer.doTaskAsync(job);

  Future.wait({task1, task2, task3});
}