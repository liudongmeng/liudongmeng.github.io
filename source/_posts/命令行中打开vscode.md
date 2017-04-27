---
title: 命令行中打开vscode
date: 2017-04-28 01:11:42
tags:
category: [笔记,命令配置]
---
不停的敲命令其实很麻烦,尤其mac下面的文件系统不是很习惯,每次用vscode打开一个文件夹时要搞半天,很是不方便
试了一下alias(同义词),感觉非常好用
<!--more-->
```sh
# 配置环境变量
$ vim ~/.bash_profile
# 添加如下内容
# vsc打开vscode文件
alias vsc="'/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'"
# 定义vsc-hexo命令,输入即可打开vscode并且打开hexo路径,其他文件配置相同
alias vsc-hexo="vsc /Users/liudongmeng/Documents/GitHub/Hexo/"
```
同样可以配置一些ssh的同义词,不用每次都用户名+ip输半天,我反正切换不太过来...