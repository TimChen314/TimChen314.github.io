
---
title: docker note
tags: [docker, cloud computing]   
top: 11
categories: 云计算
date: 2018-01-01 18:00:00
---
***
Official introduction:
   >Docker is an open platform for developers and sysadmins to build, ship, and run distributed applications, whether on laptops, data center VMs, or the cloud.

我认为可以这样介绍：docker是没有性能损失的、打包软件及其运行运行环境(包括系统在内的)的虚拟机。"Build Once, Run Anywhere!"
+ [galamost-3.0.9 docker](https://hub.docker.com/r/timchen314/galamost3/)测试
1. 完全没有速度损失（docker vs. no-docker in 1080TI: 700 TPS vs. 700±20 TPS; IP: 101）。
2. 即使host上为cuda8.0而docker上为cuda9.0，速度也基本没有损失（docker vs. no-docker in 1080: 513 TPS vs. 533 TPS; IP: 106）。

<!-- more -->

# Docker介绍

## **首先，Docker不会降低性能！**
1. docker性能(2015年的文章)[^3]：
   >docker利用namespace实现系统环境的隔离；利用Cgroup实现资源限制；
   >……   
   >docker还存在着以下几个缺点：    
1.资源隔离方面不如虚拟机，docker是利用cgroup实现资源限制的，只能限制资源消耗的最大值，而不能隔绝其他程序占用自己的资源。    
2.安全性问题。docker目前并不能分辨具体执行指令的用户，只要一个用户拥有执行docker的权限，那么他就可以对docker的容器进行所有操作，不管该容器是否是由该用户创建。比如A和B都拥有执行docker的权限，由于docker的server端并不会具体判断docker cline是由哪个用户发起的，A可以删除B创建的容器，存在一定的安全风险。    

2. [Docker Engine Utility for NVIDIA GPUs](https://github.com/NVIDIA/nvidia-docker)
这是nvidia官方支持的docker项目，里面一个issue提到了正常情况下，效率没有损失

3. By default, a container has no resource constraints and can use as much of a given resource as the host’s kernel scheduler will allow.[^8]

## docker在web开发中得使用流程是怎样的？[^4]  

### 使用Docker的正确姿势
Tomcat+Mysql,怎么做？
我们构建两个镜像，一个仅安装Tomcat并部署我们的app，另一个仅安装MySQL，然后启动这两个镜像，得到两个容器，再利用Docker的容器互联技术将二者连接(Docker的容器是通过http连接的)。


## docker原理的简介：

### 基础介绍
+ 原理[^9]
   >让某些进程在彼此隔离的命名空间中运行。大家虽然都共用一个内核和某些运行时环境（例如一些系统命令和系统库），但是彼此却看不到，都以为系统中只有自己的存在。这种机制就是容器（Container），利用命名空间来做权限的隔离控制，利用 cgroups 来做资源分配。

+ 灵剑
   >docker可以使用docker build工具链将应用和所有依赖整个安装到镜像中，部署的时候直接启动容器就是一个正确运行的服务了。docker build使用Dockerfile，Dockerfile是一个文本文件，相当于一个脚本，可以在CI系统中自动执行，做持续集成、持续部署很容易，build、test成功后直接替换线上的镜像就行。从原理上来说，docker并不是一个完全独立的虚拟化环境，而是一个有独立namespace的进程，所以启动开销就跟直接在物理机上启动服务差不多，但是保证了环境隔离。
   >
   >作者：灵剑   
链接：https://www.zhihu.com/question/51134842/answer/189312743   
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

+ Docker技术架构图[^5]
![image](https://pic4.zhimg.com/50/v2-385d2404a0ea9dd37c00b445b3168b96_hd.jpg)
   >从Docker依赖的底层技术来看，Docker原生态是不能直接在Windows平台上运行的，只支持linux系统，原因是Docker依赖linux kernel三项最基本的技术,namespaces充当隔离的第一级，是对Docker容器进行隔离，让容器拥有独立的hostname,ip,pid，同时确保一个容器中运行一个进程而且不能看到或影响容器外的其它进程;Cgroups是容器对使用的宿主机资源进行核算并限制的关键功能。
比如CPU,内存,磁盘等，union FS主要是对镜像也就是image这一块作支持，采用copy-on-write技术，让大家可以共用某一层，对于某些差异层的话就可以在差异的内存存储，Libcontainer是一个库，是对上面这三项技术做一个封装。

+ rootfs[^12]
![image](https://pic1.zhimg.com/50/v2-e7bf9fbb488309f38864cac909a022a5_hd.jpg)
   >内核空间是 kernel，Linux 刚启动时会加载 bootfs 文件系统，之后 bootfs 会被卸载掉。
用户空间的文件系统是 rootfs，包含我们熟悉的 /dev, /proc, /bin 等目录。
对于 base 镜像来说，底层直接用 Host 的 kernel，自己只需要提供 rootfs 就行了。
而对于一个精简的 OS，rootfs 可以很小，只需要包括最基本的命令、工具和程序库就可以了。相比其他 Linux 发行版，CentOS 的 rootfs 已经算臃肿的了，alpine 还不到 10MB。   
这里需要说明的是：   
1. base 镜像只是在用户空间与发行版一致，kernel 版本与发行版是不同的。
例如 CentOS 7 使用 3.x.x 的 kernel，如果 Docker Host 是 Ubuntu 16.04（比如我们的实验环境），那么在 CentOS 容器中使用的实际是是 Host 4.x.x 的 kernel。
2. 容器只能使用 Host 的 kernel，并且不能修改。

+ ==writable container==[^12]
![image](https://pic1.zhimg.com/50/v2-9496fbb036445cc557f95f657c5baea8_hd.jpg)
   >当容器启动时，一个新的可写层被加载到镜像的顶部。
这一层通常被称作“容器层”，“容器层”之下的都叫“镜像层”。
所有对容器的改动 - 无论添加、删除、还是修改文件都只会发生在容器层中。
只有容器层是可写的，容器层下面的所有镜像层都是只读的。
下面我们深入讨论容器层的细节。
镜像层数量可能会很多，所有镜像层会联合在一起组成一个统一的文件系统。如果不同层中有一个相同路径的文件，比如 /a，上层的 /a 会覆盖下层的 /a，也就是说用户只能访问到上层中的文件 /a。在容器层中，用户看到的是一个叠加之后的文件系统。
1. 添加文件 在容器中创建文件时，新文件被添加到容器层中。
2. 读取文件 在容器中读取某个文件时，Docker 会从上往下依次在各镜像层中查找此文件。一旦找到，立即将其复制到容器层，然后打开并读入内存。
3. 修改文件 在容器中修改已存在的文件时，Docker 会从上往下依次在各镜像层中查找此文件。一旦找到，立即将其复制到容器层，然后修改之。
删除文件 在容器中删除文件时，Docker 也是从上往下依次在镜像层中查找此文件。找到后，会在容器层中记录下此删除操作。
4. 只有当需要修改时才复制一份数据，这种特性被称作 Copy-on-Write。可见，容器层保存的是镜像变化的部分，不会对镜像本身进行任何修改。

### 技术细节
+ runtime/runc[^10] 
   >容器 runtime
runtime 是容器真正运行的地方。runtime 需要跟操作系统 kernel 紧密协作，为容器提供运行环境。
如果大家用过 Java，可以这样来理解 runtime 与容器的关系：
Java 程序就好比是容器，JVM 则好比是 runtime。JVM 为 Java 程序提供运行环境。同样的道理，容器只有在 runtime 中才能运行。
lxc、runc 和 rkt 是目前主流的三种容器 runtime。
lxc 是 Linux 上老牌的容器 runtime。Docker 最初也是用 lxc 作为 runtime。
runc 是 Docker 自己开发的容器 runtime，符合 oci 规范，也是现在 Docker 的默认 runtime。
rkt 是 CoreOS 开发的容器 runtime，符合 oci 规范，因而能够运行 Docker 的容器。

+ image增量存储、类似git

## 概念
可以参考官方[Docker glossary](https://docs.docker.com/glossary/?term=layer)
+ Registry
即注册服务。注册服务器是存放仓库的地方，一般会有多个仓库；而仓库是存放镜像的地方，一般每个仓库存放一类镜像

+ Dockerfile
告诉docker build命令应该执行哪些操作。

+ NAMES
自动分配的容器名称，可视为数字ID的昵称

+ layer
   >In an image, a layer is modification to the image, represented by an instruction in the Dockerfile. Layers are applied in sequence to the base image to create the final image. When an image is updated or rebuilt, only layers that change need to be updated, and unchanged layers are cached locally. This is part of why Docker images are so fast and lightweight. The sizes of each layer add up to equal the size of the final image.

   - 在 Dockerfile 文件中写入指令，每个指令都在映像上生成一个新的层。Docker 限制每个映像最多有 127 层，因此，要尽量优化映像层数。
   - During the 'build', the image is generated layer by layer. If bugs are encountered, you can start the toppest correct layer and debug the bug layer.
   
+ 构建缓存[^9]
   >在执行每条指令之前，Docker 都会在缓存中查找是否已经存在可重用的镜像，如果有就使用现存的镜像。如果你不想在构建过程中使用缓存，你可以在 docker build 命令中使用 --no-cache=true 选项。遵循的基本规则如下：
从一个基础镜像开始（FROM 指令指定），下一条指令将和该基础镜像的所有子镜像进行匹配，检查这些子镜像被创建时使用的指令是否和被检查的指令完全一样。如果不是，则缓存失效。
然而，有些指令需要更多的检查和解释。
对于 ADD 和 COPY 指令，镜像中对应文件的内容也会被检查，每个文件都会计算出一个校验和。文件的最后修改时间和最后访问时间不会纳入校验。在缓存的查找过程中，会将这些校验和和已存在镜像中的文件校验和进行对比。如果文件有任何改变，比如内容和元数据，则缓存失效。
除了 ADD 和 COPY 指令，缓存匹配过程不会查看临时容器中的文件来决定缓存是否匹配。例如，当执行完 RUN apt-get -y update 指令后，容器中一些文件被更新，但 Docker 不会检查这些文件。这种情况下，只有指令字符串本身被用来匹配缓存。

+ CoreOS[^7]
   >目前最常用的用来执行Docker集装箱的Linux发行版本既不是Ubuntu、Debian也不是RedHat、Fedora，而是CoreOS。这个发行版本根本没有软件包管理程序，所以也不能通过输入某个命令来安装软件。但是CoreOS预装了Docker，所以可以制作集装箱镜像，或者下载别人发布的集装箱镜像来执行。


## 应用
+ deploy for AI
There are many AI-related docker in [Datmo docker](https://hub.docker.com/r/datmo/tensorflow/)
+ [NAMD](https://hub.docker.com/r/alfpark/namd/)
==NOTE: dockerd NAMD can be used in Microsoft Azure!!! == 
   >2.11-icc-mkl-intelmpi contains an optimized NAMD image compatible with Azure Infiniband/RDMA instances

+ [Amber](https://hub.docker.com/r/ambermd/amber-build-box/)
With official support!

+ nvidia/cuda

+ galamost3


## 优点/缺点
+ 优点
   1. 保证了线上线下环境的一致性
   2. 简化了部署流程
   只需要从DockerHub上pull一个镜像就可以
   3. 实现了沙盒机制，提高了安全性
   由于webapp运行在容器中，与操作系统隔离开了，从而使操作系统基本不可能受到破坏，另外如果webapp因为攻击而瘫痪，并不需要重启服务器，直接重启容器或者再启动一个镜像就可以了。

+ 缺点
   参见[^1]和[^2]
   1. 调度系统的服务、环境变量
   例如利用cron服务，一旦将cron服务容器化后，原始的环境变数设定都会失效。
   你也不能使用环境变量在生成镜像的时候根据条件来改变指令(per #2637)。
   
## 其他
+ [Why we don't let non-root users run Docker in CentOS, Fedora, or RHEL](https://www.projectatomic.io/blog/2015/08/why-we-dont-let-non-root-users-run-docker-in-centos-fedora-or-rhel/)

+ Docker (开源项目)改名 Moby
   >今后的工作方式是：贡献Moby下的项目，然后使用Docker公司的Docker CE产品。


+ if the image size is too large, google docker reduce image size

+ [Kubernetes 是什么？](https://zhuanlan.zhihu.com/p/29232090)

### [Frequently Asked Questions](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#does-it-have-a-performance-impact-on-my-gpu-workload)
   >==Does it have a performance impact on my GPU workload?==
No, usually the impact should be in the order of less than 1% and hardly noticeable.
==Do you support CUDA Multi Process Service (a.k.a. MPS)?==
No, MPS is not supported at the moment. However we plan on supporting this feature in the future, and this issue will be updated accordingly.
**Do you support running a GPU-accelerated X server inside the container?**
No, running a X server inside the container is not supported at the moment and there is no plan to support it in the near future (see also OpenGL support).
**I have multiple GPU devices, how can I isolate them between my containers?**
GPU isolation is achieved through a container environment variable called NVIDIA_VISIBLE_DEVICES.
Devices can be referenced by index (following the PCI bus order) or by UUID (refer to the documentation).
**Why is nvidia-smi inside the container not listing the running processes?**
nvidia-smi and NVML are not compatible with PID namespaces.
We recommend monitoring your processes on the host or inside a container using --pid=host.

# Command
+ `docker --help`
+ `docker ps/start/stop`   
查看/停止/启动容器   
+ `docker list/rmi`
列出/删除本地镜像
+ `run`
`docker run -it -p 8080:80 centos:latest /bin/bash`，表示用latest版本，shell为bash，
`-p` 将container8080端口映射到80端口。
`-d` 守护容器，就是后台运行，退出命令窗口容器也不会停止
`-it` 交互式容器 退出命令窗口容器就停止运行了
`-P` 将容器内部使用的网络端口映射到我们使用的主机上。`docker ps`会显示**端口是如何映射的**
`--runtime=nvidia` without it gpu and its drive wouldn't be found.
`--name your_name` assign a name to your container
   - run centos image in background[^14]
   ==`docker run --runtime=nvidia -t -d --name conda_hoomd timchen314/galamost3:3.0.9 /bin/bash`==
   - automatically restart   
   `--restart=always` 意味着无论容器因何种原因退出（包括正常退出），就立即重启。   
   `--restart=on-failure:3`，意思是如果启动进程退出代码非0，则重启容器，最多重启3次。   

+ `exec`
`docker exec -it your_container_name bash   # login an existed container`
   - run source 
   Source is not an executable (source is a bash shell built-in command that executes the content of the file passed as argument)
   `docker run --rm -ti _image_name_ bash -c 'source FILE'`
   - Piping a file into docker run
   `echo 'export=$PATH:/opt/miniconda2/bin/' | docker exec -i conda_hoomd bash -c "cat >> /etc/profile"`
   Note that it won't work in this way: `docker exec -i conda_hoomd  echo 'export=$PATH:/opt/miniconda2/bin/' >> /etc/profile`

+ pause/unpause

+ `cp`
   ```shell
docker cp foo.txt mycontainer:/foo.txt
docker cp mycontainer:/foo.txt foo.txt
```

+ `rm`
remove all exited containers: 
`docker rm -v $(docker ps -aq -f status=exited)`

+ attach 
直接进入容器 启动命令 的**终端**，不会启动新的进程。

+ `system`
`docker system prune` 

+ tag
每个仓库会有多个镜像，用tag标示，如果不加tag，默认使用latest镜像(不设tag，则默认为latest)[^13]。
[image name] = [repository]:[tag]
注意！一个repo可以含有多个image！一个image可以打上多个tag！只有[repository]:[tag]唯一对应一个image！
   ```shell
docker tag myimage-v1.9.2 myrepo:1
docker tag myimage-v1.9.2 myrepo:1.9
docker tag myimage-v1.9.2 myrepo:1.9.2
docker tag myimage-v1.9.2 myrepo:latest
```
如果执行下面的命令，之前的tag会自动覆盖掉。
   ```shell
docker tag myimage-v2.0.0 myrepo:latest
```
+ logs
Docker daemon log: `/var/log/daemon.log | grep docker `[^15]


+ 保存/加载tar格式的镜像
   ```shell
docker save -o centos.tar xianhu/centos:git    # 保存镜像, -o也可以是--output
docker load -i centos.tar    # 加载镜像, -i也可以是--input
```
+ `-H` 指定host IP[^11]
   >默认配置下，Docker daemon 只能响应来自本地 Host 的客户端请求。如果要允许远程客户端请求，需要在配置文件中打开 TCP 监听，步骤如下：
1.编辑配置文件 /etc/systemd/system/multi-user.target.wants/docker.service，在环境变量 ExecStart 后面添加 -H tcp://0.0.0.0，允许来自任意 IP 的客户端连接。

+ 根据已有容器，新建自有镜像
   1. `docker commit -m "centos with git" -a "your_name" 72f1a8a0e394`
   The last is container ID. `-a` means author
   `docker commit [选项] <容器ID或容器名> [<仓库名>[:<标签>]]`
   2. Dockerfile
  
## show info 
   - `docker images` 显示已有docker
   - `docker ps -a` 查看终止状态的容器
   - `docker stats -a` Resource Usage
   - `docker top NAMES` 查看容器内部运行的进程 
   - `docker system df` show the used space
   - `docker history your_image`   
   - show tags
   For the images pulled to hub.docker.com, the tags can be found by：
   visit 'https://hub.docker.com/r/library/debian/tags/' and you can see tags。
   By replace "/r/" in path to "/v2/repositories/" the tags can be downloaded and analysed.
   `curl 'https://registry.hub.docker.com/v2/repositories/library/debian/tags/'|jq '."results"[]["name"]'  ` will ==List first 10 tags!== [^6]
   Note: `jq` is a tool for processing JSON inputs. If all tags is needed, see reference[^6].
   VALIDATE: `curl 'https://registry.hub.docker.com/v2/repositories/library/python/tags/'|jq '."results"[]["name"]'  ` does work!
    

## build
+ 注释符号`#`

+ ADD
与 COPY 类似，从 build context 复制文件到镜像。不同的是，如果 src 是归档文件（tar, zip, tgz, xz 等），文件会被自动解压到 dest。
+ ARG 
   >构建参数[^9]
格式：ARG <参数名>[=<默认值>]
构建参数和 ENV 的效果一样，都是设置环境变量。所不同的是，ARG 所设置的构建环境的环境变量，在将来容器运行时是不会存在这些环境变量的。但是不要因此就使用 ARG 保存密码之类的信息，因为 docker history 还是可以看到所有值的。


+ CMD   
三种格式[^16]   
   >1. Exec 格式：CMD ["executable","param1","param2"]
   >2. 这是 CMD 的推荐格式。
CMD ["param1","param2"] 为 ENTRYPOINT 提供额外的参数，此时 ENTRYPOINT 必须使用 Exec 格式。
   >3. Shell 格式：CMD command param1 param2

   >==指令就是用于指定默认的容器主进程的启动命令的。==[^9]
在运行时可以指定新的命令来替代镜像设置中的这个默认命令，比如，`docker run -it ubuntu cat /etc/os-release`   
在指令格式上，一般推荐使用 exec 格式，这类格式在解析时会被解析为 JSON 数组，因此一定要使用双引号 "，而不要使用单引号。   
如果使用 shell 格式的话，实际的命令会被包装为 sh -c 的参数的形式进行执行。比如：   
`CMD echo $HOME`   
在实际执行中，会将其变更为：   
`CMD [ "sh", "-c", "echo $HOME" ]`   

另外，docker的主程序不能是退出或后台运行的状态：
   >对于容器而言，其启动程序就是容器应用进程，容器就是为了主进程而存在的，主进程退出，容器就失去了存在的意义，从而退出，其它辅助进程不是它需要关心的东西。



+ COPY 
支持两种形式：
```
COPY src dest
COPY ["src", "dest"]
```

+ ENTRYPOINT
`<ENTRYPOINT> "<CMD>"`
ENTRYPOINT 不会被忽略，一定会被执行，即使运行 docker run 时指定了其他命令。
   >`ENTRYPOINT ["/bin/echo", "Hello"]  `   
`CMD ["world"]`   
当容器通过 `docker run -it [image]` 启动时，输出为：
Hello world
而如果通过 `docker run -it [image] CloudMan` 启动，则输出为：
Hello CloudMan

PS: 最佳实践[^16]
   >使用 RUN 指令安装应用和软件包，构建镜像。
如果 Docker 镜像的用途是运行应用程序或服务，比如运行一个 MySQL，应该优先使用 Exec 格式的 ENTRYPOINT 指令。CMD 可为 ENTRYPOINT 提供额外的默认参数，同时可利用 docker run 命令行替换默认参数。
如果想为容器设置默认的启动命令，可使用 CMD 指令。用户可在 docker run 命令行中替换此默认命令。

+ ENV
```
ENV MY_VERSION 1.3
RUN apt-get install -y mypackage=$MY_VERSION
```

+ LABEL
   >LABEL指令添加元数据到一个镜像。一个LABEL是一个键值对。要在LABEL值中包含空格，使用双引号和反斜杠(续行)。
查看LABEL，可以用`docker inspect`。
例子：   
   ```docker
LABEL "com.example.vendor"="ACME Incorporated"
LABEL com.example.label-with-value="foo"
LABEL version="1.0"
LABEL description="This text illustrates \
that label-values can span multiple lines."
```


+ MAINTAINER (depreciate)
设置镜像的作者，可以是任意字符串。

+ 其他
EXPOSE VOLUME RUN 


## 安装
+ Mac OS
homebrew直接安装
`brew cask install docker`
+ CentOS
[官网](https://docs.docker.com/engine/installation/linux/docker-ce/centos/)
官网的方法是最正确的：
   ```shell
# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/centos7/x86_64/nvidia-docker.repo | \
  sudo tee /etc/yum.repos.d/nvidia-docker.repo

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo yum install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
```

[CentOS runoob](http://www.runoob.com/docker/centos-docker-install.html)
单独安装docker-ce非常麻烦的，因为需要安装和配置nvidia-container-runtime：
   ```shell
sudo yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo systemctl start docker
sudo docker run hello-world
# install nvidia-container-runtime
yum install -y nvidia-container-runtime
# Then you should follow the troublesome setting process in https://github.com/nvidia/nvidia-container-runtime#docker-engine-setup
```

+ Docker Machine
   >Docker Machine是一个简化Docker安装的命令行工具，通过一个简单的命令行即可在相应的平台上安装Docker，比如VirtualBox、 Digital Ocean、Microsoft Azure。

## configuration
+ bash-completion
   ```bash
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion  
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion  
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion 
```
+ `docker run hello-world` for test

## error
+ "Docker version reports bad response from Docker engine"
A lot of people encounter this error (https://forums.docker.com/t/docker-version-reports-bad-response-from-docker-engine/13395). For me, I sovled this by reset to factory defaults.

## problem
### ==use gcc5.x (solved)==

source /opt/rh/devtoolset-4/enable
### can't get the size of remote image (unsolved)
by google: docker remote image size, or docker image size in REPOSITORY, there is no cli command to do this.
A complicate answer is: 
[Docker: How to get image size?](https://unix.stackexchange.com/questions/134186/docker-how-to-get-image-size)

# reference
[^1]: [一年之后重新审视 Docker —— 根本性缺陷和炒作](https://yq.aliyun.com/articles/113842)
[^2]: [Docker架构优缺点大剖析](http://www.sohu.com/a/155079445_120672)
[^3]: [docker与虚拟机实现原理比较](http://blog.csdn.net/cbl709/article/details/43955687)
[^4]: [docker在web开发中得使用流程是怎样的？](https://www.zhihu.com/search?q=docker&type=content)
[^5]: [【 全干货 】5 分钟带你看懂 Docker ！](https://zhuanlan.zhihu.com/p/30713987)   
[^6]: [How to list all tags of a docker image](http://www.googlinux.com/list-all-tags-of-docker-image/index.html)
[^7]: [分布式机器学习的故事：Docker改变世界](https://zhuanlan.zhihu.com/p/19902938)
[^8]: [Limit a container's resources](https://docs.docker.com/engine/admin/resource_constraints/)
[^9]: [Docker — 从入门到实践](http://docker_practice.gitee.io/image/multistage-builds.html)
[^10]: [每天5分钟玩转Docker容器技术（一）](https://zhuanlan.zhihu.com/p/32324673)
[^11]: [每天5分钟玩转Docker容器技术（二）](https://zhuanlan.zhihu.com/p/32356831)
[^12]: [每天5分钟玩转Docker容器技术（三）](https://zhuanlan.zhihu.com/p/32383774)
[^13]: [镜像命名的最佳实践 - 每天5分钟玩转 Docker 容器技术（18）](http://blog.csdn.net/cloudman6/article/details/72603130)
[^14]: [Docker container will automatically stop after “docker run -d”](https://stackoverflow.com/questions/30209776/docker-container-will-automatically-stop-after-docker-run-d/30209974#30209974)
[^15]: [Where is the Docker daemon log?](https://stackoverflow.com/questions/30969435/where-is-the-docker-daemon-log)
[^16]: [RUN vs CMD vs ENTRYPOINT - 每天5分钟玩转 Doc
ker 容器技术（17）](https://www.cnblogs.com/CloudMan6/p/6875834.html)

--- 

+ 入门   
[只要一小时，零基础入门Docker](https://zhuanlan.zhihu.com/p/23599229)     
[runoob](http://www.runoob.com/docker/docker-container-usage.html)   
+ 进阶   
[Docker Cheat Sheet](https://github.com/wsargent/docker-cheat-sheet#layers)   
[官网 get started](https://docs.docker.com/get-started/)   
[Docker — 从入门到实践](http://docker_practice.gitee.io/image/multistage-builds.html)
+ 待读

---

Examples of Dockerfile:
1. centos   
   ```docker
FROM scratch
ADD centos-7-docker.tar.xz /

LABEL name="CentOS Base Image" \
    vendor="CentOS" \
    license="GPLv2" \
    build-date="20180107"

CMD ["/bin/bash"]
```
2. 