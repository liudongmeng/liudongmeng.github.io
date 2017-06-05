---
title: Mac命令
date: 2017-03-09 23:33:59
tags:
update: 2017-04-09 16:16:59
category: ['笔记','随便记点什么']
---
也说不上是手贱吧,反正是买了台低配MBP,有些东西还是要记一下的
<!--more-->

# 命令

## 允许从任意来源安装应用

允许从任何来源安装应用,有些软件包安装的时候权限不足会安装失败,需要用到,记得安装完毕回复

```sh
sudo spctl --master-disable
```

## 关闭system integrity protection

买了台显示器,分辨率默认不适配HiDPI,下了个软件也改不好,提示需要关闭System Intergrity Protection
重启电脑,按住command+R键进入恢复模式,调出终端
操作完了记得恢复,毕竟是系统保护功能

```sh
# 关闭sip
csrutil disable

# 打开sip
csrutil enable
```


# 快捷键

先空着,这个东西常用的用多了就记得了

# 软件

[Awesome Mac][Awesome Mac]看起来不错,慢慢拉
[Awesome Mac]: https://github.com/jaywcjlove/awesome-mac "Awesome Mac"