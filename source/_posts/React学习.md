---
title: React学习
subtitle: 学尼玛学,工资能涨吗?
tags:
  - 前端开发
category:
  - 笔记
date: 2019-06-29 15:28:05
---


## 习惯性叨逼叨

今年工作有点不上心,上班吃饭上班下班吃饭看视频睡觉->上班吃饭上班下班吃饭睡觉->上班...  
工作的事情也不怎么用心,下班也不用心,浑浑噩噩半年又过去了.
然后前一段工作安排了个写前端的活,之前看过的 vue.js 又捡起来看了看,顺便就又膨胀了觉得自己可以顺手把 ES5/TS/Angular/React/ReactNative/Weex/Flutter/Dart 什么的一起看了.
又觉得 Webpack/Babel/ESLint/TSLint/CSS/Less/Sass 什么的也没什么难的,然后就吭哧吭哧的看了几天文档,然后发现,其实需要沉下心来学一下的东西还挺多的...
虽然主要也不是做这个,不过了解一下也没什么坏处,整理一下自己学习 React 的东西吧,光看不学还是弟弟.
我要涨工资...

<!-- more -->

## React

介绍就不多说了,无非就是起源 Facebook 用于 instgram 的项目开发,血统高贵,应用广泛,各种优点,直接开始正题

### React 是什么

> React-用于构建用户界面的 JavaScript 库

实质上,React 是一个前端库/框架,用户通过编写 JavaScript+HTML+CSS 代码实现网页的布局,展示,交互等功能.  
传统逻辑下,我们编写一个网页首先要新建一个 html 页面,然后在页面上设计好我们的页面样式和布局,通过 JavaScript 代码响应页面的交互事件,请求数据,并且通过直接操作页面元素的方式实现功能,这个时候最常用的库是 `JQuery`.  
但是后来,可能是人们发现这种操作页面元素的方式代码有很多冗余,用户在关注实际业务逻辑的同时也会过度的关注与页面元素的操作逻辑,于是开始尝试着将逻辑编写和页面元素的操作渐渐隔离开,`JQuery`其实能够实现一部分目标,但是还不够,用户只是在选择和操作页面元素时更加的方便,但是并没有抛开这一部分工作.  
再后来,人们尝试着将页面元素的操作封装的更深,尽可能的屏蔽用户对于页面元素的操作,使得用户更专注于业务逻辑本身,这时候就出现了`MVC`/`MVVM`等设计思想,也出现了各种各样的框架.  
目前说起来最流行的框架,无非是`React`,`Angular`,`Vue.js`,各自有自己的设计理念,我现在的学习除了初步掌握这些技术本身之外,更重要的在于学习其设计思想,拓展视野.

本来想翻墙白嫖[官网]["react官网"]的信息,无奈断了代理...暂且结合之前看的视频和中文网站的信息开始吧 ┑(￣ Д ￣)┍

> React 是一个声明式，高效且灵活的用于构建用户界面的 JavaScript 库。使用 React 可以将一些简短、独立的代码片段组合成复杂的 UI 界面，这些代码片段被称作“组件”。

### 搭建开发环境

随着前端技术的发展,从 html+js+css+assets 的构建方式变化到了现在通过各种工具,专门的 cli 工具,npx,脚手架.  
优点:简单易用,新手可以快速开始代码的编写  
缺点:就是如果是新手,开始开发之后遇到一些需求的时候手足无措,一脸蒙蔽  
因此,脚手架/cli 可以用,但是自己动手也要会,知己知彼

例如官方提供的最简单的方式

```sh
npx create-react-app my-app
```

这句命令会在当前路径创建一个 my-app 的文件夹,并且初始化一个 react 项目,包含了打包环境,基础库(React/ReactDom 等),npm 脚本命令等,在命令执行完成之后可以直接切换到目录下执行 npm start,就看到了一个 Hello World 程序  
**_But_**,这种方式好像不太符合目前的主流模式,webpack+babel+loader+plugin+webpack-dev-server....所以我也就跑一下,然后切换到 webpack

#### 安装 devDependencies

```sh
mkdir my-app
cd my-app
npm init
# 接下来回车回车回车回车....
# 然后开始安装依赖包

# webpack工具,提供了打包,运行,热加载等功能,集成babel,html-webpack-plugin,style-loader等插件
npm install webpack webpack-cli webpack-dev-server webpack-merge html-webpack-plugin -D
# react基础环境,react+react-dom,scripts在这里应该没用到
npm install react react-dom -D #react-scripts
# babel组件,包括babel核心和jsx支持
npm install babel-core jsx-loader -D
# 样式打包插件
npm install style-loader css-loader sass-loader url-loader file-loader -D
```

#### 配置基础环境

##### Webpack

`configs/webpack.common.js`通用配置,包含了:

1. 打包模式(development/production)的设置
2. 项目入口(entry)
3. 项目输出(output)设置
4. 插件,包含 jsx 语法模块,sass/css 编译模块
5. 优化配置 optimization
6. webpack-dev-server 配置
7. 同义词(alias)配置
8. HtmlWebPackPlugin/HotModuleReplacementPlugin 配置

```JavaScript
const webpack = require("webpack");
const path = require("path");
const HtmlWebPackPlugin = require("html-webpack-plugin");
const APP_PATH = path.join(__dirname, "../src");
const DIST_PATH = path.join(__dirname, "../dist");
module.exports = (env, argv) => {
  const PROD_MODE = argv.mode === "production" ? true : false;
  return {
    entry: {
      main: path.resolve(__dirname, APP_PATH, "app.jsx")
    },
    output: {
      path: path.resolve(DIST_PATH),
      filename: "[name].[hash].js"
    },
    module: {
      rules: [
        { test: /\.jsx|js$/, use: ["babel-loader"] },
        {
          test: /\.scss|css$/,
          use: ["style-loader", "css-loader", "sass-loader"],
          include: [APP_PATH, /bootstrap.min.css/]
        }
      ]
    },
    optimization: {
      splitChunks: {
        chunks: "async",
        minSize: 30000,
        maxSize: 0,
        minChunks: 1,
        maxAsyncRequests: 5,
        maxInitialRequests: 3,
        automaticNameDelimiter: "~",
        name: true,
        cacheGroups: {
          common: {
            name: "common",
            chunks: "initial",
            priority: 2,
            minChunks: 2
          }
        }
      },
      runtimeChunk: {
        name: "runtime"
      }
    },
    devServer: {
      hot: true,
      inline: true
    },
    resolve: {
      alias: {
        "@": APP_PATH
      }
    },
    plugins: [
      new HtmlWebPackPlugin({
        filename: "index.html",
        template: "./src/index.html",
        minify: {
          removeComments: PROD_MODE,
          collapseWhitespace: PROD_MODE
        }
      }),
      new webpack.HotModuleReplacementPlugin()
    ]
  };
};

```

`configs/webpack.dev.js`包含了开发模式下,DevServer 的一些配置

```JavaScript
module.exports = (env, argv) => {
  return Merge(CommonConfig(env, argv), {
    mode: "development",
    devServer: {
      contentBase: path.join(__dirname, "./dist"),
      compress: true,
      port: 9000
    }
  });
};
```

##### Babel

提供了 jsx 语法和 es6 语法特性的支持

```json
{
  "plugins": [
    "@babel/plugin-transform-react-jsx",
    "@babel/plugin-proposal-class-properties"
  ]
}
```

##### 配置 npm 命令

这里主要是添加`dev`和`build`运行命令

```json
{
  "name": "my-app",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "dev": "webpack-dev-server --mode development --open --config configs/webpack.dev.js",
    "build": "webpack --mode production --config configs/webpack.prod.js"
  },
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "babel-core": "^6.26.3",
    "css-loader": "^3.0.0",
    "file-loader": "^4.0.0",
    "html-webpack-plugin": "^3.2.0",
    "jsx-loader": "^0.13.2",
    "node-sass": "^4.12.0",
    "react": "^16.8.6",
    "react-dom": "^16.8.6",
    "react-scripts": "^3.0.1",
    "sass-loader": "^7.1.0",
    "style-loader": "^0.23.1",
    "url-loader": "^2.0.1",
    "webpack": "^4.35.0",
    "webpack-cli": "^3.3.5",
    "webpack-dev-server": "^3.7.2",
    "webpack-merge": "^4.2.1"
  },
  "dependencies": {}
}
```

#### 入口文件

`src/index.html`,挂载渲染的元素`id="app"`

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Document</title>
  </head>
  <body>
    <div id="app"></div>
  </body>
</html>
```

## Hello World

`src/app.jsx`,包含了`APP组件`的定义,以及 React 的元素挂载

```jsx
import React from "react";
import ReactDom from "react-dom";

class APP extends React.Component {
  constructor(props) {
    super(props);
  }
  render = () => {
    return <h1>Hello World</h1>;
  };
}

ReactDom.render(<APP />, document.getElementById("app"));
```

至此,Hello World 项目创建成功,运行`npm run dev`,即可运行项目,看到 HelloWorld 效果

## TodoList 示例

这个要比 hello world 更完整一些

1. 包含了 props,并且可以包含 state 和 children,refs 等,能够区分 state 和 props 的不同应用场景
2. 包含了 render 函数
3. 可以包含生命周期函数

`src/components/TodoList.jsx`

```jsx
import React from "react";

export default class TodoList extends React.Component {
  constructor(props) {
    super(props);
  }

  render = () => {
    let list = props.list.map(o => {
      return <li key={o.id}>{o.content}</li>;
    });
    return <ul>{list}</ul>;
  };
}
```

`src/app.jsx`

```jsx
import React from "react";
import ReactDom from "react-dom";
import TodoList from "@/components/TodoList.jsx";
// 构建数据
let todo = {
  todo: ["买调料", "烧水", "磨刀", "杀牛", "喝牛奶", "吃牛肉"].map((k, v) => {
    return { id: v, content: k };
  })
};

class APP extends React.Component {
  constructor(props) {
    super(props);
  }
  render = () => {
    return (
      <div>
        <TodoList list={todo} />
      </div>
    );
  };
}

ReactDom.render(<APP />, document.getElementById("app"));
```

## 待续

其实这个东西一写起来就没完,熟练的完全不用看我这些罗里吧嗦的一堆有的没的,官方文档最好.不会的,就只能跟着复制粘贴敲命令,出了问题就懵逼...

1. [ ] webpack
2. [ ] loader
3. [ ] plugin
4. [ ] dev-server
5. [ ] npm
6. [ ] babel
7. [ ] es6 各种新特性
8. [ ] jsx

其实 webpack 这个东西我也用的不熟,毕竟用的不多,而且这个迭代的感觉是有点快...各种新特性,新插件,新配置,新写法 (╯﹏╰)  
先写到这里吧,慢慢补...

1. ReactDOM.render
2. `React.Component`/`constructor`/`render`
3. state/props/children
4. 生命周期函数`componentDidMount`/`componentWillUnmount`
5. 设计思想
6. 事件处理
7. Debugger with Visual Studio Code

["react官网"]: https://www.reactjs.org/ "React 官网"
