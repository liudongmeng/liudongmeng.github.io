---
title: windows系统下Hexo的安装和配置
date: 2017-01-10 22:38:15
tags: [Blog,Hexo]
category: [笔记,Hexo]
---
根据网上的各路教程把Hexo搭起来了，难度其实不高，但是要用好还是要多练习多思考，先整理一下我搭建博客的过程，省得改天又百度各种网页……
<!--more-->
# Hexo的安装
首先引用作者wsgzao的[原文][wsgzao.hexo]
然后是阮一峰的[文章][ruanyifeng.blog]
Hexo的[官网][hexo.io]
后来发现简书上面一篇文章写的也很不错，mark一下改天来完善一下我的笔记[Andrew_liu:通过Hexo在Github上搭建博客教程][Andrew_liu]
[留言板][留言板]
[留言板来自知乎的回答][留言板知乎]
[hexo文章设置首页不显示技巧][hexo文章设置首页不显示技巧]
## 安装Git

## 安装Node.js
[下载][NodeJS]安装就行了，具体过程记不得了，好像是装上就行，环境变量自己就配好了，有机会再搭一次的话确认一下……
## 安装Hexo
装好Node.js之后用npm命令安装hexo
```batch
npm install hexo-cli -g
npm install hexo --save
#如果命令无法运行，可以尝试更换taobao的npm源
npm install -g cnpm --registry=https://registry.npm.taobao.org
```
## 初始化Hexo
安装成功之后，切换到指定路径，初始化Hexo项目
```batch
hexo init
#安装完成之后该路径下会出现一个完整的hexo项目，可以通过命令进行操作，不过很多操作依赖于插件
#安装 Hexo 完成后，请执行下列命令，Hexo 将会在指定文件夹中新建所需要的文件。
$ hexo init <folder>
$ cd <folder>
$ npm install

#新建完成后，指定文件夹的目录如下
.
├── _config.yml
├── package.json
├── scaffolds
├── scripts
├── source
|      ├── _drafts
|      └── _posts
└── themes
```
## 安装Hexo插件
通过插件可以实现自动生成静态页面、自动打包发布等功能
这里有一个问题，就是将一个全新的hexo项目通过hexo d命令发布至github可能会把原有的项目全删了……没想清楚是什么原理，还需要慢慢摸索
```batch
npm install hexo-generator-index --save
npm install hexo-generator-archive --save
npm install hexo-generator-category --save
npm install hexo-generator-tag --save
npm install hexo-server --save
npm install hexo-deployer-git --save
npm install hexo-deployer-heroku --save
npm install hexo-deployer-rsync --save
npm install hexo-deployer-openshift --save
npm install hexo-renderer-marked@0.2 --save
npm install hexo-renderer-stylus@0.2 --save
npm install hexo-generator-feed@1 --save
npm install hexo-generator-sitemap@1 --save
```
常用命令
```batch
hexo g #根据md文件生成静态页面
hexo d #根据_config.yml文件中配置的信息，将静态页面发布到github指定项目
hexo n "title" #生成文章，生成md文件，路径在_posts文件夹下
hexo s #本地启动服务(port:4000)，可以直接预览md文件的修改
```
## 部署静态网页到[GitHub][GitHub]
---
注册帐号，之后创建`New repository`，name和用户名保持一致，例如`username.github.io`
第一次部署上去之后一直访问不到，以为是代码有问题，或者是网站延迟，后来发现是网站需要审核10分钟左右，之后每次提交完成之后如果没有错误就可以直接看到更新内容
### 手动部署
我这个人也是比较懒，每次都要`git add .` `git commit -m "xxx"` `git push origin master` 也是嫌麻烦，所以现在在用`hexo d`自动部署，关于项目怎么在不同服务器上同步的问题还在考虑，用github感觉速度是个问题
### 自动部署
这个感觉用起来很方便，每次`hexo g d`，等发布完成就好了
打开Hexo项目路径下的`_config.yml`文件，修改如下配置就可以了
```batch
deploy:
  type: git
  repo: https://github.com/username/username.github.io
  branch: master
```


# Markdown资料
之前在公司写wiki时接触了类似的东西，感觉挺好用，不过用的比较生疏
网上找的[Markdown][Markdown]语法链接，放这里慢慢学习整理

[Markdown]: http://www.appinn.com/markdown/ "网上找的Markdown文档"
[wsgzao.hexo]: https://wsgzao.github.io/post/hexo-guide/ "使用GitHub和Hexo搭建免费静态Blog"
[ruanyifeng.blog]: http://www.ruanyifeng.com/blog/2012/08/blogging_with_jekyll.html "搭建一个免费的，无限流量的Blog----github Pages和Jekyll入门 by ruanyifeng"
[hexo.io]: https://hexo.io/ "hexo.io"
[NodeJS]: https://nodejs.org/en/ "NodeJS"
[GitHub]: https://github.com/ "GitHub"
[Andrew_liu]: http://www.jianshu.com/p/858ecf233db9 "Andrew_liu:通过Hexo在Github上搭建博客教程"
[留言板]: http://blog.csdn.net/shenshanlaoyuan/article/details/52774473 "Hexo博客增加留言板功能"
[留言板知乎]: https://www.zhihu.com/question/38797520?sort=created "知乎"
[hexo文章设置首页不显示技巧]: http://www.xbool.com/article-not-show-home/ "hexo文章设置首页不显示技巧"