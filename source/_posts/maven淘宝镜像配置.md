---
title: maven淘宝镜像配置
date: 2017-01-14 15:05:20
tags:
---
修改`settings.xml`文件中的镜像配置即可
```xml
<mirrors>
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>        
    </mirror>
</mirrors>
```