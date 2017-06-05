---
title: yield
date: 2017-06-01 19:22:18
update: 2017-06-03 16:22:18
tags:
category: [python,yield]
---
yield这个关键字是之前看爬虫框架的时候demo里面用到过的,当时心情也不好,没心思琢磨,今天突然看到一篇还不错的文章,感觉讲的够清楚,做个笔记
[参考链接][Python yield 使用浅析]
<!--more-->
按照我现在的理解,yield的作用就是返回一个可迭代的对象,用例子看一下吧

```py
def feb(max):
    n,a,b=0,0,1
    while n<max:
        yield b
        a,b=b,a+b
        n+=1
```

以上就是一个生成斐波那契数列的方法了,调用方法就跟range一样

```py
x = feb(20)
for i in x:
    print(i)
```

```
1
1
2
3
5
8
13
21
34
55
89
144
233
377
610
987
1597
2584
4181
6765
```

简单地讲，yield 的作用就是把一个函数变成一个 generator，带有 yield 的函数不再是一个普通函数，Python 解释器会将其视为一个 generator，调用 fab(5) 不会执行 fab 函数，而是返回一个 iterable 对象！在 for 循环执行时，每次循环都会执行 fab 函数内部的代码，执行到 yield b 时，fab 函数就返回一个迭代值，下次迭代时，代码从 yield b 的下一条语句继续执行，而函数的本地变量看起来和上次中断执行前是完全一样的，于是函数继续执行，直到再次遇到 yield。

一个带有 yield 的函数就是一个 generator，它和普通函数不同，生成一个 generator 看起来像函数调用，但不会执行任何函数代码，直到对其调用 next()（在 for 循环中会自动调用 next()）才开始执行。虽然执行流程仍按函数的流程执行，但每执行到一个 yield 语句就会中断，并返回一个迭代值，下次执行时从 yield 的下一个语句继续执行。看起来就好像一个函数在正常执行的过程中被 yield 中断了数次，每次中断都会通过 yield 返回当前的迭代值。

试了一下下面一段代码

```python
def h():
    print('wenchuan')
    yield 5
    print('fighting')
c=h()
c.__next__()
# >>> c.__next__()
# webchuan
# 5
# >>> c.__next__()
# fighting
# Traceback (most recent call last):
#   File "<stdin>", line 1, in <module>
# StopIteration
```

可以清晰的看到,执行第一次next()方法时,到yield就停止了,直到再次调用next(),打印出了fighting这个单词,然后抛出了迭代结束的异常
还有个send,慢慢消化,等我把selenium写完再回来补...

x.send()的作用是传递一个值给generator,可以根据值改变迭代器的状态

```python
def h(max):
    n=0
    while n<max:
        x=(yield n)
        if x is not None:
            n=x
        else:
            n+=1
            
x=h(1000)
x.__next__()
0
x.__next__()
1
......
x.__next__()
100
x.send(500)
500
x.__next__()
501
```

基本搞清楚这个东西怎么用了,下一节

[Python yield 使用浅析]: https://www.ibm.com/developerworks/cn/opensource/os-cn-python-yield/ "Python yield 使用浅析"