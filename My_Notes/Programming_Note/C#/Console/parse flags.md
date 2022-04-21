# Parse Flags

方法大概可以分成三種

官方套件 https://github.com/dotnet/command-line-api

傳統方式 https://makolyte.com/csharp-parsing-commands-and-arguments-in-a-console-app/

其他第三方套件



官方套件有點搞不懂用法，以後再補

傳統方式就還滿單純的，剛好有應用到就先記下來了

```C#
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace LogParser
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            switch (args[0])
            {
                case "-h":
                case "--h":
                    Console.WriteLine("use \"-p\" or \"--path\" to specify the log file path.");
                    return;

                case "-p":
                case "--path":
                    break;

                default:
                    Console.WriteLine("missing path parameter");
                    return;
            }

            string path = args[1];
            StreamReader reader = new(path);
            string contents = reader.ReadToEnd();
            reader.Close();

            List<string> lines = new(contents.Split('\n'));
            List<string> outPutLines = lines.Where(str => str.Contains("ERROR")).ToList();

            string outputFilePath = @".\log_parser_output.log";
            FileStream fs = new(outputFilePath, FileMode.Create);
            fs.Close();

            using StreamWriter sw = new(outputFilePath);
            foreach (string line in outPutLines)
                sw.WriteLine(line);
        }
    }
}

```

實際上應該還要處理`-f`但沒給後面參數情況之類的，不過想想跳例外好像也沒差就不想管了。



第三方套件也是以後有用到好用的再回來補充。

