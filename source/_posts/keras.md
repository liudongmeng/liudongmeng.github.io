---
title: keras
date: 2017-05-16 01:11:51
tags: [keras]
category: [笔记,keras]
---
公司要做一个简单的机器学习项目,用来预测一些我们无法用因果关系推导出来的关系
简单看了看机器学习的一些相关知识,数学不好,理解不深,先学学框架怎么用吧,数学的事情,也只好慢慢来了
/(ㄒoㄒ)/~~
<!--more-->
其实之前已经稍微做了一点,但是是生抄的代码
现在需要把训练模型稍微改一下,数据从原来的0/1变成了一个一维数组,正好结合之前抄的代码理解一下keras的用法
keras的使用方法大概就是下面这一段代码,建立模型,然后带入数据,models.fit(....)算就好了
关于深度学习,真有能力从原始的数学原理开始推导肯定是最好的
像我这种菜鸡,强烈推荐先把玩一下Google的[TensorFLowPlayground][TensorFLowPlayground]这个项目

```py
from keras.models import Sequential
from keras.layers import Dense,Activation
# For a single-input model with 2 classes (binary classification):
model = Sequential()
model.add(Dense(32, activation='relu', input_dim=100))
model.add(Dense(1, activation='sigmoid'))
model.compile(optimizer='rmsprop',
              loss='binary_crossentropy',
              metrics=['accuracy'])
# Generate dummy data
import numpy as np
data = np.random.random((1000, 100))
labels = np.random.randint(2, size=(1000, 1))
# Train the model, iterating on the data in batches of 32 samples
model.fit(data, labels, epochs=10, batch_size=32)
```

这段代码其实就是一个完整的训练模型了,再略微思考思考吧,今天先简单写到这里.
好久没有更新博客,其实也没太多营养,慢慢积累吧,说不定哪一天也有人能顺着我的文章和思路解决一些入门的问题呢?

[TensorFLowPlayground]: http://playground.tensorflow.org/ "TensorFlow playground"