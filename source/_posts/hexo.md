---
title:  hexo 
tags: [hexo, yilia]
categories: hexo
date: 2017-07-21 18:00:00
---


# memo
+ 这个网站可以作为参考[www.ezlippi.com](http://www.ezlippi.com)
+ npm i(nstall) hexo-generator-json-content --save
Fix error to ensure "all article" works normally.
+ ~~hexo-footnote~~(已不再维护)
   >`npm install hexo-footnotes --save`   
如果Hexo不能自动发现插件，则需要手动安装插件5，编辑\_config.yml文件：   
   ```
plugins:
  - hexo-footnotes
```
<!-- more -->

+ 安装hexo-renderer-marked以支持更多Markdown特性
   ```bash
npm un hexo-renderer-marked --save
npm i hexo-renderer-markdown-it --save
npm install markdown-it-emoji --save
```
## 设置文章置顶 & Cloudinary在线图片服务[^4]
   >top: 3 # 数字越大越靠前，默认为0
   >除了在本地存储图片，还可以将图片上传到一些免费的CDN服务中。比如Cloudinary提供的图片CDN服务，在Cloudinary中上传图片后，会生成对应的url地址，将地址直接拿来引用即可。
在Cloudinary申请账号，上传图片(注意把upload选项中的unsigned signature选上)

   Cloundinary的免费存储空间还是非常大的[cloudinary价格](http://cloudinary.com/pricing)
   [我的cloudinary](https://cloudinary.com/console/media_library)
   使用方法：
   1. 点击图片
   2. 点击url
   3. 拷贝链接

## hexo个人命令
+ 用`hexol`/`hexod`命令一次性完成本地/远程预览
配置`.bash_profile`:   
   ```bash
export HEXO='/Users/Aether/Documents/hexo_file'
export HEXOMD='/Users/Aether/Documents/hexo_file/source/_posts/'
alias hexod='cd $HEXOMD && sh tackle_md.sh && hexo clean && hexo g && hexo deploy'
alias hexol='cd $HEXOMD && sh tackle_md.sh && hexo clean && hexo g && hexo s'
```

+ `tackle_md.sh`自动调整缩进、设置部分显示(for next theme)
   ```bash
#!/bin/sh

sh indent.sh
sh read_more.sh
```
   其中，`indent.sh`:
   ```bash
#!/bin/sh
# indent for code block
sed -i 's/^```[a-z]/   &/g' *.md
# indent for quote
sed -i 's/^>/   &/g' *.md
```
   `read_more.sh`:
   ```bash
#!/bin/sh

# if no "<!-- more -->" in *.md file, adding it into the file.
for md_file in $(ls *md)
do
    stat=$(grep "<!-- more -->" $md_file)
    if [ -z "$stat" ];then
        sed -i '20a <!-- more -->' $md_file
    fi
done
```

## yilia theme
+ image file path
`hexo_file/themes/hexo-theme-yilia/source/img`
+ theme-yilia
[yilia](https://github.com/litten/hexo-theme-yilia/wiki/Yilia源码目录结构及构建须知)

## next theme
+ 要想显示标签页，需要手动操作，详见[^1]
+ 添加搜索[^3]
**在os X safari上无法正常使用，原因不明；在os X chrome上和win7 chrome上都可以正常使用**
   ```bash
npm install hexo-generator-search --save
npm install hexo-generator-searchdb --save
```
+ 如何设置页面文章的篇数？[^2]
   ```bash
npm install --save hexo-generator-index
npm install --save hexo-generator-archive
npm install --save hexo-generator-tag
```

+ 设置social\_icons
`next`是通过[FontAwesome](http://fontawesome.io/cheatsheet/)进行图标设计的，FA支持的图标都在主页上。
目前FA不支持知乎，所以随便选了个fa-bed作为icons。设置中写为`  zhihu: bed`
+ 设置文章标题的格式[^5]
~~直接用html就可以~~
~~`title: <font size=6><b>人工智能简介`~~
next themes的配置文件在`themes/next/source/css/_variables/custom.styl`
   ```sh
$font-size-headings-base  = 28px
$font-size-headings-step  = 2px
```

## more available setting
+ [Hexo文章简单加密访问](http://blog.csdn.net/Lancelot_Lewis/article/details/53422901)
+ [静态网站计数](http://busuanzi.ibruce.info)

## hexo bug
+ ``Error: Cannot find module './build/Release/DTraceProviderBindings'`` in OS X 
   1. `npm install hexo --no-optional` doesn't work
   2. `npm un hexo-cli && npm i hexo-cli -g` still encounts bugs, and it's about dtrace-provider.
   3. Then we try to install dtrace-provider:
      `Error: Python executable anaconda3/bin/python is v3.5.2, which is not supported by gyp.`
   4. If `PYTHON=python2.7 npm install dtrace-provider --save` is used then a new bug will be reported:
      `xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance`
   5. This is an error about Xcode, [solution link](https://github.com/nodejs/node-gyp/issues/569#issuecomment-259421050)
   6. Finally, this DTrace error is solved.

# References:
[HEXO搭建个人博客](http://baixin.io/2015/08/HEXO搭建个人博客/)   
[2个小时教你hexo博客添加评论、打赏、RSS等功能](http://www.jianshu.com/p/5973c05d7100)   
[从搭建hexo个人博客过程中理解学习DNS解析](http://coolcao.com/2016/10/19/从搭建hexo个人博客过程中理解学习DNS解析)   
[^1]: [Next-主题配置](http://theme-next.iissnan.com/theme-settings.html)
[^2]: [Next-常见问题](http://theme-next.iissnan.com/faqs.html#%E9%A6%96%E9%A1%B5%E6%98%BE%E7%A4%BA%E6%96%87%E7%AB%A0%E6%91%98%E5%BD%95)
[^3]: [参考：Hexo博客添加站内搜索](http://www.ezlippi.com/blog/2017/02/hexo-search.html)
[^4]: [Hexo Configuration](http://jiaxm.me/2017-07-day/Hexo%20Configuration/#more)
[^5]: [set title size](http://prozhuchen.com/2015/10/05/Hexo%E5%8D%9A%E5%AE%A2%E4%B9%8B%E6%94%B9%E5%AD%97%E4%BD%93/)
