using System.Threading.Tasks;
using System;

namespace Async
{
    partial class Program
    {
        static void EventQueueSample()
        {
            var Task1 = Task.Run(() =>
            {
                Console.WriteLine("<1> start");
                DateTime end = DateTime.Now.AddSeconds(2);
                while (DateTime.Now < end) { }
                Console.WriteLine("<1> end");
            });
            var Task2 = Func2Async();
            Task.WaitAll(Task1, Task2);
        }
        static async Task Func2Async()
        {
            Console.WriteLine("<2> start");
            await Func3Async();
            Console.WriteLine("<2> end");
        }

        static async Task Func3Async()
        {
            Console.WriteLine("<3> start");
            DateTime end = DateTime.Now.AddSeconds(2);
            while (DateTime.Now < end) { }
            Console.WriteLine("<3> end");
        }
    }
}