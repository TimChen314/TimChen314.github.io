---
title:  <font size=7><b>gnuplot笔记（上）</b></font>
tags: [画图,linux]   
top: 11
categories: linux   
date: 2017-08-16 20:00:00
---

gnuplot笔记，包含中高级使用方法，方便入门之后的进阶学习。
<!-- more -->
[TOC]

## Note about Version 5 
### 1. dashtype需要单独设置
与4.x版本不同，现在linetype画出的都是实线了。
例子：`p sin(x) dt 2 #设为2型虚线`
### 2. size的用法
+ eps to png
when eps size is set to 1.0,1.0，png的像素为600,420
eps：size 1.8,1.8 那么png的像素为1080,755
+ ==**x11**== set terminal x11 size 600,420应该是默认大小
size 2,2 会导致图像超过窗口大小

### 3. 新加入几个命令
`plot ... smooth mcsplines `
`plot <datafile> skip N`    # skip lines at start of ascii data file
`set colorsequence default|classic|podo` # colors used by successive plot elements
### 4. 变量的引用
For 4.6:
```
var=123
set label 1 'var' at 1,1 
```
For 5.0:
```
var=123
set label 1 var at 1,1 
```



## format
### 1. `set logscale y`
`set logscale` # x和y轴都设置成logscale
### 2. set format 
设置坐标轴上数字的格式。
以1000为例：
   ```gnuplot
set format x "10^{%L}" 
``` 
显示出来的格式为10^3

   ```gnuplot
set format x "%2.0t{\327}10^{%T}" 
``` 
显示为1×10^3 

需要注意的是：
   - `{\327}`是乘号，需要将编码指定为`set encoding iso_8859_1`才可以使用
   - `%t`与`%T`
  比如1200, %t=1.2 %T=3。这种写法可以方便的描线性标度下的较大的刻度。

### 3. offset x,y   
设置label到坐标轴的距离， 0,0 是默认距离 e.g. `set xlabel "123" offset 1,0`

### 4. `set ticscale n m`    
   >Command set ticscale n m changes the length (size) of tics. The major tics are multiplied by the provided value n, while the minor tics are multiplied by m.

只改major tics:`set tic scale 2`
  
### 5. 字体font:
 (1) gnuplot-5.0.1 manual:
   > All PostScript printers or viewers should know about the standard set of Adobe fonts Times-Roman, Helvetica, Courier, and Symbol.  

[注意：TimesNewRoman和Times（又称TimesRoman）是几乎一样的](https://www.zhihu.com/question/36527847)
 (2) TimesRoman和TimesNewRoman都是一样的
    For other fonts, 尽管程序不会报错，但也显示不出来
    但是可以加粗/斜体 （可以参看http://www.manpagez.com/info/gnuplot/gnuplot-4.4.0/gnuplot_390.php）
### 6. tc (textcolor)
### 7. border
`set border lw 3` 只改变线的宽度
  

### 8. key
**set key height #调节key与坐标轴的距离**
set key spacing 1.3 #调节两行之间的距离
set key maxcols/maxrow
set key autotitle

### 9. label 
+ 设定位置时候，是设定的左下角的坐标
+ 用法：·set label 1 '20%wt' at graph 0.42,0.92 font ',50'·

### 10. arrow
+ 控制起始/终止位置
set arrow from 坐标 to 坐标
e.g.: 
  `set arrow from 9.5,3.8 to 9.5,1.8 nohead lt 5 lc rgb "black"`
  `set arrow 1 from (log10(50000)),-1 to (log10(50000)),2 nohead lt 5 lc rgb "black"`  "arrow 1"中"1"是一个标记数组，方便arrow的管理，比如`unset arrow 1`就取消arrow 1。

+ 控制head
e.g.: 
`set arrow from -4,-4 to 4,-4 head filled size screen 1,30,55 lw 2 lt 2 lc rgb "cyan"`
其中head filled size 1,30,55 为控制head的格式。
`size <length>,<angle>{,<backangle>}`
length是长度,加上screen是代表屏幕长度，也就是相对长度；后面两个是箭头与线的角度

### 11. lmargin rmargin tmargin bmargin(左右上下)
以lmargin为例，lmargin是左侧坐标轴到图左边边界的距离







## style：颜色、形状等与审美相关的设置
### 1. line and point types
[gnuplot-line-and-point-types](https://img.alicdn.com/imgextra/i4/95029972/TB21hDfhpXXXXbrXpXXXXXXXXXX_!!95029972.png)

### 2. most useful point type
| shape | full id | empty  id|
|--------|--------|--------|
|    square    |   5     | 64 | 
|    sphere    |   7     | 65 | 
|    up-tri    |   9     | 66 | 
|    down-tri    |   11     | 67 |
|    diamond    |   13     | 68 |
|    pentagon    |   15     | 69 ||
e.g.:
`p sin(x) w p pt 5 `
### 3. 点的颜色的设置方法：
`lc rgb "red"`，或者`ls 1`也可以！
### 4. several color set
![my color](https://img.alicdn.com/imgextra/i3/95029972/TB2RODgopXXXXbSXXXXXXXXXXXX_!!95029972.png)






##  DSL(domain-specific language) in DSL
有时候一个图里可能有一次画10条线，如果一条一条的画太麻烦了。为此gnuplot内置了自己的DSL。包括循环、逻辑等语句。
### 0. for、字符串数组
+ for循环：
`p for [i = 1:9] sample.i.'.dat' u 1:2 w l ls i t 'p='.i   #一次画九条先，每条线有不同的title和linesytle（sytle是自己定义的）`
+ 字符串数组
`a="2 3 4 6 8 9 12 16 24" 
a被当成字符串数组,word(a,n)是字符串类型。整数可以除字符串，例如864/word(a,1)。sprintf内的变量也可以用864/word(a,1)。
**.**点：字符串连接操作符，只能用于处理字符串和变量，不能处理表达式！！！
**注意：sprintf与C++的sprintf一样，百分号的转义字符是%%。**
**总结：字符串和文件名都用sprinf；无论是字符类型还是数字类型，都可以用在ls，column这些地方，并且可以进行数学运算。例子可见Paper3_segMSD.plt**



### 1. escape charactor   
In postscript eps enhanced terminal, use `"\\"` before an escape charactor to keep its basic form, e.g. , `"\\_"`  representation `"_"`.
### 2.各种字符的表达方式，可以google "Syntax for postscript enhanced option"
  （0）例子：`set terminal postscript eps enhanced color lw 3.0 dashlength 3.0 "TimsRoman,50"`
  （1）PostScript Character Codes的模式是T模式；输入"set encoding"后是E模式
  （2）希腊字母写法的例子：`{/Symbol r}`
  （3）上下标同时出现：`t@^{\*}_{p}`，多用了一个@字符

### 3. string
+ 单引号内的字符串不转义，双引号内的字符串转义
+ set title noenhanced #让title的内容直接输出，不进行转义
+ ".", "eq" and "ne"
Three binary operators require string operands: the string concatenation operator".", the string equality operator"eq"and the string inequality operator"ne". The following example will print TRUE.
`if ("A"."B" eq "AB") print "TRUE"`

### 4.`print "hello world!"`







