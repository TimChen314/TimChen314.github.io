---
title: vmd整理    
tags: [画图]   
top: 11
categories: linux
---

<!-- more -->
## Format
1. pbc 
(1) pbc是周期性边界条件的缩写（periodic boundary condition）
(2) pbc wrap -all 【将粒子折回盒子内】
(3) 画盒子
    pbc box -on 【画出盒子】
    pbc box -center origin 【设定盒子中心的位置】
    pbc box -center origin -style tubes -width 1 -color gray
(4) pbc join res -border 5 【接上由于pbc导致的盒子边界处的断键】
2. display projection orthographic
【相当于在display选项卡中选择orthographic】
3. 背景设置为白色
（Graphics->Colors->Categories栏->选Display->再在name栏选Background）时，图像会显得比较浅。修正这个问题的方法是：去掉Display->Depth Cueing


## 如何存高质量图片
+ render TachyonInternal name.tga
convert name.tga name.png
这样得到的图片效果有限 
==尝试了各种方法，似乎tga转换png的质量不能控制==
==要想得到高质量的图片，方法如下==
+ File->render(这里有三行)
 - (第一行选择)Tachyon
 - (第三行加上，设置分辨率) -res 1024 1024 
 - 最后convert vmdscene.tga vmdscene.png（转成jpg格式也可以）
 - res代表resolution，设为1024*1024时，tga大小为3.1M，png大小为680K
 - ambient occlusion（AO,环境光遮蔽）
+ script: 
render Tachyon ==vmdscene.dat== "/usr/local/lib/vmd/tachyon_LINUXAMD64" -aasamples 12 %s -format TARGA ==-res 1024 1024== -o %s.tga
+ **culling** 
>culling actually reduces performance on some hardware renderers

 [source](http://www.ks.uiuc.edu/Research/vmd/vmd-1.8.7/ug/node43.html)
+ **Depth Cueing**
>Depth cueing causes distant objects to blend into the background color, in order to aid in 3-D depth perception

## 如何存动画
（1）进入  Extensions -> Visualization -> Movie Maker
（2）Render -> Tachyon
（3）Movie Settings -> Trajectory 
（4）Format -> Animated GIF

# reference
[^1]: []()
