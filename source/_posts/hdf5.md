---
title:  <font size=6><b>hdf5简介 </b></font>
tags: [技术杂烩]
top: 1
categories: 技术杂烩
---

## HDF5
可以存储不同类型的图像和数码数据的文件格式，同时还有统一处理这种文件格式的函数库。
### 历史
HDF(Hierarchical Data File)是美国国家高级计算应用中心(National Center for Supercomputing Application,NCSA)为了满足各种领域研究需求而研制的一种能高效存储和分发科学数据的新型数据格式。1998年，发布HDF5版本。迄今为5.1版，已经非常稳定。
### 特性
- 自述性   
对于一个HDF文件里的每一个数据对象，有关于该数据的综合信息（元数据）。在没有任何外部信息的情况下，HDF允许应用程序解释HDF文件的结构和内容。
- 通用性   
许多数据类型都可以被嵌入在一个HDF文件里。例如，通过使用合适的HDF数据结构，符号、数字和图形数据可以同时存储在一个HDF文件里。
- 灵活性   
HDF允许用户把相关的数据对象组合在一起，放到一个分层结构中，向数据对象添加描述和标签。它还允许用户把科学数据放到多个HDF文件里。
- 扩展性   
HDF极易容纳将来新增加的数据模式，容易与其他标准格式兼容。
- 跨平台性
- 现代性   
<!-- more -->
支持并行I/O，线程和其他一些现代系统和应用要求。

**解决我的trajectory程序的问题：自述性、通用性、扩展性**

### Why HDF?
- 有专门的维护： [hdfgroup.org](https://www.hdfgroup.org)
- NASA's Earth Observing System等等官网介绍

### Caffe等机器学习、深度学习框架原生支持
 

## 文档
- sphinx   
它能够把一组 reStructuredText 格式的文件转换成各种输出格式，而且自动地生成交叉引用，生成目录等。也就是说，如果有一个目录，里面包含一堆reST格式的文档（可能子目录里面也同样存在reST格式的文档），Sphinx能够生成一个漂亮的组织结构以及便于浏览和导航的HTML 文件（这些文件在其他的文件夹中）。   
  - Sphinx介绍：https://zhuanlan.zhihu.com/p/25688826
  - 中文文档：https://zh-sphinx-doc.readthedocs.io/en/latest/index.html#
  - 再通过github部署（专门为生成程序介绍页而设计的功能）：https://segmentfault.com/a/1190000002765287
