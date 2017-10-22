---
title: Portal
category:
  - 笔记
date: 2017-10-22 17:19:19
tags: [webpack]
---
# Portal

公司项目,webpack开发+打包,包括css/template等部分的编译,以及开发调试,加上bower/npm发布,做一点写一点吧,差不多也该把公司的事情优先级调高一点了
大概是要做一个脚手架,然后在这个脚手架上面配置开发,其实我也不用搞的太通用,框架出来就好
<!--more-->

## quick start

这里是根据官网的`quick start`部分搭建的,最简单的webpack应用,跑起来没难度,只是实际项目中不可能这么简单就是咯
┑(￣Д ￣)┍

执行`npm init`命令初始化项目,之后`npm install --save-dev webpack webpack-dev-server`,安装基础环境

webpack项目的基本结构,大概是这样(来源于官网)

```txt
webpack-demo
|- package.json
|- webpack.config.js
|- /dist
  |- index.html
|- /src
  |- index.js
```

/src/index.js
src中包含了项目所有的源文件,理论上应该包括所有的css/js/html(template)

```js
import _ from 'lodash';

function component() {
  var element = document.createElement('div');

  // Lodash, now imported by this script
  element.innerHTML = _.join(['Hello', 'webpack'], ' ');

  return element;
}

document.body.appendChild(component());
```

dist/index.html
这个文件应该是这里调试用的,如果是template的话还是要打包在src里面,用webpack来compile


```html
<html>
  <head>
    <title>Getting Started</title>
  </head>
  <body>
    <script src="bundle.js"></script>
  </body>
</html>

```

webpack.config.js
webpack的配置文件,执行webpack命令时将会自动在当前路径下读取该文件,并按照配置进行compile及打包
这里使用quick start中的基础配置,只是配置了入口`entry`以及output`filename/path`

```js
const path = require('path');

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  }
};
```

package.json
npm配置文件,这里主要体现在scripts里面,dev是我自己配的,表示在dist路径下启动http-server,build则是代表调用webpack命令进行打包(需要运行`npm run build`,切无需全局安装webpack命令,会自动在当前路径的node_modules中运行)

```json
{
  "name": "portal",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "dev": "http-server ./dist/",
    "build": "webpack"
  },
  "repository": {
    "type": "git",
    "url": "git@gitee.com:sayonara.ldm/webpack.git"
  },
  "author": "liudongmeng",
  "license": "ISC",
  "devDependencies": {
    "http-server": "^0.10.0",
    "lodash": "^4.17.4",
    "webpack": "^3.8.1",
    "webpack-dev-server": "^2.9.3"
  }
}
```

以上执行`npm run build`就可以跑了,没什么问题,hello webpack
下一章往下写吧,把官网文档翻一翻

## Asset Management

### Setup

dist/index.html
tittle改一下,毕竟下一章

```html
<html>
  <head>
    <title>Asset Management</title>
  </head>
  <body>
    <script src="./bundle.js"></script>
  </body>
</html>
```

### Loading CSS

安装style-loader和css-loader,这里应该就是要compile样式/图片/字体等文件咯,大脚叫做编译,这个叫法我觉得不太合适,个人感觉tranlate更贴切吧,毕竟出来的不是机器码

```sh
npm install --save-dev style-loader css-loader
```

webpack.config.js
添加mudule:{rule:{...}}用于对应的样式文件打包

```js
const path = require('path');

module.exports = {
    entry: './src/index.js',
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'dist')
    },
    module: {
        rules: [
            {
                test: /\.css$/,
                use: [
                    'style-loader',
                    'css-loader'
                ]
            }
        ]
    }
};
```

src/style.css
添加style.css文件,并在index.js中通过require加载

```css
.hello {
  color: red;
}
```

src/index.js

```js
import _ from 'lodash';
import './style.css';

function component() {
  var element = document.createElement('div');

  // Lodash, now imported by this script
  element.innerHTML = _.join(['Hello', 'webpack'], ' ');
  element.classList.add('hello');

  return element;
}

document.body.appendChild(component());
```

运行`webpack`命令打包,之后访问index.html,`hello webpack`显示为红色,查看bundle.js文件可以发现css文件已经被打包并通过webpack加载

### Loading Images

图片打包使用`file-loader`

```sh
npm install --save-dev file-loader
```

webpack.config.js
添加mudule:{rule:{...}}用于对应的图像文件打包

```js
const path = require('path');

module.exports = {
    entry: './src/index.js',
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'dist')
    },
    module: {
        rules: [
            {
                test: /\.css$/,
                use: [
                    'style-loader',
                    'css-loader'
                ]
            },
            {
                test: /\.(png|svg|jpg|gif)$/,
                use: [
                    'file-loader'
                ]
            }
        ]
    }
};
```

/src/webpack.svg
放置对应的文件,在index.js中通过require引用,或是在css文件中使用url(...)的方式引用,webpack在打包时会自动处理文件的命名与引用

/src/index.js
import对应的文件,并在js代码中使用

```js
import _ from 'lodash';
import './style.css';
import Icon from './webpack.svg';

function component() {
  var element = document.createElement('div');

  // Lodash, now imported by this script
  element.innerHTML = _.join(['Hello', 'webpack'], ' ');
  element.classList.add('hello');
  // Add the image to our existing div.
  var myIcon = new Image();
  myIcon.src = Icon;

  element.appendChild(myIcon);

  return element;
}

document.body.appendChild(component());
```

/src/style.css
通过url('路径')的方式引用文件,打包时会自动更改文件命名,并引用

```css
.hello {
    color: blue;
    background: url('./webpack.svg');
  }
```

html-loader的用法类似,直接src='./webpack.svg'即可,但是没有用到,还不是很清楚html怎么打包,后面再说,这里不作处理,

webpack.config.js中配置添加image-webpack-loader听说是可以压缩大小?试了一下svg小了0.4k...可能是svg不好压缩吧

```js
{
                test: /\.(png|svg|jpg|gif)$/,
                use: [
                    'file-loader',
                    {
                        loader: 'image-webpack-loader',
                        options: {
                            bypassOnDebug: true,
                        },
                    },
                ]
            }
```

### Loading Fonts

字体的处理还是用file-loader

webpeck.config.js

```js
const path = require('path');

module.exports = {
    entry: './src/index.js',
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'dist')
    },
    module: {
        rules: [
            {
                test: /\.css$/,
                use: [
                    'style-loader',
                    'css-loader'
                ]
            },
            {
                test: /\.(png|svg|jpg|gif)$/,
                use: [
                    'file-loader',
                    {
                        loader: 'image-webpack-loader',
                        options: {
                            bypassOnDebug: true,
                        },
                    },
                ]
            },
            {
                test: /\.(html)$/,
                use: {
                    loader: 'html-loader',
                    options: {
                        attrs: [':data-src']
                    }
                }
            },
            {
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                use: [
                    'file-loader'
                ]
            }
        ]
    }
};
```

/src/my_font.woff2
这里没找到woff+woff2的配套文件,只在官网的source里面找到了个woff2,凑合看一下效果吧,这个东西也没啥难的

/src/style.css

```css
@font-face {
     font-family: 'MyFont';
     src:  url('./my_font.woff2') format('woff2');
     font-weight: 600;
     font-style: normal;
     }

.hello {
    color: gray;
    font-family: 'MyFont';
    background: url('./webpack.svg');
  }
```

重新打包后,刷新可以看到字体改变

### Loading Data

Another useful asset that can be loaded is data, like JSON files, CSVs, TSVs, and XML. Support for JSON is actually built-in, similar to NodeJS, meaning import Data from './data.json' will work by default. To import CSVs, TSVs, and XML you could use the csv-loader and xml-loader. Let's handle loading all three:
>可以通过loader加载数据,比如JSON文件,CSVs,TSVs,XML等.对于JSON文件的支持是内置的,意味着`import Data from './data.json'`默认不需要配置就可以生效.如果要import其他格式,可以使用`csv-loader`和`xml-loader`.

`npm install --save-dev csv-loader xml-loader`

webpack.config.js

```js
const path = require('path');

module.exports = {
    entry: './src/index.js',
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'dist')
    },
    module: {
        rules: [
            {
                test: /\.css$/,
                use: [
                    'style-loader',
                    'css-loader'
                ]
            },
            {
                test: /\.(png|svg|jpg|gif)$/,
                use: [
                    'file-loader',
                    {
                        loader: 'image-webpack-loader',
                        options: {
                            bypassOnDebug: true,
                        },
                    },
                ]
            },
            {
                test: /\.(html)$/,
                use: {
                    loader: 'html-loader',
                    options: {
                        attrs: [':data-src']
                    }
                }
            },
            {
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                use: [
                    'file-loader'
                ]
            },
            {
                test: /\.(csv|tsv)$/,
                use: [
                    'csv-loader'
                ]
            },
            {
                test: /\.xml$/,
                use: [
                    'xml-loader'
                ]
            }
        ]
    }
};
```

/src/data.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<note>
  <to>Mary</to>
  <from>John</from>
  <heading>Reminder</heading>
  <body>Call Cindy on Tuesday</body>
</note>
```

/src/index.js

```js
import _ from 'lodash';
import './style.css';
import Icon from './webpack.svg';
import Data from './data.xml';

function component() {
  var element = document.createElement('div');

  // Lodash, now imported by this script
  element.innerHTML = _.join(['Hello', 'webpack'], ' ');
  element.classList.add('hello');
  // Add the image to our existing div.
  var myIcon = new Image();
  myIcon.src = Icon;

  element.appendChild(myIcon);
  //输出Data查看import的结果
  console.log(Data);

  return element;
}

document.body.appendChild(component());
```

打包之后运行,console中会输出xml中的数据,表示导入成功

This can be especially helpful when implementing some sort of data visualization using a tool like d3. Instead of making an ajax request and parsing the data at runtime you can load it into your module during the build process so that the parsed data is ready to go as soon as the module hits the browser.
>这个功能在使用一些工具进行数据可视化工作时(比如D3)时尤其有用.你可以在build处理时在模块中加载数据,而不需要创建ajax请求并实时解析数据,因此解析过的数据加载会更快.(渣翻译,可能有误解,发现了再改)

### Global Assets

The coolest part of everything mentioned above, is that loading assets this way allows you to group modules and assets together in a more intuitive way. Instead of relying on a global /assets directory that contains everything, you can group assets with the code that uses them. For example, a structure like this can be very useful:
>上面提到的所有东西中最酷的部分是，通过这种方式加载资源，可以以更直观的方式将模块和资源组合在一起。您可以不依赖包含所有内容的全局/资源目录，而可以使用使用它们的代码对资源进行分组。例如，这样的结构是非常有用的：

```diff
- |- /assets
+ |– /components
+ |  |– /my-component
+ |  |  |– index.jsx
+ |  |  |– index.css
+ |  |  |– icon.svg
+ |  |  |– img.png
```

This setup makes your code a lot more portable as everything that is closely coupled now lives together. Let's say you want to use /my-component in another project, simply copy or move it into the /components directory over there. As long as you've installed any external dependencies and your configuration has the same loaders defined, you should be good to go.
>这种设置使您的代码更易于移植，因为所有紧密耦合的程序现在都一起存在。假设您希望在另一个项目中使用`我的组件`，只需将其复制或移动到该组件目录中就可以了。只要您安装了任何外部依赖项，并且您的配置具有相同的装载器定义，你应该很容易搞定这一切。

However, let's say you're locked into your old ways or you have some assets that are shared between multiple components (views, templates, modules, etc.). It's still possible to store these assets in a base directory and even use aliasing to make them easier to import.
>但是，假设您使用了旧的方法，或者有一些资源在多个组件（视图、模板、模块等）之间共享。仍然可以将这些资源存储在基目录中，甚至使用别名来使它们更容易导入。

### Wrapping up

结束语
For the next guides we won't be using all the different assets we've used in this guide, so let's do some cleanup so we're prepared for the next piece of the guides Output Management:
>下一篇指南文章中我们不会用到这篇文章里提到的所有资源类型,所以我们现在做一些清理工作,准备下一章节`Output Management`
简单一句话,删了src中除了index.js之外的所有文件...

```diff
  webpack-demo
  |- package.json
  |- webpack.config.js
  |- /dist
    |- bundle.js
    |- index.html
  |- /src
-   |- data.xml
-   |- my-font.woff
-   |- my-font.woff2
-   |- icon.png
-   |- style.css
    |- index.js
  |- /node_modules
```

webpack.config.js

```diff
const path = require('path');

  module.exports = {
    entry: './src/index.js',
    output: {
      filename: 'bundle.js',
      path: path.resolve(__dirname, 'dist')
    },
-   module: {
-     rules: [
-       {
-         test: /\.css$/,
-         use: [
-           'style-loader',
-           'css-loader'
-         ]
-       },
-       {
-         test: /\.(png|svg|jpg|gif)$/,
-         use: [
-           'file-loader'
-         ]
-       },
-       {
-         test: /\.(woff|woff2|eot|ttf|otf)$/,
-         use: [
-           'file-loader'
-         ]
-       },
-       {
-         test: /\.(csv|tsv)$/,
-         use: [
-           'csv-loader'
-         ]
-       },
-       {
-         test: /\.xml$/,
-         use: [
-           'xml-loader'
-         ]
-       }
-     ]
-   }
  };
```

src/index.js

```diff
import _ from 'lodash';
- import './style.css';
- import Icon from './icon.png';
- import Data from './data.xml';
-
  function component() {
    var element = document.createElement('div');
-
-   // Lodash, now imported by this script
    element.innerHTML = _.join(['Hello', 'webpack'], ' ');
-   element.classList.add('hello');
-
-   // Add the image to our existing div.
-   var myIcon = new Image();
-   myIcon.src = Icon;
-
-   element.appendChild(myIcon);
-
-   console.log(Data);

    return element;
  }

  document.body.appendChild(component());
```

## Output Management

So far we've manually included all our assets in our index.html file, but as your application grows and once you start using hashes in filenames and outputting multiple bundles, it will be difficult to keep managing your index.html file manually. However, a few plugins exist that will make this process much easier to manage.
>到目前为止，我们已经手动引用了所有的资源在我们的index.html文件中，但随着应用的增长，一旦你开始使用哈希表中的文件名和输出的bundle.js中，将很难手动管理您的index.html文件。然而，存在一些插件，这将使这个过程更容易管理。

### Preparation

首先添加新的文件

```diff
webpack-demo
  |- package.json
  |- webpack.config.js
  |- /dist
  |- /src
    |- index.js
+   |- print.js
  |- /node_modules
```

/src/print.js
Let's add some logic to our src/print.js file:
>让我们在`/src/print.js`中添加一些逻辑代码

```js
export default function printMe() {
  console.log('I get called from print.js!');
}
```

/src/index.js
And use that function in our src/index.js file:
>然后再`/src/index.js`中使用print中的方法

```diff
import _ from 'lodash';
+ import printMe from './print.js';

  function component() {
    var element = document.createElement('div');
+   var btn = document.createElement('button');

    element.innerHTML = _.join(['Hello', 'webpack'], ' ');

+   btn.innerHTML = 'Click me and check the console!';
+   btn.onclick = printMe;
+
+   element.appendChild(btn);

    return element;
  }

  document.body.appendChild(component());
```

/dist/index.html
Let's also update our dist/index.html file, in preparation for webpack to split out entries:
>更新`/dist/index.html`文件,为下一步将文件打包成分离的文件做准备

```diff
 <html>
    <head>
-     <title>Asset Management</title>
+     <title>Output Management</title>
+     <script src="./print.bundle.js"></script>
    </head>
    <body>
-     <script src="./bundle.js"></script>
+     <script src="./app.bundle.js"></script>
    </body>
  </html>
```

webpack.config.js
Now adjust the config. We'll be adding our src/print.js as a new entry point (print) and we'll change the output as well, so that it will dynamically generate bundle names, based on the entry point names:
>现在适配config文件,我们将添加`/src/print.js`作为一个新的入口文件,并且我们将同时修改文件输出配置,这样一来我们将根据入口文件名动态的生成打包文件的名称.

```diff
const path = require('path');

  module.exports = {
    entry: {
-     index: './src/index.js',
+     app: './src/index.js',
+     print: './src/print.js'
    },
    output: {
-     filename: 'bundle.js',
+     filename: '[name].bundle.js',
      path: path.resolve(__dirname, 'dist')
    }
  };
```

运行`npm run build`

We can see that webpack generates our print.bundle.js and app.bundle.js files, which we also specified in our index.html file. if you open index.html in your browser, you can see what happens when you click the button.
>我们可以看到，webpack生成了print.bundle.js和app.bundle.js文件，这也是我们的index.html文件中引用的文件。如果你在浏览器中打开index.html，你可以看看点击按钮时会发生什么。

But what would happen if we changed the name of one of our entry points, or even added a new one? The generated bundles would be renamed on a build, but our index.html file would still reference the old names. Let's fix that with the HtmlWebpackPlugin.
>但是，如果我们更改了某个入口点的名称，或者添加了一个新的入口点，会发生什么？产生的bundle名称在build时将发生改变，但是我们的index.html文件仍然使用旧名称。让我们使用HtmlWebpackPlugin修复这个问题。

### Setting up HtmlWebpackPlugin

`npm install --save-dev html-webpack-plugin`

webpack.config.js

```diff
  const path = require('path');
+ const HtmlWebpackPlugin = require('html-webpack-plugin');

  module.exports = {
    entry: {
      app: './src/index.js',
      print: './src/print.js'
    },
+   plugins: [
+     new HtmlWebpackPlugin({
+       title: 'Output Management'
+     })
+   ],
    output: {
      filename: '[name].bundle.js',
      path: path.resolve(__dirname, 'dist')
    }
  };
```

Before we do a build, you should know that the HtmlWebpackPlugin by default will generate its own index.html file, even though we already have one in the dist/ folder. This means that it will replace our index.html file with a newly generated one. Let's see what happens when we do an npm run build:
>在我们执行构建操作之前,你应该知道尽管我们已经在`/dist/`路径下有了一个index.html文件,HtmlWebpackPlugin仍然会默认创建自己的`index.html`文件.这意味着这个插件将会替换掉我们原有的index.html文件.让我们看看在运行`npm run build`时将会发生什么.

```sh
Hash: 81f82697c19b5f49aebd
Version: webpack 2.6.1
Time: 854ms
           Asset       Size  Chunks                    Chunk Names
 print.bundle.js     544 kB       0  [emitted]  [big]  print
   app.bundle.js    2.81 kB       1  [emitted]         app
      index.html  249 bytes          [emitted]
   [0] ./~/lodash/lodash.js 540 kB {0} [built]
   [1] (webpack)/buildin/global.js 509 bytes {0} [built]
   [2] (webpack)/buildin/module.js 517 bytes {0} [built]
   [3] ./src/index.js 172 bytes {1} [built]
   [4] multi lodash 28 bytes {0} [built]
Child html-webpack-plugin for "index.html":
       [0] ./~/lodash/lodash.js 540 kB {0} [built]
       [1] ./~/html-webpack-plugin/lib/loader.js!./~/html-webpack-plugin/default_index.ejs 538 bytes {0} [built]
       [2] (webpack)/buildin/global.js 509 bytes {0} [built]
       [3] (webpack)/buildin/module.js 517 bytes {0} [built]
```

If you open index.html in your code editor, you'll see that the HtmlWebpackPlugin has created an entirely new file for you and that all the bundles are automatically added.
>如果你用编辑器打开`index.html`文件,你将会发现HtmlWebpackPlugin为你创建了一个全新的文件,并且自动添加了所有的bundles文件引用.

If you want to learn more about all the features and options that the HtmlWebpackPlugin provides, then you should read up on it on the HtmlWebpackPlugin repo.
>如果你想要了解HtmlWebpackPlugin提供的更多特性,你应该前往HtmlWebpackPlugin的仓库进行阅读.

You can also take a look at html-webpack-template which provides a couple of extra features in addition to the default template.
>你同样可以看一下html-webpack-template,其中提供了很多特性的模板.

### Cleaning up the /dist folder

As you might have noticed over the past guides and code example, our /dist folder has become quite cluttered. Webpack will generate the files and put them in the /dist folder for you, but it doesn't keep track of which files are actually in use by your project.
>你可能已经注意到了,在之前指南的示例代码中,我们的`/dist/`文件夹变得相当混乱.webpack会生成这些文件并且将它们放置在目标文件夹中,但是并不会记录文件是否实际应用在项目中.

In general it's good practice to clean the /dist folder before each build, so that only used files will be generated. Let's take care of that.
>一般来说,在每次构建之前清理`/dist/`文件夹时很好的实践,只有被使用的文件将会被生成.让我们来处理这件事情.

A popular plugin to manage this is the clean-webpack-plugin so let's install and configure it.
>`clean-webpack-plugin`是一个用来处理这件事的流行插件,因此让我们安装并配置它.

`npm install clean-webpack-plugin --save-dev`

webpack.config.js

```diff
  const path = require('path');
  const HtmlWebpackPlugin = require('html-webpack-plugin');
+ const CleanWebpackPlugin = require('clean-webpack-plugin');

  module.exports = {
    entry: {
      app: './src/index.js',
      print: './src/print.js'
    },
    plugins: [
+     new CleanWebpackPlugin(['dist']),
      new HtmlWebpackPlugin({
        title: 'Output Management'
      })
    ],
    output: {
      filename: '[name].bundle.js',
      path: path.resolve(__dirname, 'dist')
    }
  };
```

Now run an npm run build and inspect the /dist folder. If everything went well you should now only see the files generated from the build and no more old files!

不翻译了...简单能看懂,翻译要来回看好几遍,麻烦...

### The Manifest

You might be wondering how webpack and its plugins seem to "know" what files are being generated. The answer is in the manifest that webpack keeps to track how all the modules map to the output bundles. If you're interested in managing webpack's output in other ways, the manifest would be a good place to start.
>关于webpack如何知道哪些文件将被生成引用的机制,感兴趣的话请阅读mainfest了解.

The manifest data can be extracted into a json file for easy consumption using the [WebpackManifestPlugin][WebpackManifestPlugin].

We won't go through a full example of how to use this plugin within your projects, but you can read up on the [concept page][concept page] and the [caching guide][caching guide] to find out how this ties into long term caching.

### Conclusion

Now that you've learned about dynamically adding bundles to your HTML, let's dive into the [development guide][development guide]. Or, if you want to dig into more advanced topics, we would recommend heading over to the [code splitting guide][code splitting guide].
>现在你已经学会了如何在html中动态添加bundles,让我们深入开发指南.或者,如果你想要挖掘更多进阶话题,我们建议你转到分别的代码指南.

## Development

If you've been following the guides, you should have a solid understanding of some of the webpack basics. Before we continue, let's look into setting up a development environment to make our lives a little easier.
>如果你一直跟随指南,你应该已经了解了一些基本的webpack只是.在继续之前,让我们研究一下如何配置一个开发环境来使我们的生活更加便捷.

The tools in this guide are only meant for development, please avoid using them in production!!
>注意:这篇指南中用到的工具只用于开发环境,请不要将它们用于产品化.

### Using source maps

When webpack bundles your source code, it can become difficult to track down errors and warnings to their original location. For example, if you bundle three source files (a.js, b.js, and c.js) into one bundle (bundle.js) and one of the source files contains an error, the stack trace will simply point to bundle.js. This isn't always helpful as you probably want to know exactly which source file the error came from.
>当使用webpack打包你的源代码时,追踪错误和定位变得很困难.例如:将三个源文件(a.js,b.js,c.js)打包在一个文件中,其中一个文件中包含有一个错误,堆栈追踪将简单的定位到bundle.js.这并不是一直有意义的,因为你可能更想要知道错误究竟源于具体的哪个文件中.

In order to make it easier to track down errors and warnings, JavaScript offers source maps, which maps your compiled code back to your original source code. If an error originates from b.js, the source map will tell you exactly that.
>为了使定位错误和警告更加容易,JavaScript提供了`source maps`资源映射,将编译后的代码映射到源文件中.如果一个错误源于b.js,资源映射机制将会告知你.

There are a lot of different options available when it comes to source maps, be sure to check them out so you can configure them to your needs.
>资源映射机制有很多不同的可用配置,请将它们研究透彻,以便在使用时能够按照你的具体需求进行配置.

For this guide, let's use the inline-source-map option, which is good for illustrative purposes (though not for production):
>在这篇指南中,让我们使用`inline-source-map`配置,这对于以说明为目的的本文来说很不错(尽管对产品化来说并不好).

webpack.config.js

```diff
const path = require('path');
  const HtmlWebpackPlugin = require('html-webpack-plugin');
  const CleanWebpackPlugin = require('clean-webpack-plugin');

  module.exports = {
    entry: {
      app: './src/index.js',
      print: './src/print.js'
    },
+   devtool: 'inline-source-map',
    plugins: [
      new CleanWebpackPlugin(['dist']),
      new HtmlWebpackPlugin({
        title: 'Development'
      })
    ],
    output: {
      filename: '[name].bundle.js',
      path: path.resolve(__dirname, 'dist')
    }
  };
```

Now let's make sure we have something to debug, so let's create an error in our print.js file:
>现在让我们确认在debug中拥有的某些特性,让我们在`print.js`中创建一个错误.

/src/print.js

```diff
  export default function printMe() {
-   console.log('I get called from print.js!');
+   cosnole.log('I get called from print.js!');
  }
```

执行`npm run build`,并且点击按钮,发生错误

```console
 Uncaught ReferenceError: cosnole is not defined
    at HTMLButtonElement.printMe (print.js:2)
```

We can see that the error also contains a reference to the file (print.js) and line number (2) where the error occurred. This is great, because now we know exactly where to look in order to fix the issue.
>我们可以看到,错误信息同样包含一个指向`pring.js`文件的引用,并且标出了错误发生的行数(2).这很不错,因为现在我们确切的知道去哪里可以修复我们的代码.

### Choosing a Development Tool

Some text editors have a "safe write" function that might interfere with some of the following tools. Read Adjusting Your text Editor for a solution to these issues.
>有一些编辑器拥有`安全写`功能,有可能实现了下面列出的工具.阅读适配你的编辑器来解决这些问题.

It quickly becomes a hassle to manually run npm run build every time you want to compile your code.
>每次都运行`npm run build`命令来编译项目很快就显得很麻烦.

There are a couple of different options available in webpack that help you automatically compile your code whenever it changes:

webpack's Watch Mode
webpack-dev-server
webpack-dev-middleware
In most cases, you probably would want to use webpack-dev-server, but let's explore all of the above options.
>现在有几个不同的选项可以让webpack在代码改变的时候自动执行编译操作
在大多数情况下,你可能更倾向于使用`webpack-dev-server`,不过还是让我们浏览上面所有的选择.

### Using Watch Mode

You can instruct webpack to "watch" all files within your dependency graph for changes. If one of these files is updated, the code will be recompiled so you don't have to run the full build manually.
>你可以指挥webpack`监控`依赖图中的所有文件改变状态.如果其中一个文件有更新,代码将会重新编译,因此你不需要手动运行完整的构建操作.
Let's add an npm script that will start webpack's Watch Mode:
>让我们在npm脚本中添加一条命令,用于运行webpack的监控模式

package.json

```diff
  {
    "name": "development",
    "version": "1.0.0",
    "description": "",
    "main": "webpack.config.js",
    "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1",
+     "watch": "webpack --watch",
      "build": "webpack"
    },
    "keywords": [],
    "author": "",
    "license": "ISC",
    "devDependencies": {
      "clean-webpack-plugin": "^0.1.16",
      "css-loader": "^0.28.4",
      "csv-loader": "^2.1.1",
      "file-loader": "^0.11.2",
      "html-webpack-plugin": "^2.29.0",
      "style-loader": "^0.18.2",
      "webpack": "^3.0.0",
      "xml-loader": "^1.2.1"
    }
  }
```

You can now run npm run watch from the command line to see that webpack compiles your code, but doesn't exit to the command line. This is because the script is still watching your files.
>现在你可以运行`npm run watch`命令来查看webpack编译你的代码,不过不要退出命令行.这是因为这条脚本将一直监控你的文件.

Now, with webpack watching your files, let's remove the error we introduced earlier:

src/print.js

```diff
  export default function printMe() {
-   cosnole.log('I get called from print.js!');
+   console.log('I get called from print.js!');
  }
```
Now save your file and check the terminal window. You should see that webpack automatically recompiles the changed module!

The only downside is that you have to refresh your browser in order to see the changes. It would be much nicer if that would happen automatically as well, so let's try webpack-dev-server which will do exactly that.

### Using webpack-dev-server

The webpack-dev-server provides you with a simple web server and the ability to use live reloading. Let's set it up:
`npm install --save-dev webpack-dev-server`

Change your config file to tell the dev server where to look for files:

webpack.config.js

```diff
  const path = require('path');
  const HtmlWebpackPlugin = require('html-webpack-plugin');
  const CleanWebpackPlugin = require('clean-webpack-plugin');

  module.exports = {
    entry: {
      app: './src/index.js',
      print: './src/print.js'
    },
    devtool: 'inline-source-map',
+   devServer: {
+     contentBase: './dist'
+   },
    plugins: [
      new CleanWebpackPlugin(['dist']),
      new HtmlWebpackPlugin({
        title: 'Development'
      })
    ],
    output: {
      filename: '[name].bundle.js',
      path: path.resolve(__dirname, 'dist')
    }
  };
```

This tells webpack-dev-server to serve the files from the dist directory on localhost:8080.

Let's add a script to easily run the dev server as well:

package.json

```diff
  {
    "name": "development",
    "version": "1.0.0",
    "description": "",
    "main": "webpack.config.js",
    "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1",
      "watch": "webpack --progress --watch",
+     "start": "webpack-dev-server --open",
      "build": "webpack"
    },
    "keywords": [],
    "author": "",
    "license": "ISC",
    "devDependencies": {
      "clean-webpack-plugin": "^0.1.16",
      "css-loader": "^0.28.4",
      "csv-loader": "^2.1.1",
      "file-loader": "^0.11.2",
      "html-webpack-plugin": "^2.29.0",
      "style-loader": "^0.18.2",
      "webpack": "^3.0.0",
      "xml-loader": "^1.2.1"
    }
  }
```

Now we can run npm start from the command line and we will see our browser automatically loading up our page. If you now change any of the source files and save them, the web server will automatically reload after the code has been compiled. Give it a try!

The webpack-dev-server comes with many configurable options. Head over to the documentation to learn more.

Now that your server is working, you might want to give [Hot Module Replacement][Hot Module Replacement] a try!

### Using webpack-dev-middleware

[WebpackManifestPlugin]: https://github.com/danethurber/webpack-manifest-plugin "WebpackManifestPlugin"
[concept page]: https://webpack.js.org/concepts/manifest "concept page"
[caching guide]: https://webpack.js.org/guides/caching/ "caching guide"
[development guide]: https://webpack.js.org/guides/development/ "development guide"
[code splitting guide]: https://webpack.js.org/guides/output-management/ "code splitting guide"
[Hot Module Replacement]: https://webpack.js.org/guides/hot-module-replacement "Hot Module Replacement"