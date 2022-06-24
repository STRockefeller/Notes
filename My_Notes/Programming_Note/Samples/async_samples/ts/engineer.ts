import "./job"

export interface IEngineer {
    do(job: Job): void;
}

export class DBEngineer implements IEngineer {
    async do(job:Job){
        console.log("db task start")
        await new Promise(f => setTimeout(f, 1000 * job.db));
        console.log("db task complete")
    }
}

export class APIEngineer implements IEngineer {
    async do(job:Job){
        console.log("api task start")
        await new Promise(f => setTimeout(f, 1000 * job.api));
        console.log("api task complete")
    }
}

export class UIEngineer implements IEngineer {
    async do(job:Job){
        console.log("ui task start")
        await new Promise(f => setTimeout(f, 1000 * job.ui));
        console.log("ui task complete")
    }
}