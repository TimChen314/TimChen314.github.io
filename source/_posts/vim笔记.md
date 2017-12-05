---
title:  vim笔记 
tags: [vim]   
top: 11
categories: vim   
date: 2017-08-01 18:00:00
---


记录用过的命令，方便以后查找。不包含太简单的或太难的。
<!-- more -->
删除线代表已经非常熟练的掌握，不需要再看了。
## vim下命令： 

~~(3)~~ `:.,$ s/str1/str2/g` 用字符串 str2 替换正文当前行到末尾所有出现的字符串 str1 
其中`.`代表当前行，`$`代表最后一行，而`.,$`就代表从当前行到最后一行
也可以这样 `:.,.+8 s/str1/str2/g`， 其中`.,.+8`代表从当前行到从当前行开始下面第8行。
例如：如果当前行是第二行，那么`:.,.+8 s/str1/str2/g`等价于`:2,10 s/str1/str2/g`

~~(4)~~ ` s/\(love\)able/\1er/  ` # 会将loveable替换成lover，`\1`代表第一对小括号内的匹配项   
(6) 读入文件   
`:23r input_file`，在当前文件23行将`input_file`的内容插入近来
(7) `<leader>` is backlash   
(8) “+y  复制到系统剪贴板   
(11) Vu(VU) # V mode下，大小写转换   

(14) vim中的g(global)和%的区别：   
   + g:全局的
s/pattern/replacement/  : 替换行中出现的每一个pattern
g/pattern/s/pattern/replacement/g : 开始处的g是全局命令，意味着对所有与地址匹配的行进行改变。结尾处的g是一个标志，意味着改变一行上的每个。
   linux中的grep = g/rep/p

   + %:代表这文件本身每一行

(15) 全部格式化: gg=G
(16) vi如何关闭打开的多个文件中的一个?
切换到你想关闭的 文件窗口.
然后输入 :bd
即 : buffers delete
就可以关闭了.
(17) 两条命令合在一起用
`:%s/abc/def/ | wq`
### 移动
+ zz 光标所在行居中
+ 20| 到第20列！【Normal mode】

### 多个文件同时处理
+ 文件以tab打开
   ```language
:args *.c
:tab all
```
   or `vim -p *.h *cc `
+ Run a command in multiple buffers
将所有文件进行格式化，并写入所有文件
     ```vim
:tabdo Autoformat
:wa 
```

### 替换、查找
+ 去掉换行符^M: 输入以下字符串: `%s/^M//g`  (注意，^M = Ctrl v + Ctrl m，而不是手动输入^M)
+ 换行符可以**用\n直接匹配，用\r添加**

+ 对文件内含有特定字符的行操作。
g/-/s/^/#/ 是把所有含‘-’的行注释掉


+ /open\c
    其中 \c表示忽略大小写
+ vi（lzy0xa@192.9.207.102）的正则表达式中`H[1-9]*`并不能match H20 ,因为这里vi认为`*`是匹陪[1-9]中的数，而不是匹配所有的字符。要想匹配H20、H320、H308之类的字符串就需要用`H[0-9]*`

### 代码折叠

   ```vimscript
set foldmethod=indent                                                        
set foldnestmax=10                                                           
set nofoldenable " makes sure that when opening, files are "normal", i.e. not
folded.                                                                      
set foldlevel=0                                                              
```
+ zM/zR zm/zr 
大/小写 -- 所有/逐层 
m/r -- 折叠/打开
+ （对当前折叠）zc/zo zC/zO
大/小写 -- 所有/逐层 
+ zf/zd 创建/删除折叠
+ zj/zk
+ [z / ]z       到当前打开的折叠的开始/结尾处。

### 显示信息
+ 历史命令
`q:`或`:hist`
+ 是否具有某种特性
   ```vim
:echo has('python3') #0 is false, 1 means true #判断是否支持python3
:echo has('viminfo')
```
### ==shell cmd in vim==
 + `:!pwd` # Execute the pwd unix command, then returns to Vi   
 + `!!pwd` # Execute the pwd unix command and insert output in file 
 + `:r !command`
 + `:起始行号,结束行号 !command`
 将起始行号和结束行号指定的范围中的内容输入到shell命令command处理，并将处理结果替换起始行号和结束行号指定的范围中的内容
 例如
 `:62,72 !sort #，将62行到72行的内容进行排序`
 + `:起始行号,结束行号 w !command`
 将起始行号和结束行号所指定的范围的内容作为命令command的输入。不会改变当前编辑的文件的内容

## vimrc
### Plugin

+ auto-pairs 
github readme里，有括号包裹单词这个功能，但我尝试多次也没有使用成功。
<A-e>或<M-e>对应这一功能（A means Alt, M means Meta, in present context Alt and Meta is the same ），但我在Xshell中用的时候，<A-e>并没有激活auto-pairs，激活的是linux自带的快捷键--向右移动到词尾。
最终我输入单个括号是用：ctrl+v，（
+ markdown插件 vim-markdown
http://www.jianshu.com/p/24aefcd4ca93
https://github.com/plasticboy/vim-markdown
有用的命令：c
   ```
:Toc
```

### YouCompleteMe 
+ 需要进入bundle文件夹进行编译
+ 错误`YouCompleteMe unavailable: requires Vim compiled with Python (2.6+ or 3.3+) support`
明明安装VIM时已经选择支持python3了，为什么还会报错？而且：
   ```vim
:echo has('python3') #返回值为0，说明在vim中不能正常支持python
```
   这很可能是因为：python运行时找不到库。解决方法就是添加python库的路径到LD_LIBRARY_PATH环境变量：
   ```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/anaconda3/lib/
```
   然而，这样又会导致其他程序找到的是`/opt/anaconda3/lib/`里的库，而非系统自带的库，例如：
   ```bash
$ evince
evince: symbol lookup error: /lib64/libgdk-3.so.0: undefined symbol: cairo_surface_set_device_scale
```
   **最终解决方法，是分别设置环境变量**，例如：
   ```bash
alias evince='LD_LIBRARY_PATH="" evince'
```
   这样evince启动时，就不会去anaconda的路径里面找库了。

### cmd
+ 颜色
.vim/colors/中放置配置文件
:colo 查看当前颜色
+ noremap：绑定键的时候，不迭代绑定
五中模式代号：nvoic


## reference 

[vim tutorial](https://danielmiessler.com/study/vim/#why)
[超过130个你需要了解的vim命令](http://developer.51cto.com/art/201308/406941.htm) 【好】
[vim map nmap](http://www.cnblogs.com/lq0729/archive/2011/12/24/2300189.html)【非常好，介绍vimrc的一些基本命令】

