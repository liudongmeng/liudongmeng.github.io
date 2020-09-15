---
title: CentOS常见问题
category:
  - 笔记
date: 2020-09-15 11:45:42
tags:
---

## 配置authorized_keys之后无法免密码登录

通常是由于authorized_keys文件权限问题导致的

```zsh
chmod 600 authorized_keys
```

修改文件访问权限之后正常