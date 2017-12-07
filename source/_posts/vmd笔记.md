---
title:  vmd笔记
tags: [画图]   
top: 11
categories: linux
date: 2017-09-29 18:00:00
---
+ 什么是VMD？[^5]
   >VMD is a molecular visualization program for displaying, animating, and analyzing large biomolecular systems using 3-D graphics and built-in scripting. 

+ [VMD官网的图片示例展览](http://www.ks.uiuc.edu/Gallery/Science-New/)
+ **本文定位**：本文不适合作为入门教程，适合于在进阶阶段作为参考。本文偏重于VMD脚本；图形界面(GUI)上的操作因为比较简单，讨论的较少。


<!-- more -->
## 显示
0. ==console中，输入命令且不加参数，就会显示帮助信息==  
tcl语言作为脚本语言，tcl语法可以参考[TCL脚本入门教程](https://wenku.baidu.com/view/aaf5d6d449649b6648d74771.html)【当然没必要学完】
如何进入console：Extension -> Tk Console 
例子：
   + `console% measure`结果[见图](https://res.cloudinary.com/do7yb5qw4/image/upload/v1506587376/杂/vmd_measure.jpg
)
   + `console% mol` 
   + `pbc`...
1. pbc 
   + pbc是周期性边界条件的缩写（periodic boundary condition）
   + `pbc wrap -all 【将粒子折回盒子内】`
   + pbc wrap -shiftcenterrel {-0.5 -0.5 -0.5}
     我们希望wrap后坐标的中心在{0 0 0}处，然而，默认情况下，wrap的中心在{L/2 L/2 L/2}处，所以我们要将其平移回来！
   + `pbc set {1308.998 1278.998 1281.998} -all`：手动定义盒子
   + 画盒子
     pbc box -on 【画出盒子】   
     pbc box -center origin 【设定盒子中心的位置为{0 0 0}，而默认的盒子{0 0 0}点在盒子角上】   
     pbc box -center origin -style tubes -width 1 -color gray   
   + pbc join res -border 5 【接上由于pbc导致的盒子边界处的断键】  
2. display
   + display projection orthographic
【相当于在display选项卡中选择orthographic】   
   + display distance x
设置东西与屏幕的距离，越大则分子离屏幕越近，相当于放大。不可太小比如几十，否则有凸镜的效果
3. 背景设置为白色   
（Graphics->Colors->Categories栏->选Display->再在name栏选Background）时，图像会显得比较浅。修正这个问题的方法是：去掉Display->Depth Cueing   
4. graphics
  graphics top list【to show a list of number, standing for the ID of each object】
  graphics top text {40 0 20} "my drawing objects"  # 文字
  graphics top info ID  # The detailed information about each object
  graphics top delete ID
  ==box is also considered as graphics in VMD==
   + draw shapes【画图形】[^2]     
   graphics top color COLORID【先设定颜色后画图形才能设定成功】【colorid for each color can be found in Graphics -> Colors -> menu 】
   graphics top sphere {10 10 10} radius 10 resolution 80
   graphics top line {10 0 0} {0 0 0} width 5 style dashed
   graphics top material transparent
   graphics top delete all/ID【delete shapes】  
   **NOTE**: vmd看gromacs文件（*.gro）时，会把单位自动换位埃，比如在.gro文件中，坐标为1，则vmd中坐标为10，画图形时，可能会用到

6. colorinfo colors 
显示有多少种预置颜色，比如red
8. 旋转
rotate x by/to 90 


## Script
### 基本命令
1. ~/.vmdrc ： 配置文件
2. logfile my.log
在console中输入此命令,可以将你在图形界面中的操作保存成脚本，存储在my.log中    ***有用又简单的命令*** !!!
3. console中导入脚本
source yourscript.tcl
4. 不显示图形界面的执行脚本
`sh$ vmd -dispdev none -e script.tcl`
需要注意到的是，使用`-dispdev none`选项后，用`pbc`命令的脚本回报错：
`invalid command name "pbc"`
在脚本中添加下列命令即可解决该错误：
`package require pbctools`

### mol   
mol的用法帮助：如前面第0节所述，在console中输入mol并且不加参数，就会显示mol的用法。
这里要介绍VMD中两个重要的概念：**molid**（molecular ID）和**repid**（representation ID）。   
==molid==：对单个frame，molid恒等于0   
==repid==：打开一个frame，默认的repid为0   
如果你想添加第二种呈现方式（representation），可以用：`mol addrep 0`向molid为0的图中，新增一种representation，这一representation的repid等于之前最大的repid+1。   
GUI中，Graphics -> Representations -> Create Rep 就相当于下列命令：   
   ```tcl   
mol addrep 0
mol modselect 1 0 "type 1"
```
   + ==注意：写脚本时，尤其要注意的一点是如果打开一个frame成功，会隐式的执行一次`mol addrep 0`！==
   例如，我们将类型为A的原子显示成蓝色（ColorID 0）、将B类型的原子显示成红色（ColorID 1），脚本这样写：
      ```tcl
# mol addrep 0     # NOTE: VMD has execute this statement invisibly. If  
#                    you add this "mol addrep 0" manually, there will 
#                    be an error. 
mol modselect 0 0 "type A"
mol modcolor 0 0 ColorID 0
mol addrep 0
# now there are two "rep". The index of second "rep" is 1.
mol modselect 1 0 "type B"
mol modcolor 0 0 ColorID 0

```
   + mol default style {CPK}
【相当于Graphical选项卡中选择Representations,再在Draw style中Drawing Method下选择CPK】
   + mol default material {Diffuse}
【相当于Graphical选项卡中选择Representations,再在Draw style中Material下选择Diffuse】
   + mol list
列出目前所有representation
   + mol delrep 3 0
与mol addrep 0相对，删除molid=0，repid=3的mol
   + molinfo list/num
显示全部分子的molid




### atomselect
例子：
   ```tcl
set particle [atomselect 0 "index<13000"]
$particle set resname CD  #默认是空
$particle set chain X
$particle set resid 1     #默认是0
$particle set radius 0.6
$particle num # 输出particle中原子个数
$particle delete
```
0. atomselect有单独的编号
比如atomselect345，我们可以用编号atomselect345来调用它;它的各种信息都可以输出出来。
1. atomselect macro
macro指的就是那些charged、acidic、amino之类的，比如`atomselect charged`会选择体系中带电荷的原子。蛋白质体系容易用到，聚合物体系不容易用到。
atomselect macro 显示所有macro
2. atomselect keywords
`atomselect 3 "resid 25" frame last` 选择molid为3、最后一帧的resid 25。molid可以是数字或者top，所选内容就是普通的selection，用双引号或者{}括住，帧号可以是数字、first、last、now。
atomselect list会列出所有的atomselect
3. index 
除了上文中`set particle [atomselect 0 "index<13000"]`的筛选方法，index选择原子时还支持多种筛选方式：
   + "(index>100 && index<200) || index = 66" 
   + "index 1 3 5"
   + `"index = [ expr 250 * $i ]"` # index 支持expr表达式求值，`i`为自定义变量




### Script Syntax[^3]
#### 0. 注释
   >TCL中的注释符是’＃’，’＃’和直到所在行结尾的所有字符都被TCL看作注释，TCL解释器对注释将不作任何处理。不过，要注意的是，’＃’必须出现在TCL解释器期望命令的第一个字符出现的地方，才被当作注释。  
   
   例如：  
   %＃This is a comment  
%set a 100 # Not a comment  
%set b 101 ; # this is a comment  

#### 1. for语句
   ```tcl

for {set i 0} {$i < [llength $list]} {incr i}
```
#### 2. list
`set list { Opaque Transparent ... }`
`[llength $list]  # get index`
`[lindex $list $i]  # reference the list`

#### 3. measure
measure的功能非常多，从相对简单的求质心、几何中心、均方回转半径、RDF（vmd中叫gofr）、rmsd和rmsf(RMS fluctuation)，到比较专业的**氢键分析、sasa**（solvent-accessible surface area）等。
全部功能见图：https://res.cloudinary.com/do7yb5qw4/image/upload/v1506587376/杂/vmd_measure.jpg
+ measure center $sel
+ measure minmax $sel
+ `measure bond { index_1 index_2}`
   - GUI下
   Mouse > Label > Bonds， 或是在激活3D 窗口的条件下按2
   鼠标形状会变成+，然后依次点击2个原子即可，
   Graphics > Label 可以进行更多的操作




#### 4. xyz(coordinate) is storaged as list!
When you  get multiple atom attributes (in this case, x, y, and z), the result is always returned as a nested list, even if that list contains only one element. 
As somebody may think the code below is very intuitive:
   ```tcl
set sel [atomselect 0 "index = 250"]
graphics top text [ $sel get {x y z} ] "words i want to say"
```
However, ` $sel get {x y z} ]` is actually a **list**, but there need a vector.
It's like you give：
   ```tcl
graphics top text { {1 2 3} } "words i want to say"
```
But actually we need:
   ```tcl
graphics top text {1 2 3} "words i want to say"
```
The solution is ugly:
   ```tcl
foreach coor [ $sel get {x y z} ] {
  graphics top text $coor "words i want to say"
}
```
Beside that, coordiante should be used like below:
`graphics top text [list $x $y $z] "words i want to say" `
[source: vmd mailing list](http://www.ks.uiuc.edu/Research/vmd/mailing_list/vmd-l/17294.html)

#### 5. get one coor of three(only one element in pxyz)
   ```tcl
  set pxyz [atomselect top "index = [ expr 250 * $i ]" ]
  set px [$pxyz get x]
```




## 存高质量图片[^4]
+ render TachyonInternal name.tga
convert name.tga name.png
这样得到的图片效果有限 
==尝试了各种方法，似乎tga转换png的质量不能控制==
==要想得到高质量的图片，方法如下==
+ File->render(这里有三行)
   - (第一行选择)Tachyon
   - (第三行加上，设置分辨率) -res 1024 1024 
     res代表resolution，设为1024*1024时，tga大小为3.1M，png大小为680K
   - 最后convert vmdscene.tga vmdscene.png（转成jpg格式也可以）
   - ambient occlusion（AO,环境光遮蔽）效果会很好
+ script: 
render Tachyon ==vmdscene.dat== "/usr/local/lib/vmd/tachyon_LINUXAMD64" -aasamples 12 %s -format TARGA ==-res 1024 1024== -o %s.tga
+ **culling** 
   >culling actually reduces performance on some hardware renderers[^1]
+ **Depth Cueing**
   >Depth cueing causes distant objects to blend into the background color, in order to aid in 3-D depth perception

## 存动画
（1）进入  Extensions -> Visualization -> Movie Maker
（2）Render -> Tachyon
（3）Movie Settings -> Trajectory 
（4）Format -> Animated GIF

## color scale【颜色梯度】
### trajectory with color gradient
1. load a trajectory <!-- (e.g. oneNPmovie.tcl)-->
2. 设置颜色随frame变化
Graphical -> Representations -> Draw style -> Coloring method -> Timestep
Graphical -> Representations -> Trajectory -> 选择"update color every frame"; 修改"Color Scale Data Range"
3. 设置Color Scale Bar
Extensions -> Visuilizition -> Color Scale Bar
4. 选择颜色
Graphical -> Colors -> Color Scale -> 这个设置还可以以"RWB(Read Whie Blue) Offset -0.09, Midpoint 0.5 "

### frame with color gradient
1. load a frame
2. 设置颜色随index变化
Graphical -> Representations -> Draw style -> Coloring method -> index
Graphical -> Representations -> Trajectory -> "Color Scale Data Range 0 ~ total_monomer_number"
3. 设置Color Scale Bar和选择颜色与上面"trajectory with color gradient"相同


## 其他

+ ~~compound（**似乎没什么用**）~~
只用于pbc中
supported compound types: segment, residue, chain, fragment, connected

+ 问题
   1. pbc join
      pbc join res -border 5 -sel "resname 0"好使，但不明白为什么？
但是注意，resname一个不存在的名字，比如"resname 1000000"，也不会报错。
      pbc join res -sel尝试了各种办法也没有成功
最后解决：还是在xml文件中删除多余的bond和angle，就是join的时候很慢，要等很久。

+ vmd有很多功能，如：
   1. VMD extensions: membrane builder
   2. Molecular Surface Representations

+ 对vmd脚本的感觉
优点：vmd本身功能非常多，使用者多。
缺点：以tcl为基础的vmd脚本，坑很多，体现了很多动态弱类型语言的缺点。

## reference
[^1]: [manual culling](http://www.ks.uiuc.edu/Research/vmd/vmd-1.8.7/ug/node43.html)
[^2]: [VMD Tutorial](http://www.ks.uiuc.edu/Training/Tutorials/vmd/tutorial-html/index.html)
[^3]: [VMD Tutorial: Scripting in VMD](http://www.ks.uiuc.edu/Training/Tutorials/vmd/tutorial-html/node4.html)
[^4]: [非常好的效果的vmd作图](https://ourphysics.org/wiki/index.php/How_to_make_images_for_publication_using_VMD)  
==NOTE==：该CBMSG网站还有很多有用的教程和资源（Computational Biophysics and Materials Science Group）
[^5]: [VMD官网](http://www.ks.uiuc.edu/Research/vmd/)
