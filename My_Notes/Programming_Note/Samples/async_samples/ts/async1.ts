function async1():Promise<void>{
    var job = new Job(3,1,2);
    var dbEngineer = new DBEngineer();
    var apiEngineer = new APIEngineer();
    var uiEngineer = new UIEngineer();

    var task1:Promise<void> = dbEngineer.do(job)
    var task2:Promise<void> = apiEngineer.do(job)
    var task3:Promise<void> = uiEngineer.do(job)

    Promise.all([task1, task2, task3])
    return null;
}