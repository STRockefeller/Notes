import { DBEngineer, APIEngineer, UIEngineer } from "./engineer";

function async2():Promise<[void,void]>{
    var job = new Job(3,1,2);
    var dbEngineer = new DBEngineer();
    var apiEngineer = new APIEngineer();
    var uiEngineer = new UIEngineer();

    var task1:Promise<void> = dbEngineer.do(job).then(() =>apiEngineer.do(job))
    var task2:Promise<void> = uiEngineer.do(job)

    return Promise.all([task1, task2])
}