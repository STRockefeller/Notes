namespace Async
{
    internal class Job
    {
        internal int db;
        internal int api;
        internal int ui;
        internal Job(int db, int api, int ui)
        {
            this.db = db;
            this.api = api;
            this.ui = ui;
        }
    }
}