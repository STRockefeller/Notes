using System.Threading.Tasks;

namespace Async
{
    partial class Program
    {
        static async void Async1()
        {
            var job = new Job(3, 1, 2);
            var dbEngineer = new DBEngineer();
            var apiEngineer = new APIEngineer();
            var uiEngineer = new UIEngineer();
            Task task1 = dbEngineer.DoAsync(job);
            Task task2 = apiEngineer.DoAsync(job);
            Task task3 = uiEngineer.DoAsync(job);
            await Task.WhenAll(task1, task2, task3);
        }
    }
}