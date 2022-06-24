import { DBEngineer, APIEngineer, UIEngineer } from "./engineer";

export function sync(): void {
    var job = new Job(3,1,2);
    var dbEngineer = new DBEngineer();
    var apiEngineer = new APIEngineer();
    var uiEngineer = new UIEngineer();
    dbEngineer.do(job).then(
        ()=>{apiEngineer.do(job).then(
            ()=>{uiEngineer.do(job)}
        );}
    );
}