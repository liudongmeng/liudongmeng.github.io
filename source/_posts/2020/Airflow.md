---
title: Airflow
tags:
  - Workflow
category:
  - 笔记
date: 2020-09-13 21:32:17
---


Airflow是一个社区创建的平台,用于以编程的方式创作,调度和监控工作流.

<!-- more -->

## 设计原则

* 可伸缩,Airflow拥有模块化的架构,通过一个消息队列来编排任意数量的worker,具备无限扩展的能力.
* 动态性,Airflow管道通过Python代码配置,可以动态生成管道,可以动态实例化管道代码.
* 可扩展,可以轻松的定义自己的运算符,执行程序并且扩展代码库,适用于抽象级别的环境适配.
* 优雅,Airflow管道简单易用,使用强大的Jinja模板引擎使得脚本可以实现参数化.

## 特性

### 纯Python

> 没有命令行或者xml的黑魔法.
> 使用完整的Python特性来创建您的工作流.
> 使用时间格式来调度任务,使用循环动态的创建任务,从而允许用户完全按照自己的意愿创建工作流.

### 有用的界面

> 使用Web应用来监控,调度和管理工作流.
> 无需学习陈旧的类cron接口.
> 通过洞悉日志实现洞悉已完成和正在进行的任务状态.

### 丰富的集成

> Airflow提供了很多即插即用的运算符,可以立即用与管理Google CloudPlatform,Amazon Web Services,Microsoft Azure和其他的云服务中的任务.
> 这使得Airflow可以很方便的集成到现有的基础架构中.

### 易用

> 任何具有Python知识的人都可以部署工作流.
> Apache Airflow不限制管道的范围,你可以用它来构建机器学习模型,交换数据或者管理基础架构.

### 开源

> 您可以通过打开PR来分享自己的改进.
> 简单,没有阻碍,没有冗长的过程.
> Airflow有许多活跃的用户愿意分享他们的经验.

## 概览

> 使用Airflow来编写由不同任务组成的DAG(有向无环图)工作流.
> Airflow调度器会根据指定的依赖关系在一系列worker节点上执行任务.
> 丰富的命令行工具使得在DAG上执行复杂的手术变得轻而易举.
> 丰富的UI使得查看生产中运行的管道,监控进度和排除故障变得容易.

将工作流定义为代码时,它们将变得更加易于维护,版本化,易于测试和协作.

### Beyond the Horizon

> Airflow不是数据流解决方案.
> 任务不会将数据在任务见传递(尽管任务可以交换元数据).
> Airflow不属于Spark Streaming或者Storm的范畴,它更类似于Oozie或者Azkaban.
> 工作流通常被认为是静态的或者是缓慢变化的.
> 可以认为工作流中的任务结构比数据库结构的动态性更强.
> Airflow工作流被认为是任务的连续执行过程,使得工作单元的连续性变得更清晰.

## 入门

Airflow的安装十分快速和直接

```sh
# airflow needs a home, ~/airflow is the default,
# but you can lay foundation somewhere else if you prefer
# (optional)
# airflow需要一个主目录,默认是~/airflow,也可以根据喜好修改(可选)
export AIRFLOW_HOME=~/airflow

# install from pypi using pip
# 通过pip在pypi上安装
pip install apache-airflow

# initialize the database
# 初始化数据库
airflow initdb

# start the web server, default port is 8080
# 启动web服务,默认端口为8080
airflow webserver -p 8080

# start the scheduler
# 开启调度器
airflow scheduler

# visit localhost:8080 in the browser and enable the example dag in the home page
# 通过浏览器浏览http://localhost:8080
# 并且在主页中开启示例DAG
```

通过执行上述命令,Airflow将会创建`$AIRFLOW_HOME`文件夹并且放置一个带有默认设置的`airflow.cfg`文件,使得用户可以快速入门.
可以通过`$AIRFLOW_HOME/airflow.cfg`或者WebUI中的`Admin-Configuration`来观察配置文件.
web服务器的PID文件存储在`$AIRFLOW_HOME/airflow-webserver.pid`.
当web服务器由systemd启动时,PID文件存储在`/run/airflow/webserver.pid`路径.

除此之外,Airflow使用sqlite数据库,由于使用此数据库不具备并行能力.
Airflow与`airflow.executors.sequential_executor.SequentialExecutor`结合使用,后者只用于顺序运行任务实例.

这里有一些触发任务实例的命令.
运行以下命令时应该可以在example1的DAG中查看作业的状态变更.

```zsh
# run your first task instance
airflow run example_bash_operator runme_0 2020-09-13
# run a backfill over 2 days
airflow backfill example_bash_operator -s 2020-09-13 -e 2020-09-14
```
