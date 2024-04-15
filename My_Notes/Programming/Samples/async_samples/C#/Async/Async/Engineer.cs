using System;
using System.Threading.Tasks;
namespace Async
{
        internal interface IEngineer
    {
        void Do(Job job);
        Task DoAsync(Job job);
    }

    internal class DBEngineer : IEngineer
    {
        public void Do(Job job)
        {
            Console.WriteLine("db task start");
            Task.Delay(job.db * 1000).Wait();
            Console.WriteLine("db task complete");
        }

        async public Task DoAsync(Job job){
            Console.WriteLine("db task start");
            await Task.Delay(job.db * 1000);
            Console.WriteLine("db task complete");
        }
    }

    internal class APIEngineer : IEngineer
    {
        public void Do(Job job)
        {
            Console.WriteLine("api task start");
            Task.Delay(job.api * 1000).Wait();
            Console.WriteLine("api task complete");
        }
        async public Task DoAsync(Job job){
            Console.WriteLine("api task start");
            await Task.Delay(job.api * 1000);
            Console.WriteLine("api task complete");
        }
    }

    internal class UIEngineer : IEngineer
    {
        public void Do(Job job)
        {
            Console.WriteLine("ui task start");
            Task.Delay(job.ui * 1000).Wait();
            Console.WriteLine("ui task complete");
        }

         async public Task DoAsync(Job job){
            Console.WriteLine("ui task start");
            await Task.Delay(job.ui * 1000);
            Console.WriteLine("ui task complete");
        }
    }
}