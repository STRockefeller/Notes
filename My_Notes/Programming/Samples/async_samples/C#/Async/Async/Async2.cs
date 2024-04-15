using System.Threading.Tasks;

namespace Async
{
    partial class Program
    {
        static async void Async2()
        {
            var job = new Job(3, 1, 2);
            var dbEngineer = new DBEngineer();
            var apiEngineer = new APIEngineer();
            var uiEngineer = new UIEngineer();
            Task task1 = dbEngineer.DoAsync(job);
            Task task3 = uiEngineer.DoAsync(job);

            await task1;
            Task task2 = apiEngineer.DoAsync(job);
            await Task.WhenAll(task2, task3);
        }
    }
}