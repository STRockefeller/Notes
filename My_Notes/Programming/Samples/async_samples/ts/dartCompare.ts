export function eventQueueSample() {
  var fAsync = async (): Promise<void> => {
    console.log("<1> start");
    const end: Date = new Date();
    end.setSeconds(end.getSeconds() + 2);
    while (new Date() < end);
    console.log("<1> end");
  };
  fAsync();
  asyncFunction2();
}

async function asyncFunction2(): Promise<void> {
  console.log("<2> start");
  var f = async (): Promise<void> => {
    console.log("<3> start");
    const end: Date = new Date();
    end.setSeconds(end.getSeconds() + 2);
    while (new Date() < end);
    console.log("<3> end");
  };
  await f();
  console.log("<2> end");
}