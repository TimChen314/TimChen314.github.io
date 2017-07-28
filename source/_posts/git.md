---
title:  <font size=7><b>git笔记 </b></font>
tags: [git]   
top: 5
categories: git   
date: 2017-07-26 18:00:00
---


# git
## 开始
非常好的入门:   
![非常好的入门0](http://res.cloudinary.com/do7yb5qw4/image/upload/v1500901433/%E6%9D%82/MgaV9.png)   
非常好的入门1[^1]:
   >- 工作区：就是你在电脑里能看到的目录。   
   >- 暂存区：英文叫stage, 或index。一般存放在 ".git目录下" 下的index文件（.git/index）中，所以我们把暂存区有时也叫作索引（index）。   
<!-- more -->
   >- 版本库：工作区有一个隐藏目录.git，这个不算工作区，而是Git的版本库。   

[非常好的入门2](https://marklodato.github.io/visual-git-guide/index-zh-cn.html)

+ git init
+ config    
   ```bash
git config --global user.name "your name"
git config --global user.email "your email"
git config --global core.editor "vim #set vim as editor
```
+ git difftool 
没有默认的difftool，如果首次输入命令git difftool，CentOS会自动推荐kompare。
   ```language
Viewing: 'particles/BinReader.cc'
Launch 'kompare' [Y/n]: y 
```
kompare的效果非常好。

## 操作
+ add filename
+ commit 
   - `git commit -m "your message"`   
   - Amending the most recent commit message[^3]
   >`git commit --amend`
**will open your editor**, allowing you to change the commit message of the most recent commit. Additionally, you can set the commit message directly in the command line with:
   >
   >`git commit --amend -m "New commit message"`
…however, this can make multi-line commit messages or small corrections more cumbersome to enter.
   >
   >Make sure you don't have any working copy changes staged before doing this or they will get committed too. (Unstaged changes will not get committed.)

+ reset    
`git reset --hard HEAD^   `   
`git reset --hard 3628164`   
+ reflog 查看历史命令
+ clone   
git clone /path/to/repository    
如果是远端服务器上的仓库，你的命令会是这个样子：   
`git clone username@host:/path/to/repository   `
`git clone git@github.com:dunitian/Windows10.git "F:/Work/WP/Windows10" #到指定文件夹`
+ push   
`git push origin master:master   `
origin is the remote server; the branch name before the colon is local branch name, and that after the colon is remote branch name. e.g.:
   ```bash
git push origin HEAD:refs/for/branch1 # push HEAD branch to a remote branch
git push origin :refs/for/branch1  # delete remote branch
```
+ `git checkout hexo myfile`
从hexo分支得到myfile
+ stash[^4]
   >储藏会处理工作目录的脏的状态 - 即，修改的跟踪文件与暂存改动 - 然后将未完成的修改保存到一个栈上，而你可以在任何时候重新应用这些改动。

   `git stash` 临时存储当前状态
   `git stash list` 
   `git stash apply (--index)` 找回临时存储的状态
   `git stash drop` 删除stash

+ branch
   - `git checkout -b dev` #-b参数表示创建并切换   
git checkout master
   - git merge dev
合并指定分支到当前分支
   - git branch -d dev #删除
   - `git branch -r/-a` # 查看远程/所有分支；
`git branch` 查看本地分支
   - `git checkout mybfranch` # shift to another branch
+ pull
`git pull origin master`相当于`git fetch`加上`git merge`


## 丢弃
+ git rm (then git commit)
+ `git checkout -- file   `
git checkout其实是用版本库里的版本替换工作区的版本，无论工作区是修改还是删除，都可以“一键还原”。

    + 删错了，因为版本库里还有呢，所以可以很轻松地把误删的文件恢复到最新版本：   
$ `git checkout -- test.txt`

    + 场景1：当你改乱了工作区某个文件的内容，想直接丢弃工作区的修改时，用命令`git checkout -- file`。   
    场景2：当你不但改乱了工作区某个文件的内容，还添加到了暂存区时，想丢弃修改，分两步，第一步用命令git reset HEAD file，就回到了场景1，第二步按场景1操作。
要重返未来，用git reflog查看命令历史，以便确定要回到未来的哪个版本。

## 显示状态
+ status 
+ log
   `git log --oneline --decorate` # 加上--decorate 时，我们可以看到我们的标签   
+ remote  
看当前配置有哪些远程仓库，可以用命令   
`git remote`   
执行时加上 -v 参数，你还可以看到每个别名的实际链接地址。

+ `git ls-files #ls files in present branch`
`git ls-files -u #显示冲突的文件，-s是显示标记为冲突已解决的文件`

+ diff
   - `git diff #对比工作区和stage文件的差异 `   
`git diff --cached ` 对比stage和branch之间的差异
   - `git diff master remotes/origin/hexo #对比本地“master” branch和远程“remotes/origin/hexo” branch`


## rebase
[git rebase 用法](http://blog.csdn.net/wangjia55/article/details/8776409)   
[stackoverflow](https://stackoverflow.com/questions/29902967/rebase-in-progress-can-not-commit-how-to-proceed-or-stop-abort)
+ git rebase --skip   
+ git rebase --continue #use this when you solved conflicts.
+ git rebase --abort #放弃当前rebase

## tag
git push origin --tags

## 其他概念
+ origin   
顾名思义，origin就是一个名字，它是在你clone一个托管在Github上代码库时，git为你默认创建的指向这个远程代码库的标签
+ (远程仓库名)/(分支名) 这样的形式表示远程分支
Note that when `git branch -a` is used, there is 'remote' in front of branch name, e.g.:
   ```bash
$ git branch -r   
  orgin/master   
$ git branch -a   
  remote/origin/master   
```
+ ` local_branch_name:remote_branch_name`
远程分支和本地分支的名字相同，可以省略远程分支的名字

+ [upstream vs. origin](https://stackoverflow.com/questions/9257533/what-is-the-difference-between-origin-and-upstream-on-github/9257901#9257901)
   >This should be understood in the context of GitHub forks (where you fork a GitHub repo at GitHub before cloning that fork locally)
   >- upstream generally refers to the original repo that you have forked
(see also "Definition of “downstream” and “upstream”" for more on upstream term)
   >- origin is your fork: your own repo on GitHub, clone of the original repo of GitHub

## git原理
+ branch & hash[^2]
   >you need to understand that branch and tag names are just pointers to hash values, which represent a single commit


## 错误
+ prompt to input passphrase time and time again:   
[Git enter long passphrase for every push](https://stackoverflow.com/questions/6106137/git-enter-long-passphrase-for-every-push)   
Note that you can use ssh-key only if you use ssh to build remote connections.   
`git remote -v` should looks like:   
   `origin	git@github.com:TimChen314/MDTackle.git (fetch)`   
but not:   
   `origin	https://github.com/TimChen314/MDTackle.git`

# reference
[^1]: [Git 工作区、暂存区和版本库](http://www.runoob.com/git/git-workspace-index-repo.html)   
[^2]: [What's the difference between `git reset --hard master` and `git reset --hard origin/master`?](https://stackoverflow.com/questions/29862319/whats-the-difference-between-git-reset-hard-master-and-git-reset-hard-or)   
[^3]: [How to modify existing, unpushed commits?](https://stackoverflow.com/questions/179123/how-to-modify-existing-unpushed-commits)   
[^4]: [6.3 Git 工具 - 儲藏](https://git-scm.com/book/zh/v2/Git-工具-储藏与清理)

## 待读
[**超好**: git cheatsheet](http://ndpsoftware.com/git-cheatsheet.html#loc=remote_repo;)
[常用git](http://www.jb51.net/article/55441.htm)
