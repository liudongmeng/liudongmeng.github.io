---
title: OpenTSDB的安装部署及简单使用
date: 2017-01-28 15:46:16
tags: [OpenTSDB,HBase]
category: [笔记,OpenTSDB]
---
部署流程，其实部署东西大都不难，呵呵。
<!--more-->

# 安装
首先看官方文档，需要linux系统+Java Runtime+HBase+GnuPlot
linux系统不说了，java运行时是因为程序是用java编写的，HBase是最终的底层存储系统。GnuPlot其实不装也可以，只是web端绘图的时候要调用，没有不影响基础功能
```
Runtime Requirements
To actually run OpenTSDB, you'll need to meet the following:

A Linux system (or Windows with manual building)
Java Runtime Environment 1.6 or later
HBase 0.92 or later
GnuPlot 4.2 or later
```
之前安装Hadoop的时候已经安装了jdk，设置了JAVA_HOME，所以这里从hbase开始
## 安装HBase
首先[官网][HBase]下载程序包`hbase-1.2.4-bin.tar.gz`和md5校验文件`hbase-1.2.4-bin.tar.gz.mds`
```bash
 ssh hadoop@192.168.2.128
wget https://mirrors.tuna.tsinghua.edu.cn/apache/hbase/stable/hbase-1.2.4-bin.tar.gz
wget https://mirrors.tuna.tsinghua.edu.cn/apache/hbase/stable/hbase-1.2.4-bin.tar.gz.mds
md5sum hbase-1.2.4-bin.tar.gz | tr 'a-z' 'A-Z' #查看文件的md5值，检查文件是否完整
```
然后解压到`/usr/local/`路径
```bash
tar -zxvf hbase-1.2.4-bin.tar.gz
su
mv hbase-1.2.4 /usr/local/hbase

```
切换到目录，修改`conf/hbase-site.xml`
```xml
<configuration>
  <property>
    <name>hbase.rootdir</name>
    <value>file:///usr/local/hbase</value>
    <!--value>hdfs://192.168.2.128:9000/user/hadoop/hbase</value-->
  </property>
  <property>
    <name>hbase.zookeeper.property.dataDir</name>
    <value>/usr/local/zookeeper</value>
  </property>
</configuration>
```
修改环境变量
```bash
vim ~/.bashrc
$HBASE_HOME=/usr/local/hbase
```
启动`start-hbase.sh`,打开http://192.168.2.128:16010/ 查看启动是否成功。能够打开web页面说明启动成功，暂时到此为止
zookeeper要通过hbase启动，如果手动打开了hbase则会报错

---------

## 安装zookeeper
```
wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/stable/zookeeper-3.4.9.tar.gz
tar -zxvf zookeeper-3.4.9.tar.gz
mv zookeeper-3.4.9 /usr/local/zookeeper
```
创建配置文件
```cfg
cp zoo_sample.cfg zoo.cfg
```
启动服务
```bash
./bin/zkServer.sh start #启动服务
./bin/zkServer.sh stop #停止服务
```
修改环境变量
```bash
vim ~/.bashrc
$ZK_HOME=/usr/local/zookeeper
```
[HBase]: http://hbase.apache.org/ "hbase.apache.org"