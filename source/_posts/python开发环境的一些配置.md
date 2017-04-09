---
title: python开发环境的一些配置
date: 2017-04-08 16:44:27
tags: ['python']
category: ['笔记','python','环境配置']
---
本来只是想学习一下Scrapy怎么做爬虫，顺便爬点东西😄
结果发现之前想装robot framework的时候遇到的问题重现了……正好整理一下
因为brew什么的没用过，所以参考的[原文][参考链接]里面有一部分我没写进来，以后用到了再看
<!--more-->

# 安装模块

下载pip文件
[下载地址][pip-download]
然后执行命令

```sh
# 安装pip,可能是需要管理员权限的
$ sudo python get-pip.py
# 安装完pip之后安装virtualenv
$ sudo pip install virtualenv
# 然后用virtualenv创建虚拟环境
$ virtualenv ENV
# 切换至ENV路径后开启虚拟环境
$ source bin/activate
# To undo these changes to your path (and prompt), just run:
# 撤销改变?暂时不是很理解
$ deactivate
```

之后就可以在虚拟环境里面为所欲为了吧，据说是和外部的python环境互不影响的，因为Mac操作系统的原因有一些包没有办法正常安装，我也不想去改系统权限，这个方案目前看起来不错

# pip的User Install

在使用pip安装包的时候加上user参数，可以避免因为mac系统安全性限制导致的一些安装失败，不过需要修改pip的配置和系统的环境变量，这里也记一下吧，难保会不会用到

```sh
# python安装命令
$ python setup.py install --user
# 或者下面的命令也可以
# python setup.py install --home=<dir>

# pip也一样
$ pip install package --user
```

但是这样安装的包因为不在系统默认的PATH中，装是可以装，但是不能用，需要改一下环境变量

```sh
# 打开配置文件，不存在的话新建一个
$ vim ~/.bash_profile
# 添加如下的配置
if [ -d $HOME/Library/Python/2.7/bin ]; then
    export PATH=$HOME/Library/Python/2.7/bin:$PATH
fi
# 应用环境变量的修改
$ source ~/.bash_profile
```

修改pip的配置文件

```sh
# 创建目录
$ mkdir -p ~/.pip
# 看了一下touch是创建空文件的命令，用vim代替一样吧
$ touch ~/.pip/pip.conf
# 编辑配置文件
$ vim ~/.pip/pip.conf
# pip.conf文件添加如下配置
[global]
default-timeout = 60
download-cache = ~/.pip/cache
log-file = ~/.pip/pip.log

[install]
# 这个地方可以配pip源，这个是豆瓣的，试了一下国内两个源，包都不全，尽量还是翻墙拿吧
# 注意需要在地址后加/simple
index-url = http://pypi.douban.com/simple
```

# pip源地址

记录一下pip源的地址，万一以后用到了省的到处找

* 清华:https://pypi.tuna.tsinghua.edu.cn/
* 豆瓣:http://pypi.douban.com/
* 华中理工大学:http://pypi.hustunique.com/
* 山东理工大学:http://pypi.sdutlinux.org/
* 中国科学技术大学:http://pypi.mirrors.ustc.edu.cn/


[pip-download]: https://bootstrap.pypa.io/get-pip.py "pip下载地址"
[参考链接]: https://havee.me/mac/2014-05/individual-scheme-for-pip.html "参考链接"
