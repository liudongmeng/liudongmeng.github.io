---
title: ElasticSearch
category:
  - 笔记
date: 2017-11-09 22:22:16
tags:
---
# ElasticSearch
<!--more-->

## JDK
<!--more-->

总归先装这玩意儿...看了一眼Cent虚拟机上还真是没装

```sh
wget -c --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/9.0.1+11/jdk-9.0.1_linux-x64_bin.tar.gz
```

命令没有问题,但是由于种种原因下载不成功,于是本机迅雷下载,然后`scp`拷贝过来

```sh
$ scp ./Downloads/jdk-9.0.1_linux-x64_bin.tar.gz liu@192.168.1.132:downloads
jdk-9.0.1_linux-x64_bin.tar.gz                100%  338MB   4.8MB/s   01:09
```

然后切换到cent系统,解压,创建路径,移动到路径,配置环境变量

```sh
$ tar -zxvf jdk-9.0.1_linux-x64_bin.tar.gz
$ sudo mkdir /usr/java
$ sudo mv jdk-9.0.1 /usr/java
$ sudo vi /etc/profile

#set java environment
export JAVA_HOME=/usr/java/jdk-9.0.1
export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib
export PATH=$JAVA_HOME/bin:/usr/local/nginx/sbin:/usr/local/mysql/bin:$PATH

$ sudo source /etc/profile

$ java --version
java 9.0.1
```

java环境配置完成

## ElasticSearch安装

安装过程由于网络问题,和第一步一样,迅雷下载之后`scp`

```sh
$ scp ./elasticsearch-5.6.4.tar.gz liu@192.168.1.132:downloads
elasticsearch-5.6.4.tar.gz                    100%   32MB   4.9MB/s   00:06
```

解压,运行,就好了

```sh
$ tar -zxvf elasticsearch-5.6.4.tar.gz
$ cd elasticsearch-5.6.4/bin
$ ./elasticsearch
$ curl http://localhost:9200/
{
  "name" : "ayEt8t8",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "CVjDymvNQOujg1SudUE0BQ",
  "version" : {
    "number" : "5.6.4",
    "build_hash" : "8bbedf5",
    "build_date" : "2017-10-31T18:55:38.105Z",
    "build_snapshot" : false,
    "lucene_version" : "6.6.1"
  },
  "tagline" : "You Know, for Search"
}
```

centos的防火墙一直不太会玩...还是挺麻烦的