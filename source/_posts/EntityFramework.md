---
title: EntityFramework
tags:
#   - EntityFramework
#   - .Net Core
#   - ORM
category:
  - 笔记
# subtitle: 吾尝终日而思矣,不如须臾之所学也
date: 2020-06-07 21:12:45
---


## 什么是 EntityFramework

EntityFramework 是一款 ORM 框架(对象关系映射 Object Relational Mapping，简称 ORM），可以使.NET 开发人员能够使用特定领域的关系型数据。开发人员无需像往常一样编写大量的数据访问代码。

## Quick Start

> 如果对`.Net Core`/`命令行操作`/`C#语言`一窍不通的建议不用往下看了...

### 安装

首先安装[.NetCore SDK][.netcore sdk],之后创建一个新的.Net Core 项目,安装`EF Core`

```zsh
# 创建一个新的控制台项目,名字叫做"EFGetStarted"
dotnet new console -o EFGetStarted
# 切换到项目路径
cd EFGetStarted
# 从NuGet添加相关的包依赖,也可以通过VisualStudio的管理器安装,不赘述
# SQLite
dotnet add package Microsoft.EntityFrameworkCore.Sqlite
# PostgreSQL
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL
# MSSQL
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
```

### Code First

示例代码创建了一个简单的博客模型示例,包含了 Blog 和 Post 类的定义,以及 DbContext

```c#
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace EFGetStarted
{
    public class BloggingContext : DbContext
    {
        public DbSet<Blog> Blogs { get; set; }
        public DbSet<Post> Posts { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder options)
            => options.UseSqlite("Data Source=blogging.db");
    }

    public class Blog
    {
        public int BlogId { get; set; }
        public string Url { get; set; }

        public List<Post> Posts { get; } = new List<Post>();
    }

    public class Post
    {
        public int PostId { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }

        public int BlogId { get; set; }
        public Blog Blog { get; set; }
    }
}
```

### 创建数据库

```zsh
# 安装dotnet-ef工具
dotnet tool install --global dotnet-ef
# 安装EF设计器
dotnet add package Microsoft.EntityFrameworkCore.Design
# 根据代码创建一个数据库版本
dotnet ef migrations add InitialCreate
# 将数据库版本更新至当前
dotnet ef database update
```

执行完成上述代码之后,项目中将会多出一个`blogging.db`文件,是 Sqlite 的数据库文件,其中包含了三张表

- `Blogs`:存储 Blogs 类对象
- `Posts`:存储 Posts 类对象
- `__EFMigrationsHistory`:存储对应的 EF 部署历史信息

### 调用数据库方法

```c#
using System;
using EFGetStarted.Models;
using System.Linq;

namespace EFGetStarted
{
    class Program
    {
        static void Main()
        {
            using (var db = new BlogContext())
            {
                // Create
                Console.WriteLine("Inserting a new blog");
                db.Add(new Blog { Url = "http://blogs.msdn.com/adonet" });
                db.SaveChanges();

                // Read
                Console.WriteLine("Querying for a blog");
                var blog = db.Blogs
                    .OrderBy(b => b.BlogId)
                    .First();

                // Update
                Console.WriteLine("Updating the blog and adding a post");
                blog.Url = "https://devblogs.microsoft.com/dotnet";
                blog.Posts.Add(
                    new Post
                    {
                        Title = "Hello World",
                        Content = "I wrote an app using EF Core!"
                    });
                db.SaveChanges();

                // Delete
                Console.WriteLine("Delete the blog");
                db.Remove(blog);
                db.SaveChanges();
            }
        }
    }
}
```

包含了对数据库的 CRUD 操作,例子到此结束,可以看到全程我们没有进行任何实际的数据库操作,包括:

- 设计数据库
- 创建数据库及表结构
- 使用 client 程序连接数据库
- 编写 SQL 进行数据库操作

这就是 ORM 框架的优点:屏蔽了繁复的数据库操作细节,让用户专注于业务模型的建立

[.netcore sdk]: https://dotnet.microsoft.com/download ".NetCore SDK下载页面"
