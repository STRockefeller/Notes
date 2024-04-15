import './job.dart';
import './engineer.dart';

void sync() {
  Job job = Job(3, 1, 2);
  DBEngineer dbEngineer = DBEngineer();
  APIEngineer apiEngineer = APIEngineer();
  UIEngineer uiEngineer = UIEngineer();
  dbEngineer.doTask(job);
  apiEngineer.doTask(job);
  uiEngineer.doTask(job);
}
