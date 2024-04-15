# Pre-Commit

tags: #git #hooks #c_sharp #bash #yaml

references:

https://mropengate.blogspot.com/2019/08/pre-commit-git-hooks_4.html

https://github.com/dnephin/pre-commit-golang

https://pre-commit.com/

https://ithelp.ithome.com.tw/articles/10244882



​	git hooks basic

​	https://ithelp.ithome.com.tw/articles/10224412

​	https://kaylumah.nl/2019/09/07/using-csharp-code-your-git-hooks.html

​	https://www.atlassian.com/git/tutorials/git-hooks

​	https://pre-commit.com/hooks.html

## 使用別人寫好的腳本

### Installation

安裝完python後 下`pip install pre-commit`

```powershell
C:\Users\rockefel>pip install pre-commit
Collecting pre-commit
  Downloading pre_commit-2.16.0-py2.py3-none-any.whl (191 kB)
     |████████████████████████████████| 191 kB 544 kB/s
Collecting toml
  Downloading toml-0.10.2-py2.py3-none-any.whl (16 kB)
Collecting pyyaml>=5.1
  Downloading PyYAML-6.0-cp310-cp310-win_amd64.whl (151 kB)
     |████████████████████████████████| 151 kB 1.3 MB/s
Collecting virtualenv>=20.0.8
  Downloading virtualenv-20.10.0-py2.py3-none-any.whl (5.6 MB)
     |████████████████████████████████| 5.6 MB 1.7 MB/s
Collecting nodeenv>=0.11.1
  Downloading nodeenv-1.6.0-py2.py3-none-any.whl (21 kB)
Collecting cfgv>=2.0.0
  Downloading cfgv-3.3.1-py2.py3-none-any.whl (7.3 kB)
Collecting identify>=1.0.0
  Downloading identify-2.4.0-py2.py3-none-any.whl (98 kB)
     |████████████████████████████████| 98 kB 786 kB/s
Collecting platformdirs<3,>=2
  Downloading platformdirs-2.4.0-py3-none-any.whl (14 kB)
Collecting six<2,>=1.9.0
  Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
Collecting backports.entry-points-selectable>=1.0.4
  Downloading backports.entry_points_selectable-1.1.1-py2.py3-none-any.whl (6.2 kB)
Collecting distlib<1,>=0.3.1
  Downloading distlib-0.3.4-py2.py3-none-any.whl (461 kB)
     |████████████████████████████████| 461 kB 1.6 MB/s
Collecting filelock<4,>=3.2
  Downloading filelock-3.4.0-py3-none-any.whl (9.8 kB)
Installing collected packages: six, platformdirs, filelock, distlib, backports.entry-points-selectable, virtualenv, toml, pyyaml, nodeenv, identify, cfgv, pre-commit
Successfully installed backports.entry-points-selectable-1.1.1 cfgv-3.3.1 distlib-0.3.4 filelock-3.4.0 identify-2.4.0 nodeenv-1.6.0 platformdirs-2.4.0 pre-commit-2.16.0 pyyaml-6.0 six-1.16.0 toml-0.10.2 virtualenv-20.10.0
WARNING: You are using pip version 21.2.4; however, version 21.3.1 is available.
You should consider upgrading via the 'C:\Users\rockefel\AppData\Local\Programs\Python\Python310\python.exe -m pip install --upgrade pip' command.
```

### yaml

在根目錄寫yaml `.pre-commit-config.yaml`

```yaml
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.3.0
    hooks:
    -   id: check-yaml
    -   id: end-of-file-fixer
    -   id: trailing-whitespace
-   repo: https://github.com/psf/black
    rev: 19.3b0
    hooks:
    -   id: black
```

在這邊指定要使用的遠端repo/版本號/要執行的腳本id



執行 `pre-commit install`

然後在.git/hooks/ 可以找到pre-commit



### golang 推薦

不是每個腳本都可以正常作用、也不是每個腳本都適合自己使用。

比如go fmt就有很多腳本既不幫修改也不給過。

在多方嘗試之後，整理了一些用起來比較順手的腳本如下

.pre-commit-config.yaml

```go
repos:
- repo: https://github.com/dnephin/pre-commit-golang
  rev: v0.4.0
  hooks:
    - id: go-vet
    - id: go-lint
    - id: go-mod-tidy
- repo: https://github.com/doublify/pre-commit-go
  rev: 208a4aaa7f86b44e961eaaea526743b920e187a0
  hooks:
    - id: fmt
- repo: https://github.com/syntaqx/git-hooks
  rev: v0.0.16
  hooks:
  - id: go-generate
- repo: https://github.com/golangci/golangci-lint
  rev: v1.42.1
  hooks:
    - id: golangci-lint
```

如果要更客製的東西，可以寫在go generate裡面就會被順便執行到了，或者也可以乾脆自己寫腳本。



## 自己寫腳本

這算是方法二，上面那些都不用做

在 .git/hooks/  新增 pre-commit 文件

並直接把腳本寫在裡面，第一行以註解的形式聲明使用的腳本語言



稍微以csx試寫了一下

```c#
#!/usr/bin/env dotnet-script
using System.Security.Cryptography;
using System.Reflection.Metadata;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Diagnostics;

Console.WriteLine("pre-commit hook");
Process cmd = new Process();
cmd.StartInfo.FileName = "cmd.exe";
cmd.StartInfo.RedirectStandardInput = true;
cmd.StartInfo.RedirectStandardOutput = true;
cmd.StartInfo.CreateNoWindow = true;
cmd.StartInfo.UseShellExecute = false;
cmd.Start();
string command = "go test ./...";
cmd.StandardInput.WriteLine(command);
cmd.StandardInput.Flush();
cmd.StandardInput.Close();
cmd.WaitForExit();
Console.WriteLine(cmd.ExitCode);
Console.WriteLine(cmd.StandardOutput.ReadToEnd());
```



又花了點時間把它改得更完整了

```C#
#!/usr/bin/env dotnet-script
using System;
using System.Collections.Generic;
using System.Diagnostics;

Console.WriteLine("pre-commit hook");
Command command = new Command();
command.AddCommandWithoutCheck("go fmt", "go fmt ./...");
command.AddCommandWithoutCheck("go fmt", "git add .");
command.AddCommand("go test", "go test ./... -count 1");
command.AddCommand("golint", "golint -set_exit_status ./...");
command.AddCommand("go vet", "go vet ./...");
command.ListExecute();
command.Finish();

public class Command
{
    private int checkExitCode;
    private List<CommandStruct> listCommands;
    public Command()
    {
        checkExitCode = 0;
        listCommands = new List<CommandStruct>();
    }

    private struct CommandStruct
    {
        internal string symbol;
        internal string command;
        internal bool check;
    }

    /// <summary>
    /// 新增指令到List中，這個指令會被執行且確認
    /// </summary>
    /// <param name="symbol">標示</param>
    /// <param name="command">指令內容</param>
    public void AddCommand(string symbol, string command) => listCommands.Add(new CommandStruct() { symbol = symbol, command = command,check = true });

    /// <summary>
    /// 新增指令到List中，這個指令會被執行，但不會進行確認
    /// </summary>
    /// <param name="symbol">標示</param>
    /// <param name="command">指令內容</param>
    public void AddCommandWithoutCheck(string symbol, string command) => listCommands.Add(new CommandStruct() { symbol = symbol, command= command, check = false });

    /// <summary>
    /// 執行所有存在List中的Command，結束時需要呼叫Finish()
    /// </summary>
    public void ListExecute()
    {
        string result = "pre-commit result:";
        foreach(CommandStruct cs in listCommands)
        {
            Process cmd = new Process();
            cmd.StartInfo.FileName = "powershell.exe";
            cmd.StartInfo.RedirectStandardInput = true;
            cmd.StartInfo.RedirectStandardOutput = true;
            cmd.StartInfo.CreateNoWindow = true;
            cmd.StartInfo.UseShellExecute = false;
            cmd.Start();
            string command = cs.command;
            cmd.StandardInput.WriteLine(command);
            cmd.StandardInput.Flush();
            cmd.StandardInput.Close();
            cmd.WaitForExit();
            if (!cs.check)
                continue;
            checkExitCode += cmd.ExitCode;
            if (cmd.ExitCode == 0)
                result += $"\r\n{cs.symbol}: Pass";
            else
                result += $"\r\n{cs.symbol}: Fail";
        }
        Console.WriteLine(result);
    }


    /// <summary>
    /// 這個指令會被執行且確認，結束時需要呼叫Finish()
    /// </summary>
    /// <param name="excuteCommand"></param>
    public void Execute(string excuteCommand)
    {
        Process cmd = new Process();
        cmd.StartInfo.FileName = "powershell.exe";
        cmd.StartInfo.RedirectStandardInput = true;
        cmd.StartInfo.RedirectStandardOutput = false;
        cmd.StartInfo.CreateNoWindow = true;
        cmd.StartInfo.UseShellExecute = false;
        cmd.Start();
        string command = excuteCommand;
        cmd.StandardInput.WriteLine(command);
        cmd.StandardInput.Flush();
        cmd.StandardInput.Close();
        cmd.WaitForExit();
        checkExitCode += cmd.ExitCode;
        if (cmd.ExitCode == 0)
            Console.WriteLine("Pass");
        else
            Console.WriteLine("Fail");
    }

    /// <summary>
    /// 這個指令會被執行，但不會進行確認，結束時需要呼叫Finish()
    /// </summary>
    /// <param name="excuteCommand"></param>
    public void ExecuteWithoutCheck(string excuteCommand)
    {
        Process cmd = new Process();
        cmd.StartInfo.FileName = "cmd.exe";
        cmd.StartInfo.RedirectStandardInput = true;
        cmd.StartInfo.RedirectStandardOutput = false;
        cmd.StartInfo.CreateNoWindow = true;
        cmd.StartInfo.UseShellExecute = false;
        cmd.Start();
        string command = excuteCommand;
        cmd.StandardInput.WriteLine(command);
        cmd.StandardInput.Flush();
        cmd.StandardInput.Close();
        cmd.WaitForExit();
    }

    /// <summary>
    /// 當結束時呼叫
    /// </summary>
    public void Finish()
    {
        int exitCode = checkExitCode == 0 ? 0 : 1;
        Environment.Exit(exitCode);
    }
}
```

執行起來像這樣子

```shell
rockefel@DESKTOP-4RCB60P MINGW64 /d/Rockefeller/Projects/mcom (pre-commit-test)
$ git commit -m "test: should Fail" --allow-empty
pre-commit hook
pre-commit result:
go test: Fail
golint: Fail
go vet: Pass
```



又改了一下，改成從yaml讀取要執行的內容，並且把錯誤的部分印出來

```C#
#!/usr/bin/env dotnet-script
tags: #r "nuget: YamlDotNet, 11.2.1"
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using YamlDotNet;

Console.WriteLine("pre-commit hook");
Command command = new Command();
StreamReader streamReader = new StreamReader(@"precommit.yaml");
string str = streamReader.ReadToEnd();
streamReader.Close();
YamlDotNet.Serialization.IDeserializer deSerializer = new YamlDotNet.Serialization.DeserializerBuilder().Build();
List<CommandStruct> res = deSerializer.Deserialize<List<CommandStruct>>(str);
command.AddCommandStructs(res);

command.ListExecute();
command.Finish();

public struct CommandStruct
{
    public string symbol;
    public string command;
    public bool check;
}

public class Command
{
    private int checkExitCode;
    private readonly List<CommandStruct> listCommands;
    public Command()
    {
        checkExitCode = 0;
        listCommands = new List<CommandStruct>();
    }

    /// <summary>
    /// 新增指令到List中，這個指令會被執行且確認
    /// </summary>
    /// <param name="symbol">標示</param>
    /// <param name="command">指令內容</param>
    public void AddCommand(string symbol, string command) => listCommands.Add(new CommandStruct() { symbol = symbol, command = command,check = true });

    /// <summary>
    /// 給外部指定使用
    /// </summary>
    /// <param name="commandStructs"></param>
    public void AddCommandStructs(List<CommandStruct> commandStructs) => listCommands.AddRange(commandStructs);

    /// <summary>
    /// 新增指令到List中，這個指令會被執行，但不會進行確認
    /// </summary>
    /// <param name="symbol">標示</param>
    /// <param name="command">指令內容</param>
    public void AddCommandWithoutCheck(string symbol, string command) => listCommands.Add(new CommandStruct() { symbol = symbol, command= command, check = false });

    /// <summary>
    /// 執行所有存在List中的Command，結束時需要呼叫Finish()
    /// </summary>
    public void ListExecute()
    {
        string result = "pre-commit result:";
        foreach(CommandStruct cs in listCommands)
        {
            Process cmd = new Process();
            cmd.StartInfo.FileName = "powershell.exe";
            cmd.StartInfo.RedirectStandardInput = true;
            cmd.StartInfo.RedirectStandardOutput = true;
            cmd.StartInfo.CreateNoWindow = true;
            cmd.StartInfo.UseShellExecute = false;
            cmd.Start();
            string command = cs.command;
            cmd.StandardInput.WriteLine(command);
            cmd.StandardInput.Flush();
            cmd.StandardInput.Close();
            cmd.WaitForExit();
            if (!cs.check)
                continue;
            checkExitCode += cmd.ExitCode;
            if (cmd.ExitCode == 0)
                result += $"\r\n{cs.symbol}: Pass";
            else
            {
                result += $"\r\n{cs.symbol}: Fail";
                Console.WriteLine(cmd.StandardOutput.ReadToEnd());
            }
        }
        Console.WriteLine(result);
    }


    /// <summary>
    /// 這個指令會被執行且確認，結束時需要呼叫Finish()
    /// </summary>
    /// <param name="excuteCommand"></param>
    public void Execute(string excuteCommand)
    {
        Process cmd = new Process();
        cmd.StartInfo.FileName = "powershell.exe";
        cmd.StartInfo.RedirectStandardInput = true;
        cmd.StartInfo.RedirectStandardOutput = false;
        cmd.StartInfo.CreateNoWindow = true;
        cmd.StartInfo.UseShellExecute = false;
        cmd.Start();
        string command = excuteCommand;
        cmd.StandardInput.WriteLine(command);
        cmd.StandardInput.Flush();
        cmd.StandardInput.Close();
        cmd.WaitForExit();
        checkExitCode += cmd.ExitCode;
        if (cmd.ExitCode == 0)
            Console.WriteLine("Pass");
        else
            Console.WriteLine("Fail");
    }

    /// <summary>
    /// 這個指令會被執行，但不會進行確認，結束時需要呼叫Finish()
    /// </summary>
    /// <param name="excuteCommand"></param>
    public void ExecuteWithoutCheck(string excuteCommand)
    {
        Process cmd = new Process();
        cmd.StartInfo.FileName = "cmd.exe";
        cmd.StartInfo.RedirectStandardInput = true;
        cmd.StartInfo.RedirectStandardOutput = false;
        cmd.StartInfo.CreateNoWindow = true;
        cmd.StartInfo.UseShellExecute = false;
        cmd.Start();
        string command = excuteCommand;
        cmd.StandardInput.WriteLine(command);
        cmd.StandardInput.Flush();
        cmd.StandardInput.Close();
        cmd.WaitForExit();
    }

    /// <summary>
    /// 當結束時呼叫
    /// </summary>
    public void Finish()
    {
        int exitCode = checkExitCode == 0 ? 0 : 1;
        Environment.Exit(exitCode);
    }
}
```



測試 

yaml檔長這樣

```yaml
- symbol: go fmt
  command: go fmt ./...
  check: false
- symbol: go fmt
  command: git add .
  check: false
- symbol: go test
  command: go test ./... -count 1
  check: true
- symbol: golint
  command: golint -set_exit_status ./...
  check: true
- symbol: go vet
  command: go vet ./...
  check: true
```

執行起來像這樣，Fail的部分會被印出來

```powershell
rockefel@DESKTOP-4RCB60P MINGW64 /d/Rockefeller/Projects/mcom (pre-commit-test)
$ git commit -m "test: should Fail" --allow-empty
pre-commit hook
Windows PowerShell
Copyright (C) Microsoft Corporation. µۧ@Åv©Ҧ³¡A¨ëO¯d¤@¤ÁÅv§Q¡C

½йÁ¸շsªº¸󥭥x PowerShell https://aka.ms/pscore6

PS D:\Rockefeller\Projects\mcom> go test ./... -count 1
ok      gitlab.kenda.com.tw/kenda/mcom  1.084s
?       gitlab.kenda.com.tw/kenda/mcom/cmd/mockgenerator        [no test files]
?       gitlab.kenda.com.tw/kenda/mcom/cmd/sync-table-schema    [no test files]
ok      gitlab.kenda.com.tw/kenda/mcom/errors   0.341s
--- FAIL: Test_CouldNotPAss (0.00s)
    code_test.go:235:
                Error Trace:    code_test.go:235
                Error:          Should be true
                Test:           Test_CouldNotPAss
FAIL
FAIL    gitlab.kenda.com.tw/kenda/mcom/impl     46.068s
ok      gitlab.kenda.com.tw/kenda/mcom/impl/orm/models  1.441s
ok      gitlab.kenda.com.tw/kenda/mcom/impl/pda 0.760s
?       gitlab.kenda.com.tw/kenda/mcom/mock     [no test files]
?       gitlab.kenda.com.tw/kenda/mcom/utils/resources  [no test files]
?       gitlab.kenda.com.tw/kenda/mcom/utils/roles      [no test files]
?       gitlab.kenda.com.tw/kenda/mcom/utils/sites      [no test files]
?       gitlab.kenda.com.tw/kenda/mcom/utils/stations   [no test files]
ok      gitlab.kenda.com.tw/kenda/mcom/utils/types      0.454s
FAIL
PS D:\Rockefeller\Projects\mcom>
Windows PowerShell
Copyright (C) Microsoft Corporation. µۧ@Åv©Ҧ³¡A¨ëO¯d¤@¤ÁÅv§Q¡C

½йÁ¸շsªº¸󥭥x PowerShell https://aka.ms/pscore6

PS D:\Rockefeller\Projects\mcom> golint -set_exit_status ./...
cmd\mockgenerator\main.go:338:2: comment on exported const DISO should be of the form "DISO ..."
cmd\mockgenerator\main.go:340:2: comment on exported const DIMO should be of the form "DIMO ..."
cmd\mockgenerator\main.go:342:2: comment on exported const TISO should be of the form "TISO ..."
cmd\mockgenerator\main.go:344:2: comment on exported const TIMO should be of the form "TIMO ..."
cmd\mockgenerator\main.go:346:2: comment on exported const SISO should be of the form "SISO ..."
cmd\mockgenerator\main.go:348:2: comment on exported const SIMO should be of the form "SIMO ..."
cmd\mockgenerator\main.go:350:2: exported const NotSupported should have comment (or a comment on this block) or be unexported
impl\impl.go:8:2: a blank import should be only in a main or test package, or have a comment justifying it
impl\impl.go:264:77: exported method BeginTx returns unexported type *impl.txDataManager, which can be annoying to use
PS D:\Rockefeller\Projects\mcom>
pre-commit result:
go test: Fail
golint: Fail
go vet: Pass
```



## 同時使用兩種方法

意外發現的，只要把自己寫的腳本命名為 pre-commit.legacy就可以同時使用.pre-commit-config.yaml的hooks了。



## 疑難雜症

### 不管有沒有出錯，ExitCode總是抓到0

可能還真的是0，例如golint，參考[這個issue](https://github.com/golang/lint/issues/65)

```powershell
PS D:\Rockefeller\Projects\mcom> golint ./...
cmd\mockgenerator\main.go:338:2: comment on exported const DISO should be of the form "DISO ..."
cmd\mockgenerator\main.go:340:2: comment on exported const DIMO should be of the form "DIMO ..."
cmd\mockgenerator\main.go:342:2: comment on exported const TISO should be of the form "TISO ..."
cmd\mockgenerator\main.go:344:2: comment on exported const TIMO should be of the form "TIMO ..."
cmd\mockgenerator\main.go:346:2: comment on exported const SISO should be of the form "SISO ..."
cmd\mockgenerator\main.go:348:2: comment on exported const SIMO should be of the form "SIMO ..."
cmd\mockgenerator\main.go:350:2: exported const NotSupported should have comment (or a comment on this block) or be unexported
impl\impl.go:8:2: a blank import should be only in a main or test package, or have a comment justifying it
impl\impl.go:264:77: exported method BeginTx returns unexported type *impl.txDataManager, which can be annoying to use
PS D:\Rockefeller\Projects\mcom> $LASTEXITCODE
0
```

幸好官方後來有提供flag讓人知道到底有沒有lint錯誤

```powershell
PS D:\Rockefeller\Projects\mcom> golint -h
Usage of C:\Users\rockefel\go\bin\golint.exe:
        golint [flags] # runs on package in current directory
        golint [flags] [packages]
        golint [flags] [directories] # where a '/...' suffix includes all sub-directories
        golint [flags] [files] # all must belong to a single package
Flags:
  -min_confidence float
        minimum confidence of a problem to print it (default 0.8)
  -set_exit_status
        set exit status to 1 if any issues are found
```

再試一次

```powershell
PS D:\Rockefeller\Projects\mcom> golint -set_exit_status ./...
cmd\mockgenerator\main.go:338:2: comment on exported const DISO should be of the form "DISO ..."
cmd\mockgenerator\main.go:340:2: comment on exported const DIMO should be of the form "DIMO ..."
cmd\mockgenerator\main.go:342:2: comment on exported const TISO should be of the form "TISO ..."
cmd\mockgenerator\main.go:344:2: comment on exported const TIMO should be of the form "TIMO ..."
cmd\mockgenerator\main.go:346:2: comment on exported const SISO should be of the form "SISO ..."
cmd\mockgenerator\main.go:348:2: comment on exported const SIMO should be of the form "SIMO ..."
cmd\mockgenerator\main.go:350:2: exported const NotSupported should have comment (or a comment on this block) or be unexported
impl\impl.go:8:2: a blank import should be only in a main or test package, or have a comment justifying it
impl\impl.go:264:77: exported method BeginTx returns unexported type *impl.txDataManager, which can be annoying to use
Found 9 lint suggestions; failing.
PS D:\Rockefeller\Projects\mcom> $LASTEXITCODE
1
```





或者腳本寫錯

```C#
    public void Execute(string excuteCommand)
    {
        Process cmd = new Process();
        cmd.StartInfo.FileName = "cmd.exe";
        cmd.StartInfo.RedirectStandardInput = true;
        cmd.StartInfo.RedirectStandardOutput = true;
        cmd.StartInfo.CreateNoWindow = true;
        cmd.StartInfo.UseShellExecute = false;
        cmd.Start();
        string command = excuteCommand;
        cmd.StandardInput.WriteLine(command);
        cmd.StandardInput.Flush();
        cmd.StandardInput.Close();
        cmd.WaitForExit();
        checkExitCode += cmd.ExitCode;
        Console.WriteLine(cmd.StandardOutput.ReadToEnd());
        if (cmd.ExitCode == 0)
            Console.WriteLine("Pass");
        else
            Console.WriteLine("Fail");
    }
```

用"Process.ExitCode is always 0"丟Google可以查到很多資訊，但很不幸的幾乎都沒有作用

後來隨手改用powershell執行看看，就可以正常拿到exitCode了，都cmd在雷

```C#
    public void Execute(string excuteCommand)
    {
        Process cmd = new Process();
        cmd.StartInfo.FileName = "powershell.exe";
        cmd.StartInfo.RedirectStandardInput = true;
        cmd.StartInfo.RedirectStandardOutput = false; // 這邊有改是因為後來還是覺得即時顯示比較合適，不影響這執行結果
        cmd.StartInfo.CreateNoWindow = true;
        cmd.StartInfo.UseShellExecute = false;
        cmd.Start();
        string command = excuteCommand;
        cmd.StandardInput.WriteLine(command);
        cmd.StandardInput.Flush();
        cmd.StandardInput.Close();
        cmd.WaitForExit();
        checkExitCode += cmd.ExitCode;
        if (cmd.ExitCode == 0)
            Console.WriteLine("Pass");
        else
            Console.WriteLine("Fail");
    }
```



### (no files to check)Skipped

參考 https://stackoverflow.com/questions/54697699/how-to-propertly-configure-my-pre-commit-and-pre-push-hooks

目前看來比較合理的原因就是commit 的目標中不含指定類型的檔案 ，試著修改原始碼後再commit通常可以解決

```powershell
rockefel@DESKTOP-4RCB60P MINGW64 /d/Rockefeller/Projects/mcom (pre-commit-test)
$ git add .

rockefel@DESKTOP-4RCB60P MINGW64 /d/Rockefeller/Projects/mcom (pre-commit-test)
$ git commit -m "test"
go fmt...................................................................Failed
- hook id: go-fmt
- exit code: 1

tee: /dev/fd/5: No such file or directory

go vet...................................................................Passed
go lint..................................................................Passed

rockefel@DESKTOP-4RCB60P MINGW64 /d/Rockefeller/Projects/mcom (pre-commit-test)
$ git commit -m "test" --allow-empty
[WARNING] Unstaged files detected.
[INFO] Stashing unstaged files to C:\Users\rockefel\.cache\pre-commit\patch1639367848-14048.
go fmt...................................................................Failed
- hook id: go-fmt
- exit code: 1

tee: /dev/fd/5: No such file or directory

go vet...................................................................Passed
go lint..................................................................Passed
[INFO] Restored changes from C:\Users\rockefel\.cache\pre-commit\patch1639367848-14048.

rockefel@DESKTOP-4RCB60P MINGW64 /d/Rockefeller/Projects/mcom (pre-commit-test)
$ git add .

rockefel@DESKTOP-4RCB60P MINGW64 /d/Rockefeller/Projects/mcom (pre-commit-test)
$ git commit -m "test" --allow-empty
go fmt...............................................(no files to check)Skipped
go vet...............................................(no files to check)Skipped
go lint..............................................(no files to check)Skipped
[pre-commit-test c3e2ff5] test
```

