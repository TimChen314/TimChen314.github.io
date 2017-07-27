---
title:  <font size=7><b>Story of Terminal </b></font>
tags: [linux,编码,Terminal]   
top: 5
categories: [linux]   
date: 2017-07-27 17:00:00
---

# 总结
从本地到远程sever，经过了多个编码环节。从按下一个键到远程server最终反应，经历的过程：
本地terminal类型和编码 -> linux下terminal类型和编码 
+ ctrl+h的编码
**ascii中Backspace的值为010（八进制），而ASCII values can be represented in several equivalent ways.**
而ctrl+h的值也为010。
terminal区分不了二者，因此输入以ascii编码，则ctrl+h变为Backspace；而输入不以ascii编码，Backspace也会显示成^H，即ctrl+h
<!-- more -->
+ F1键
terminal类型的选择也会影响快捷键。
Xshell中，文件--属性--键盘--功能键类型 选择xterm R6，则VIM中可以绑定F1；如果选linux，则不可以


## 问题：
为什么BS无法删除，而是想左移动？
为什么在执行程序进行输入时，按下BS显示的是^H?

## 答案
   [知乎](https://www.zhihu.com/question/23550774/answer/132576876)：
``` 
早在 VT100终端时代，^H（ASCII码 0x08）表示<BS> 而 ^? （ASCII码 0x7f）表示<DEL>。过去 0x7f是留给 DELETE键使用的。而到了 VT220时代，DELETE已经变为 ^[[3~ （ASCII 码 0x1b, 0x5b, 0x33, 0x7e 共4个字节），而 ^? 的 0x7f 换给了我们的<BS>，有些老点版本的终端软件，默认 <BS>还是使用 VT100的 ^H，比如 Xshell 4 Build 0142以前的版本，默认<BS>是发送^H。SecureCRT直到6.x版本还在默认发送 VT100的 ^H。
```


Terminal
+ [VT100](http://www.ibb.net/~anne/keyboard.html)
**Xterms on the other hand, emulate the vt100 terminal, which didn't have a [Delete].**
```
VT100
Key            KeySymName       Console characters
  --------------------------------------------------
  Ctrl+H   --->  Control_H  --->  ASCII  BS (0x08)
  [<---]   --->  Backspace  --->  ASCII DEL (0x7F)
  --------------------------------------------------
Xterm's emulation of VT100
Key            KeySymName       Console characters
  --------------------------------------------------
  Ctrl+H   --->  Control_H  --->  ASCII  BS (0x08)
  [<---]   --->  Backspace  --->  ASCII BS (0x08)
  [Delete] --->  Delete     --->  ASCII DEL (0x7F)
```
VT series have their own keyboard: [http://www.vt100.net/](http://www.vt100.net/docs/vt510-rm/chapter8.html)


[wikipedia](https://en.wikipedia.org/wiki/Computer_terminal):
   >A personal computer can run** terminal emulator** software that replicates the function of a terminal, sometimes allowing concurrent use of local programs and access to a distant terminal host system.
