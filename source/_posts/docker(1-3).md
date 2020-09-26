---
title: docker(1-3)
date: 2017-04-30 16:05:21
tags: [docker]
category: [笔记,docker]
---
抽空看一下[Docker][Docker]
<!--more-->

## 安装

### CentOS

```zsh
#
$ sudo yum install -y yum-utils
#
$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
# 安装相关工具
$ sudo yum install docker-ce docker-ce-cli containerd.io
# 启动docker服务
$ systemctl start docker
```

### Ubuntu

[官方文档][Part1]

```bash
sudo apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

sudo apt-get update
sudo apt-get -y install docker-ce
```

HelloWorld
网络原因可能会拉不到镜像,这里就可以考虑[改镜像仓库][改用镜像仓库]了

```sh
$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
78445dd45222: Pull complete 
Digest: sha256:c5515758d4c5e1e838e9cd307f6c6a0d620b5e07e6f927b07d05f6d12a1ac8d7
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://cloud.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/

```

其他系统安装过程大差不差吧

## 容器

[官方文档][Part2]

### 配置环境

新建一个文件夹存放相关的文件
首先是`Dockerfile`

```bash
# Use an official Python runtime as a base image
FROM python:2.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
```

>This Dockerfile refers to a couple of things we haven’t created yet, namely app.py and requirements.txt. Let’s get those in place next.

然后是`requirements.txt`

```sh
Flask
Redis
```

最后是`app.py`

```py
from flask import Flask
from redis import Redis, RedisError
import os
import socket

# Connect to Redis
redis = Redis(host="redis", db=0)

app = Flask(__name__)

@app.route("/")
def hello():
    try:
        visits = redis.incr('counter')
    except RedisError:
        visits = "<i>cannot connect to Redis, counter disabled</i>"

    html = "<h3>Hello {name}!</h3>" \
           "<b>Hostname:</b> {hostname}<br/>" \
           "<b>Visits:</b> {visits}"
    return html.format(name=os.getenv('NAME', "world"), hostname=socket.gethostname(), visits=visits)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
```

### 改用镜像仓库

官方的仓库地址是在是太卡太卡太卡了,而且很容易断开,自己注册了一个阿里的,速度不很快但是还算稳定
这里是[参考文章][配置registry]

```bash
$ vi /etc/default/docker
DOCKER_OPTS="--registry-mirror=http://registry.cn-hangzhou.aliyuncs.com/sayonara/private"
# 重启服务使配置生效
$ service docker restart
```

### build

```sh
$ ls
Dockerfile app.py requirements.txt
# 后面有个点,应该是当前路径的意思
$ docker build -t friendlyhello .
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
friendlyhello       latest              8b3b8bb5ae50        20 seconds ago      194 MB
python              2.7-slim            7fd4e5a52ace        3 days ago          182 MB
hello-world         latest              48b5124b2768        3 months ago        1.84 kB
```

### Run the app

```bash
# 在容器内启动应用,并且将地址映射到外部的4000端口
# 这里应用起来了没问题,但是不知道为什么访问一直不正常,好像redis有点问题
$ docker run -p 4000:80 friendlyhello
 * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)
# 查看启动的docker应用
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                  NAMES
d7c99c812184        friendlyhello       "python app.py"     2 minutes ago       Up 2 minutes        0.0.0.0:4000->80/tcp   kind_bose
# 停止应用
$ docker stop d7c99c812184
```

### 发布容器

这个就类似npm和bower的发布了,私有库的话文档指向[Docker Trusted Registry][Docker Trusted Registry],用到了再看,懒得注册账号了,就记录一下命令吧

```bash
$ docker login
# Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
$ docker tag friendlyhello username/repository:tag
$ docker push username/repository:tag
# 这里类似第一步docker run hello-world,从远程仓库直接启动容器
$ docker run -p 4000:80 username/repository:tag
```

### 相关命令

```bash
docker build -t friendlyname .  # Create image using this directory's Dockerfile
docker run -p 4000:80 friendlyname  # Run "friendlyname" mapping port 4000 to 80
docker run -d -p 4000:80 friendlyname         # Same thing, but in detached mode
docker ps                                 # See a list of all running containers
docker stop <hash>                     # Gracefully stop the specified container
docker ps -a           # See a list of all containers, even the ones not running
docker kill <hash>                   # Force shutdown of the specified container
docker rm <hash>              # Remove the specified container from this machine
docker rm $(docker ps -a -q)           # Remove all containers from this machine
docker images -a                               # Show all images on this machine
docker rmi <imagename>            # Remove the specified image from this machine
docker rmi $(docker images -q)             # Remove all images from this machine
docker login             # Log in this CLI session using your Docker credentials
docker tag <image> username/repository:tag  # Tag <image> for upload to registry
docker push username/repository:tag            # Upload tagged image to registry
docker run username/repository:tag                   # Run image from a registry
```

## 服务

[官方文档][Part3]

>In a distributed application, different pieces of the app are called “services.” For example, if you imagine a video sharing site, there will probably be a service for storing application data in a database, a service for video transcoding in the background after a user uploads something, a service for the front-end, and so on.

>A service really just means, “containers in production.” A service only runs one image, but it codifies the way that image runs – what ports it should use, how many replicas of the container should run so the service has the capacity it needs, and so on. Scaling a service changes the number of container instances running that piece of software, assigning more computing resources to the service in the process.

>Luckily it’s very easy to define, run, and scale services with the Docker platform – just write a docker-compose.yml file.

部署服务大概是这样的过程

1. 创建一个容器
1. 并且发布出来
1. 通过`docker-compose.yml`配置服务
1. 通过docker运行

### 配置

```yml
version: "3"
services:
  web:
    image: username/repository:tag
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "80:80"
    networks:
      - webnet
networks:
  webnet:
```

`docker-compose.yml`这个文件告诉Docker做五件事

1. 启动五个指定的容器线程,命名为`web`,限制每个线程最多占用10%的CPU资源和50MB的内存
1. 服务故障立刻重启
1. 映射服务器的80端口到服务的80端口
1. 通过`webnet`进行负载均衡,容器通过临时端口(an ephemeral port)将自己发布到`web`服务的80端口
1. 使用默认设置定义`webnet`(负载均衡网络)

### 运行

使用`docker stack deploy`命令之前需要先执行下列命令,否则将提示`this node is not a swarm manager`

```bash
$ docker swarm init
# 部署
$ docker stack deploy -c docker-compose.yml getstartedlab
# 查看加载的容器列表
$ docker stack ps getstartedlab
```

### 扩展

直接修改`docker-compose.yml`文件,重新部署服务,即可扩展应用的配置

```bash
# Docker会自动更新配置,不需要停掉现有的服务
$ docker stack deploy -c docker-compose.yml getstartedlab
# Take down the app
$ docker stack rm getstartedlab
```

### 相关命令

```bash
docker stack ls              # List all running applications on this Docker host
docker stack deploy -c <composefile> <appname>  # Run the specified Compose file
docker stack services <appname>       # List the services associated with an app
docker stack ps <appname>   # List the running containers associated with an app
docker stack rm <appname>                             # Tear down an application
```

先写到这里,集群什么的用到了再说...感觉这是运维的东西

[改用镜像仓库]: #改用镜像仓库 "改用镜像仓库"
[配置registry]: http://blog.csdn.net/qq_26091271/article/details/51501768 "Docker学习笔记 — 配置国内免费registry mirror"
[Docker Trusted Registry]: https://docs.docker.com/datacenter/dtr/2.2/guides/ "Docker Trusted Registry"
[Docker]: https://www.docker.com/ "Docker"
[Part1]: https://docs.docker.com/get-started/ "Orientation and Setup"
[Part2]: https://docs.docker.com/get-started/part2/ "Containers"
[Part3]: https://docs.docker.com/get-started/part3/ "Services"