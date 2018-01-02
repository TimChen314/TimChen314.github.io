---
title: python notes
tags: [python, 编程语言]   
top: 11
categories: python   
date: 2017-10-02 18:00:00
---
[TOC] 
Python features a dynamic type system and automatic memory management and supports multiple programming paradigms.[^3]
<!-- more -->

## Python Syntax

### [Python doc](https://docs.python.org)
### [builtin functions](https://docs.python.org/3/library/functions.html) (import builtin**s**)

| | | | | |
|-|-|-|-|-|
|~~abs()~~   |~~dict()~~    |~~help()~~    |~~min()~~   |~~setattr()~~    |
|~~all()~~    |dir()    |~~hex()~~   |~~next()~~    |slice()    |
|~~any()~~    |divmod()    |~~id()~~    |~~object()~~    |sorted()    |
|ascii()    |~~enumerate()~~    |~~input()~~    |~~oct()~~    |staticmethod()    |
|bin()    |eval()    |~~int()~~    |~~open()~~   |~~str()~~    |
|~~bool()~~    |exec()    |~~isinstance()~~    |ord()    |~~sum()~~    |
|bytearray()    |filter()    |issubclass()    |pow()    |super()    |
|bytes()    |~~float()~~    |~~iter()~~    |~~print()~~    |~~tuple()~~    |
|callable()    |format()    |~~len()~~    |property()    |~~type()~~    |
|~~chr()~~   |frozenset()    |~~list()~~    |~~range()~~    |vars()    |
|classmethod()    |~~getattr()~~    |locals()    |~~repr()~~    |~~zip()~~    |
|compile()    |globals()    |~~map()~~    |reversed()   | \_\_import__()    |
|complex()    |~~hasattr()~~    |~~max()~~    |round()    |
|~~delattr()~~    |hash()    |memoryview()    |~~set()~~    |

#### sum() 
sum(iterable[, start]) ，iterable

#### [max()](https://docs.python.org/3/library/functions.html#max)
   >max(iterable, *[, key, default])
max(arg1, arg2, *args[, key])

   >Return the largest item in an iterable or the largest of two or more arguments.

   >**If one positional argument is provided, it should be an iterable.** The largest item in the iterable is returned. **If two or more positional arguments are provided, the largest of the positional arguments is returned.**

   >There are two optional keyword-only arguments. The key argument specifies a one-argument ordering function like that used for list.sort(). The default argument specifies an object to return if the provided iterable is empty. If the iterable is empty and default is not provided, a ValueError is raised.

   >If multiple items are maximal, the function returns the first one encountered. This is consistent with other sort-stability preserving tools such as sorted(iterable, key=keyfunc, reverse=True)[0] and heapq.nlargest(1, iterable,key=keyfunc).
   
   + [几个例子](http://www.cnblogs.com/whatisfantasy/p/6273913.html)

#### next(iterator[, default])

#### `all()/any()`
   >Return True if all elements of the iterable are true (or if the iterable is empty). Equivalent to:
   ```python
def all(iterable):
    for element in iterable:
        if not element:
            return False
    return True
```

#### filter
把传入的函数依次作用于每个元素，然后根据返回值是True还是False决定保留还是丢弃该元素。
python3起，filter 函数返回的对象从列表改为 filter object（迭代器）。
   ```python
def is_odd(n):
    return n % 2 == 1

[item for item in filter(is_odd, [1, 2, 4, 5, 6, 9, 10, 15]) ]
```


#### getattr()/setattr()/hasattr()/delattr()
   >getattr(x, 'foobar') is equivalent to x.foobar

All these function are similar. See **docs** for more.

#### vars()
From python doc:
   >**Return the \_\_dict\_\_** attribute for a module, class, instance, or any other object with a \_\_dict\_\_ attribute.


#### enumerate

如果mylist是一个二维数组：

   ```python
for i,line in enumerate(mylist):
    ...
```
**line是元组**


#### staticmethod(function)	
PS: 
   >@classmethod means: when this method is called, we pass the class as the first argument instead of the instance of that class (as we normally do with methods). This means you can use the class and its properties inside that method rather than a particular instance.
   >@staticmethod means: when this method is called, we don't pass an instance of the class to it (as we normally do with methods). This means you can put a function inside a class but you can't access the instance of that class (this is useful when your method does not use the instance).

classmethod涉及类，不涉及类的实例；staticmethod两者都不涉及，但与类有紧密的联系
[ref:](https://www.zhihu.com/question/20021164)




### Python——类属性/实例属性
[Python——类属性/实例属性](http://blog.csdn.net/bolike/article/details/21554901)
[Python类属性，实例属性](http://www.cnblogs.com/dream-for/p/5199308.html) #非常好 

   ```python
C.__name__     # 类C的名字（字符串）
C.__doc__      # 类C的文档字符串
C.__bases__    # 类C的所有父类构成的元组
C.__dict__     # 类C的属性
C.__module__   # 类C定义所在的模块
C.__class__    # 实例C对应的类
```

+ module.__file__
**含有module的路径！**






### 操作符特性：`a, b = b, a+b`
Take the calculation of Fibinacci: 
`a, b = b, a+b`  # a and a+b will be computed separately

### print
+ `print(end='str')`

### dict

+ mydict.iterm() 将项以list返回
  `for key,val in myd3.iterm():`

+ ~~iteriterms()返回迭代器，节省内存~~ **Only for python2**



### file
1. `f.readline()/readlines()/write()/writelines()`
   + `readline()`#每次读入一行
   + `readlines()` #以list的形式存储每一行
   + `write()` #自动换行
   + `writelines()` #不自动换行

2. f.closed 
注意closed是一个变量，值为True/False

### list comprehension
+ two fold list comprehension
   ```python
content = f.readlines()
word_list=[word for line in content for word in line.split()]
```


### string
#### 1. strip(s[, chars]) 去掉首尾的字符   
   默认情况下strip() 去掉首尾的whitespace 【whitespace include \n, \t and \r】。
   >The charsargument is not a prefix or suffix; rather, all combinations of its values are stripped:

   ```python
   >>> 'www.example.com'.strip('cmowz.') 
'example'
```

#### 2. format 
- '{0:.2f} {1:s} {2:d}'.format( v0[,v1[v2...] )
- 可以使用关键词
- 应用时转化：{!s}、{!r}
- 旧式字符串格式化符号是 %，如：{0:%.4f}


##### custom object(define \_\_format\_\_ in a class)
   ```python
class HAL9000(object):
    def __format__(self, format):
        if (format == 'open-the-pod-bay-doors'):
            return "I'm afraid I can't do that."
        return 'HAL 9000'
```

##### datetime
   ```python
from datetime import datetime
'{:%Y-%m-%d %H:%M}'.format(datetime(2001, 2, 3, 4, 5))
```

##### named placeholder
use key to hold the place. **input the dictionary as elements**
   ```python
data = {'first': 'Hodor', 'last': 'Hodor!'}
'{first} {last}'.format(**data)
# or
'{first} {last}'.format(first='Hodor', last='Hodor!')
```

##### Getitem and Getattr
##### Parametrized formats



#### 3. rjust(width[, fillchar])  【ljust(), center() is similar】

#### 4. zfill(n) 左侧填充0至n位

返回一个原字符串右对齐,并使用空格填充至长度 width 的新字符串。如果指定的长度小于字符串的长度则返回原字符串。

#### 5. split(str="", num=string.count(str)) # str and num is not a kewword
+ num -- 分割次数。
+ **注意split后常会产生空字符**

#### 6. join
   ```python
out.write(" ".join(mylist))
# 用" "链接mylist中的iterm
```
+ elegant use
   ```python
out.write(" ".join( map(str,iterable)  ))
```


#### 7. encode()/decode()
+ str.encode(encoding="utf-8", errors="strict")
   >设置不同错误的处理方案。默认为 'strict',意为编码错误引起一个UnicodeError。 其他可能得值有 'ignore', 'replace', 'xmlcharrefreplace', 'backslashreplace' 以及通过 codecs.register_error() 注册的任何值。



### ternary operator
   ```python
result='5 is larger than 3' if 5>3 else '5 is not larger than 3' 
```



### CLI
+ `python -c "print('hello world')"`
+ `python -m mymodule`
   1. sys.path is changed
   2. it's equal to `python mymodule.py`






## module
### re module

#### 1. replace(str1, str2)

### sys module
+ sys.version/version_info(version_info is a object)

### os module
#### 1. os.path
   [os.path模块](http://www.cnblogs.com/dkblog/archive/2011/03/25/1995537.html)

+ os.path.exist  
determine if a file or dir exists

+ os.remove 
remove a file; if file does not exists, an Error will be throwed out.

+ os.rmdir 
remove a dir

+ os.path.splitext(path)
Split the pathname path into a pair (root, ext)
+ os.path.basename(your_path)

#### 2. ~~os.popen~~

1. **shell cmd is executed in background and you can't change it**

2. inplemented by _subprocess.Popen_, so why not you use _subprocess_?

[python doc](https://docs.python.org/3.5/library/os.html?highlight=os.popen#os.popen)

### time & calendar
[Python 日期和时间 runoob](http://www.runoob.com/python/python-date-time.html)

+ time.time()	
Return the current time in seconds since the Epoch.
+ mktime(tupletime)
+ localtime()		
Convert seconds since the Epoch to a time tuple expressing local time.
When 'seconds' is not passed in, convert the current time instead.
+ strftime()	
strftime(format[, tuple]) -> string
+ strptime()	
strptime(string, format) -> struct_time	   
Parse a string to a time tuple according to a format specification.   
+ time.sleep(secs)	
+ calendar.isleap(year)
+ calendar.weekday(year,month,day)


### subprocess module

[python doc](https://docs.python.org/3.5/library/subprocess.html?highlight=subprocess#frequently-used-arguments)

#### 1.  For cmd that needn't stdout
   `subprocess.run("cp standard_py/*py .", shell=True, check=True)`

+ _shell=True_
you can use a string instead of a series of args!
+ _check=True_
throw an Error if shell cmd exit wrong!

#### 2. For cmd needing stdout
An example:
   ```python
ret = subprocess.run("ls standard_py/*py", shell=True, check=True, universal_newlines=True, stdout=PIPE)
print(ret.stdout, end="")
```
+ _universal_newlines=True_
stdout
Captured stdout from the child process. A bytes sequence, or a string if run() was called with universal_newlines=True. None if stdout was not captured.

+ stdout=PIPE
without this argument, stdout will be printed as stdout of python script, instead of captured, as from python doc:
   >This(ct: means _run_) does not capture stdout or stderr by default. To do so, pass PIPE for the stdout and/or stderr arguments.

### glob module
The glob module finds all the pathnames matching a specified pattern

+ glob.glob(pathname, *, recursive=False)
+ glob.iglob(pathname, recursive=False)
Return an iterator which yields the same values as glob()

### [collections module 廖雪峰](http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/001431953239820157155d21c494e5786fce303f3018c86000)
+ Counter


### PIL
+ `img = Image.open(‘origin.png’) #支持多种格式` 
注意：类似于.htm和.html，.jpg和.jpeg没有区别，只是两种写法
+ font
`font = ImageFont.truetype("FreeMono.ttf", 28, encoding="unic")`
+ `img2.save('./test_image_data/cat_001_blur.jpeg','jpeg')` #save('path','format')
+ resize()、rotate()、convert(mode='your_mode')
+ Coordinates (0, 0) in the upper left corner.
+ `draw = ImageDraw.Draw(img)` 
   ```language
#img is from:
#img = Image.open('./test_image_data/cat_001.jpg')
draw.text((width - add_width, 0), number, font=font, fill=fillcolor) # first parameter is the start point of the draw
```


### random [doc](https://docs.python.org/3/library/random.html)
+ random.seed(a=None, version=2)

#### functions for integers
+ random.randrange(start, stop[, step])
+ random.randint(a, b)
   >return a random integer N such that a <= N <= b. Alias for randrange(a, b+1).

#### real-valued distributions
+ random.random()
   >Return the next random floating point number in the range [0.0, 1.0).
+ random.uniform(a, b)
+ random.gauss(mu, sigma)


### shutil
   >The shutil module offers a number of high-level operations on files and collections of files. In particular, functions are provided which support file copying and removal.

`shutil.copyfile(src, dst)`


## other useful things
### ipython
[入门](https://www.cnblogs.com/cuiyubo/p/6823478.html)
+ "?" 帮助与显示信息
`?save` 会给出save命令的用法、对象的签名
`??your_function` 显示源代码
+ `!pwd` 加!执行shell command
+ `%hist`
+ `%edit` 使用编辑器打开

### conda
+ minicoda
+ [使用conda管理python环境](https://zhuanlan.zhihu.com/p/22678445)
+ anaconda
[Anaconda使用总结](http://python.jobbole.com/86236/)
+ conda install scipy #安装scipy
+ conda list #列出已安装的包

### pip
+ Usage：`pip --help`
[for more info](http://www.tuicool.com/articles/NFV3yaJ)
#### error
+ Could not fetch URL https://pypi.python.org/simple/pytest-cov/...   
   ```shell
   Could not fetch URL https://pypi.python.org/simple/pytest-cov/: There was a problem confirming the ssl certificate: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed (_ssl.c:600) - skipping
  Could not find a version that satisfies the requirement pytest-cov (from versions: )
No matching distribution found for pytest-cov
```
   解决：
   ```shell
pip install --trusted-host pypi.python.org pytest-xdist
```

## 工程能力

### 工程/OOP
+ [setting all instance variables in the \_\_init\_\_ is cleaner](https://stackoverflow.com/questions/20661448/python-should-all-member-variables-be-initialized-in-init)

+ 工厂函数
见python核心编程：工厂函数看上去有点像函数，实质上他们是类，当你调用它们时，实际上是生成了该类型的一个实例，就像工厂生产货物一样.

###  debug
   要融汇的方法[^2]：
   >回答先在本地重现的就算了吧……那么容易就能重现通常说明最基本的代码逻辑覆盖测试都没做好。相比起C/C++来说，动态语言还是比较幸福的，异常都有详细的堆栈，只要打印到日志里就行了，错误信息通常也比较明确。要点在于该打印的日志一点都不能少，严禁在出现异常的时候只打印错误信息而不打堆栈。但归根结底来说，发现和解决bug靠的是良好的程序结构，必要的defensive（关键函数的参数合法性校验等），自动化的测试流程，线上调试只是亡羊补牢。

### test
pytest比较好！从它入门 ！
[unittest vs pytest vs nose ](https://stackoverflow.com/questions/28408750/unittest-vs-pytest-vs-nose)
[Pytest vs Unittest vs Nose](http://pythontesting.net/transcripts/2-pytest-vs-unittest-vs-nose/) 【详细的对比】
待读！：
[Writing unit tests in Python: How do I start? ](https://stackoverflow.com/questions/3371255/writing-unit-tests-in-python-how-do-i-start) 
[Improve Your Python: Understanding Unit Testing](https://jeffknupp.com/blog/2013/12/09/improve-your-python-understanding-unit-testing/)
[python自动化测试](http://www.cnblogs.com/beer/p/5075619.html) 【先读】
[最完整的自动化测试流程](http://www.cnblogs.com/yufeihlf/p/5752146.html)






## python缺点
- efficiency
   + slow than java
   + global lock, which makes multi-threads suck
- hard to distribution (compare to JAVA et al., python is dependent to package)
- easily decompiled
### 和其他语言的对比
+ ruby
ruby最大的优势在于Ruby on Rails

### 我的经验
- 都说python有很多包、方便，然而包里有可能有很多坑（bug or bad practice），比如Pillow中遇到过`**karg`的滥用。这些特点使得python很容易开发原型，但很难构建稳定、高效、一致的大型应用。
- 有不少不符合直觉的"feature"[^1]
例如：
   ```python
   >>> a = ([1], [2])
   >>> a[0] += [3]
Traceback (most recent call last):
  File "", line 1, in 
TypeError: 'tuple' object does not support item assignment
   >>> a
([1, 3], [2])
```

## reference
[^1]: [有哪些明明是 bug，却被说成是 feature 的例子？](https://www.zhihu.com/question/66941121)
[^2]: [老程序员解bug有那些通用套路？](https://www.zhihu.com/people/ling-jian-94/answers)
[^3]: [Python](https://en.wikipedia.org/wiki/Python_(programming_language)#Features_and_philosophy)
