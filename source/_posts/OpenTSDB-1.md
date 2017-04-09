---
title: OpenTSDB服务器启动操作
date: 2017-01-06 12:08:08
tags:
category: [笔记,OpenTSDB]
---
公司的虚拟机关了之后OpenTSDB的时候各种报错……折腾了一会儿才想起来基础的Hadoop/Zookeeper/HBase服务貌似没起……
启动服务的命令记一下，虽然搞了两次大概记住了
<!--more-->
所有操作都在master上进行

启动Hadoop
```batch
start-dfs.sh
start-yarn.sh
#mr-jobhistory-daemon.sh start historyserver
```
启动HBase(自带启动Zookeeper)
切换至HBase安装路径
```batch
./bin/start-hbase-sh
```

启动OpenTSDB
切换至OpenTSDB安装路径(build)
```batch
./tsdb tsd
```