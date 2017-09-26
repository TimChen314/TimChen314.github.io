---
title:  <font size=7><b>如何快速的向Word格式的硕士/博士论文中，添加引用文献？</b></font>
tags: [word,]   
top: 11
categories: 技术杂烩 
---

通常，很多理工科硕士/博士的毕业论文，是将自己Paper翻译成汉语再稍作组织而写成的。由于论文要求是Word格式的，重新向Word中添加引用文献是一项繁琐的工作。这里我介绍一种方法，利用Latex写Paper时准备的**bib文件**，向Word中添加引用文献。该方法有几个好处:
1. 几乎所有文献引用在.bib文件中都是现成的，不用再重新下载引用
2. latex中采用的bibtex key（“@article{paper_name,”中paper_name即为bibtex key）可以直接用到Word中。
3. 不用跳转到EndNote等其他软件
<!-- more -->

必要软件bibtex4word的安装请参考：
[用Bibtex4Word实现Word写作时参考文献的插入和排版](https://wenku.baidu.com/view/4bb336d3b14e852458fb576d.html)
多数高校一般都要求采用《GB/T 7714-2005 文后参考文献著录规则》作为毕业论文的引文规则，上面连接中给出的下载已经不可用了，戳这里可以找到[下载](http://blog.sina.com.cn/s/blog_7139ed830102vi6y.html)

至此，软件的准备工作就完成了。我们将我们几篇Paper中用到的.bib文件合并到一起（如果有少量重复的引用，手动删除就可以；重复引用较多的话，可以用bib文件管理软件删除，比如我用的JabRef），就可以愉快的插入文献啦。插入方法很简单，见Bibtex4Word的介绍。

