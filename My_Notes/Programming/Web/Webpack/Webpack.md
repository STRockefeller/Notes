# Webpack

references:

https://webpack.js.org/concepts/

[1. Webpack 初學者教學課程 Part1 · Webpack Tutorial 繁體中文](https://neighborhood999.github.io/webpack-tutorial-gitbook/Part1/)

[關於 Webpack，它是什麼？能夠做什麼？為什麼？怎麼做？— freeCodeCamp 的筆記 - Askie&#39;s Coding Life](https://askie.today/what-is-webpack/)

## Abstract

用了這東西也有好幾次了，但都沒有真的花時間好好了解它。趁現在來補個票。

## Concepts

### Modules

> In [modular programming](https://en.wikipedia.org/wiki/Modular_programming), developers break programs up into discrete chunks of functionality called a *module*.
> 
> Each module has a smaller surface area than a full program, making verification, debugging, and testing trivial. Well-written *modules* provide solid abstractions and encapsulation boundaries, so that each module has a coherent design and a clear purpose within the overall application.

> In contrast to [Node.js modules](https://nodejs.org/api/modules.html), webpack *modules* can express their *dependencies* in a variety of ways. A few examples are:
> 
> - An [ES2015 `import`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import) statement
> - A [CommonJS](http://www.commonjs.org/specs/modules/1.0/) `require()` statement
> - An [AMD](https://github.com/amdjs/amdjs-api/blob/master/AMD.md) `define` and `require` statement
> - An [`@import` statement](https://developer.mozilla.org/en-US/docs/Web/CSS/@import) inside of a css/sass/less file.
> - An image url in a stylesheet `url(...)` or HTML `<img src=...>` file.

簡單來說，我們把功能細分成多個module後，可以透過webpack幫我們管理依賴。

以下是一些webpack支援的module types

> Webpack supports the following module types natively:
> 
> - [ECMAScript modules](https://webpack.js.org/guides/ecma-script-modules)
> - CommonJS modules
> - AMD modules
> - [Assets](https://webpack.js.org/guides/asset-modules)
> - WebAssembly modules
> 
> In addition to that webpack supports modules written in a variety of languages and preprocessors via *loaders*. *Loaders* describe to webpack **how** to process non-native *modules* and include these *dependencies* into your *bundles*. The webpack community has built *loaders* for a wide variety of popular languages and language processors, including:
> 
> - [CoffeeScript](http://coffeescript.org/)
> - [TypeScript](https://www.typescriptlang.org/)
> - [ESNext (Babel)](https://babeljs.io/)
> - [Sass](http://sass-lang.com/)
> - [Less](http://lesscss.org/)
> - [Stylus](http://stylus-lang.com/)
> - [Elm](https://elm-lang.org/)
> 
> And many others! Overall, webpack provides a powerful and rich API for customization that allows one to use webpack for **any stack**, while staying **non-opinionated** about your development, testing, and production workflows.
> 
> For a full list, see [**the list of loaders**](https://webpack.js.org/loaders) or [**write your own**](https://webpack.js.org/api/loaders).

## Entry

> An **entry point** indicates which module webpack should use to begin building out its internal [dependency graph](https://webpack.js.org/concepts/dependency-graph/). Webpack will figure out which other modules and libraries that entry point depends on (directly and indirectly).
> 
> By default its value is `./src/index.js`, but you can specify a different (or multiple) entry points by setting an [`entry` property in the webpack configuration](https://webpack.js.org/configuration/entry-context/#entry). For example:
> 
> **webpack.config.js**
> 
> ```js
> module.exports = {
>   entry: './path/to/my/entry/file.js',
> };
> ```

設置打包的起始點，可以多筆。

## Output

> The **output** property tells webpack where to emit the *bundles* it creates and how to name these files. It defaults to `./dist/main.js` for the main output file and to the `./dist` folder for any other generated file.
> 
> You can configure this part of the process by specifying an `output` field in your configuration:
> 
> **webpack.config.js**
> 
> ```
> const path = require('path');
> 
> module.exports = {
>   entry: './path/to/my/entry/file.js',
>   output: {
>     path: path.resolve(__dirname, 'dist'),
>     filename: 'my-first-webpack.bundle.js',
>   },
> };
> ```
> 
> In the example above, we use the `output.filename` and the `output.path` properties to tell webpack the name of our bundle and where we want it to be emitted to. In case you're wondering about the path module being imported at the top, it is a core [Node.js module](https://nodejs.org/api/modules.html) that gets used to manipulate file paths.

輸出路徑。

## Loaders

> Out of the box, webpack only understands JavaScript and JSON files. **Loaders** allow webpack to process other types of files and convert them into valid [modules](https://webpack.js.org/concepts/modules) that can be consumed by your application and added to the dependency graph.

> At a high level, **loaders** have two properties in your webpack configuration:
> 
> 1. The `test` property identifies which file or files should be transformed.
> 2. The `use` property indicates which loader should be used to do the transforming.
> 
> **webpack.config.js**
> 
> ```
> const path = require('path');
> 
> module.exports = {
>   output: {
>     filename: 'my-first-webpack.bundle.js',
>   },
>   module: {
>     rules: [{ test: /\.txt$/, use: 'raw-loader' }],
>   },
> };
> ```
> 
> The configuration above has defined a `rules` property for a single module with two required properties: `test` and `use`. This tells webpack's compiler the following:

簡單來說，除了js和json以外的檔案，都需要有對應的loader才能讓webpack解析。

## Plugins

> While loaders are used to transform certain types of modules, plugins can be leveraged to perform a wider range of tasks like bundle optimization, asset management and injection of environment variables.

> In order to use a plugin, you need to `require()` it and add it to the `plugins` array. Most plugins are customizable through options. Since you can use a plugin multiple times in a configuration for different purposes, you need to create an instance of it by calling it with the `new` operator.
> 
> **webpack.config.js**
> 
> ```
> const HtmlWebpackPlugin = require('html-webpack-plugin');
> const webpack = require('webpack'); //to access built-in plugins
> 
> module.exports = {
>   module: {
>     rules: [{ test: /\.txt$/, use: 'raw-loader' }],
>   },
>   plugins: [new HtmlWebpackPlugin({ template: './src/index.html' })],
> };
> ```
> 
> In the example above, the `html-webpack-plugin` generates an HTML file for your application and automatically injects all your generated bundles into this file.

> Using plugins in your webpack configuration is straightforward. However, there are many use cases that are worth further exploration. [Learn more about them here](https://webpack.js.org/concepts/plugins).

找不到想要的功能?那就去找找有沒有合適的plugin吧。

## Mode

> By setting the `mode` parameter to either `development`, `production` or `none`, you can enable webpack's built-in optimizations that correspond to each environment. The default value is `production`.
> 
> ```
> module.exports = {
>   mode: 'production',
> };
> ```
> 
> Learn more about the [mode configuration here](https://webpack.js.org/configuration/mode) and what optimizations take place on each value.

BJ4
