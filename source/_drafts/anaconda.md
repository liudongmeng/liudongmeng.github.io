---
title: anaconda
category:
  - 笔记
date: 2017-12-23 14:22:16
tags: [python]
---
# anaconda相关的笔记

最近工作没有特别忙,有功夫学点东西,准备在机器上跑TensorFlow官网的MNIST玩,然后才发现本机还是MacOS自带的python2.7,并且什么都没装,然后又想起了大半年前是用的virtualenv装的环境,真是一晃好久过去了...
<!--more-->

## 安装

其实安装过程很简单,无非下载运行下一步,linux和mac上也无非就是跑个sh,不多说了吧

## 命令

### 配套组件

相关命令用到的可以简单说下
`ipython`:这个是一个增强版的python shell,里面支持代码智能提示,高亮等功能,不过用起来终究不是很方便,还是觉得用编辑器更舒服

`jupyter notebook`:jupyter是什么我其实也不是太有概念,但是jupyter notebook确实是个学习用很不错的东西,提供了一个web版本的notebook,优点是可以在里面写代码,并且可以运行,直接在页面中查看结果,代码是在本地运行,可以访问本地文件,`matplotlib`生成的图形可以直接输出在浏览器页面中,写文档有点方便,并且文档可以直接输出markdown.
据说好像是和ipython同出一系,缺点就是始终没有编辑器用着方便,有时候需要跳转去看源码的说明时很费劲.

### 基本命令

`conda install`:包安装命令
`conda search`:包查找命令
`conda uninstall`:包删除命令
说到这几个就不得不提镜像的问题了,[清华大学提供的Anaconda镜像][清华镜像],里面还提供了精简版的Anaconda安装包`Miniconda`.
使用如下命令添加清华镜像源,并且设置生效,之后的下载速度就起飞了~
后添加的channels会默认最高优先级,free channels中包的版本会比较旧,导致直接使用`conda install`命令无法安装期望版本的包,因此要先添加free,后添加main,或者不添加free

```sh
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --set show_channel_urls yes
```

`conda create`:virtualenv的替代品,具体实现不清楚,但是功能用起来是一样的,创建一个虚拟环境,可以任意指定python的版本,搭载的包,实现单机多环境,用了这个之后我已经准备把本机的virtualenv删了...毕竟重复功能
然后Anaconda Navigator的图形界面直接就具有这个管理功能,所以说什么`conda create``conda remove`命令其实不用记也可以,大不了`-h`一下...

```sh
# 下列命令创建了一个python27版本的运行环境,名字叫做test_conda
conda create -n test_conda python=2.7
# 使用命令切换至test_conda环境
source activate test_conda
# 之后再里面使用python就是一个全新的27版本
# 使用deactivate命令退出虚拟环境
source deactivate
```

我本机安装的是Anaconda的python3.6.3版本,但是仍然可以创建27版本的环境,并且在里面执行相关的包安装,并不会影响外面

[清华镜像]: https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/ "五道口职业技术学校提供的anaconda镜像"