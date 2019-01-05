---
title: mnist
category:
  - 笔记
date: 2019-01-01 14:52:03
tags:
---

# 利用TensorFlow实现MNIST数据集的训练

## 什么是MNIST数据集

[MNIST数据集][MNIST数据集]由手写数字图像组成，它分为60,000个训练集示例和10,000个测试示例。在许多论文中，60,000的官方训练集分为50,000个实例和10,000个验证示例的实际训练集（用于选择学习率和模型大小等超参数）。所有数字图像都经过尺寸标准化，并以28 x 28像素的固定尺寸图像为中心。在原始数据集中，图像的每个像素由0到255之间的值表示，其中0是黑色，255是白色，其间的任何东西是不同的灰色阴影。

数据集([下载地址][下载地址])的使用方式

官网的例子是python2的,到python3一个是要把cPickle库换成pickle,然后就是`pickle.load(f, encoding='latin1')`
```py
import pickle
import gzip
import numpy

def load_dataset(fp):
    # Load the dataset
    f = gzip.open(fp, 'rb')
    train_set, valid_set, test_set = pickle.load(f, encoding='latin1')
    f.close()
    x_train, y_train = train_set
    x_valid, y_valid = valid_set
    x_test, y_test = test_set
    x_train = x_train/255
    x_valid = x_valid/255
    x_test = x_test/255
    dataset = {"x_train": x_train, "y_train": y_train, "x_valid": x_valid,
               "y_valid": y_valid, "x_test": x_test, "y_test": y_test}
    return dataset
```

## 什么是TensorFlow

[TensorFlow][TensorFlow]是一个用于研究和生产的开源机器学习库。 TensorFlow为初学者和专家提供API，以便为桌面，移动，Web和云开发。
官网现在的例子已经变了很多,主要提供了很多封装好的API供用户使用,底层的开发很少提及

## Lower API实现

```py
import tensorflow as tf
from data_loader import load_dataset

epochs = 50
batch_size = 100
dataset = load_dataset('./data/mnist.pkl.gz')
sess = tf.InteractiveSession()
# 定义占位变量,用于输入训练数据
x = tf.placeholder(dtype=tf.float32, shape=[None, 784])
y = tf.placeholder(dtype=tf.int64, shape=[None])
# 定义模型变量
w = tf.Variable(tf.zeros([784, 10]))
b = tf.Variable(tf.zeros([10]))
# 定义模型
_y = tf.matmul(x, w)+b
# 定义损失函数
loss = tf.losses.sparse_softmax_cross_entropy(labels=y, logits=_y)
# 预测结果
prediction = tf.argmax(_y, 1)
# 定义准确率函数,用于输出观察模型的训练情况
correction = tf.equal(prediction, y)
accuracy = tf.reduce_mean(tf.cast(correction, tf.float32))
# 定义训练方法,这里用的是Adam梯度下降
train = tf.train.AdamOptimizer(0.5).minimize(loss)
# 初始化模型变量
tf.global_variables_initializer().run()
# 训练迭代的次数
for i in range(epochs):
    # 根据batch_size获取数据进行训练
    for j in range(50000//batch_size):
        bx, by = dataset['x_train'][j*batch_size:(
            j+1)*batch_size], dataset['y_train'][j*batch_size:(j+1)*batch_size]
        sess.run(train, {x: bx, y: by})
        # 定期输出准确率信息
        if (j*batch_size) % 10000 == 0:
            acc = sess.run(
                accuracy, {x: dataset['x_test'], y: dataset['y_test']})
            print('epoch={0},accuracy={1:2f}'.format(i, acc))
# 输出最终准确率
acc = accuracy.run({x: dataset['x_test'], y: dataset['y_test']})
print('epoch={0},accuracy={1:2f}'.format(i, acc))
```

## Higher API实现

显而易见的是,keras的api实现实在是太简单了...

```py
import tensorflow as tf
from data_loader import load_dataset

dataset = load_dataset('./data/mnist.pkl.gz')
model = tf.keras.Sequential([
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dense(512, activation='relu6'),
    tf.keras.layers.Dropout(0.2),
    tf.keras.layers.Dense(10, activation='softmax')
])
model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy', metrics=['accuracy'])
model.fit(x=dataset['x_train'], y=dataset['y_train'], epochs=5)
```

[MNIST数据集]: http://deeplearning.net/tutorial/gettingstarted.html "MNIST数据集"
[下载地址]: http://deeplearning.net/data/mnist/mnist.pkl.gz "下载地址"
[TensorFlow]: https://www.tensorflow.org "TensorFlow"