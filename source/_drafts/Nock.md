---
title: Nock
category:
  - 笔记
date: 2020-09-19 21:27:22
tags:
---

<!-- more -->

## 安装ssl

```zsh
yum install openssl-devel
```

## 安装nodejs

首先去[nodejs][nodejs]的官网下载对应的安装包,进行安装

```zsh
# 下载安装包
wget https://nodejs.org/dist/v12.18.4/node-v12.18.4-linux-x64.tar.xz
# 解压
xz -d node-v12.18.4-linux-x64.tar.xz
tar -xvf node-v12.18.4-linux-x64.tar
# 配置安装路径
mkdir ~/deployment
mv node-v12.18.4-linux-x64 ~/deployment/nodejs
export NODEPATH=/home/centos/deployment/nodejs
export PATH=$PATH:$NODEPATH/bin
# 查看版本信息
# v12.18.4
node --version
```

## 安装nock

```zsh
# 创建工作目录
mkdir mock-server && cd mock-server
# 安装依赖
npm install --save-dev nock --registry=
```


<!-- [NodeJS]: https://nodejs.org/dist/v12.18.4/node-v12.18.4-linux-x64.tar.xz "nodejs.org" -->
[nodejs]: https://nodejs.org/ "https://nodejs.org"
