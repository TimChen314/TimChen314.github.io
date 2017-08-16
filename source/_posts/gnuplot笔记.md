---
title:  <font size=7><b>gnuplot笔记 </b></font>
tags: [画图,linux]   
top: 10
categories: linux   
date: 2017-08-16 20:00:00
---

[TOC]

##  DSL(domain-specific language) in DSL
有时候一个图里可能有一次画10条线，如果一条一条的画太麻烦了。为此gnuplot内置了自己的DSL。包括循环、逻辑等语句。
### 0. for、字符串数组
+ for循环：
`p for [i = 1:9] sample.i.'.dat' u 1:2 w l ls i t 'p='.i   #一次画九条先，每条线有不同的title和linesytle（sytle是自己定义的）`
+ 字符串数组
```
a="2 3 4 6 8 9 12 16 24" 
```
a被当成字符串数组,word(a,n)是字符串类型。整数可以除字符串，例如864/word(a,1)。sprintf内的变量也可以用864/word(a,1)。
**.**点：字符串连接操作符，只能用于处理字符串和变量，不能处理表达式！！！
**注意：sprintf与C++的sprintf一样，百分号的转义字符是%%。**
**总结：字符串和文件名都用sprinf；无论是字符类型还是数字类型，都可以用在ls，column这些地方，并且可以进行数学运算。例子可见Paper3_segMSD.plt**



### 1. escape charactor   
In postscript eps enhanced terminal, use "\\" before an escape charactor to keep its basic form, e.g. , "\\_" representation "_".
### 2.各种字符的表达方式，可以google "Syntax for postscript enhanced option"
  （0）例子：`set terminal postscript eps enhanced color lw 3.0 dashlength 3.0 "TimsRoman,50"`
  （1）PostScript Character Codes的模式是T模式；输入"set encoding"后是E模式
  （2）希腊字母写法的例子：{/Symbol r}
  （3）上下标同时出现：t@^{\*}_{p}，多用了一个@字符

### 3. string
+ 单引号内的字符串不转义，双引号内的字符串转义
+ set title noenhanced #让title的内容直接输出，不进行转义
+ ".", "eq" and "ne"
Three binary operators require string operands: the string concatenation operator".", the string equality operator"eq"and the string inequality operator"ne". The following example will print TRUE.
`if ("A"."B" eq "AB") print "TRUE"`

### 4.`print "hello world!"`







## format
### 1. `set logscale y`
`set logscale` # x和y轴都设置成logscale
### 2. set format 
设置坐标轴上数字的格式。
以1000为例：
+ `set format x "10^{%L}"`，显示出来的格式为$$$10^3$$$
+ `set format x "%2.0t{\327}10^{%T}"`，显示为$$$1×10^3$$$
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

### 14. points 
    颜色的设置方法：lc rgb "red"
## Note about Version 5 
### 1. dashlength需要单独设置
`p sin(x) dt 2 #设为2型虚线`
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









## gnuplot命令
### 1. terminal
gnuplot可以将画出的结果输出到不同terminal中。所谓terminal，既可以是png、eps等图片格式，也可以是x11、qt等窗口格式。
+ x11 支持像素大小
`set terminal x11 enhanced lw 3.0 dashlength 5.0 size 1080,755` 可以使用interactive脚本
`set terminal x11 font "Helvetica,45"` 加上font后，就不能使用了

+ eps 不支持支持像素大小
eps默认是以inch为单位，默认大小是10,6；我的图因为还要放大1.8倍，所以是18,10.8
All PostScript printers or viewers should know about the standard set of Adobe fonts ==Times-Roman, Helvetica, Courier, and Symbol.==
+ eps ps、eps格式不支持transparent，png支持

+ eps不支持transparent
ps、eps格式不支持transparent，可以用png格式。


### 2. 数据筛选/处理
#### 2.1. awk等预处理
+ 下面两条命令是等价的
`plot 't1.dat' `
`p '< cat t1.dat' `
+ 我用过
```gnuplot
p "<awk '{if(NR>13) print}' q.log"
```

#### 2.2. pi（pointinterval） for linespoints plot
只用于linespoints plot。决定点的symbol的稀疏，用法例子：`pi 2`，“means that point symbols are drawn only for every Nth point”

#### 2.3. every
==**注意every不能简写成e**==
5个冒号，最后一个数字之后的冒号==必须要省略==
正确写法是：
`
p  'PS500_26w_1/msd-PS_1.dat'every 10::::90000 w l
`
而不是：
`
p  'PS500_26w_1/msd-PS_1.dat'every 10::::90000: w l
`
**意思是每10个数据点画一个，一共画到第九万个点**
具体参看gnuplot5.0.1 P85或`help every`


#### 2.4. index( column(-2) )
用于一个文件中多个数据
[stackoverflow](http://stackoverflow.com/questions/12818797/gnuplot-plotting-several-datasets-with-titles-from-one-file)

```
"p = 0.1"
1 1
3 3
4 1


"p = 0.2"
1 3
2 2
5 2
```
```
 plot 'test.dat' i 0 u 1:2 w lines title columnheader(1),\
      'test.dat' i 1 u 1:2 w lines title columnheader(1)
```
需要注意的是光用空格来分割两个data block是不够的。
column(-2)是Pseudocolumns，可以在manual中搜索是Pseudocolumns。

### 3. 保存交互模式下的命令为脚本
```gnuplot
gnuplot> save 'name.plt'
gnuplot> load 'name.plt'
```

### 4. 函数及设置定义域
```gnuplot  
  g(x)=3*x**2 # 普通函数
  f(x,min,max)=( (x>min && x<max) ? (3*x**2) : 1/0 ) # 定义一个带定义域的函数
  p f(x,1,100) w l # 在[1,100]的定义域内，画出3*x**2
```
`f(x,min,max)=( (x>min && x<max) ? (3*x**2) : 1/0 )`的解释：
min，max只是自定义的变量，` ? : `是经典三元表达式，`1/0`在gnuplot中不会被画出。综合起来`f(x,min,max)`的定义相当于：如果`(x>min && x<max)`，就画出3*x**2，否则不画。
**这里用到的几个技巧很有用，不光可以用来定义域。
**

### 5. 自带函数
+ log() & log10()
+ exp
+ sin()等三角函数
+ gamma()

### 6. fit  
+ 自变量要设定成x、y等，如`f(x)=exp(-(x/tau)**beta)`，因为gnuplot似乎对变量名敏感
+ fit范围
```gnuplot
f(x)=a*x**b
fit [0:300] f(x) 'msd.dat'u 1:5 via a,b
```

### 7. 传入参数到脚本
命令行（CLI）下，
```shell
gnuplot -c script.plt hehestr1 str2 str3
```
"script.plt" 就是ARG0，以此类推"hehestr1"就是ARG1...


### 8. how to set the config file?
show loadpath at 200.18 show that configuration file locate at `/home/ct/bin/gnuplot/share/gnuplot/4.6/`
gerenal configuration is in app-defaults dir.

### 9. smooth csplines 可以解决由于点多画不出虚线的问题


### 少用的命令
+ [Interactive label placing](http://www.gnuplotting.org/tag/interactive/)
+ parametric mode
```
set parametric
set trange [-pi:pi]
plot sin(t),cos(t)
unset parametric
```
+ MOUSE_BUTTON
点左键 MOUSE_BUTTON==1；
中键 ==2；
右键 ==3;
光点击的话，其他三个自带变量（MOUSE_SHIFT,MOUSE_ALT,MOUSE_CTRL）==0



## 显示信息型命令
### 1. show
show variables
show all
### 2. history
  `history 5           `  #显示最近5条命令
  `history ?load       `  #显示所有以load开头的命令
  `history ?"set label"`  #显示所有以set label开头的命令
  `history !"set label"`  #执行所有以set label开头的命令
### 3. test
test可以展示当前terminal或palette的画图效果
`test (terminal | palette)`
```
gnuplot> help test
 This command graphically tests or presents terminal and palette capabilities.
 ...
```
+ x11 test
`test x11`
![x11 test](https://img.alicdn.com/imgextra/i1/95029972/TB2Zr_ShXXXXXcTXpXXXXXXXXXX_!!95029972.jpg)
+ eps test
![eps test](https://img.alicdn.com/imgextra/i1/95029972/TB2uWEAhXXXXXaRXXXXXXXXXXXX_!!95029972.jpg)
+ png test
![png test](https://img.alicdn.com/imgextra/i4/95029972/TB2k97ihXXXXXalXpXXXXXXXXXX_!!95029972.jpg)



## 各种plot
### multiplot
```gnuplot
 set size 3,1.5
 set multiplot
 
#set the parameter of 1st subfigure
 set origin 0,0
 set size 1.5,1,5
 p ......
#set the parameter of 2nd subfigure
 set origin 1.5,0
 set size 1.5,1,5
 p ......
```

+ 对齐subfig
用set lmargin 进行对齐

+ 调整所有subfig的scale大小
set tics scale 3
+ 取消前面的设置
因为后面的subfig会继承前面subfig的设置，有时候需要取消前面的设置。
时常需要取消的有：label, arrow, scale等。
最常用的取消方式是unset
**对于key**--set key default
**对于tics**-- set xtics autofreq

### 3D plot
+ view
view用来设定3d图的观察角度
`set view <rot_x>, <rot_z>`
默认值是：
`set view 60, 30`

+ 设置Z轴起点
`set xyplane at 0.6`
+ 设置背景网格
`set grid x y z back`
+ 自定义渐变色
`set palette define (0.6 "#FF0000",1.1 "blue")`
+ External Link
[1](http://jswails.wikidot.com/using-gnuplot)
[2 Plot functions using the special-filenames property](http://www.gnuplotting.org/tag/splot/)


+ **colorbox**
 **自定义colorbox**： `set colorbox vertical user origin 1.1,0.5 size .06,.4`
 **设定colorbox的tics**： `set cbtics 0.1`
 **set logscale cb**
 **set cbrange [0.001:1]**


### filled curve
![示意图](http://gnuplot.sourceforge.net/demo_4.6/fillbetween.1.png)
`plot 'silver.dat' u 1:2:3 w filledcu`


## Error & 问题：   
+ 输出文件的大小为0——解决方法：
The eps file doesn't get written until a plot command is specified after specifing the output. Possible solutions:
1) Move your plot command after your set output command
2) add a replot command to the end of your script

## Reference
An amazing web: [gnuplotting.org](http://www.gnuplotting.org/tag/palette/)


