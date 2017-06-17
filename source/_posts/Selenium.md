---
title: selenium
date: 2017-06-01 21:15:12
tags:
category: [selenium]
---
给你写的,都不知道你是不是用python...
嗯突然发现官网打不开了,开代理也打不开...骂了两句发现是chrome的代理规则忘了添加...
<!--more-->

# Python

## 安装

### Windows

#### 安装python

1. 官网[下载][Python]安装包,安装到目标位置
2. 安装完成后右键点击`我的电脑`->`属性`->`高级系统设置`->`环境变量`,将python安装的路径添加到PATH里面,例如`;c:\python2.6`.这里注意如果是直接在文本后面追加的话记得前面要加分号`;`.添加完成之后再命令行中输入python能够进入python shell,说明安装成功

#### 安装pip

> pip is already installed if you're using Python 2 >=2.7.9 or Python 3 >=3.4 binaries downloaded from python.org, but you'll need to upgrade pip.

官网的说法是2.7.9以及3.4版本以上的python安装后已经包含了pip,不需要另外安装,执行`pip install`命令安装最新版本即可(参数-U表示安装或更新至最新版)

```sh
pip install -U pip
```

版本不满足时,首先下载[get-pip][get-pip]文件,并在命令行中切换至文件所在的路径执行文件
这里吐槽一下windows的cmd实在不好用,powershell也一般,推荐一个暂时感觉还不错的命令行工具[cmder][cmder]
[下载地址][cmder-download]

```sh
# 切换至指定路径
cd xxxx/xxxx
# 执行
python ./get-pip.py
```

#### 安装selenium

[官网链接][selenium]
安装完成`pip`之后,使用命令安装`selenium`包

```sh
$ pip install -U selenium
Collecting selenium
  Downloading selenium-3.4.3-py2.py3-none-any.whl (931kB)
    100% |████████████████████████████████| 942kB 191kB/s
Installing collected packages: selenium
Successfully installed selenium-3.4.3
```

#### 下载WebDriver

##### ChromeDriver

[chrome-driver][chrome-driver]

* 截止目前最新的windows版本的driver的[下载地址](https://chromedriver.storage.googleapis.com/2.29/chromedriver_win32.zip "chromedriver_win32.zip")

* 将解压后的`chromedriver.exe`文件放在指定路径,例如`D:\Selenium\chromedriver.exe`路径下,将`D:\Selenium\`目录添加至环境变量`PATH`中

#### Demo

```python
from selenium import webdriver
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait # available since 2.4.0
from selenium.webdriver.support import expected_conditions as EC # available since 2.26.0
# 新建一个chrome进程driver
driver = webdriver.Chrome()
# 打开指定页面
driver.get("http://www.baidu.com")
driver.
# 将浏览器当前的标题打印出来
print driver.title
# 定位到页面中的具体元素,这里需要一点html的知识,或者直接浏览器切换到开发者模式查看xpath&cssselector
inputElement = driver.find_element_by_name("wd")
# 填写搜索内容
inputElement.send_keys("cheese!")
# 提交input控件中的内容
inputElement.submit()
try:
    # 这里是等待页面状态改变的方法,WebDriverWait(driver,10)代表定的进程等待10秒,直到符合until()中的参数符合或是超过了等待时间
    WebDriverWait(driver, 10).until(EC.title_contains("cheese!"))
    #另一种写法
    wait = WebDriverWait(driver,10)
    element = wait.until(EC.title_contains("cheese!"))
    # cheese!_百度搜索
    print driver.title
finally:
    driver.quit()
```

### Mac

```sh
pip install selenium
vi ~/.bash_profile

export PATH=$HOME/Documents/workspace/Selenium:$PATH
```

测试是否安装成功

```py
from selenium import webdriver
dr = webdriver.Chrome()
# 测试完成后记得关闭进程
dr.quit()
```

安装成功的话这里应该显示一个空的浏览器
![chromedriver_empty](chromedriver_empty.png)

## Introducing the Selenium-WebDriver API by Example
照搬官网的例子

```py
from selenium import webdriver
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait # available since 2.4.0
from selenium.webdriver.support import expected_conditions as EC # available since 2.26.0

# 新建一个chrome进程driver
driver = webdriver.Chrome()

# 打开指定页面
driver.get("http://www.baidu.com")

# 将浏览器当前的标题打印出来
print driver.title

# 定位到页面中的具体元素,这里需要一点html的知识,或者直接浏览器切换到开发者模式查看xpath&cssselector
inputElement = driver.find_element_by_name("wd")

# 填写搜索内容
inputElement.send_keys("cheese!")

# 提交input控件中的内容
inputElement.submit()

try:
    # 这里是等待页面状态改变的方法,WebDriverWait(driver,10)代表定的进程等待10秒,直到符合until()中的参数符合或是超过了等待时间
    WebDriverWait(driver, 10).until(EC.title_contains("cheese!"))

    #另一种写法
    wait = WebDriverWait(driver,10)
    element = wait.until(EC.title_contains("cheese!"))
    # cheese!_百度搜索
    print driver.title

finally:
    driver.quit()
```

上面差不多就是一个完整的例子了,实际操作过程中有一些地方灵活运用就好

### 打开浏览器

这里不同浏览器的话需要[下载][webdriver-download]对应的webdriver,并且将文件所在的路径添加到系统的环境变量

```py
from selenium import webdriver
# 新建实例
driver = webdriver.Chrome()
# 设置大小
driver.set_window_size(240, 320)
# 最大化
driver.maximize_window()
# 获取页面title
driver.title
# 获取页面当前url
driver.current_url
```

### 关闭浏览器

测试的话一般在主程序的finally里面调用`driver.quit()`,不然有时候会因为异常导致没有退出进程,然后测试的机子会开很多个进程然后卡的不行...

```py
from selenium import webdriver
import time

driver = webdriver.Chrome()

driver.quit()
```

### 打开页面

以百度为例

```py
from selenium import webdriver

driver = webdriver.Chrome()
driver.get('http://www.baidu.com')
```

### 定位UI元素

```html
  <html>
    <head>
      <meta http-equiv="content-type" content="text/html;charset=utf-8" />
      <title>Form</title>
      <script type="text/javascript" async="" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
      <link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css" rel="stylesheet" />
      <script src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>
    </head>
    <body>
      <h3>simple login form</h3>
      <form class="form-horizontal">
        <div class="control-group">
          <label class="control-label" for="inputEmail">Email</label>
          <div class="controls">
            <input type="text" id="inputEmail" placeholder="Email" name="email">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="inputPassword">Password</label>
          <div class="controls">
            <input type="password" id="inputPassword" placeholder="Password" name="password">
          </div>
        </div>
        <div class="control-group">
          <div class="controls">
            <label class="checkbox">
              <input type="checkbox"> Remember me
            </label>
            <button type="submit" class="btn">Sign in</button>
            <a href="#">register</a>
          </div>
        </div>
      </form>
    </body>
  </html>
```

```py
from selenium import webdriver
from time import sleep
import os
if 'HTTP_PROXY'in os.environ: del os.environ['HTTP_PROXY']

dr = webdriver.Chrome()
file_path = 'file:///' + os.path.abspath('form.html')
print file_path

dr.get(file_path)

# by id
dr.find_element_by_id('inputEmail').click()

# by name
dr.find_element_by_name('password').click()

# by tagname
print dr.find_element_by_tag_name('form').get_attribute('class')

# by class_name
e = dr.find_element_by_class_name('controls')
dr.execute_script('$(arguments[0]).fadeOut().fadeIn()', e)
sleep(1)

# by link text
link = dr.find_element_by_link_text('register')
dr.execute_script('$(arguments[0]).fadeOut().fadeIn()', link)
sleep(1)

# by partial link text
link = dr.find_element_by_partial_link_text('reg')
dr.execute_script('$(arguments[0]).fadeOut().fadeIn()', link)
sleep(1)

# by css selector
div = dr.find_element_by_css_selector('.controls')
dr.execute_script('$(arguments[0]).fadeOut().fadeIn()', div)
sleep(1)

# by xpath
dr.find_element_by_xpath('/html/body/form/div[3]/div/label/input').click()

sleep(2)
dr.quit()
```

#### by id

```html
<div id="coolestWidgetEvah">...</div>
```

```py
# 写法一
element = driver.find_element_by_id("coolestWidgetEvah")
# 写法二
from selenium.webdriver.common.by import By
element = driver.find_element(by=By.ID, value="coolestWidgetEvah")
```

#### by class

```html
<div class="cheese"><span>Cheddar</span></div><div class="cheese"><span>Gouda</span></div>
```

```py
# 写法一
cheeses = driver.find_elements_by_class_name("cheese")
# 写法二
from selenium.webdriver.common.by import By
cheeses = driver.find_elements(By.CLASS_NAME, "cheese")
```

#### by tag

```html
<iframe src="..."></iframe>
```

```py
# 写法二
frame = driver.find_element_by_tag_name("iframe")
# 写法二
from selenium.webdriver.common.by import By
frame = driver.find_element(By.TAG_NAME, "iframe")
```

#### by name

```html
<input name="cheese" type="text"/>
```

```py
# 写法一
cheese = driver.find_element_by_name("cheese")
# 写法二
from selenium.webdriver.common.by import By
cheese = driver.find_element(By.NAME, "cheese")
```

#### by link text

```html
<a href="http://www.google.com/search?q=cheese">cheese</a>>
```

```py
# 写法一
cheese = driver.find_element_by_link_text("cheese")
# 写法二
from selenium.webdriver.common.by import By
cheese = driver.find_element(By.LINK_TEXT, "cheese")
```

#### by partial link text

```html
<a href="http://www.google.com/search?q=cheese">search for cheese</a>>
```

```py
# 写法一
cheese = driver.find_element_by_partial_link_text("cheese")
# 写法二
from selenium.webdriver.common.by import By
cheese = driver.find_element(By.PARTIAL_LINK_TEXT, "cheese")
```

#### by css

```html
<div id="food"><span class="dairy">milk</span><span class="dairy aged">cheese</span></div>
```

```py
# 写法一
cheese = driver.find_element_by_css_selector("#food span.dairy.aged")
# 写法二
from selenium.webdriver.common.by import By
cheese = driver.find_element(By.CSS_SELECTOR, "#food span.dairy.aged")
```


#### by xpath

```html
<input type="text" name="example" />
<INPUT type="text" name="other" />
```

```py
# 写法一
inputs = driver.find_elements_by_xpath("//input")
# 写法二
from selenium.webdriver.common.by import By
inputs = driver.find_elements(By.XPATH, "//input")
```

### 执行JavaScript

```py
# execute_script的参数就是要执行的JavaScript代码
element = driver.execute_script("return $('.cheese')[0]")
# 获取label元素
labels = driver.find_elements_by_tag_name("label")
inputs = driver.execute_script(
    "var labels = arguments[0], inputs = []; for (var i=0; i < labels.length; i++){" +
    "inputs.push(document.getElementById(labels[i].getAttribute('for'))); } return inputs;", labels)
```

### 获取文本内容

首先定位到目标元素,然后取`text`属性

```py
# 定位元素
element = driver.find_element_by_id("element_id")
# 取text
element.text
```

### 输入内容

选择下拉框

```py
# 定位到页面元素
select = driver.find_element_by_tag_name("select")
# 获取页面元素的相关属性
allOptions = select.find_elements_by_tag_name("option")
# 遍历操作
for option in allOptions:
    print "Value is: " + option.get_attribute("value")
    option.click()
```

```py
# available since 2.12
from selenium.webdriver.support.ui import Select
# 直接定位到一个select对象
select = Select(driver.find_element_by_tag_name("select"))
# 封装好的方法,不需要通过复杂的元素属性获取就可以操作对象
# 取消选择
select.deselect_all()
# 通过可见的文本内容选择显示为"Edam"的元素
select.select_by_visible_text("Edam")
```

### 点击事件

```py
# 定位到submit控件
submit = driver.find_element_by_id("submit")
# 模拟点击操作
submit.click()
# 可以简单写为
driver.find_element_by_id("submit").click()
# webdriver会遍历整个DOM,查找可以submit的元素,如果没有找到会抛异常,不推荐使用
element.submit()
```

### 切换页面

```html
<a href="somewhere.html" target="windowName">Click here to open a new window</a>
```

```py
# 切换至名为windowName的窗口
driver.switch_to.window("windowName")
# 通过handle遍历的方式切换窗口
for handle in driver.window_handles:
    driver.switch_to.window(handle)
# 切换至frame
driver.switch_to.frame("frameName")
# 切换至alert
alert = driver.switch_to.alert
```

### 导航

简单的模拟浏览器的历史导航功能,感觉用的不多

```py
# 浏览器前进
driver.forward()
# 浏览器后退
driver.back()
```

sample

```py
from selenium import webdriver
from time import sleep
import os
if 'HTTP_PROXY'in os.environ: del os.environ['HTTP_PROXY']

dr = webdriver.Chrome()

first_url = 'http://www.baidu.com'
print "now access %s" %(first_url)

dr.get(first_url)
sleep(1)
second_url = 'http://www.news.baidu.com'
print "now access %s" %(second_url)
dr.get(second_url)
sleep(1)

print "back to %s" %(first_url)
dr.back()
sleep(1)
print "forward to %s" %(second_url)
dr.forward()
sleep(1)
dr.quit()
```

### Cookie

```py
# Go to the correct domain
driver.get("http://www.example.com")

# Now set the cookie. Here's one for the entire domain
# the cookie name here is 'key' and its value is 'value'
driver.add_cookie({'name':'key', 'value':'value', 'path':'/'})
# additional keys that can be passed in are:
# 'domain' -> String,
# 'secure' -> Boolean,
# 'expiry' -> Milliseconds since the Epoch it should expire.

# And now output all the available cookies for the current URL
for cookie in driver.get_cookies():
    print "%s -> %s" % (cookie['name'], cookie['value'])

# You can delete cookies in 2 ways
# By name
driver.delete_cookie("CookieName")
# Or all of them
driver.delete_all_cookies()
```

### 代理

```py
profile = webdriver.FirefoxProfile()
profile.set_preference("general.useragent.override", "some UA string")
driver = webdriver.Firefox(profile)
```

# 拖放

```py
from selenium.webdriver.common.action_chains import ActionChains
element = driver.find_element_by_name("source")
target =  driver.find_element_by_name("target")

ActionChains(driver).drag_and_drop(element, target).perform()
```


[webdriver-download]: http://www.seleniumhq.org/download/ "webdriver-download"
[Python]: https://www.python.org/downloads/ "Python"
[get-pip]: https://bootstrap.pypa.io/get-pip.py "get-pip"
[cmder]: http://cmder.net/ "cmder"
[cmder-download]: https://github.com/cmderdev/cmder/releases/download/v1.3.2/cmder.zip "cmder-download"
[selenium]: https://pypi.python.org/pypi/selenium "selenium"
[chrome-driver]: https://sites.google.com/a/chromium.org/chromedriver/downloads "chrome-driver"