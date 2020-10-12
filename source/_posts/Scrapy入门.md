---
title: 'Scrapy入门'
date: 2017-04-08 10:39:38
tags: ['python','spider',Scrapy]
category: ['笔记','Scrapy']
---
做个爬虫试试吧，打发无聊时光

这里看到了yield关键字,python的东西还是不熟,百度了一下大概有个概念,慢慢研究,先放个[链接][yield]mark一下

[yield]: http://www.jianshu.com/p/d09778f4e055 "彻底理解Python中的yield"

<!--more-->

# 最简单的爬网页

先贴一段代码，简单的没什么好讲

```py
#!/usr/bin/python2.7
# -*- coding: utf-8 -*-
import urllib2
def getHtml(url):
    page = urllib2.urlopen(url)
    html=page.read()
    return html
url="https://hisashiburidane.github.io"
html=getHtml(url)
print(html)
```

# Scrapy

百度了一下接下来应该怎么做，无非先拉数据，然后使用正则或者其他手段把目标数据提取出来，之后要能自动翻页之类的，能够持续拉
说起来简单，获取网页内容只需要第一步那几行代码，然后就要仔细琢磨一下怎么做了，百度的结果是用[Scrapy][Scrapy官网]这个框架的比较多，先简单学习一下吧
![input](scrapy_architecture_02.png)
看完文档又踩了好多坑……现在开始补充
顺着文档看下来，`pip install`按说应该很简单啊，可是OSX下面安装就是出了一堆问题，比如系统权限了，还有一个什么系统保护机制了，不能在usr和etc这种目录下装东西……看了一圈，一种解决办法是配置pip安装路径，装在当前用户的目录下，要改一堆配置文件
最后决定要采用的是[virtualenv][visualenv官网]，因为不用这么麻烦……
写在一起太乱了，放个链接{% post_link python开发环境的一些配置 python开发环境的一些配置 %}

## Scrapy安装

搞定了虚拟环境，就可以开始安装配置Scrapy了

```sh
# 创建虚拟环境目录(?暂时这样叫吧)
$ visualenv ENV
# 切换至虚拟环境
$ source ENV/bin/activate
# 退出虚拟环境
$ deactivate
# pip安装
$ pip install Scrapy
# 创建名为tutorial的scrapy项目
$ scrapy startproject tutorial
```

## Scrapy Tuurtorial

下面是[Scrapy官网Tutorial][Scrapy官网Tutorial]给出的教程中的代码

### 抓取网页

```py
import scrapy


class QuotesSpider(scrapy.Spider):
    name = "quotes"

    def start_requests(self):
        urls = [
            'http://quotes.toscrape.com/page/1/',
            'http://quotes.toscrape.com/page/2/',
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        page = response.url.split("/")[-2]
        filename = 'quotes-%s.html' % page
        with open(filename, 'wb') as f:
            f.write(response.body)
        self.log('Saved file %s' % filename)
```

之后在tutorial目录下执行命令

```sh
$ scrapy crawl quotes
# This command runs the spider with name quotes that we’ve just added, that will send some requests for the quotes.toscrape.com domain. You will get an output similar to this:
... (omitted for brevity)
2016-12-16 21:24:05 [scrapy.core.engine] INFO: Spider opened
2016-12-16 21:24:05 [scrapy.extensions.logstats] INFO: Crawled 0 pages (at 0 pages/min), scraped 0 items (at 0 items/min)
2016-12-16 21:24:05 [scrapy.extensions.telnet] DEBUG: Telnet console listening on 127.0.0.1:6023
2016-12-16 21:24:05 [scrapy.core.engine] DEBUG: Crawled (404) <GET http://quotes.toscrape.com/robots.txt> (referer: None)
2016-12-16 21:24:05 [scrapy.core.engine] DEBUG: Crawled (200) <GET http://quotes.toscrape.com/page/1/> (referer: None)
2016-12-16 21:24:05 [scrapy.core.engine] DEBUG: Crawled (200) <GET http://quotes.toscrape.com/page/2/> (referer: None)
2016-12-16 21:24:05 [quotes] DEBUG: Saved file quotes-1.html
2016-12-16 21:24:05 [quotes] DEBUG: Saved file quotes-2.html
2016-12-16 21:24:05 [scrapy.core.engine] INFO: Closing spider (finished)
...
```

>Scrapy schedules the scrapy.Request objects returned by the start_requests method of the Spider. Upon receiving a response for each one, it instantiates Response objects and calls the callback method associated with the request (in this case, the parse method) passing the response as argument.

这时候ENV目录下保存了两个html文件`quotes-1.html`,`quotes-2.html`,这就是爬下来的东西了

接下来是一个简化的实现

```py
import scrapy

class QuotesSpider(scrapy.Spider):
    name = "quotes_shortcut"
    start_urls = [
        'http://quotes.toscrape.com/page/1/',
        'http://quotes.toscrape.com/page/2/',
    ]

    def parse(self,response):
        page = response.url.split("/")[-2]
        finename = 'quotes_shortcut-%s.html' % page
        with open(finename,'wb') as f:
            f.write(response.body)
```

>The parse() method will be called to handle each of the requests for those URLs, even though we haven’t explicitly told Scrapy to do so. This happens because parse() is Scrapy’s default callback method, which is called for requests without an explicitly assigned callback.

看了一下,这一段大概是为了说明parse是scrapy的默认回调函数,不需要下面这一段代码指定也会被默认调用

```py
for url in urls:
    yield scrapy.Request(url=url, callback=self.parse)
```

### CSSSelector提取数据

然后是讲scrapy如何提取数据的

#### .extract() method

```sh
# scrapy shell
$ scrapy shell 'http://quotes.toscrape.com/page/1/'
# 执行完毕之后看到如下输出
[ ... Scrapy log here ... ]
2016-09-19 12:09:27 [scrapy.core.engine] DEBUG: Crawled (200) <GET http://quotes.toscrape.com/page/1/> (referer: None)
[s] Available Scrapy objects:
[s]   scrapy     scrapy module (contains scrapy.Request, scrapy.Selector, etc)
[s]   crawler    <scrapy.crawler.Crawler object at 0x7fa91d888c90>
[s]   item       {}
[s]   request    <GET http://quotes.toscrape.com/page/1/>
[s]   response   <200 http://quotes.toscrape.com/page/1/>
[s]   settings   <scrapy.settings.Settings object at 0x7fa91d888c10>
[s]   spider     <DefaultSpider 'default' at 0x7fa91c8af990>
[s] Useful shortcuts:
[s]   shelp()           Shell help (print this help)
[s]   fetch(req_or_url) Fetch request (or URL) and update local objects
[s]   view(response)    View response in a browser
>>>
# 接下来可以在scrapy shell中进行一些命令操作
# css selector
>>> response.css('tittle')
[<Selector xpath=u'descendant-or-self::title' data=u'<title>Quotes to Scrape</title>'>]
>>> response.css('tittle::text')
[<Selector xpath=u'descendant-or-self::title/text()' data=u'Quotes to Scrape'>]
>>> response.css('title::text').extract()
[u'Quotes to Scrape']
>>> response.css('title').extract()
[u'<title>Quotes to Scrape</title>']
# extract()方法处理的是一个selectorList实例,如果只想要第一个结果可以如下操作
>>> response.css('title::text').extract_first()
u'Quotes to Scrape'
# 也可以像数组一样写
# 使用.extract_first()方法在数组长度为0(没有找到对应选择器的元素)的时候可以返回None而不是引发索引错误
# However, using .extract_first() avoids an IndexError and returns None when it doesn’t find any element matching the selection.
>>> response.css('title::text')[0].extract()
u'Quotes to Scrape'
```

#### regular expressions

>Besides the extract() and extract_first() methods, you can also use the re() method to extract using regular expressions:

正则表达式提取数据

```sh
>>> response.css('title::text').re(r'Quotes.*')
[u'Quotes to Scrape']
>>> response.css('title::text').re(r'Q\w+')
[u'Quotes']
>>> response.css('title::text').re(r'(\w+) to (\w+)')
[u'Quotes', 'Scrape']
```

为了验证提取到的数据是否正确,可以调用`view(response)`方法打开浏览器,在开发者工具中查看页面元素

### XPath提取数据

这一块之前在做selenium的端对端测试的时候有一点点了解,可以用的时候再百度

```sh
>>> response.xpath('//title')
[<Selector xpath='//title' data=u'<title>Quotes to Scrape</title>'>]
>>> response.xpath('//title/text()').extract_first()
u'Quotes to Scrape'
```

>XPath expressions are very powerful, and are the foundation of Scrapy Selectors. In fact, CSS selectors are converted to XPath under-the-hood. You can see that if you read closely the text representation of the selector objects in the shell.

这里说XPath是CSSSelector的基础,意思是更强大了

### 这里讲如何提取最终的目标数据

这篇教程中的目的是从网站中抓取作品和作者数据,我猜是用正则🙄
抓到的网站数据格式如下

```html
<div class="quote">
    <span class="text">“The world as we have created it is a process of our
    thinking. It cannot be changed without changing our thinking.”</span>
    <span>
        by <small class="author">Albert Einstein</small>
        <a href="/author/Albert-Einstein">(about)</a>
    </span>
    <div class="tags">
        Tags:
        <a class="tag" href="/tag/change/page/1/">change</a>
        <a class="tag" href="/tag/deep-thoughts/page/1/">deep-thoughts</a>
        <a class="tag" href="/tag/thinking/page/1/">thinking</a>
        <a class="tag" href="/tag/world/page/1/">world</a>
    </div>
</div>
```

这里重新打开scrapy shell

```sh
$ scrapy shell 'http://quotes.toscrape.com'
# 使用CSSSelector获取到了所有的div.quote元素对象
>>> response.css("div.quote")
# quote现在就是第一个元素对象
>>> quote=response.css("div.quote")[0]
>>> quote
<Selector xpath=u"descendant-or-self::div[@class and contains(concat(' ', normalize-space(@class), ' '), ' quote ')]" data=u'<div class="quote" itemscope itemtype="h'>
# 然后根据quote的元素去查找下面的元素
>>> title = quote.css("span.text::text").extract_first()
>>> title
u'\u201cThe world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.\u201d'
>>> author = quote.css("small.author::text").extract_first()
>>> author
'Albert Einstein'
>>> tags = quote.css("div.tags a.tag::text").extract()
>>> tags
[u'change', u'deep-thoughts', u'thinking', u'world']
```

```sh
>>> for quote in response.css("div.quote"):
...     text=quote.css("span.text::text").extract_first()
...     author=quote.css("small.author::text").extract_first()
...     tags=quote.css("div.tags a.tag::text").extract()
...     print(dict(text=text,author=author,tags=tags))
...
{'text': u'\u201cThe world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.\u201d', 'tags': [u'change', u'deep-thoughts', u'thinking', u'world'], 'author': u'Albert Einstein'}
{'text': u'\u201cIt is our choices, Harry, that show what we truly are, far more than our abilities.\u201d', 'tags': [u'abilities', u'choices'], 'author': u'J.K. Rowling'}
... a few more of these, omitted for brevity
```

### 在Spider中提取数据

```py
import scrapy


class QuotesSpider(scrapy.Spider):
    name = "quotes_extract"
    start_urls = [
        'http://quotes.toscrape.com/page/1/',
        'http://quotes.toscrape.com/page/2/',
    ]

    def parse(self, response):
        for quote in response.css('div.quote'):
            yield {
                'text': quote.css('span.text::text').extract_first(),
                'author': quote.css('small.author::text').extract_first(),
                'tags': quote.css('div.tags a.tag::text').extract(),
            }
```

运行程序看输出,大概就是下面这样

```sh
$ scrapy crawl quotes_extract
...
2017-04-08 22:00:06 [scrapy.core.scraper] DEBUG: Scraped from <200 http://quotes.toscrape.com/page/1/>
{'text': u'\u201cThe world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.\u201d', 'tags': [u'change', u'deep-thoughts', u'thinking', u'world'], 'author': u'Albert Einstein'}
2017-04-08 22:00:06 [scrapy.core.scraper] DEBUG: Scraped from <200 http://quotes.toscrape.com/page/1/>
{'text': u'\u201cIt is our choices, Harry, that show what we truly are, far more than our abilities.\u201d', 'tags': [u'abilities', u'choices'], 'author': u'J.K. Rowling'}
...
# 输出json文件
$ scrapy crawl quotes_extract -o quotes_extract.json
# 输出jl文件
$ scrapy crawl quotes_extract -o quotes_extract.jl
```

>The JSON Lines format is useful because it’s stream-like, you can easily append new records to it. It doesn’t have the same problem of JSON when you run twice. Also, as each record is a separate line, you can process big files without having to fit everything in memory, there are tools like JQ to help doing that at the command-line.

这里终端和上面的输出是一样的,只是把数据保存在了json文件里,随便列几条看看效果就行了

```json
[
{"text": "\u201cThe world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.\u201d", "author": "Albert Einstein", "tags": ["change", "deep-thoughts", "thinking", "world"]},
{"text": "\u201cIt is our choices, Harry, that show what we truly are, far more than our abilities.\u201d", "author": "J.K. Rowling", "tags": ["abilities", "choices"]},
{"text": "\u201cThere are only two ways to live your life. One is as though nothing is a miracle. The other is as though everything is a miracle.\u201d", "author": "Albert Einstein", "tags": ["inspirational", "life", "live", "miracle", "miracles"]},
{"text": "\u201cThe person, be it gentleman or lady, who has not pleasure in a good novel, must be intolerably stupid.\u201d", "author": "Jane Austen", "tags": ["aliteracy", "books", "classic", "humor"]},
{"text": "\u201cImperfection is beauty, madness is genius and it's better to be absolutely ridiculous than absolutely boring.\u201d", "author": "Marilyn Monroe", "tags": ["be-yourself", "inspirational"]},
{"text": "\u201cTry not to become a man of success. Rather become a man of value.\u201d", "author": "Albert Einstein", "tags": ["adulthood", "success", "value"]},
...
]
```

>In small projects (like the one in this tutorial), that should be enough. However, if you want to perform more complex things with the scraped items, you can write an Item Pipeline. A placeholder file for Item Pipelines has been set up for you when the project is created, in tutorial/pipelines.py. Though you don’t need to implement any item pipelines if you just want to store the scraped items.

这个是管道了,这部分回头再看吧,今天先到这里.么有效率...

### 如何持续查找所有网页

这里应该就是找到"下一页"的标记,然后无限向下直到没有下一页为止,也没什么难度,指定选择器而已.
下面是quotes网站的下一页元素

```html
<ul class="pager">
    <li class="next">
        <a href="/page/2/">Next <span aria-hidden="true">&rarr;</span></a>
    </li>
</ul>
```

shell里面先看看

```sh
$ scrapy shell 'http://quotes.toscrape.com/'
>>> response.css('li.next a::attr(href)').extract_first()
u'/page/2/'
```

```py
import scrapy


class QuotesSpider(scrapy.Spider):
    name = "quotes_next"
    start_urls = [
        'http://quotes.toscrape.com/page/1/',
    ]

    def parse(self, response):
        for quote in response.css('div.quote'):
            yield {
                'text': quote.css('span.text::text').extract_first(),
                'author': quote.css('small.author::text').extract_first(),
                'tags': quote.css('div.tags a.tag::text').extract(),
            }

        next_page = response.css('li.next a::attr(href)').extract_first()
        if next_page is not None:
            # 从相对路径获取页面的绝对路径
            # http://quotes.toscrape.com/page/1/
            # /page/2/
            # 拼起来就是http://quotes.toscrape.com/page/2/这样
            next_page = response.urljoin(next_page)
            yield scrapy.Request(next_page, callback=self.parse)
```

>What you see here is Scrapy’s mechanism of following links: when you yield a Request in a callback method, Scrapy will schedule that request to be sent and register a callback method to be executed when that request finishes.

scrapy回调parse的时候会触发next_page下面的`scrapy.Request(next_page, callback=self.parse)`代码,循环直到`next_page=None`

```py
import scrapy


class AuthorSpider(scrapy.Spider):
    name = 'quotes_author'

    start_urls = ['http://quotes.toscrape.com/']

    def parse(self, response):
        # follow links to author pages
        for href in response.css('.author + a::attr(href)').extract():
            yield scrapy.Request(response.urljoin(href),
                                 callback=self.parse_author)

        # follow pagination links
        next_page = response.css('li.next a::attr(href)').extract_first()
        if next_page is not None:
            next_page = response.urljoin(next_page)
            yield scrapy.Request(next_page, callback=self.parse)

    def parse_author(self, response):
        def extract_with_css(query):
            return response.css(query).extract_first().strip()

        yield {
            'name': extract_with_css('h3.author-title::text'),
            'birthdate': extract_with_css('.author-born-date::text'),
            'bio': extract_with_css('.author-description::text'),
        }
```

这一段是先加载页面之后拿到所有的作者的链接,然后在parse中新建scrapy.Request()请求,触发parse_author回调,在作者页面中拿到作者信息
我在想这个东西会不会一不小心搞成递归了...
>Another interesting thing this spider demonstrates is that, even if there are many quotes from the same author, we don’t need to worry about visiting the same author page multiple times. By default, Scrapy filters out duplicated requests to URLs already visited, avoiding the problem of hitting servers too much because of a programming mistake. This can be configured by the setting DUPEFILTER_CLASS.

话说这是自带防止递归的功能?框架果然是好东西,急人之所急啊

### 传递参数

```py
import scrapy


class QuotesSpider(scrapy.Spider):
    name = "quotes_tags"

    def start_requests(self):
        url = 'http://quotes.toscrape.com/'
        tag = getattr(self, 'tag', None)
        if tag is not None:
            url = url + 'tag/' + tag
        yield scrapy.Request(url, self.parse)

    def parse(self, response):
        for quote in response.css('div.quote'):
            yield {
                'text': quote.css('span.text::text').extract_first(),
                'author': quote.css('small.author::text').extract_first(),
            }

        next_page = response.css('li.next a::attr(href)').extract_first()
        if next_page is not None:
            next_page = response.urljoin(next_page)
            yield scrapy.Request(next_page, self.parse)
```

```sh
 scrapy crawl quotes_tags -o quotes_tags.json -a tag=humor
```

最终获取的结果只有humor类型的

>You can learn more about [handling spider arguments here][spider-arguments].

今天就到这里,消化一下.

[visualenv官网]: https://virtualenv.pypa.io "visualenv官网"
[Scrapy官网]: https://scrapy.org/ "Scrapy官网"
[Scrapy官网Tutorial]: https://docs.scrapy.org/en/latest/intro/tutorial.html "Scrapy官网Tutorial"
[spider-arguments]: https://docs.scrapy.org/en/latest/topics/spiders.html#spiderargs "spider-arguments"
