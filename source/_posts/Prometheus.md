---
title: Prometheus
category:
  - 笔记
date: 2020-03-15 16:25:33
tags:
---

## Prometheus介绍

Prometheus 是一款开源的系统监控和报警工具包,主要提供了以下功能

> 1. 多维数据模型,用`key-value`的方式标识时序数据
> 2. PromQL,利用这种数据类型的灵活的查询语言
> 3. 互不相关的分布式存储,单独的服务节点之间互相独立
> 4. 通过基于 HTTP 协议的拉取式的时序数据的收集
> 5. 支持通过中间件网关的方式推送时序数据
> 6. 可以通过静态的配置文件和"服务发现"技术发现监控目标
> 7. 丰富的图形化模型和仪表盘支持

<!--more-->

Prometheus的生态系统包含了丰富的组件,并且很多组件是可选的,可以根据需求灵活搭建

> 1. 主程序`Prometheus Server`,用来获取和存储时序数据
> 2. 丰富的用于检测应用程序状态的客户端库
> 3. 支持短期任务的推送网关
> 4. 针对不同服务的`exporter`服务,例如支持`HAProxy/StatsD/Graphite`等
> 5. 报警管理器,用于报警管理
> 6. 丰富的支持工具

程序架构

![Prometheus架构图](prometheus_architecture.png)

Prometheus直接或者通过中间推送网关收集各种检测指标,它把所有收集到的数据存储到本地,并且根据规则对数据进行聚合,并且记录根据已有的数据记录新的时序数据记录或者是报警.通常,Prometheus使用Grafana来可视化数据.

## 示例

以下示例都来自官方网站

### 安装Prometheus

首先,在官网下载程序包到指定位置,之后根据命令提示开始解压运行

```zsh
# 解压命令
tar xvfz prometheus-*.tar.gz
# 进入程序目录
cd prometheus-*
# 查看帮助信息,说明程序可以正常运行
./prometheus --help
usage: prometheus [<flags>]

The Prometheus monitoring server

Flags:
  -h, --help                     Show context-sensitive help (also try
                                 --help-long and --help-man).
      --version                  Show application version.
      --config.file="prometheus.yml"  
                                 Prometheus configuration file path.
      --web.listen-address="0.0.0.0:9090"  
                                 Address to listen on for UI, API, and
                                 telemetry.
```

### 配置Prometheus

Prometheus程序通过YAML和命令行参数文件进行配置,详细的配置项在使用过程中参考[Prometheus官网的说明文档][PrometheusConfig]

命令行参数通常用来配置系统参数,例如存储位置/硬盘和内存的用量等,配置文件通常定义了所有相关的数据收集才做/实例/规则文件等.

此外,Prometheus运行时可以重载配置,如果配置文件编写有格式错误,则配置项不会生效.重载配置通常通过两种方式:

1. SIGHUP进程,例如`kill HUP`
2. 通过HTTP POST请求`/-/reload`地址

Prometheus支持多种服务发现配置,例如常用的Kubernetes/Consul/Static Files方式,可以动态改变监听的内容

```yaml
# my global config 全局配置
global:
  # 设置数据获取间隔(秒),默认为一分钟
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  # 规则执行间隔(秒),默认为一分钟
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # 数据获取超时时间全局默认设置为10秒
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
# 报警管理配置
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # 报警服务器的目标地址:端口
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
# 加载规则文件,并且根据'evaluation_interval'配置的周期执行
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
# 一个scrape配置包含了一个endpoint
# 默认配置的第一个是Prometheus服务本身的endpoint
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  # job_name将会被作为job=<job_name>的label添加
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    # 指标路径默认为'/metrics'
    # 协议默认为'http'
    static_configs:
    - targets: ['128.1.6.73:9090']
```

配置文件支持以下几种数据类型定义:

1. `boolean`: 布尔值,`true/false`
2. `duration`: 持续时间,符合正则表达式规则`[0-9]+(ms|[smhdwy])`
3. `labelname`: 字符串,符合正则表达式规则`[a-zA-Z_][a-zA-Z0-9_]*`
4. `labelvalue`: unicode字符串
5. `filename`: 当前工作目录下的可用路径
6. `host`: 可用的主机名/IP地址:端口号
7. `path`: 可用的URL路径
8. `scheme`: 协议类型,`http/https`
9. `string`: 常规字符串
10. `secret`: 常规字符串,例如密码/token等
11. `tmpl_string`: 模板字符串

#### global

```yaml
global:
  # How frequently to scrape targets by default.
  [ scrape_interval: <duration> | default = 1m ]

  # How long until a scrape request times out.
  [ scrape_timeout: <duration> | default = 10s ]

  # How frequently to evaluate rules.
  [ evaluation_interval: <duration> | default = 1m ]

  # The labels to add to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    [ <labelname>: <labelvalue> ... ]

  # File to which PromQL queries are logged.
  # Reloading the configuration will reopen the file.
  [ query_log_file: <string> ]

# Rule files specifies a list of globs. Rules and alerts are read from
# all matching files.
rule_files:
  [ - <filepath_glob> ... ]

# A list of scrape configurations.
scrape_configs:
  [ - <scrape_config> ... ]

# Alerting specifies settings related to the Alertmanager.
alerting:
  alert_relabel_configs:
    [ - <relabel_config> ... ]
  alertmanagers:
    [ - <alertmanager_config> ... ]

# Settings related to the remote write feature.
remote_write:
  [ - <remote_write> ... ]

# Settings related to the remote read feature.
remote_read:
  [ - <remote_read> ... ]
```

#### scrape

```yaml
# The job name assigned to scraped metrics by default.
job_name: <job_name>

# How frequently to scrape targets from this job.
[ scrape_interval: <duration> | default = <global_config.scrape_interval> ]

# Per-scrape timeout when scraping this job.
[ scrape_timeout: <duration> | default = <global_config.scrape_timeout> ]

# The HTTP resource path on which to fetch metrics from targets.
[ metrics_path: <path> | default = /metrics ]

# honor_labels controls how Prometheus handles conflicts between labels that are
# already present in scraped data and labels that Prometheus would attach
# server-side ("job" and "instance" labels, manually configured target
# labels, and labels generated by service discovery implementations).
#
# If honor_labels is set to "true", label conflicts are resolved by keeping label
# values from the scraped data and ignoring the conflicting server-side labels.
#
# If honor_labels is set to "false", label conflicts are resolved by renaming
# conflicting labels in the scraped data to "exported_<original-label>" (for
# example "exported_instance", "exported_job") and then attaching server-side
# labels.
#
# Setting honor_labels to "true" is useful for use cases such as federation and
# scraping the Pushgateway, where all labels specified in the target should be
# preserved.
#
# Note that any globally configured "external_labels" are unaffected by this
# setting. In communication with external systems, they are always applied only
# when a time series does not have a given label yet and are ignored otherwise.
[ honor_labels: <boolean> | default = false ]

# honor_timestamps controls whether Prometheus respects the timestamps present
# in scraped data.
#
# If honor_timestamps is set to "true", the timestamps of the metrics exposed
# by the target will be used.
#
# If honor_timestamps is set to "false", the timestamps of the metrics exposed
# by the target will be ignored.
[ honor_timestamps: <boolean> | default = true ]

# Configures the protocol scheme used for requests.
[ scheme: <scheme> | default = http ]

# Optional HTTP URL parameters.
params:
  [ <string>: [<string>, ...] ]

# Sets the `Authorization` header on every scrape request with the
# configured username and password.
# password and password_file are mutually exclusive.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Sets the `Authorization` header on every scrape request with
# the configured bearer token. It is mutually exclusive with `bearer_token_file`.
[ bearer_token: <secret> ]

# Sets the `Authorization` header on every scrape request with the bearer token
# read from the configured file. It is mutually exclusive with `bearer_token`.
[ bearer_token_file: /path/to/bearer/token/file ]

# Configures the scrape request's TLS settings.
tls_config:
  [ <tls_config> ]

# Optional proxy URL.
[ proxy_url: <string> ]

# List of Azure service discovery configurations.
azure_sd_configs:
  [ - <azure_sd_config> ... ]

# List of Consul service discovery configurations.
consul_sd_configs:
  [ - <consul_sd_config> ... ]

# List of DNS service discovery configurations.
dns_sd_configs:
  [ - <dns_sd_config> ... ]

# List of EC2 service discovery configurations.
ec2_sd_configs:
  [ - <ec2_sd_config> ... ]

# List of OpenStack service discovery configurations.
openstack_sd_configs:
  [ - <openstack_sd_config> ... ]

# List of file service discovery configurations.
file_sd_configs:
  [ - <file_sd_config> ... ]

# List of GCE service discovery configurations.
gce_sd_configs:
  [ - <gce_sd_config> ... ]

# List of Kubernetes service discovery configurations.
kubernetes_sd_configs:
  [ - <kubernetes_sd_config> ... ]

# List of Marathon service discovery configurations.
marathon_sd_configs:
  [ - <marathon_sd_config> ... ]

# List of AirBnB's Nerve service discovery configurations.
nerve_sd_configs:
  [ - <nerve_sd_config> ... ]

# List of Zookeeper Serverset service discovery configurations.
serverset_sd_configs:
  [ - <serverset_sd_config> ... ]

# List of Triton service discovery configurations.
triton_sd_configs:
  [ - <triton_sd_config> ... ]

# List of labeled statically configured targets for this job.
static_configs:
  [ - <static_config> ... ]

# List of target relabel configurations.
relabel_configs:
  [ - <relabel_config> ... ]

# List of metric relabel configurations.
metric_relabel_configs:
  [ - <relabel_config> ... ]

# Per-scrape limit on number of scraped samples that will be accepted.
# If more than this number of samples are present after metric relabelling
# the entire scrape will be treated as failed. 0 means no limit.
[ sample_limit: <int> | default = 0 ]
```

#### tls

```yaml
# CA certificate to validate API server certificate with.
[ ca_file: <filename> ]

# Certificate and key files for client cert authentication to the server.
[ cert_file: <filename> ]
[ key_file: <filename> ]

# ServerName extension to indicate the name of the server.
# https://tools.ietf.org/html/rfc4366#section-3.1
[ server_name: <string> ]

# Disable validation of the server certificate.
[ insecure_skip_verify: <boolean> ]
```

### 运行

启动Prometheus服务之后,可以通过浏览器访问地址,例如`http://128.1.10.22:9090`访问

#### Graph

图形界面中,在Console中输入表达式,例如`prometheus_target_interval_length_seconds`,即可在页面上查询对应的指标数据,并且展示在图形上绘制出相关曲线

>prometheus_target_interval_length_seconds{quantile="0.99"} 99%延迟
>count(prometheus_target_interval_length_seconds) 返回实现序列的数量
>rate(prometheus_tsdb_head_chunks_created_total[1m]) 一分钟内的tsdb块创建数量

## 比较

### Prometheus VS. Graphite

#### 总体

Graphite专注于成为`具有查询语言和图形的时序数据库`,其他问题由外部组件解决.

Prometheus是一个`全面的监控系统`,包括`基于时间序列`的数据库的`数据获取/存储/查询/可视化/报警`.具有`判断异常的知识`.

#### 数据模型

两者都能够存储时序数据,区别在于
Prometheus的原数据更加丰富,
Graphite的指标名称由`.`进行分割,通过这种方式隐含代表数据的维度,
Prometheus通过`键值对`的label代表数据的维度,作为指标名称的附加信息,通过这种方式实现查询语言更好的数据聚合操作,例如`filter/group/mach`

此外,尤其是当Graphite和StatsD结合使用时,通常只在受监视的实力上存储聚合数据,而不是将实例保留为一个能够下钻分析问题的维度.

#### 存储

Graphite的数据在本地以`Whisper`的格式存储,这是一种RRD风格的数据库,将数据以常规的间隔存储.每一个时间序列单独存放在一个文件,新的样本将在一定时间之后覆盖原有的样本(待明确含义).

Prometheus采用类似的方法,为每一个时间序列创造一个新的本地文件,但是允许数据以任意的间隔收集,可以和数据收集或者规则的执行保持一致.由于新的样本只是简单的通过append的方式添加,旧数据可以存储任意时间.Prometheus同样适用于许多短期的,或者是经常变化的时间序列集合.

#### 总结

Prometheus提供了更丰富的数据模型和查询语言,可以更容易的启动并且集成至你的环境.如果你想要一个集群方案来保存长时间的历史数据,Graphite可能是更好的选择.

### Prometheus VS. InfluxDB

InfluxDB是一个开源的时间序列数据库,可以选择商业版本的可伸缩/集群配置.InfluxDB的提出比Prometheus的开发时间要晚一年,所以我们没有办法将它作为一个替代方案.两个软件之间存在着一些显著的差异,并且针对不同场景进行应用.

#### 总体情况

为了公平的比较,我们必须考虑将InfluxDB和`Kapacitor`一起使用,实现和Prometheus一样的功能场景.

InfluxDB的差异和Graphite类似,区别在于InfuxDB提供了可持续的查询,和Prometheus的记录规则相同.

Kapacitor的范围是Prometheus记录规则/警报规则/Alertmanager的通知功能的组合.Prometheus提供了更强大的查询语言来进行图形显示和警报,并且Prometheus Alertmanager还提供了分组/重复数据删除/静音的功能.

#### 数据模型/存储

与Prometheus一样,InfluxDB数据模型也将键值对作为标签,称为`tag`.此外,InfluxDB还有第二级标签,称为`field`,使用范围受到更多限制. InfluxDB支持最高达十亿分之一秒分辨率的时间戳,以及`float64,int64,bool和字符串数据类型`.相比之下,Prometheus支持`float64`数据类型,对字符串和毫秒分辨率时间戳的支持有限.

InfluxDB使用[`log-structured merge tree for storage with a write ahead log`][log-structured merge tree for storage with a write ahead log]来存储带有按时间分片的预写日志的存储.与Prometheus每个时间序列的仅附加文件相比,此方法更适合事件记录.

[Logs and Metrics and Graphs, Oh My!][Logs and Metrics and Graphs, Oh My!] 这篇文章描述了事件日志和指标记录的区别.

#### 架构

Prometheus服务独立运行,仅仅依赖于各自的本地存储和核心功能:scraping,规则处理和报警.开源版本的InfluxDB的功能也类似.

商业版的InfuxDB是一个分布式存储集群,存储和查询由多个节点一次处理.

这意味着商业版的InfluxDB更易于水平扩展,但是同样意味着你不得不从一开始就管理复杂的分布式存储系统.Prometheus更易于使用,但是经常需要根据产品/服务/数据中心或者类似方面的原因对服务进行碎片化,以实现伸缩性.各自独立的服务器(可以并行冗余运行)可以提供更好的可靠性和故障隔离.

Kapacitor的开源发布没有为规则/报警/通知功能内置分布式/冗余选项,可以通过用户手动分片实现伸缩扩展,和Prometheus类似.Infux提供了企业级的Kapacitor,支持分布式高可用的报警系统.

相比之下,Prometheus和Alertmanager通过开源的冗余选项,可以启动Prometheus的冗余副本并启用Alertmanager的高可用模式.

#### 总结

这两个系统具有很多相似之处.例如:同样具有标签(labels/tags)为多维指标提供便捷的支持.同样使用基础的数据压缩算法.同样具有广泛的扩展性,包括互相之间的集成.两者都具有`hooks`,可以让进一步对它们进行扩展,例如使用统计工具分析数据或者执行自动操作.

InfluxDB在以下方面表现的更好:

1. 处理时间日志,
2. 商业版提供了集群功能,在长期的数据存储中表现更好
3. 数据视图使得不同副本之间的数据保持一致

Prometheus在以下方面表现的更好:

1. 指标数据的应用(对应时间日志),
2. 更强大的查询语言,报警和通知功能,
3. 高可用和正常使用(uptime)的图形/报警功能.

InfluxDB主要由一个独立的商业公司维护核心代码,并提供高级特性,例如闭源的的集群/托管/支持.Prometheus是一个完全开源的独立项目,由许多公司和个人维护,其中一些还提供商业服务和支持(例如阿里云).

### Prometheus VS. OpenTSDB

OpenTSDB是一个基于Hadoop和HBase的分布式时间序列数据库.

#### 总体

和Graphite类似

#### 数据模型

OpenTSDB的数据模型几乎和Prometheus一致:时间序列由一系列的键值对定义(OpenTSDB的tags对应Prometheus的labels).所有的指标数据存在一起,限制指标的基数.有一些细微的差别:Premetheus允许标签值中包含任意字符,而OpenTSDB的限制更严格.OpenTSDB缺少查询语言,只能通过API进行简单的查询,聚合和数学运算.

#### 存储

OpenTSDB的存储实现基于Hadoop和HBase,意味着OpenTSDB可以很轻易的实现水平扩展,但是你不得不从一开始就接受运行Hadoop/HBase集群的复杂性.

Prometheus的初始使用更加简单,但是一单超出了单个节点的容量,就需要显式的进行分片.

#### 总结

Prometheus提供了更丰富的查询语言,可以处理更大基数的指标,并且构成了完整的监视系统的一部分.如果你已经在运行Hadoop,并且重视长期存储的优势,OpenTSDB将是更好的选择.

[PrometheusConfig]: https://prometheus.io/docs/prometheus/latest/configuration/configuration/ "Prometheus的配置说明"
[log-structured merge tree for storage with a write ahead log]: https://blog.raintank.io/logs-and-metrics-and-graphs-oh-my/ "log-structured merge tree for storage with a write ahead log"
[Logs and Metrics and Graphs, Oh My!]: https://docs.influxdata.com/influxdb/v1.7/concepts/storage_engine/ "Logs and Metrics and Graphs, Oh My!"
