---
title: java写入OpenTSDB
date: 2017-01-07 22:20:02
tags:
category: [笔记,OpenTSDB]
---
***

#### *放个链接*

[GitBlog](https://hisashiburidane.github.io)

# 其实我就是先练习练习Markdown
<!--more-->
OpenTSDB用webapi还是觉得有点性能问题，试一下java api，写入成功，明天写个循环测一下性能
linux环境下java的编译还要多用用，还要改环境变量好麻烦……
还有几个问题需要翻一下源代码
1. 在服务器上localhost环境可以写入hbase，但是到其他机器上怎么调，配置文件应该是有体现，顺着构造函数往下看
这个问题已经解决了
`# 注意
在winodws下的 C:\Windows\System32\drivers\etc\hosts文件中
   添加服务器端host与ip的映射关系
   如： 10.8.1.135 master`
2. 之前webapi调用post数据的时候，数据长度超过限制之后会导致连接关闭，服务端报的是netty的错误，也要翻一下看能不能解决，毕竟webapi调起来比较简单，13k/s应该还远没到极限    
## 修改环境变量  
```batch
vim ~/.bashrc
```
## 内容修改
```batch
export PROJECT_HOME=~/bo
for loop in `ls $PROJECT_HOME/*.jar`;do
export CLASSPATH=${loop}:${CLASSPATH}
done
```

>引用


## 调用addPoint代码
```Java
import java.util.HashMap;
import java.util.Map;
import net.opentsdb.core.TSDB;
import net.opentsdb.utils.Config;

public class opentsdb {
        public static void main(String[] args) throws Exception {
                String path="opentsdb.conf";
                Config config=new Config(path);
                TSDB db= new TSDB(config);
                String metric= "mysql.bytes_received";
                long timeStamp =2;
                long value=1;
                Map<String, String> tags= new HashMap<String, String>();
                hmap.put("host", "web04");
                db.addPoint(metric, timeStamp, value,tags);
        }
}
```
通过配置文件实例化对象
`TSDB db= new TSDB(config);`
***
## 编译/调用
```batch
javac opentsdb.java
java opentsdb
```

## 实验一个表格，没有现成的，先放个例子，回头有的时候再做
>| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |