---
title:  jupyter
tags: [python, jupyter]   
top: 11
categories: python  
date: 2018-01-16 18:00:00
---



# Tutorial

## %pylab?
This sentence will give out the 'help information' of pylab.
Note that %pylab will import 

## cell magics
Magics come in two kinds:【ct】可以简单理解为单行/多行
<!-- more -->

+ Line magics: these are commands prepended by one % character and whose arguments only extend to the end of the current line.

+ Cell magics:





### Some simple cell magics

   ```python
%%writefile foo.py
print('foo')
print('Equinox')
```

### Magics for running code under other interpreters

IPython has a %%script cell magic, which lets you run a cell in a subprocess of any interpreter on your system, such as: bash, ruby, perl, zsh, R, etc.

To use it, simply pass a path or shell command to the program you want to run on the %%script line, and the rest of the cell will be run by that script, and stdout/err from the subprocess are captured and displayed.

```
In [10]: %%script python2 import sys print 'hello from Python %s' % sys.version

```

### Background Scripts
These scripts can be run in the background, by adding the --bg flag.
When you do this, output is discarded unless you use the --out/err flags to store output as above.

```
In [17]: %%ruby --bg --out ruby_lines for n in 1...10    sleep 1    puts "line #{n}"    STDOUT.flush end

```

## shortcut key
[Jupyter Notebook 的快捷键](http://www.jianshu.com/p/72493e81a708)
### command mode

+ `ESC`: command mode

+ ==h: 显示快捷键帮助==

+ `Enter`: edit mode

+ `ctrl+enter`、`shitf+enter`: 执行、执行后选中下个单元

+ b: 在下方插入新单元

+ dd: 删除当前cell

+ m: 设为markdown cell

+ y: 单元转入代码状态

+ 3:     设定 3 级标题
+ x/c/v: 剪切/复制/粘贴

+ space/shift+spcae: 向下/上滚动

### edit mode

+ shift+tab:  补全提示

+ `ctrl + shift + -`: 分割cell










---

[source 1](http://nbviewer.jupyter.org/github/ipython/ipython/blob/4.0.x/examples/IPython%20Kernel/Cell%20Magics.ipynb)
[source 2](http://ipython.org/ipython-doc/3/notebook/notebook.html#importing-py-files)



