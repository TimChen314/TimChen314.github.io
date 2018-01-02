---
title: solving linux problem   
tags: [linux]   
top: 11
categories: linux   
date: 2017-11-05 18:00:00
---

解决各种linux问题。
<!-- more -->

## linux挂载2T以上硬盘
0. 找到硬盘编号   
`ls /dev/sd*`   
结果一般为：   
`/dev/sda /dev/sda1 /dev/sda2 /dev/sda3 /dev/sdb`   
后面跟很多数字的是系统盘，上面的例子中系统盘是`/dev/sda`；那么`/dev/sdb`就是新安装的备份盘。

1. root下，执行`parted /dev/sdb`以建立分区列表   
  mklabel gpt  #(有不同选项，如MS-DOS gpt Mac) 3T/4T盘必须要手动建立分区列表   
  mkpart + Enter键   
  ext4 + Enter键   
  "Start"" 2048s + Enter键
  "End" -1s  + Enter键  #（s是单位2048s留给分区列表）   
  **可选步骤，对齐分区以最优化硬盘性能：**   
  align-check TYPE + Enter键   
  opt + Enter键   
  "partition number?" 1 + Enter键   

2. `mkfs.ext4  /dev/sdb/` # 格式化硬盘
3. `mount # 挂载`  
   ```bash
mkdir /home/your_name/backup #建立文件夹
mount -t ext4 /dev/sdb /home/your_name/backup #挂载文件夹
chown -R your_name:your_name /home/your_name/backup
```
4. 修改`/etc/fstab` # 设置开机后自动挂载备份硬盘
得到硬盘的UUID：
   ```shell
[root@node34 ~]$ uuidgen /dev/sda
c6af66d2-f6dc-4a4b-8d83-40ce2b8d0b75
```

   打开`/etc/fstabe`，加入备份盘的UUID：
`UUID=c6af66d2-f6dc-4a4b-8d83-40ce2b8d0b75 /home/your_name/backup/ ext4    defaults        1 2`


