---
title: Vue 3
category:
  - 笔记
date: 2020-09-26 23:06:23
tags:
---


疲于工作啥都没关注,突然发现vue发布3.0了,来看看有什么新特性,有没有开始学习的必要,毕竟我还是比较倾向于React的🐶

<!-- more -->

首先的问题是虚拟机中为了上次安装Mock Server装了8.x的node,vite报错,所以第一步是安装nvm便于后面的测试开发

## 安装环境

### 安装NVM

```sh 下载并安装 https://github.com/nvm-sh/nvm nvm-sh/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
```

```zsh 配置zsh环境变量
cat>>$HOME/.zshrc<<EOF
# >>> nvm initialize >>>
# !! NVM !!
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# <<< nvm initialize <<<
EOF
```

### 安装Python2.7环境

nvm安装node 12.x需要python2.7环境,这对于我这种python/node都会来回切版本的人就真的是不友好...

```yaml .condarc https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/ 配置清华源
channels:
  - defaults
show_channel_urls: true
channel_alias: https://mirrors.tuna.tsinghua.edu.cn/anaconda
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

```zsh 创建python2.7环境并切换
# 创建名为py2的虚拟环境并且指定Python的版本为2.7
conda create --name py2 Python=2.7
# 切换python2.7环境
conda activate py2
```

### 安装Nodejs 12.x

之后开始安装lts版本的node

```shell
$ nvm install 12 --lts
Downloading and installing node v12.18.4...
Downloading https://nodejs.org/dist/v12.18.4/node-v12.18.4-linux-x64.tar.xz...
############################################################################################################################################################### 100.0%
Computing checksum with sha256sum
Checksums matched!
Now using node v12.18.4 (npm v6.14.6)
Creating default alias: default -> 12 (-> v12.18.4)
```

## Hello World

```shell 通过vite工具创建项目 https://vue3js.cn/docs/zh/guide/installation.html#vite vue3js.cn
$ npm install -g nrm # 安装nrm工具用于切换镜像
$ nrm use taobao # 使用淘宝镜像
$ npm init vite-app magicyang # 创建magicyang项目
npx: installed 7 in 5.187s
Scaffolding project in /home/centos/workspace/magicyang...

Done. Now run:

  cd magicyang
  npm install (or `yarn`)
  npm run dev (or `yarn dev`)
$ cd magicyang # 切换到项目路径
$ npm install # 安装依赖
$ npm run dev # 启动开发服务
```

到此为止,一个hello world项目就创建完成了.
**我特喵的别的不说这个启动速度是真滴牛逼!**

从hello world的组件中看,语法和前一代还是基本保持一致的,不过翻了翻感觉破坏性的修改还是很多的,有空慢慢看吧,先看看设计思路和理念再说

```html
<template>
  <h1>{{ msg }}</h1>
  <button @click="count++">count is: {{ count }}</button>
  <p>Edit <code>components/HelloWorld.vue</code> to test hot module replacement.</p>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
      count: 0
    }
  }
}
</script>
```
