---
title: CentOS常见问题
category:
  - 笔记
date: 2020-09-15 11:45:42
update: 2020-09-20 20:34:11
tags:
---


记录一些比较反直觉的问题,以后可以快速检索解决

<!-- more -->

## 配置 authorized_keys 之后无法免密码登录

通常是由于 authorized_keys 文件权限问题导致的

配置文件`/etc/ssh/sshd_config`,配置项都比较常规,有两个权限要注意

```zsh 修改权限
# rw
chmod 600 .ssh/authorized_keys
# rwx
chmod 700 .ssh
```

修改文件访问权限之后正常

## 创建新用户

例如用户名为 zhangsan

```zsh 创建超级管理员
# 创建用户
adduser zhangsan
# 创建密码
passwd zhangsan
# 获取超级管理员文件路径
whereis sudoers
# sudoers: /etc/sudoers.d /etc/sudoers /usr/share/man/man5/sudoers.5.gz
# 赋予管理员配置文件写入权限
chmod u+w /etc/sudoers
# 编辑后保存
# 删除配置文件的写入权限
chmod u-x /etc/sudoers
```

```ini /etc/sudoers
## Next comes the main part: which users can run what software on
## which machines (the sudoers file can be shared between multiple
## systems).
## Syntax:
##
##      user    MACHINE=COMMANDS
##
## The COMMANDS section may have other options added to it.
##
## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
centos  ALL=(ALL)       ALL
```

## 清华镜像

### yum

修改`/etc/yum.repos.d/CentOS-Base.repo`

```ini /etc/yum.repos.d/CentOS-Base.repo https://mirrors.tuna.tsinghua.edu.cn/help/centos/ CentOS镜像使用帮助
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#



[BaseOS]
name=CentOS-$releasever - Base
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/BaseOS/$basearch/os/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=BaseOS&infra=$infra
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[AppStream]
name=CentOS-$releasever - AppStream
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/AppStream/$basearch/os/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=AppStream&infra=$infra
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[PowerTools]
name=CentOS-$releasever - PowerTools
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/PowerTools/$basearch/os/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=PowerTools&infra=$infra
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial


#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/extras/$basearch/os/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial



#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/centosplus/$basearch/os/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
```

```bash 清除yum缓存
# 清除缓存
$ sudo yum makecache
```

### docker

#### 安装

```zsh 配置Docker源镜像 https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/ Docker Community Edition 镜像使用帮助
# 删除之前安装的软件
$ sudo yum remove docker docker-common docker-selinux docker-engine
# 官方删除
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
# 安装依赖
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2
# 根据发行版下载repo文件
$ wget -O /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
# 替换仓库地址
$ sudo sed -i 's+download.docker.com+mirrors.tuna.tsinghua.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo
# 安装
$ sudo yum makecache fast
$ sudo yum install docker-ce --nobest -y
# $ sudo dnf install docker-ce --nobest -y
# $ sudo yum install docker-ce
```

#### 配置

到此为止,非 root 用户在执行`docker`命令时会遇到权限不足的情况,需要在 docker 用户组中添加当前用户

```shell 添加用户到Docker分组
$ docker ps
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.40/containers/json: dial unix /var/run/docker.sock: connect: permission denied
$ sudo groupadd docker #添加docker用户组
groupadd: group 'docker' already exists
$ sudo gpasswd -a $USER docker #将登陆用户加入到docker用户组中
[sudo] password for centos:
Adding user centos to group docker
$ newgrp docker #更新用户组
$ docker ps
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
$ systemctl start docker
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ====
Authentication is required to start 'docker.service'.
Authenticating as: root
Password:
==== AUTHENTICATION COMPLETE ====
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

#### 配置镜像源

```shell
# 添加网易源
$ vi /etc/docker/daemon.json
{
    "registry-mirrors": [ "https://hub-mirror.c.163.com/",
                          "https://registry.docker-cn.com/",
                          "https://dockerhub.azk8s.cn/",
                          "https://docker.mirrors.ustc.edu.cn/",
                          "https://mirror.ccs.tencentyun.com/"]
}
```

| 提供方      | 地址                                 |
| ----------- | ------------------------------------ |
| 网易        | `https://hub-mirror.c.163.com`       |
| docker 中国 | `https://registry.docker-cn.com`     |
| Azure       | `https://dockerhub.azk8s.cn`         |
| 中科大      | `https://docker.mirrors.ustc.edu.cn` |
| 腾讯云      | `https://mirror.ccs.tencentyun.com`  |

## dnf

[dnf][dnf]是新一代的 rpm 软件包管理工具,据说将会取代 yum.

DNF 包管理器克服了 YUM 包管理器的一些瓶颈，提升了包括用户体验，内存占用，依赖分析，运行速度等多方面的内容。DNF 使用 RPM, libsolv 和 hawkey 库进行包管理操作。尽管它没有预装在 CentOS 和 RHEL 7 中，但你可以在使用 YUM 的同时使用 DNF 。你可以在这里获得关于 DNF 的更多知识：[《 DNF 代替 YUM ，你所不知道的缘由》][dnf代替yum,你所不知道的缘由]

[dnf]: https://man.linuxde.net/dnf
[dnf代替yum,你所不知道的缘由]: http://www.tecmint.com/dnf-next-generation-package-management-utility-for-linux/
