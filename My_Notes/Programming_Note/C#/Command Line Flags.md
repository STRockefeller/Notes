# Command Line Flags

先排除argv的寫法~~，你以為再寫C language嗎~~，這篇筆記主要紀錄使用套件的寫法。

https://stackoverflow.com/questions/491595/best-way-to-parse-command-line-arguments-in-c



## GoFlag

https://github.com/mikeruhl/Goflag

想在C#使用Go package嗎? 沒有問題

老實說這東西還包含generic，實際上應該比在golang時還要好用。



## NDesk.Option

雖然有不少人推薦，不過已經沒有在維護了。

![](https://i.imgur.com/PIqj9V2.png)



## Mono.Options

https://github.com/xamarin/XamarinComponents/tree/main/XPlat/Mono.Options

![](https://i.imgur.com/jOrHlkl.png)



### Getting Started

Lots more information is available in the [Getting Started Guide](https://github.com/xamarin/XamarinComponents/blob/main/XPlat/Mono.Options/GettingStarted.md), but some of the quick start information can be found here or in the [Details Guide](https://github.com/xamarin/XamarinComponents/blob/main/XPlat/Mono.Options/Details.md).

There are a few steps to get everything in place. First, we need to set up the options expected:

```C#
// these variables will be set when the command line is parsed
var verbosity = 0;
var shouldShowHelp = false;
var names = new List<string> ();
var repeat = 1;
// these are the available options, note that they set the variables
var options = new OptionSet { 
    { "n|name=", "the name of someone to greet.", n => names.Add (n) }, 
    { "r|repeat=", "the number of times to repeat the greeting.", (int r) => repeat = r }, 
    { "v", "increase debug message verbosity", v => { if (v != null) ++verbosity; } }, 
    { "h|help", "show this message and exit", h => shouldShowHelp = h != null },
};
```

Then, in the `static void Main (string[] args)` method, we can parse the incoming arguments and get a list of any extras:

```C#
List<string> extra;
try {
    // parse the command line
    extra = options.Parse (args);
} catch (OptionException e) {
    // output some error message
    Console.Write ("greet: ");
    Console.WriteLine (e.Message);
    Console.WriteLine ("Try `greet --help' for more information.");
    return;
}
```

This will read in the arguments from the command line and set the variables. For example, if the command line is:

```
> greet.exe -n Matthew Welcome to Xamarin {0}!
```

Then, the variables will be processed and result in:

```C#
verbosity      == 0
shouldShowHelp == false
names          == ["Matthew"]
repeat         == 1
extras         == ["Welcome to Xamarin {0}!"]
```