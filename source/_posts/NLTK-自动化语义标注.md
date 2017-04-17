---
title: NLTK-自动化语义标注
date: 2017-04-17 22:05:09
tags: ['NLTK','聊天机器人','python']
category: [笔记,NLTK]
---
简单看了一下第四章,没看太懂,边写边做理解理解看
<!--more-->

# 英文词干提取器

```python
>>> import nltk
>>> porter = nltk.PorterStemmer()
>>> porter.stem('lying')
u'lie'
```

# 词性标注器

```py
>>> import nltk
>>> text = nltk.word_tokenize("And now for something completely different")
>>> nltk.pos_tag(text)
[('And', 'CC'), ('now', 'RB'), ('for', 'IN'), ('something', 'NN'), ('completely', 'RB'), ('different', 'JJ')]
```

其中CC是连接词，RB是副词，IN是介词，NN是名次，JJ是形容词
这是一句完整的话，实际上pos_tag是处理一个词序列，会根据句子来动态判断，比如：

```py
>>> nltk.pos_tag(['i','love','you'])`
[('i', 'NN'), ('love', 'VBP'), ('you', 'PRP')]
```

这里的love识别为动词
而：

```py
>>> nltk.pos_tag(['love','and','hate'])
[('love', 'NN'), ('and', 'CC'), ('hate', 'NN')]
```

这里的love识别为名词
nltk中多数都是英文的词性标注语料库，如果我们想自己标注一批语料库该怎么办呢？
nltk提供了比较方便的方法：

```py
>>> tagged_token = nltk.tag.str2tuple('fly/NN')
>>> tagged_token
('fly', 'NN')
```

这里的nltk.tag.str2tuple可以把fly/NN这种字符串转成一个二元组，事实上nltk的语料库中都是这种字符串形式的标注，那么我们如果把语料库标记成：

```py
>>> sent='我/NN 是/IN 一个/AT 大/JJ 傻逼/NN'
>>> [nltk.tag.str2tuple(t) for t in sent.split()]
[('\xe6\x88\x91', 'NN'), ('\xe6\x98\xaf', 'IN'), ('\xe4\xb8\x80\xe4\xb8\xaa', 'AT'), ('\xe5\xa4\xa7', 'JJ'), ('\xe5\x82\xbb\xe9\x80\xbc', 'NN')]
```

这么说来，中文也是可以支持的，恩~
我们来看一下布朗语料库中的标注：

```py
>>> nltk.corpus.brown.tagged_words()
[(u'The', u'AT'), (u'Fulton', u'NP-TL'), ...]
```

事实上nltk也有中文的语料库，我们来下载下来
执行

```py
nltk.download()
```

选择Corpora里的sinica_treebank下载
sinica就是台湾话中的中国研究院
我们看一下这个中文语料库里有什么内容，创建cn_tag.py，内容如下：

```py
>>> import sys
>>> reload(sys)
<module 'sys' (built-in)>
>>> sys.setdefaultencoding('utf-8')
>>> import nltk
>>> for word in nltk.corpus.sinica_treebank.tagged_words():
...     print word[0],word[1]
...
持 VC2
有效期 Nad
國際 Ncc
學生證 Nab
ＩＳＩＣ Nba
、 Caa
ＳＴＡ Nba
青年證 Nab
、 Caa
ＳＴＡ Nba
會員證 Nab
```

第一列是中文的词汇，第二列是标注好的词性
我们发现这里面都是繁体，因为是基于台湾的语料生成的，想要简体中文还得自己想办法。不过有人已经帮我们做了这部分工作，那就是[jieba切词][结巴切词]，强烈推荐，可以自己加载自己的语料，进行中文切词，并且能够自动做词性标注

# 词性自动标注

面对一片新的语料库(比如我们从未处理过中文，只有一批批的中文语料，现在让我们做词性自动标注)，如何实现词性自动标注？有如下几种标注方法：

默认标注器：不管什么词，都标注为频率最高的一种词性。比如经过分析，所有中文语料里的词是名次的概率是13%最大，那么我们的默认标注器就全部标注为名次。这种标注器一般作为其他标注器处理之后的最后一道门，即：不知道是什么词？那么他是名次。默认标注器用DefaultTagger来实现，具体用法如下：

```py
>>> import sys
>>> reload(sys)
<module 'sys' (built-in)>
>>> sys.setdefaultencoding('utf-8')
>>> import nltk
>>> default_tagger = nltk.DefaultTagger('NN')
>>> raw = '我勒个去'
>>> tokens = nltk.word_tokenize(raw)
>>> tags = default_tagger.tag(tokens)
>>> print tags
[('\xe6\x88\x91\xe5\x8b\x92\xe4\xb8\xaa\xe5\x8e\xbb', 'NN')]
```

正则表达式标注器：满足特定正则表达式的认为是某种词性，比如凡是带“们”的都认为是代词(PRO)。正则表达式标注器通RegexpTagge实现，用法如下：

```py
>>> pattern = [(r'.*们$','PRO')]
>>> tagger = nltk.RegexpTagger(pattern)
>>> print tagger.tag(nltk.word_tokenize('我们 累 个 去 你们 和 他们 啊'))
[('\xe6\x88\x91\xe4\xbb\xac', 'PRO'), ('\xe7\xb4\xaf', None), ('\xe4\xb8\xaa', None), ('\xe5\x8e\xbb', None), ('\xe4\xbd\xa0\xe4\xbb\xac', 'PRO'), ('\xe5\x92\x8c', None), ('\xe4\xbb\x96\xe4\xbb\xac', 'PRO'), ('\xe5\x95\x8a', None)]
```

查询标注器：找出最频繁的n个词以及它的词性，然后用这个信息去查找语料库，匹配的就标记上，剩余的词使用默认标注器(回退)。这一般使用一元标注的方式，见下面。

一元标注：基于已经标注的语料库做训练，然后用训练好的模型来标注新的语料，使用方法如下：

```py
>>> import nltk
>>> from nltk.corpus import brown
>>> tagged_sents = [[('我','PRO'),('小兔','NN')]]
>>> unigram_tagger = nltk.UnigramTagger(tagged_sents)
>>> sents = brown.sents(categories='news')
>>> sents = [['我','你','小兔']]
>>> tags = unigram_tagger.tag(sents[0])
>>> print tags
[('\xe6\x88\x91', 'PRO'), ('\xe4\xbd\xa0', None), ('\xe5\xb0\x8f\xe5\x85\x94', 'NN')]
```

这里的tagged_sents是用于训练的语料库，我们也可以直接用已有的标注好的语料库，比如：

```py
brown_tagged_sents = brown.tagged_sents(categories='news')
```

二元标注和多元标注：一元标注指的是只考虑当前这个词，不考虑上下文。二元标注器指的是考虑它前面的词的标注，用法只需要把上面的UnigramTagger换成BigramTagger。同理三元标注换成TrigramTagger

组合标注器：为了提高精度和覆盖率，我们对多种标注器组合，比如组合二元标注器、一元标注器和默认标注器，如下：

```py
t0 = nltk.DefaultTagger('NN')
t1 = nltk.UnigramTagger(train_sents, backoff=t0)
t2 = nltk.BigramTagger(train_sents, backoff=t1)
```

标注器的存储：训练好的标注器为了持久化，可以存储到硬盘，具体方法如下：

```py
>>> from cPickle import dump
>>> output = open('t2.pkl', 'wb')
>>> dump(t2, output, -1)
>>> output.close()
```

使用时也可以加载，如下：

```py
>>> from cPickle import load
>>> input = open('t2.pkl', 'rb')
>>> tagger = load(input)
>>> input.close()
```

# 结巴切词

## 主要功能

直接拷贝了[使用说明][使用说明]里面的例子

* jieba.cut 方法接受三个输入参数: 需要分词的字符串；cut_all 参数用来控制是否采用全模式；HMM 参数用来控制是否使用 HMM 模型
* jieba.cut_for_search 方法接受两个参数：需要分词的字符串；是否使用 HMM 模型。该方法适合用于搜索引擎构建倒排索引的分词，粒度比较细
* 待分词的字符串可以是 unicode 或 UTF-8 字符串、GBK 字符串。注意：不建议直接输入 GBK 字符串，可能无法预料地错误解码成 UTF-8
* jieba.cut 以及 jieba.cut_for_search 返回的结构都是一个可迭代的 generator，可以使用 for 循环来获得分词后得到的每一个词语(unicode)，或者用
* jieba.lcut 以及 jieba.lcut_for_search 直接返回 list
* jieba.Tokenizer(dictionary=DEFAULT_DICT) 新建自定义分词器，可用于同时使用不同词典。jieba.dt 为默认分词器，所有全局分词相关函数都是该分词器的映射。


```sh
pip install jieba
```

```py
# encoding=utf-8
import jieba

seg_list = jieba.cut("我来到北京清华大学", cut_all=True)
print("Full Mode: " + "/ ".join(seg_list))  # 全模式

seg_list = jieba.cut("我来到北京清华大学", cut_all=False)
print("Default Mode: " + "/ ".join(seg_list))  # 精确模式

seg_list = jieba.cut("他来到了网易杭研大厦")  # 默认是精确模式
print(", ".join(seg_list))

seg_list = jieba.cut_for_search("小明硕士毕业于中国科学院计算所，后在日本京都大学深造")  # 搜索引擎模式
print(", ".join(seg_list))
```

```text
【全模式】: 我/ 来到/ 北京/ 清华/ 清华大学/ 华大/ 大学

【精确模式】: 我/ 来到/ 北京/ 清华大学

【新词识别】：他, 来到, 了, 网易, 杭研, 大厦    (此处，“杭研”并没有在词典中，但是也被Viterbi算法识别出来了)

【搜索引擎模式】： 小明, 硕士, 毕业, 于, 中国, 科学, 学院, 科学院, 中国科学院, 计算, 计算所, 后, 在, 日本, 京都, 大学, 日本京都大学, 深造
```

## 载入词典

开发者可以指定自己自定义的词典，以便包含 jieba 词库里没有的词。虽然 jieba 有新词识别能力，但是自行添加新词可以保证更高的正确率
用法： `jieba.load_userdict(file_name) # file_name`为文件类对象或自定义词典的路径
词典格式和 dict.txt 一样，一个词占一行；每一行分三部分：词语、词频（可省略）、词性（可省略），用空格隔开，顺序不可颠倒。file_name 若为路径或二进制方式打开的文件，则文件必须为 UTF-8 编码。
词频省略时使用自动计算的能保证分出该词的词频。

今天先看到这里,慢慢消化,回头回来补

[使用说明]: https://github.com/fxsjy/jieba/blob/master/README.md "使用说明"
[结巴切词]: https://github.com/fxsjy/jieba "结巴切词"