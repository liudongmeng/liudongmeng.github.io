---
title: pytesseract
category:
  - 笔记
date: 2017-07-01 14:21:36
tags:
---
说实话最近上班有点不走心...
不过对于某人的事情还是尽心尽力,比如今天这个玩意儿
简单的说,就是一个ocr的工具,可以简单的识别验证码,稍微跑了跑测试过了,先写写吧,windows环境其实有些烦的
<!--more-->

## step-1 安装tesseract-ocr
下载地址如下:
[tesseract-download-3.05][tesseract-download-3.05]
[tesseract-download-4.0][tesseract-download-4.0]
我当时着急测试没看清楚,下的3.05的版本,反正是可以用的,下载下来安装,之后将安装的路径添加到环境变量里面就好了
当时看的文章里面有提到说64位安装的时候要把默认路径里面的(x86)去掉,我反正是去了,但是想想不去应该也不影响啊😶

## step-2 安装python相关的库

```sh
pip install olefile
pip install Pillow
pip install pytesseract
```

实际情况来说应该直接执行最后一个命令就可以了,因为这几个包之间是有依赖关系的

```txt
Name: olefile
Version: 0.44
Summary: Python package to parse, read and write Microsoft OLE2 files (Structured Storage or Compound Document, Microsoft Office) - Improved version of the OleFileIO module from PIL, the Python Image Library.
Home-page: https://www.decalage.info/python/olefileio
Author: Philippe Lagadec
Author-email: https://www.decalage.info/contact
License: BSD
Location: /Users/liudongmeng/ENV/lib/python2.7/site-packages
Requires: 

Name: Pillow
Version: 4.0.0
Summary: Python Imaging Library (Fork)
Home-page: http://python-pillow.org
Author: Alex Clark (Fork Author)
Author-email: aclark@aclark.net
License: Standard PIL License
Location: d:\programdata\anaconda3\lib\site-packages
Requires: olefile

Name: pytesseract
Version: 0.1.7
Summary: Python-tesseract is a python wrapper for google's Tesseract-OCR
Home-page: https://github.com/madmaze/python-tesseract
Author: Matthias Lee
Author-email: pytesseract@madmaze.net
License: GPLv3
Location: d:\programdata\anaconda3\lib\site-packages
Requires: Pillow
```

## step-3 demo

```py
import pytesseract
from PIL import Image
from os import path
pic_path = path.abspath('.')

pytesseract.pytesseract.tesseract_cmd = 'D:/Program Files/Tesseract-OCR/tesseract'
def main():
    try:
        image = Image.open('image.jpg')
        code = pytesseract.image_to_string(image)
        print(code)
    except Exception as e:
        print(e)

if __name__ == '__main__':
    main()
```

[tesseract-download-3.05]: http://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-setup-3.05.00dev.exe "tesseract-download-3.05"
[tesseract-download-4.0]: http://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-setup-4.00.00dev.exe "tesseract-download-4.0"