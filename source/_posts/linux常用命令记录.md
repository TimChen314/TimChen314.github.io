---
title:  linux常用命令记录 
tags: [linux]   
top: 11
categories: linux   
date: 2017-07-31 18:00:00
---

记录用过的命令，方便以后查找。不包含太简单的或太难的。
长度感人。
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


##    diff命令    
1.对比两个文件夹的不同
`diff -ruN tmp_galamost-3.0.6/ galamost-3.0.6_origin/ > diff_text`

## echo命令：
- `-e` 开启反斜杠转义字符
- `-E` 关闭反斜杠转义字符
- `-n` 去掉echo默认输出的换行符
- 测试
   ```bash
$ echo -e "a\tb\tc\n"
a	b	c
$ echo -E "a\tb\tc\n"
a\tb\tc\n
```

##     gprof：    
http://blog.csdn.net/linquidx/article/details/5916701
http://blog.csdn.net/stanjiang2010/article/details/5655143
1. gprof -b -A -p -q test gmon.out > x
-b选项的作用是输出程序说明，对比加-b选项和不加的情况就明白了


##  grep命令：  
- `-i`： 忽略大小写
- `-v`： 不显示匹配的项

##   kill命令：  
如果要让它恢复到后台，用kill -CONT 1234 （很多在前台运行的程序这样是不行的）
kill -STOP 1234 
如果要恢复到前台，请在当时运行该进程的那个终端用jobs命令查询暂停的进程



##    ls命令：  
1.只显示文件
`ls -l | grep ^- | awk '{print $9}'`
`ls -1 -F | grep -v [/$]`

2.只显示文件夹
只显示文件夹： `ls -d */ `
`-d`的意义:      显示目录本身的信息，而不是列出目录下的文件
`ls *`：         显示所有文件、文件夹及其中的文件(文件夹)
`ls -d *`:       显示所有文件、文件夹

###    查看linux进程的执行文件路径
   >           1、以超级用户登陆
           2、进入/proc目录
           3、ps查看所有符合./cmd的进程，找出其对应的PID进程号
           4、用ll命令： ll 进程号 
              如下显示一个示例：
              [root@Cluster1 proc]# ll 22401 (proc文件夹中有对应PID码的文件名,进入即可)
       total 0
       -r--r--r--    1 zhouys    zhouys     0 Dec 11 11:10 cmdline
       -r--r--r--    1 zhouys    zhouys     0 Dec 11 11:10 cpu
       lrwxrwxrwx    1 zhouys    zhouys     0 Dec 11 11:10 cwd -> /home/zhouys/sbs/bin
       -r--------    1 zhouys    zhouys     0 Dec 11 11:10 environ
       lrwxrwxrwx    1 zhouys    zhouys     0 Dec 11 11:10 exe -> /home/zhouys/sbs/bin/cbs (deleted)
       dr-x------    2 zhouys    zhouys     0 Dec 11 11:10 fd
       -r--------    1 zhouys    zhouys     0 Dec 11 11:10 maps
       -rw-------    1 zhouys    zhouys     0 Dec 11 11:10 mem
       -r--r--r--    1 zhouys    zhouys     0 Dec 11 11:10 mounts
       lrwxrwxrwx    1 zhouys    zhouys     0 Dec 11 11:10 root -> /
       -r--r--r--    1 zhouys    zhouys     0 Dec 11 11:10 stat
       -r--r--r--    1 zhouys    zhouys     0 Dec 11 11:10 statm
       -r--r--r--    1 zhouys    zhouys     0 Dec 11 11:10 status
              /proc文件系统下的 进程号目录 下面的文件镜像了进程的当前运行信息，
              从中可以看到：
              cwd符号链接的就是进程22401的运行目录；
              exe符号连接就是执行程序的绝对路径；
              cmdline就是程序运行时输入的命令行命令；本例为：./cbs
              cpu记录了进程可能运行在其上的cpu；显示虚拟的cpu信息
              environ记录了进程运行时的环境变量
              fd目录下是进程打开或使用的文件的符号连接
              ...
        通过cwd直接进入进程运行目录，通过查看相关信息就可以定位此目录对应那个端口号，以及
    定位是那个应用才使用此服务程序。       
           5、`ps -aux` 命令
           ps也可打印其路径,但不是万能的,有些路径只能使用以上两种方法取得


## ln
+ ln source target
+ hard link
hard link是两个文件共享一个inode，然而各种编辑器编辑文件时（例如vi, Mou），是会重新生成一个文件并删除老文件的，这导致inode变化。所以hard link是几乎没用的功能：因为文件的inode经常会变。


##  mkdir命令：
在预设情况下目录得一层一层的建立，但通过-p参数，就可以之间建立。


## printf命令： 
1.补零
`printf "%05d" 123`
结果是：00123
参考：http://blog.csdn.net/truelie/article/details/1692942


##     ps命令     
1. linux查看进程启动时间(运行多长时间) 
`ps -eo pid,lstart,etime | grep your_pid`


##   sed命令：  
[sed命令详解](http://www.cnblogs.com/ctaixw/p/5860221.html)   
1. 抓取第m 到 第n行：
`sed -n "m,np" filename`
`sed -n "$[$fl*($i-1)+1],$[$fl*$i]p" ../../precopy/h-tail-10 > frame$i`

3. 在file1第3行之后插入file2:
`sed '3 r file2' file1`

4. 将“vel[i].x vel[i].y vel[i].z”替换成“velx[i] vely[i] velz[i]”
`s/\[i\]\.\([xyz]\)/\1[i]/g`

5. &字符 : 代表其前 pattern 字串
例：`sed -e 's/test/& my car/' `替换后变为：test my car

6. 在有字符串33的行的行首，添加
`sed -i '/33/s/^/#&/' t1.plm`
注意为什么要有^：
有“^”，“&”代表的是有字符串33存在的整行
没有“^”，“&”代表的是字符串33
7. 将原来的所有空行删除并在每一行后面增加一空行
`sed '/^$/d;G' file3`
8. 在指定(export)行前面加行
`sed '/export/i xxx' file`或`sed '/export/i \xxx' file`
  在指定(export)行前面后行
`sed '/export/a xxx' file`或`sed '/export/a \xxx' file`
9. 单引号的转义
`'\''`
`sed 's/'\''//g' `# 将单引号替换为空格
10. 匹配空行
正常匹配空行是`^$`；但是对于从windows拷贝过来的文件，要用`^.$`匹配
而vim（版本8.0）内置的sed，不论文件来自哪种系统，都可以用`^$`匹配
11. 指定行添加内容
`sed -i '1 i \#!/home/ct/bin/gnuplot5/bin/gnuplot5/' gnu.plt`

12. 外部变量
`sed 's/standard/'"$i"'/' `

13. `sed -i`会使软链接失效
`--follow-symlinks`可以保持软连接

14. 同时取代多个字符串
`sed -e 's/str1//;s/str2//' filename`



## sort命令 
1. 按第二行排序
`sort -n -k2 file`

##  ssh
有的命令`source .bash_profile`
例如：`sshpass -p 'password' ssh -o StrictHostKeyChecking=no -l lzy"$i" 192.9.207.204 "source .bash_profile;/opt/sge/sge6_2u4/bin/lx24-amd64/qstat"`

##  su命令： 
1.关于login
（1）.直接登录root
（2）.由其他用户名登录到root:  su -，否则就是没有login 
（3）`su -c 'command'`

## time命令
1. `time ./program`
参数：**-p** 以秒为默认单位来进行输出
  

##    top命令： 
1.查看内存
可以直接使用top命令后，查看%MEM的内容
查看用户ct的进程的内存： `top -u ct`
查看特定进程的内存：`top -d 1 -p pid [,pid ...] ` //设置为delay 1s，默认是delay 3s；如果想根据内存使用量进行排序，可以shift + m（Sort by memory usage）


##    uniq命令 
1. `uniq -c`
在每行行首加上本行在文件中出现的次数(count)。它可取代-u加-d。


##  xargs命令 & find命令：  
1. `awk '{print }' filenames | xargs du -h`
文件filenames中存储了一些文件名，用这种方式，可以看到每个文件的大小
2. `find . -name "pa*.xml" | xargs -n 10000 rm -f`   
find + xargs 是“Argument list too long”问题的标准解决方法，find命令是持续输出的，而xargs再将find的出处分成若干段，再进行下一步处理
3. `find -name *.dcd | tee -a dcd_name | xargs rm & 
删除文件，并将删除的文件的路径输入到dcd_name中
4. 批量转换文件格式
   ```bash
ls *.jpg | xargs -I{} -P 8 convert "{}" `echo {} | sed 's/jpg$/png/'` 
```
  其中-P代表进程数；
  -i 或者是-I，这得看linux支持了，将xargs的每项名称，一般是一行一行赋值给{}，可以用{}代替。”
  在当前这个命令下，以tmp.jpg为例，实际上执行的是 convert tmp.jpg tmp.png


## yum命令
1. `yum install foo`
2. `yum remove foo`
2. `yum list *foo*  #You can rearch the available packages`
3. `yum localinstall foo.rpm`




##  逻辑表达式与`&&`和`||`：
+ 逻辑表达式
（1）C语言中写法：
         `if (a == b && a == c)`

     shell 中的写法：
         `if ([ $a -eq $b ] && [ $a -eq $c ]); then`
(2) C 语言中的写法：
        `if (a == b && a == c && b == c)`
    shell 中的写法：
        `if [ $a -eq $b -o $a -eq $c -o $b -eq $c ]; then`
        `if [ $a -eq $b ] && [ $a -eq $c ] && [ $b -eq $c ]; then`
注意：“[”或“]”与表达式之间必须要有空格。
+ `[[ ]]` vs. `[ ]` [^1]
`[ ]`是shell built-in，而`[[ ]]`不属于POSIX；
`[ ]`会展开`a*`，所以用它的时候需要加双引号：`[ "$var" ]`；`[[ ]]`不需要
`[ ]`会fork a new process，`[[ ]]`不会
[^1]: [Is double braket preferable over single braket in Bash? ](https://stackoverflow.com/questions/669452/is-preferable-over-in-bash)

+ `&&`和`||`
`&&`和`||`与逻辑表达式表面相似，实则完全不同，如果混淆了会导致严重的错误。
`command1 && command2`，如果command1返回值为真（`$?==0`），才会执行command2。一般命令正确执行了，都会返回0。   
`command1 || command2`则是command1返回值为假（`$? != 0`）才执行command2。
关于这两个算符，还**有个隐僻但重要的问题**是`command1 && command2`的返回值，如果command1返回值为假，**整个表达式的返回值也为假，表达式所在的脚本的返回值也为假！**。
有不少人认为`[ ... ] && ...`和`if`语句效果一样但更简洁，这种想法是错误的，因为前一种用法会影响程序返回值，而`if`语句不会。如果在脚本中用前一种方法，会莫名其妙的导致返回值为假又没有任何报错。














## 脚本注意事项：
1. `declare -A var # 声明为关联数组`
`declare -a var # 声明为数组`
二者很不同
2. 关联数组定义的后面不能加#
例如：`array=([seg]=100)#  这样会出问题`

3. 命令中blank space是不能随便加的
  Because blank space is usually used as the separater of command or agruments.
`<<block  #`<< 和 block之间不能有空格

  
4. 脚本的长度
不要把不同功能写到一个脚本中，尤其是脚本较大的时候。
即使你可以非常顺利的写出脚本的每一句，也不意味着你的脚本可以正常执行。
所以要分块编写:
   ```bash
!/bin/sh
  part1.sh
  part2.sh
  part3.sh
exit
```
+ 优点：
这样编写把part1-3的内容写在一个脚本里执行起来是一样的，但是，像这样将脚本分割，有利于调试脚本。由于脚本过于灵活，所以非常容易出错，而出错几率是和大小成指数关系的。所以要把脚本分化，使每一部分都有明确的意义，一来方便检查脚本是否有误，二来增加代码的重复利用率。
+ 缺点：
传递参数麻烦。

###    常见错误    
+ 循环变量的错误使用
比如说循环变量i，在其他地方是否被改动了？
这种错误shell是不会检查出来的





