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

## 关于"xxxx.xx已被OS X使用,无法打开"的问题

说道这里不得不感慨自己的贫穷,硬盘不够移动的来凑,装了个双系统来回倒腾,不知道怎么就会导致移动硬盘里面一些文件无法打开,`zip/rar`文件无法解压,百度很久有一个[方法][关于“xx.xx已被OS X使用，无法打开”的问题]可行...
>Mac电脑上的文件拷贝到移动硬盘，有时候会出现“xx.xx已被OS X使用，无法打开”的问题。
>解决办法：
>
>1、打开终端(或在Mac搜索里面输入Terminal);
>
>2、在终端里输入 xattr -l ，然后把出问题的文件拖动到 "xattr -l 后面",回车；
>
>```sh
>Sayonara-MacBook-Pro:~ liudongmeng$ xattr -l
>Sayonara-MacBook-Pro:S1 liudongmeng$ xattr -l 1_1310389850k0Hh.zip
>```
>
>3、然后，第一行会有 com.apple.FinderInfo 这串字符。复制这串字符，回车
>
>例如:
>
>```sh
>Sayonara-MacBook-Pro:S1 liudongmeng$ xattr -l 1_1310389850k0Hh.zip
>com.apple.FinderInfo:
>00000000  62 72 6F 6B 4D 41 43 53 00 00 00 00 00 00 00 00  |brokMACS........|
>00000010  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  |................|
>00000020
>com.apple.metadata:kMDItemWhereFroms:
>00000000  62 70 6C 69 73 74 30 30 A2 01 02 5F 10 45 68 74  |bplist00..._.Eht|
>00000010  74 70 3A 2F 2F 72 65 6E 72 65 6E 2E 6D 61 6F 79  |tp://renren.maoy|
>00000020  75 6E 2E 74 76 2F 66 74 70 2F 61 74 74 61 63 68  |un.tv/ftp/attach|
>00000030  6D 65 6E 74 2F 32 30 31 31 30 37 2F 31 31 2F 31  |ment/201107/11/1|
>00000040  5F 31 33 31 30 33 38 39 38 35 30 6B 30 48 68 2E  |_1310389850k0Hh.|
>00000050  7A 69 70 5F 10 1A 68 74 74 70 3A 2F 2F 7A 6D 7A  |zip_..http://zmz|
>00000060  30 30 31 2E 63 6F 6D 2F 73 2F 4B 64 57 39 37 33  |001.com/s/KdW973|
>00000070  08 0B 53 00 00 00 00 00 00 01 01 00 00 00 00 00  |..S.............|
>00000080  00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00  |................|
>00000090  00 00 70                                         |..p|
>00000093
>com.apple.quarantine: 0081;5a6c2976;Chrome;8EF54D09-8C0A-4E6F-9BE0-15C8A1B945A9
>```
>
>4、接下来，输入新的命令 xattr -d com.apple.FinderInfo 再把问题文件拖进去，问题就解决了
>
>```sh
>Sayonara-MacBook-Pro:S1 liudongmeng$ xattr -d com.apple.FinderInfo 1_1310389850k0Hh.zip
>```

# 快捷键

先空着,这个东西常用的用多了就记得了

# 软件

[Awesome Mac][Awesome Mac]看起来不错,慢慢拉
[Awesome Mac]: https://github.com/jaywcjlove/awesome-mac "Awesome Mac"
[关于“xx.xx已被OS X使用，无法打开”的问题]: https://www.cnblogs.com/xiu619544553/p/5270200.html "关于“xx.xx已被OS X使用，无法打开”的问题"