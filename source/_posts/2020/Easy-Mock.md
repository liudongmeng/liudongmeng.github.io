---
title: Easy Mock
category:
  - 笔记
date: 2020-09-19 22:55:44
update: 2020-09-20 20:34:11
tags:
---

国产软件,搜了很多资料好像外国人不是很在意 mock server 这个东西?

<!-- more -->

## 依赖环境

小规模的应用,使用 docker 安装完全足够用了,可以参考[这里][docker安装]

### MongoDB

```shell Docker安装MongoDB https://hub.docker.com/_/mongo DockerHub/mongo
$ docker pull mongo
Using default tag: latest
latest: Pulling from library/mongo
5d9821c94847: Pull complete
a610eae58dfc: Pull complete
a40e0eb9f140: Pull complete
3242ba6cef1f: Pull complete
8ade7416f0cf: Pull complete
cd8d2aab224e: Pull complete
9d8c2ff7f392: Pull complete
d29b99c4ab4c: Pull complete
5d1ed7c1266e: Pull complete
77f31d60b382: Pull complete
e328c48077a2: Pull complete
31085c577c4a: Pull complete
Digest: sha256:ebcdb042054d9974c8c3160d761b0bdb39b55115448242de1a5161c124ddb0af
Status: Downloaded newer image for mongo:latest
docker.io/library/mongo:latest
# 创建并启动docker容器
$ docker run -itd --name mongo -p 27017:27017 mongo --auth
46b83cc20eb4c7270cb961ea00a6ac0df6ffdc1ff0ac6921e3eef546e163eb46
```

```shell 创建用户
$ docker exec -it mongo mongo admin
# 创建一个名为 root,密码为 p@ssw0rd 的用户。
>  db.createUser({ user:'root',pwd:'p@ssw0rd',roles:[ { role:'userAdminAnyDatabase', db: 'admin'}]});
Successfully added user: {
"user" : "root",
 "roles" : [
  {
   "role" : "userAdminAnyDatabase",
   "db" : "admin"
  }
 ]
}
# 尝试使用上面创建的用户信息进行连接。
> db.auth('root', 'p@ssw0rd')
1
# 创建一个名为 easymock，密码为 p@ssw0rd 的用户,具备easymock数据库的读写权限
> db.createUser({ user:'easymock',pwd:'p@ssw0rd',roles:["root"]});
Successfully added user: { "user" : "easymock", "roles" : [ "root" ] }
```

### Redis

```shell Docker安装Redis https://hub.docker.com/_/redis DockerHub/redis
$ docker pull redis
Using default tag: latest
latest: Pulling from library/redis
d121f8d1c412: Pull complete
2f9874741855: Pull complete
d92da09ebfd4: Pull complete
bdfa64b72752: Pull complete
e748e6f663b9: Pull complete
eb1c8b66e2a1: Pull complete
Digest: sha256:1cfb205a988a9dae5f025c57b92e9643ec0e7ccff6e66bc639d8a5f95bba928c
Status: Downloaded newer image for redis:latest
docker.io/library/redis:latest
$ docker run -itd --name redis -p 6379:6379 redis
997037310c17fb6109a42c3432fa910dc2e20ded8b863a9c572e022cc932f4cf
```

```shell 使用Redis-Cli登录
$ docker exec -it redis /bin/bash
root@997037310c17:/data# redis-cli
127.0.0.1:6379> hkeys all;
(empty array)
```

### nodejs

实际测试下来,EasyMock`不支持10.x和12.x的node环境`,因此需要安装[`8.x`][nodejs-latest-v8.x]

```shell 安装NodeJS https://nodejs.org/dist/latest-v8.x/ nodejs-v8.x-latest
# 下载压缩包
$ wget https://nodejs.org/dist/latest-v8.x/node-v8.17.0-linux-x64.tar.xz
--2020-09-20 07:48:29--  https://nodejs.org/dist/latest-v8.x/node-v8.17.0-linux-x64.tar.xz
Resolving nodejs.org (nodejs.org)... 104.20.22.46, 104.20.23.46, 2606:4700:10::6814:172e, ...
Connecting to nodejs.org (nodejs.org)|104.20.22.46|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 11820040 (11M) [application/x-xz]
Saving to: 'node-v8.17.0-linux-x64.tar.xz'

node-v8.17.0-linux-x64.tar.xz          100%[=========================================================================>]  11.27M  77.9KB/s    in 78s

2020-09-20 07:49:48 (148 KB/s) - 'node-v8.17.0-linux-x64.tar.xz' saved [11820040/11820040]

# 解压
$ xz -d ./node-v8.17.0-linux-x64.tar.xz && tar -xvf ./node-v8.17.0-linux-x64.tar
# 更改路径
$ mv ./node-v8.17.0-linux-x64 $HOME/deployment/nodejs
# 写入环境变量
$ cat>>$HOME/.bash_profile<<EOF
# NODE ENV
export NODEPATH=$HOME/deployment/nodejs
export PATH=\$PATH:$NODEPATH/bin
EOF
# 刷新环境变量
$ source $HOME/.bash_profile
$ node --version
v8.17.0
```

## 安装 EasyMock

```shell 安装EasyMock https://github.com/easy-mock/easy-mock EasyMock
$ git clone https://github.com/easy-mock/easy-mock.git
$ cd easy-mock && npm install
npm WARN ajv-keywords@2.1.1 requires a peer of ajv@^5.0.0 but none is installed. You must install peer dependencies yourself.
npm WARN easy-mock@1.6.0 No repository field.
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@1.1.3 (node_modules/fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.1.3: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})

audited 1820 packages in 18.413s
found 1850 vulnerabilities (928 low, 140 moderate, 780 high, 2 critical)
  run `npm audit fix` to fix them, or `npm audit` for details
```

```json 修改配置文件
{
  "port": 7300,
  "host": "0.0.0.0",
  "pageSize": 30,
  "proxy": false,
  // "db": "mongodb://admin:'p@ssw0rd'@localhost:27017/easy-mock",
  "db": "mongodb://localhost/easy-mock",
  "unsplashClientId": "",
  "redis": {
    "keyPrefix": "[Easy Mock]",
    "port": 6379,
    "host": "localhost",
    "password": "",
    "db": 0
  },
  "blackList": {
    "projects": [], // projectId，例："5a4495e16ef711102113e500"
    "ips": [] // ip，例："127.0.0.1"
  },
  "rateLimit": {
    // https://github.com/koajs/ratelimit
    "max": 1000,
    "duration": 1000
  },
  "jwt": {
    "expire": "14 days",
    "secret": "shared-secret"
  },
  "upload": {
    "types": [".jpg", ".jpeg", ".png", ".gif", ".json", ".yml", ".yaml"],
    "size": 5242880,
    "dir": "../public/upload",
    "expire": {
      "types": [".json", ".yml", ".yaml"],
      "day": -1
    }
  },
  "ldap": {
    "server": "", // 设置 server 代表启用 LDAP 登录。例："ldap://localhost:389" 或 "ldaps://localhost:389"（使用 SSL）
    "bindDN": "", // 用户名，例："cn=admin,dc=example,dc=com"
    "password": "",
    "filter": {
      "base": "", // 查询用户的路径，例："dc=example,dc=com"
      "attributeName": "" // 查询字段，例："mail"
    }
  },
  "fe": {
    "copyright": "",
    "storageNamespace": "easy-mock_",
    "timeout": 25000,
    "publicPath": "/dist/"
  }
}
```

```shell 运行
# 全局安装pm2
$ npm install -g --registry=http://registry.npm.taobao.org/ pm2
/home/centos/deployment/nodejs/bin/pm2 -> /home/centos/deployment/nodejs/lib/node_modules/pm2/bin/pm2
/home/centos/deployment/nodejs/bin/pm2-docker -> /home/centos/deployment/nodejs/lib/node_modules/pm2/bin/pm2-docker
/home/centos/deployment/nodejs/bin/pm2-dev -> /home/centos/deployment/nodejs/lib/node_modules/pm2/bin/pm2-dev
/home/centos/deployment/nodejs/bin/pm2-runtime -> /home/centos/deployment/nodejs/lib/node_modules/pm2/bin/pm2-runtime
npm WARN notsup Unsupported engine for mkdirp@1.0.4: wanted: {"node":">=10"} (current: {"node":"8.17.0","npm":"6.13.4"})
npm WARN notsup Not compatible with your version of node/npm: mkdirp@1.0.4
npm WARN notsup Unsupported engine for semver@7.3.2: wanted: {"node":">=10"} (current: {"node":"8.17.0","npm":"6.13.4"})
npm WARN notsup Not compatible with your version of node/npm: semver@7.3.2
npm WARN notsup Unsupported engine for semver@7.2.3: wanted: {"node":">=10"} (current: {"node":"8.17.0","npm":"6.13.4"})
npm WARN notsup Not compatible with your version of node/npm: semver@7.2.3
npm WARN ws@7.2.5 requires a peer of bufferutil@^4.0.1 but none is installed. You must install peer dependencies yourself.
npm WARN ws@7.2.5 requires a peer of utf-8-validate@^5.0.2 but none is installed. You must install peer dependencies yourself.
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@2.1.3 (node_modules/pm2/node_modules/fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@2.1.3: wanted {"os":"darwin","arch":"any"} (current: {"os":"linux","arch":"x64"})

+ pm2@4.4.1
added 186 packages from 191 contributors in 16.098s
# 编译项目
$ npm run build
$ NODE_ENV=production pm2 start app.js
```

<!-- {% post_link CentOS常见问题 Docker的安装 %} -->

[docker安装]: /2020/09/15/CentOS常见问题/#docker "CentOS常见问题#docker"
[nodejs-latest-v8.x]: https://nodejs.org/dist/latest-v8.x/
[npm镜像]: http://registry.npm.taobao.org/
