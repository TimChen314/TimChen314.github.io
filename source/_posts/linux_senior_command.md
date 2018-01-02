---
title:  linux命令之service
tags: [linux]   
top: 11
categories: linux   
date: 2017-12-18 03:00:00
---

`service`，顾名思义，是用于对系统服务进行管理的命令。
**Basically, it's a shell script! `vi` it!**
Besides, `chkconfig` is a closely related command.
<!-- more -->
CentOS中的介绍：
   ```shell
$ info service
DESCRIPTION
       service  runs  a  System V init script in as predictable environment as
       possible, removing most environment variables and with current  working
       directory set to /.

       The  SCRIPT  parameter  specifies  a  System  V init script, located in
       /etc/init.d/SCRIPT.  The supported values  of  COMMAND  depend  on  the
       invoked  script,  service  passes  COMMAND  and  OPTIONS it to the init
       script unmodified.  All scripts should support at least the  start  and
       stop  commands.   As  a special case, if COMMAND is --full-restart, the
       script is run twice, first with the stop command, then with  the  start
       command.

       service --status-all runs all init scripts, in alphabetical order, with
       the status command.

       If the init script file does not exist, the script tries to use  legacy
       actions.   If  there  is no suitable legacy action found and COMMAND is
       one of actions specified in LSB Core Specification, input is redirected
       to the systemctl.  Otherwise the command fails with return code 2.
```


[TOC]
## service命令
`service network start`就相当于`/etc/init.d/network start`。

+ An example of service command:
   ```shell
$ service netconsole
Usage: /etc/init.d/netconsole {start|stop|status|restart|condrestart}
```
   Comman used option include "start|stop|status|restart"

+ An example of init service script:
   ```shell
case "$1" in
    start)
        do start-thing;
        ;;
    stop)
        do stop-thing;
        ;;
    restart)
        do restart-thing;
        ;;
    ...
esac
```




## chkconfig命令
service与chkconfig的关系归纳为：[^1]
   >先要注册成为系统服务(即service可以调用)，然后才能使用chkconfig控制运行级别。
service是chkconfig的前提条件。

**注意**：谨记chkconfig不是立即自动禁止或激活一个服务，它只是简单的改变了`/etc/rc*.d`中的符号连接。[^3]

+ `chkconfig --list`
If you want to list systemd services use 'systemctl list-unit-files'.
+ `chkconfig --add/del SERVICE `
+ `chkconfig SERVICE on/off `
是否开机就执行
+ `chkconfig --level SERVICE 3456`
只在3456级别下运行该SERVICE
(`/etc/rc*.d`下)S开始的文件向脚本传递start参数
K开始的文件向脚本传递stop参数
K/S后面的数字代表开机启动脚本中的启动顺序，数组越大启动越晚。[^3]
+ 相应级别的文件在`/etc/rc*.d`之下
   ```shell
$ ls /etc/rc*.d -d
/etc/rc.d  /etc/rc0.d  /etc/rc1.d  /etc/rc2.d  /etc/rc3.d  /etc/rc4.d  /etc/rc5.d  /etc/rc6.d
```
+ PS: `/etc/rc.d/rc*.d/`下的文件均为符号链接，最终绝大部分都是都是链接到`/etc/rc.d/init.d`下面。`/etc/rc.d/init.d`目录下面的都是开启启动脚本文件，用来启动相应的程序。
+ PPS: 开机顺序
硬件自检 -> 初始化启动bootloade -> 加载内核 -> 初始化硬件 -> 加载根文件系统 -> 加载驱动 -> 启动一个init用户级程序
+ PPPS: 上面两次加载硬件，是因为驱动分成两种：[^2]
   >1.随内核加载的驱动，一般是中断控制器，串口，定时器，时钟，各种总线等；这种驱动的初始化函数一般会放到一个特殊的初始化段中，在内核初始化时调用；
2.编译成模块的驱动，在内核初始化完成，也就是初始线程创建完成，出现shell时，根据应用程序的需要或者脚本按需加载。

## reference
[^1]: [linux中注册系统服务—service命令的原理通俗](https://www.cnblogs.com/wangtao_20/archive/2014/04/04/3645690.html)
[^2]: [古斟布衣](https://www.zhihu.com/question/35619555/answer/150110115)
[^3]: [linux启动脚本和service、chkconfig](http://blog.csdn.net/taiyang1987912/article/details/41698817)
