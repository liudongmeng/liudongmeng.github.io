---
title: Azkaban
tags:
  - Workflow
category:
  - 笔记
date: 2020-09-13 20:11:12
---


Azkaban 是一款由领英创建,用于 Hadoop 任务场景的分布式批量工作流任务调度工具.Azkaban 解决了任务依赖循序的问题,并且提供了简单易用的 WebUI 接口,用于维护和跟踪您的工作流.

<!-- more -->

Azkaban 具有以下特性

- 适用于任意版本的 Hadoop
- 简单易用的 WebUI
- 便捷的基于 web/http 的工作流上传功能
- 项目工作空间
- 工作流调度
- 模块化和插件化
- 授权和认证
- 追踪用户行为
- 失败/成功的邮件提醒
- SLA 报警以及自动取消
- 失败任务重试

Azkaban 在设计时主要考虑到易用性.它在领英已经使用了一些年份,驱动了公司的很多 Hadoop 和数据仓库处理工作.

## 入门

Azkaban 3.0 之后的版本提供两种模式:

1. `solo-server`模式,基于嵌入的`H2`数据库,web 服务器和执行服务器在同一个进程中运行,适用于学习研究场景,同样适用于小规模的用户案例.
2. 分布式多执行者(`distributed multiple-executor`)模式,基于主从模式的 MySQL 数据库,web 服务器和执行服务器分别在不同的服务器上运行,这样升级和维护工作将不会影响用户,多服务器的配置使得 Azkaban 系统具备了更高的鲁棒性和扩展能力.

部署通常分为以下步骤:

- 配置数据库
- 配置用于多执行者的数据库
- 下载并在数据中配置的每个执行者服务器上安装`Executor Server`
- 安装 Azkaban 插件
- 安装 Web 服务

下面将为大家介绍如何配置 Azkaban

## 从源码编译

Azkaban 的编译使用 Gradle 工具,需要 Java8 以上的版本

在`*nix`设备上执行下列命令(例如 Linux/MacOS)

```zsh
# Build Azkaben
./gradlew build

# Clean the build
./gradlew clean

# Build and install distributions
./gradlew installDist

# Run tests
./gradlew test

# Build without running tests
./gradlew build -x test
```

### `Solo Server`入门

solo server 是 Azkaban 的单实例独立运行模式,有以下优势:

- 易于安装,不需要 MySQL 实例,包含了 H2 作为主要的持久化存储
- 易于装配,Web 服务器和执行服务器在同一个进程中运行
- 包含全特性,包含了 Azkaban 的完整特性

#### 安装`Solo Server`

- 克隆仓库

```zsh
git clone https://github.com/azkaban/azkaban.git
```

- 构建并创建安装包

```zsh
cd azkaban; ./gradlew build installDist
```

- 启动 solo server

```zsh
cd azkaban-solo-server/build/install/azkaban-solo-server; bin/start-solo.sh
```

Azkaban 独立服务器应该全部配置完成,通过监听默认端口`8081`的方式接受网络请求.所以,打开浏览器检查`http://localhost:
8081/`.默认的登录用户名密码在配置文件中`conf/azkaban.xml`配置.

关闭服务

```zsh
bin/shutdown-solo.sh
```

## 编译问题

Azkaban依赖于JavaFX中的包,但是由于OpenJDK默认没有包含,所以默认编译会报错

### CentOS

CentOS环境下,官方的源没有包含openjfx,可以选择手动编译安装,也可以选择安装Oracle JDK(默认包含JavaFX)

### 安装OpenJFX

Ubuntu系统下直接执行

```zsh
sudo apt-get install openjfx
```

### 添加maven镜像

编译过程中gradle会去仓库中下载相关依赖,添加aliyun镜像仓库

```gradle
allprojects {
  apply plugin: 'jacoco'

  repositories {
    maven {
        url 'https://maven.aliyun.com/repository/public'
    }
    mavenLocal()
    mavenCentral()
  }
}
```

### 时区

Azkaban默认配置为美国/洛杉矶时区,与中国有15个小时的时差,改为亚洲/上海

```properties
# default.timezone.id=America/Los_Angeles
default.timezone.id=Asia/Shanghai
```