---
title: 从头开始搭建hadoop环境
date: 2017-01-27 15:45:24
tags: [linux,ubuntu,hadoop,hdfs,yarn]
---
放假在家没什么事情，从头整理一下之前搭的环境，有些当时看起来似是而非的东西现在看起来就明确了很多，为了部落……
<!--more-->

# 首先安装server版本的ubuntu虚拟机
因为是装作虚拟机用，所以要尽可能的节省资源，图形界面什么的就不要了，这一步我之前已经做好了，也比较简单，暂时不写

# 相关的环境
[参考文章][hadoop-install]
## openssh
ubuntu默认已经装好了openssh-server，没有装的话`sudo apt-get install openssh-server`就可以了
然后是配置
### 虚拟机改为桥接
![Bridge](Bridge.png)
输入`ifconfig`查看虚拟机的ip
### 测试连接
`ssh user@xxx.xxx.xxx.xxx`,根据提示连接即可
## 创建hadoop用户
创建用户
`sudo useradd -m hadoop -s /bin/sh`
修改密码
`sudo passwd hadoop`
将用户添加至管理员
`sudo adduser hadoop sudo`
初始化root用户密码(用户需要具备管理员权限)
`sudo passwd`
在本地生成ssh-keygen
`ssh-keygen`
将keygen上传到服务器，之后就可以直接ssh命令登陆而不用输入密码了
`ssh-copy-id user@xxx.xxx.xxx.xxx`
## JDK
试了一下，1.7版本的openjdk不能跑，装1.8的
`sudo apt-get install openjdk-8-jre openjdk-8-jdk`
安装完成后输入`java -version`查看版本
输入`dpkg -L openjdk-7-jdk | grep '/bin/javac'`查看安装路径
这里不知道为啥没输出，直接查看`dpkg -L openjdk-8-jdk`
## JAVA_HOME
`vim ~/.shrc`添加`export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/`
之后执行`source ~/.shrc`使修改生效
输入`$JAVA_HOME/bin/java -version`查看jdk版本，如果能正常输出，则说明环境变量配置正确
# 安装hadoop
## 安装
到[官网][hadoop.apache.org]下载后利用scp命令上传到服务器
`scp hadoop-2.7.3.tar.gz hadoop@192.168.2.128: ~/`
校验md5
```sh
cat ~/下载/hadoop-2.6.0.tar.gz.mds | grep 'MD5' # 列出md5检验值
# head -n 6 ~/下载/hadoop-2.7.1.tar.gz.mds # 2.7.1版本格式变了，可以用这种方式输出
md5sum ~/下载/hadoop-2.6.0.tar.gz | tr "a-z" "A-Z" # 计算md5值，并转化为大写，方便比较
```
解压`tar -zxvf hadoop-2.7.3.tar.gz`
移动到/usr/local路径`mv hadoop-2.7.3 /usr/local/hadoop`
查看hadoop版本`./bin/hadoop version`
查看官方例子`./bin/hadoop jar ./share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.3.jar`
wordcount
```sh
cd /usr/local/hadoop
mkdir ./input
cp ./etc/hadoop/*.xml ./input   # 将配置文件作为输入文件
./bin/hadoop jar ./share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar grep ./input ./output 'dfs[a-z.]+'
cat ./output/*          # 查看运行结果
```
## 配置
修改配置文件`gedit ./etc/hadoop/core-site.xml`
修改为
```xml
<configuration>
        <property>
             <name>hadoop.tmp.dir</name>
             <value>file:/usr/local/hadoop/tmp</value>
             <description>Abase for other temporary directories.</description>
        </property>
        <property>
             <name>fs.defaultFS</name>
             <value>hdfs://192.168.2.128:9000</value>
        </property>
</configuration>
```
同样的，修改配置文件 hdfs-site.xml
```xml
<configuration>
        <property>
             <name>dfs.replication</name>
             <value>1</value>
        </property>
        <property>
             <name>dfs.namenode.name.dir</name>
             <value>file:/usr/local/hadoop/tmp/dfs/name</value>
        </property>
        <property>
             <name>dfs.datanode.data.dir</name>
             <value>file:/usr/local/hadoop/tmp/dfs/data</value>
        </property>
</configuration>
```
配置完成后，执行 NameNode 的格式化:
```sh
./bin/hdfs namenode -format
```

启动进程
```sh
./sbin/start-dfs.sh
```
HADOOP环境变量配置(非必需)
```sh
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
```
无法启动的解决办法
```sh
# 针对 DataNode 没法启动的解决方法
./sbin/stop-dfs.sh   # 关闭
rm -r ./tmp     # 删除 tmp 文件，注意这会删除 HDFS 中原有的所有数据
./bin/hdfs namenode -format   # 重新格式化 NameNode
./sbin/start-dfs.sh  # 重启
```
成功启动后，可以访问 Web 界面 http://192.168.2.128:50070 查看 NameNode 和 Datanode 信息，还可以在线查看 HDFS 中的文件。
## 运行伪分布式实例
上面的单机模式，grep 例子读取的是本地数据，伪分布式读取的则是 HDFS 上的数据。要使用 HDFS，首先需要在 HDFS 中创建用户目录：
`./bin/hdfs dfs -mkdir -p /user/hadoop`
接着将 ./etc/hadoop 中的 xml 文件作为输入文件复制到分布式文件系统中，即将 /usr/local/hadoop/etc/hadoop 复制到分布式文件系统中的 /user/hadoop/input 中。我们使用的是 hadoop 用户，并且已创建相应的用户目录 /user/hadoop ，因此在命令中就可以使用相对路径如 input，其对应的绝对路径就是 /user/hadoop/input:
```sh
./bin/hdfs dfs -mkdir input
./bin/hdfs dfs -put ./etc/hadoop/*.xml input
```
复制完成后，可以通过如下命令查看文件列表：
```sh
./bin/hdfs dfs -ls input
```

伪分布式运行 MapReduce 作业的方式跟单机模式相同，区别在于伪分布式读取的是HDFS中的文件（可以将单机步骤中创建的本地 input 文件夹，输出结果 output 文件夹都删掉来验证这一点）。
```sh
./bin/hadoop jar ./share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar grep input output 'dfs[a-z.]+'
```
查看运行结果的命令（查看的是位于 HDFS 中的输出结果）：
```sh
./bin/hdfs dfs -cat output/*
```
我们也可以将运行结果取回到本地：
```sh
rm -r ./output    # 先删除本地的 output 文件夹（如果存在）
./bin/hdfs dfs -get output ./output     # 将 HDFS 上的 output 文件夹拷贝到本机
cat ./output/*
```
Hadoop 运行程序时，输出目录不能存在，否则会提示错误 “org.apache.hadoop.mapred.FileAlreadyExistsException: Output directory hdfs://192.168.2.128:9000/user/hadoop/output already exists” ，因此若要再次执行，需要执行如下命令删除 output 文件夹:
```sh
./bin/hdfs dfs -rm -r output    # 删除 output 文件夹
```
### 运行程序时，输出目录不能存在
运行 Hadoop 程序时，为了防止覆盖结果，程序指定的输出目录（如 output）不能存在，否则会提示错误，因此运行前需要先删除输出目录。在实际开发应用程序时，可考虑在程序中加上如下代码，能在每次运行时自动删除输出目录，避免繁琐的命令行操作：
```java
Configuration conf = new Configuration();
Job job = new Job(conf);

/* 删除输出目录 */
Path outputPath = new Path(args[1]);
outputPath.getFileSystem(conf).delete(outputPath, true);
```
若要关闭 Hadoop，则运行
```sh
./sbin/stop-dfs.sh
```
## 启动YARN
伪分布式不启动 YARN 也可以，一般不会影响程序执行）

有的读者可能会疑惑，怎么启动 Hadoop 后，见不到书上所说的 JobTracker 和 TaskTracker，这是因为新版的 Hadoop 使用了新的 MapReduce 框架（MapReduce V2，也称为 YARN，Yet Another Resource Negotiator）。

YARN 是从 MapReduce 中分离出来的，负责资源管理与任务调度。YARN 运行于 MapReduce 之上，提供了高可用性、高扩展性，YARN 的更多介绍在此不展开，有兴趣的可查阅相关资料。

上述通过 ./sbin/start-dfs.sh 启动 Hadoop，仅仅是启动了 MapReduce 环境，我们可以启动 YARN ，让 YARN 来负责资源管理与任务调度。

首先修改配置文件 mapred-site.xml，这边需要先进行重命名：
```sh
mv ./etc/hadoop/mapred-site.xml.template ./etc/hadoop/mapred-site.xml
```
然后再进行编辑，同样使用 gedit 编辑会比较方便些 gedit ./etc/hadoop/mapred-site.xml ：
```xml
<configuration>
        <property>
             <name>mapreduce.framework.name</name>
             <value>yarn</value>
        </property>
</configuration>
```
接着修改配置文件 yarn-site.xml：
```xml
<configuration>
        <property>
             <name>yarn.nodemanager.aux-services</name>
             <value>mapreduce_shuffle</value>
            </property>
</configuration>
```
然后就可以启动 YARN 了（需要先执行过 ./sbin/start-dfs.sh）：
```sh
./sbin/start-yarn.sh      # 启动YARN
./sbin/mr-jobhistory-daemon.sh start historyserver  # 开启历史服务器，才能在Web中查看任务运行情况
```
启动 YARN 之后，运行实例的方法还是一样的，仅仅是资源管理方式、任务调度不同。观察日志信息可以发现，不启用 YARN 时，是 “mapred.LocalJobRunner” 在跑任务，启用 YARN 之后，是 “mapred.YARNRunner” 在跑任务。启动 YARN 有个好处是可以通过 Web 界面查看任务的运行情况：http://192.168.2.128:8088/cluster
但 YARN 主要是为集群提供更好的资源管理与任务调度，然而这在单机上体现不出价值，反而会使程序跑得稍慢些。因此在单机上是否开启 YARN 就看实际情况了。

`如果不想启动 YARN，务必把配置文件 mapred-site.xml 重命名，改成 mapred-site.xml.template，需要用时改回来就行。否则在该配置文件存在，而未开启 YARN 的情况下，运行程序会提示 “Retrying connect to server: 0.0.0.0/0.0.0.0:8032” 的错误，这也是为何该配置文件初始文件名为 mapred-site.xml.template。`
关闭YARN的脚本如下：
```sh
./sbin/stop-yarn.sh
./sbin/mr-jobhistory-daemon.sh stop historyserver
```




[hadoop-install]: http://www.powerxing.com/install-hadoop/ "Hadoop安装教程_单机/伪分布式配置_Hadoop2.6.0/Ubuntu14.04"
[hadoop.apache.org]: http://hadoop.apache.org/releases.html "hadoop.apache.org"
