namespace Async{

    partial class Program{
        static void Sync(){
            Job job = new Job(3,1,2);
            DBEngineer dbEngineer = new DBEngineer();
            APIEngineer apiEngineer = new APIEngineer();
            UIEngineer uiEngineer = new UIEngineer();
            dbEngineer.Do(job);
            apiEngineer.Do(job);
            uiEngineer.Do(job);
        }
    }
}

