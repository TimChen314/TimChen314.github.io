---
title:  <font size=7><b>python mechanism </b></font>
tags: [python]   
top: 10
categories: python   
date: 2017-07-28 18:00:00
---
[TOC]
## 0. is 与 `==`的区别
python对象有三个要素：id、type、value。is 比较的是id；\=\=比较的是value
而id实际上是内存地址，`(ob1 is ob2)` 等价于 `(id(ob1) == id(ob2))`
<!-- more -->
另外，一些具体的问题，结果不确定，比如用python.py：
```
   >>> x = 500
   >>> y = 500
   >>> x is y
True
   ```language
```
然而用python或者IPython，结果为False
## 1. mutable & immutable

不可变（immutable）：int、字符串(string)、float、（数值型number）、元组（tuple)
 
可变（mutable）：字典型(dictionary)、列表型(list)

## 2. with 语句
**自动进行对象的生命周期进行管理**
Python中的with语句中要求对象实现`__enter__`和`__exit__`函数。调用with语句时，会先分析该语句，执行`__enter__`函数，然后在当前suite退出时，会调用`__exit__`函数。`__exit__`函数中除了可以做释放资源的操作之外，同时也是异常处理的地方。如果当前suite正常退出，没有抛出任何异常，`__exit__`的几个参数均为None。否则，则将此异常的type、value、traceback作为参数传递给`__exit__`函数，同时，如果`__exit__`返回false，此异常会再次抛出，上一级代码suite可以继续处理，如果`__exit__`返回true，那么此异常就不会被再次抛出了。
+ 同时打开多个文件
   ```python
with open(filename1, 'rb') as fp1, open(filename2, 'rb') as fp2, open(filename3, 'rb') as fp3:
    for i in fp1:
        j = fp2.readline()
        k = fp3.readline()
        print(i, j, k)
```

## 3. list参数传递
python中的默认变量是定义时得到的，类似于static，**其它的时候无论调用几次函数，如果没有传参进来，就会一直用这个默认参数了**。
正确做法：
   ```python
def add(element, mylist=None):
    if mylist is None:
        mylist = []
    mylist.append(element)
    return mylist
```

## 4\*. [Python中函数的参数传递与可变长参数](http://www.cnblogs.com/xudong-bupt/p/3833933.html)
【tricky】可变长度参数：`*tupleArg,**dictAr`
[廖雪峰的更详细的介绍](http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/001431752945034eb82ac80a3e64b9bb4929b16eeed1eb9000)
ct总结：参数绑定优先级：
1. 指定参数名
2. 顺序
3. 不符合前两条的可以被**可变长度参数**捕捉
4. **可变长度参数**是通过拷贝传到函数内的！与一般机制不同
5. **限制关键字参数的名字**

如果要限制关键字参数的名字，就可以用命名关键字参数，例如，只接收city和job作为关键字参数。这种方式定义的函数如下：
   ```python
def person(name, age, *, city, job):
    print(name, age, city, job)

```

## 5. generator
最难理解的就是generator和函数的执行流程不一样。函数是顺序执行，遇到return语句或者最后一行函数语句就返回。而变成generator的函数，在每次调用next()的时候执行，遇到yield语句返回，再次执行时从上次返回的yield语句处继续执行。
## 6. zip() & Unpacking Argument Lists——"\*" & "\*\*"
**The implementation of zip is very beautiful：**
来自[python doc](https://docs.python.org/3/library/functions.html)
   ```python
def zip(*iterables):
    # zip('ABCD', 'xy') --> Ax By
    sentinel = object()
    # ct: iterators is a "Iterator" point to the "Iterator" of different parameters(形参)
    #     e.g., at first, iterators is the "Iterator" of 'ABCM';
    #     iterators.next() is the "Iterator" of 'xy';
    iterators = [iter(it) for it in iterables]
    while iterators:
        result = []
        for it in iterators:
            elem = next(it, sentinel)
            if elem is sentinel:
                return
            result.append(elem)
        yield tuple(result)
```
   ```python
#zip() in conjunction with the * operator can be used to unzip a list:
   >>> x = [1, 2, 3]
   >>> y = [4, 5, 6]
   >>> zipped = zip(x, y)
   >>> list(zipped)
[(1, 4), (2, 5), (3, 6)]
   >>> x2, y2 = zip(*zip(x, y))
   >>> x == list(x2) and y == list(y2)
True
```

+ Unpacking Argument Lists
   ```python
   >>> list(range(3, 6))            # normal call with separate arguments
[3, 4, 5]
   >>> args = [3, 6]
   >>> list(range(*args))            # call with arguments unpacked from a list
[3, 4, 5]
```

## 7. Iterable和Iterator
凡是可作用于for循环的对象都是Iterable类型，它有\_\_getitem\_\_()方法；
凡是可作用于next()函数的对象都是Iterator类型，它们表示一个惰性计算的序列，它有\_\_next\_\_()和\_\_iter\_\_()方法；
集合数据类型如list、dict、str等是Iterable但不是Iterator，不过可以通过iter()函数获得一个Iterator对象。
Python的for循环本质上就是通过不断调用next()函数实现的，例如：
for x in [1, 2, 3, 4, 5]:    
pass
实际上完全等价于：
首先获得Iterator对象:
`it = iter([1, 2, 3, 4, 5])`
循环:
   ```python
while True:
    try:
        # 获得下一个值:
        x = next(it)
    except StopIteration:
        # 遇到StopIteration就退出循环break
```

+ while my_iterator（参见zip的实现）
iterator最终会返回StopIteration对象，而while可以对其进行判断。
       
## 8. 内存
### 8.1. 释放内存
先del再gc.collect()
## 9. Python类
### 9.1. 和静态语言不同，Python允许对**实例变量**绑定任何数据

也就是说，对于两个实例变量，虽然它们都是同一个类的不同实例，但拥有的变量名称都可能不同：
   ```python
   >>> bart = Student('Bart Simpson', 59)
   >>> lisa = Student('Lisa Simpson', 87)
   >>> bart.age = 8
   >>> bart.age
8
   >>> lisa.age
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'Student' object has no attribute 'age'
```
### 9.2. [Python的伪私有属性](http://www.cnblogs.com/blackmatrix/p/5600830.html)
Note that user defined attributes shall not end with '__'
### 9.3. 私有变量的访问方法
不能直接访问__name是因为Python解释器对外把__name变量改成了_Student__name，所以，仍然可以通过_Student__name来访问__name变量。
注意下面的这种错误写法：
   ```python
   >>> bart = Student('Bart Simpson', 98)
   >>> bart.get_name()
'Bart Simpson'>>> bart.__name = 'New Name' # 设置__name变量！
   >>> bart.__name
'New Name'
```
表面上看，外部代码“成功”地设置了__name变量，但实际上这个__name变量和class内部的__name变量不是一个变量！内部的__name变量已经被Python解释器自动改成了_Student__name，而外部代码给bart新增了一个__name变量。

### 9.4. [特殊函数`__call__`模糊了对象与函数的区别](http://www.cnblogs.com/superxuezhazha/p/5793536.html)
### 9.5. 类类型的检查--不检查
静态语言 vs 动态语言
对于静态语言（例如Java）来说，如果需要传入Animal类型，则传入的对象必须是Animal类型或者它的子类，否则，将无法调用run()方法。

对于Python这样的动态语言来说，则不一定需要传入Animal类型。我们只需要保证传入的对象有一个run()方法就可以了：
   ```python
class Timer(object):def run(self):
        print('Start...')
        ```
这就是动态语言的“鸭子类型”，它并不要求严格的继承体系，一个对象只要“看起来像鸭子，走起路来像鸭子”，那它就可以被看做是鸭子。

Python的“file-like object“就是一种鸭子类型。对真正的文件对象，它有一个read()方法，返回其内容。但是，许多对象，只要有read()方法，都被视为“file-like object“。许多函数接收的参数就是“file-like object“，你不一定要传入真正的文件对象，完全可以传入任何实现了read()方法的对象。

## Style guide
### argument
+ `**kwargs ` is a bad practice:
  1. you don't know how `**kwargs` affect.
  2. **wrong keywrod arguments is no longer reported by the interpreter.** 
 `TypeError 'x' is an invalid keyword argument for this function`
 [reference:The Use and Abuse of Keyword Arguments in Python](http://ivory.idyll.org/blog/on-kwargs.html)

