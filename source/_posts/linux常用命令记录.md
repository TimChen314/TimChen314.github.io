---
title:  <font size=7><b>linux常用命令记录 </b></font>
tags: [linux]   
top: 11
categories: linux   
date: 2017-07-31 18:00:00
---

记录用过的命令，方便以后查找。不包含太简单的或太难的。
<!-- more -->

[TOC]
##  正则表达式  
1.\< #匹配词头 \> #匹配词尾
2.+
  匹配1或多个
3.？
  匹配0或1个
4.x|y
  匹配x或y
5.x\{5,10\}
  匹配x出现5到10次


##  linux 一句话介绍命令：
+ shell 内置
`--`: a double dash (`--`) is used to signify the end of command options. 例如`ls -- -l`中会把`-l`当成文件名   
`echo $((a%b)) `: 余数   

+ 资源管理
`ulimit`: 管理用户占用的资源   
`nice & renice 命令`: 管理任务优先级   
`pkill -kill -t pts/5`: 踢掉相应的用户   
`sudo sh -c "echo 1 > /proc/sys/vm/drop_caches"`: 清理硬盘   
`iostat -x sdb1 1 3`: 显示sdb1的状态，每1秒显示一次，一共显示3次。   
+ 键盘
`bind -p`:  查看所有的键盘绑定   
`stty -a`: 查看下默认的键位设置   
`toe /usr/share/terminfo/`: supported terminal; you can compare two terminal by `infocmp vt100 vt220`   

+ 其他
`tac`: cat倒过来写，是将文件反向输出的命令   
`join命令`: 横向连接文件，可以合并第一列   
`tee`: `tee file1 file2 -`  #将标准输出，输出到file1、file2和标准输出（“-”就是代表标准输出）（**注意** 该命令本身会向标准输出 输出一次，所以tee file1 file2 - 会将标准输出 输出两次）   
`basename & dirname`: 从路径名得到root部分和文件名部分 
`read`: `read -p "make dir now?[y/n]:" select `#直接读入变量值   
`df -T`: 显示硬盘分区类型   
lsof:  `lsof -p 456,123` 列出进程456和123所有打开的文件。`lsof -i 6` 列出所有IPv6协议的网络文件
`ssh -X`:   `Enables X11 forwarding`然后就可以用vmd、gnuplot等软件了。    
`env`: 输出所有环境变量   
`ldd ./exe `:  给出链接的库   
`systemctl start atd`: arch中用at，需要开启   
`gimp`: 看图   
`info & whatis `: they tell the information of a command; Note that in OS, info whatis will get "search database ......"   

## linux Command line
Ctrl + a, Ctrl + e, alt + f 前进一个单词、alt + b(通过xshell并不好使):  谁用谁知道
Ctrl + f, Ctrl + b 前进一个字母/后退一个字母
Ctrl + 方向键左键    光标移动到前一个单词开头
Ctrl + 方向键右键    光标移动到后一个单词结尾   
`^oldstr^newstr`    替换前一次命令中字符串  
同时head&tail: `ls | (head;tail)` 或者 `(head; tail) < file`

### `!`系列命令
- `!-n`， 重复执行倒数第 n 条命令，n 为正整数；
- `!!`， 重复执行上一条命令。该命令等价于 !-1；!?str，重复执行最近一条包含字符串 str 的命令；
- `!#`，引用当前的命令行，例如：`cp filename filename.bak` 可以写为 `cp filename !#:1.bak`

- `!^`
重用上一条命令的第一个参数；
`ls /usr/share/doc  /usr/share/man; cd !^   `# 即 cd /usr/share/doc
- `!*`
重用上一条命令的所有参数； `touch a.txt b.txt c.txt`
 `vim !*`  # 即 vim a.txt b.txt c.txt
- `!!:n`
重用上一条命令中的第 n 个参数，n 为正整数。
 `vim {a..c}.txt`
 `vim !!:2`   # 即 vim b.txt
- `!str:x-y`
重用上一条以 str 开头的命令的第 x 到第 y 个参数；
 `touch a.txt b.txt c.txt d.txt`
 `vim !touch:2-3`   # 即 vim b.txt c.txt
- `!?str:n*`
重用上一条包含 str 的命令的从第 n 个到最后一个参数；
` vim foo.h foo.cc bar.h bar.cc`
 `wc !?vim:2*  `# 即 wc foo.cc bar.h bar.cc


### 参数的子字符串
- 利用 :h 截取路径开头，相当于 dirname    
   ```bash
ls /usr/share/fonts/truetype/dejavu    
cd !$:h  # 即 cd /usr/share/fonts/truetype
```
- 利用 :t 截取路径结尾，相当于 basename
    `tar zxf !$:t  # 相当于 tar zxf nginx-1.4.7.tar.gz`
- 利用 :r 截取文件名
    ```bash
    gunzip filename.gzip
    cd !$:r  # 即 cd filename
    ```
- 利用 :e 截取文件扩展名
    ```bash
    ls file.jpg
    echo !$:e  # 即 echo jpg<b>
    ```
简单记忆：
`h|t`
`r|e`


### alt
如果不是直接在终端上操作，alt键需要进行设置才能使用。**比如Xshell中，在“属性--键盘--将Alt键作为Meta仿真”打钩，才能使用；OS X上，无法用alt键。**PS：win键盘一般alt键当做Meta键；ALt GR：有些老键盘左边是Alt，右边是ALt GR键
Alt+./Esc+. (!^ !$): 将最近一条命令的参数输出
Alt+ f/b: 向前/后移动一个词

### 其他
- Brace Expansion
`ls /usr/{,local}/bin`，会列出"/usr/bin"和"/usr/local/bin"
- shell特殊变量
`$0`     当前shell程序的名字
`$1 ~ $9`    命令行上的第一到第九个参数   
`$#`    命令行上的参数个数
`$*, $@ `   命令行上的所有参数
`$?`    上一条命令的退出状态
`$$`    当前进程的进程标识号(PID)
`$!`    最后一个后台进程的进程标识号

### 外部资源链接
更多牛逼命令：           http://www.zhihu.com/question/20140085
                         http://www.zhihu.com/question/20273259
                         http://www.zhihu.com/question/25910725/answer/31951050
linux shell 快捷键:      http://blog.chinaunix.net/uid-361890-id-342066.html

### 编码 ctrl+h；终端 F1
+ **ascii中Backspace的值为010（八进制），而ASCII values can be represented in several equivalent ways.**
而ctrl+h的值也为010。
\
terminal区分不了二者，因此输入以ascii编码，则ctrl+h变为Backspace；而输入不以ascii编码，Backspace也会显示成^H，即ctrl+h
+ terminal类型的选择也会影响快捷键
Xshell中，文件--属性--键盘--功能键类型 选择xterm R6，则VIM中可以绑定F1；如果选linux，则不可以


##  alias命令： 
http://stackoverflow.com/questions/22537699/cannot-use-alias-while-executing-a-command-via-ssh
   >Quoted from the man page of bash: Aliases are not expanded when the shell is not interactive, unless the expand_aliases shell option is set using shopt ...

##     at命令：  
介绍：定时执行一次命令。如果想周期地执行命令，请使用crontab
1. `at -f work.sh now +3 min`
3分钟后执行脚本 work.sh    -f指的是从文件读入命令
其他的时间表示法：at 17:30 2/24/99
2. atq （等于at -l）
查看at任务队列
3. atrm+任务号
4. 似乎没有单命令行的用法，一般用法都是“at 时间”然后进入at命令，输入要执行的命令，然后退出



##   awk命令：  
**替换操作在awk中不易执行。**

1. `awk '/pattern/ {print $0 }' filename`
   e.g.  `awk '/abc/ {print $0 }' filename`, 则含有 abcde 的行也会被输出。 
2. `awk 'NR==2 {print $0}' aver.tmp `
3. `awk '$1!~/match_str/ {print $0 }' filename`
4. 去掉重复的单词
   ```awk
  #!/bin/awk -f

  {
    for (i = 1; i <= NF; i++)
    {
        ++word[$i]

        if (word[$i] == 1)
            printf("%s ", $i)
    }
    printf("\n")
  }
  ```
5. awk script
   ```awk
#!/usr/bin/awk -f
#是注释符号
BEGIN {
......
}
{ #这个中括号不能省略
......
}
END {
......
}
```

6. 引用外部变量的几种方式：
  【来自：http://club.topsage.com/thread-393615-1-1.html】
   >（1）`"'"var"'"  ——错。应该是"'"$var"'"`
  （2）`awk '{print a, b}' a=111 b=222 yourfile`
  （3）`awk –v a=111 –v b=222 ‘{print a,b}’ yourfile`
  （4）【ct】`pid=$(ps -f | awk '/gpu='"$gpu"'/ && !/awk/ {print $2}')`   ——在//之间，引用外部变量的正确方式是'"$v"'

7. 引用外部命令的两种方式：【http://hi.baidu.com/gubuntu/blog/item/050398ceb010513fb700c8d0.html】
例:`awk '{if(/Beren/) {print $0 | "cut -b 2-" } else print $0}' job.plm`
   但糟糕的是，上面这条命令的输出顺序与你设想的并不一致

8. 求最大值、最小值、求方差等
   ```awk
awk '{if (max=="")  {max=$3} else {if ($3>max) max=$3}} END {print max}' file1 
awk '{if (min=="")  {min=$2} else {if ($2<min) min=$2}} END {print min}' file1 
awk '{sum+=$1; sumsq+=$1*$1} END {print sqrt(sumsq/NR-(sum/NR)**2)}' file1 
【注意】：中间不能有空行或短行，否则$3=null，而系统会认为null比负数还小，如果数列中含有负数，那么上式就会出现问题
```
9. 求和
   + 对六百列分别求和
   ```bash
for((i=1;i<=600;i++))
do
  awk '{sum+=$'"$i"'}END{print sum/"'"$num_exc"'"}' ttt1.tmp >> data
done
```
   + 对行求和
   ```bash
awk -v FS="," -v OFS="+" '{$1="";system("echo $["$0"]")}'
awk -F',' '{for(i=2;i<=NF;i++)sum[NR]+=$i;print $1","sum[NR]}'
```
【来自】http://bbs.chinaunix.net/thread-1384345-1-1.html
10. printf用法
`printf "%s %s %s ",$1,$2,$3`
11. 求最大值、最小值、求方差等
   ```awk
awk '{if (max=="")  {max=$3} else {if ($3>max) max=$3}} END {print max}' file1 
awk '{if (min=="")  {min=$2} else {if ($2<min) min=$2}} END {print min}' file1 
awk '{sum+=$1; sumsq+=$1*$1} END {print sqrt(sumsq/NR-(sum/NR)**2)}' file1 
【注意】：中间不能有空行或短行，否则$3=null，而系统会认为null比负数还小，如果数列中含有负数，那么上式就会出现问题
```
12. awk中 '' 和 "" 【单引号和双引号】
   ""是直接输出
   ''是转义输出,'C1'就有特殊的含义
13. [gawk 4.1.0之后才可以原位修改文件](https://stackoverflow.com/questions/16529716/awk-save-modifications-in-place)



##    bc命令：  
1.m的n次方
`echo "m^n"|bc `
2.计算π： 
`echo "scale=100; a(1)*4" | bc -l`
【附一部分man】
   >MATH LIBRARY 
       If bc is invoked with the -l option, a math library is preloaded and the default  scale  is  set  to  20. 
       The  math  functions  will  calculate their results to the scale set at the time of their call.  The math 
       library defines the following functions: 
       s (x)  The sine of x, x is in radians.    正玄函数 
       c (x)  The cosine of x, x is in radians.  余玄函数 
       a (x)  The arctangent of x, arctangent returns radians. 反正切函数 
       l (x)  The natural logarithm of x.  log函数(以2为底) 
       e (x)  The exponential function of raising e to the value x.  e的指数函数 
       j (n,x) 
              The bessel function of integer order n of x.   贝塞尔函数

3.做加减法时（比如`a*b+c`）bc不会读入scale信息，所以要想设定scale，可以写成`(a*b+c）/1`,除法是一定会读入scale的。（`(a*b+c）*1`）没有效果，但`a*b`有效果）
【第二次测试，不存在这个问题了】
4. bc不能识别形式为科学计数法的输入，如1.2345e+06

## convert命令：
1. `convert ${i%plt}eps -density 100x100 ${i%plt}tif`
2. `convert ${i%plt}eps -density 300 ${i%plt}png  `  #300代表dpi
3. animated gif
   >`convert -delay 120 -loop 0 *.png animated.gif`
The delay parameter specifies the delay between frames in 0.01s, while the loop parameter determines how many times the animation runs (the 0 value will run the loop infinitely).

   [source](http://www.linux-magazine.com/Online/Blogs/Productivity-Sauce/Create-Animated-GIFs-with-ImageMagick)

##    cp命令：  
1. [cp自动创建层级结构](http://blog.chinaunix.net/uid-9525959-id-2303690.html)
例子: `cp --parents parentdir1/parentdir2/sourcefile destdir/`

##   cut命令：  
cut命令很好用
`awk '/Beren/ {print $0}' tt1 | cut -b 2-`cut部分的意思是截取第二个到最后一个字符。







# reference
