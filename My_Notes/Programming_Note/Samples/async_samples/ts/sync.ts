function sync(): void {
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

class Job {
    db:number;
    api:number;
    ui:number;
    constructor(db:number, api:number, ui:number){
        this.db = db;
        this.api = api;
        this.ui = ui;
    }
}

interface IEngineer {
    do(job: Job): void;
}

class DBEngineer implements IEngineer {
    async do(job:Job){
        console.log("db task start")
        await new Promise(f => setTimeout(f, 1000 * job.db));
        console.log("db task complete")
    }
}

class APIEngineer implements IEngineer {
    async do(job:Job){
        console.log("api task start")
        await new Promise(f => setTimeout(f, 1000 * job.api));
        console.log("api task complete")
    }
}

class UIEngineer implements IEngineer {
    async do(job:Job){
        console.log("ui task start")
        await new Promise(f => setTimeout(f, 1000 * job.ui));
        console.log("ui task complete")
    }
}