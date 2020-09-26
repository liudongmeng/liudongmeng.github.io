---
title: WSO2
category:
  - 笔记
date: 2020-09-20 21:07:38
tags:
---

Enterprise Integrator

<!-- more -->

```shell 安装WSO2
$ sudo yum install ./wso2ei-linux-installer-x64-7.1.0.rpm
[sudo] password for centos:
Last metadata expiration check: 2:20:24 ago on Sun Sep 20 06:45:14 2020.
Dependencies resolved.
=========================================================================================================================================================
 Package                          Architecture                     Version                                  Repository                              Size
=========================================================================================================================================================
Installing:
 wso2ei                           x86_64                           7.1.0-1.el7                              @commandline                           445 M

Transaction Summary
=========================================================================================================================================================
Install  1 Package

Total size: 445 M
Installed size: 697 M
Is this ok [y/N]: y
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                 1/1
  Running scriptlet: wso2ei-7.1.0-1.el7.x86_64                                                                                                       1/1

PLEASE READ THE WSO2 SOFTWARE LICENSE CAREFULLY BEFORE COMPLETING THE INSTALLATION PROCESS AND USING THE SOFTWARE.
"/usr/share/doc/wso2/LICENSE.txt" may be a binary file.  See it anyway? Installing WSO2 Enterprise Integrator 7.1.0...

  Installing       : wso2ei-7.1.0-1.el7.x86_64                                                                                                       1/1
  Running scriptlet: wso2ei-7.1.0-1.el7.x86_64                                                                                                       1/1
Creating shortcuts for name profiles...
Creating wso2 user and group...
Initializing service script file...
. . .
WSO2 Enterprise Integrator installed on : "/usr/lib64/wso2/wso2ei/7.1.0/"
To start WSO2 Micro Integrator as a service, open a new terminal and run:
     $ sudo service wso2mi start
To start WSO2 Micro Integrator Dashboard as a service, open a new terminal and run:
     $ sudo service wso2mi-dashboard start
To start WSO2 Streaming Integrator as a service, open a new terminal and run:
     $ sudo service wso2si start
. . .

  Verifying        : wso2ei-7.1.0-1.el7.x86_64                                                                                                       1/1

Installed:
  wso2ei-7.1.0-1.el7.x86_64

Complete!
```