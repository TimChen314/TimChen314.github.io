
---
title: numpy notes
tags: [python, 编程语言]   
top: 11
categories: python   
date: 2017-10-31 18:00:00
---
[TOC]
The fundamental package for scientific computing with Python.
<!-- more -->

#### Introduction
1. ==Best tutorial: [Quickstart tutorial](https://docs.scipy.org/doc/numpy-dev/user/quickstart.html#tricks-and-tips)==
2. Since pythoner usually do `import numpy as np`, in most scenes =='np' measn 'numpy'== 
3. **Note: an 1d array in numpy acts like a row vector in linear algebra, but most lienar algebra textbook are written in column form!
In text book: matrix x column vector = column vector   
In numpy: row vector x matrix.T = row vector**
4. ==string type numpy array automatically encode the string to bytes!==
   ```python
new_a = a.astype('U') # get string instead of bytes
```
5. 帮助：`np.info`
例如`np.info(np.random)`

#### [broadcasting](https://docs.scipy.org/doc/numpy/user/basics.broadcasting.html) 
Broadcasting is one of most error-prone concept in numpy. 
   >When operating on two arrays, NumPy compares their shapes element-wise. It starts with the trailing dimensions, and works its way forward. Two dimensions are compatible when:
   >1. they are equal, or
   >2. one of them is 1


1. reshape can turn off the broadcast
2. an telling example
   >A      (4d array):  8 x 1 x 6 x 1   
B      (3d array):      7 x 1 x 5   
Result (4d array):  8 x 7 x 6 x 5   

   So for a single dimension, the broadcast means numpy will expand (6 x 1) to (6 x 5)， and then do element-wise operation.  

#### ndarray学习
[numpy中的ndarray方法和属性](http://blog.csdn.net/qq403977698/article/details/47254597)
+ ndarray.mean(axis=None, dtype=None, out=None)：返回指定轴的数组元素均值
+ ndarray.var(axis=None, dtype=None, out=None, ddof=0)：返回数组的方差，沿指定的轴。
+ ndarray.std(axis=None, dtype=None, out=None, ddof=0)：沿给定的轴返回数则的标准差
+ ndarray.trace(offset=0, axis1=0, axis2=1, dtype=None, out=None)：返回沿对角线的数组元素之和
+ ndarray.diagonal(offset=0, axis1=0, axis2=1)：返回对角线的所有元素。
+ 最大/小值
  + ndarray.argmin(axis=None, out=None):返回指定轴最小元素的索引。
  + darray.min(axis=None, out=None)：返回指定轴的最小值
+ flat/flatten
   + ndarray.flat 和 ndarray.T 一样不是函数调用
   ```python
   >>> x = X.flat
   >>> x
<numpy.flatiter object at 0x9e82278>
                            # 不直接返回一维数组
                            # 但可直接索引
```
   + flatten()是函数调用，可以指定平坦化的参数。
    `ndarray.flatten(order='C')`
    可选参数，order：
（1）’C’：C-style，行序优先
（2）’F’：Fortran-style，列序优先
（3）’A’：保持
（4）默认为’C’

+ ndarray.transpose(*axes) :返回矩阵的转置矩阵
+ ndarray.take(indices, axis=None, out=None, mode=’raise’):获得数组的指定索引的数据，如：
   ```python
   >>> a.take([1,3],axis=1) #提取1，3列的数据
array([[ 1,  3],
[ 5,  7],
[ 9, 11]])
```

+ `numpy.argmax(a, axis=None, out=None)` ==非常有用==
Returns the indices of the maximum values along an axis. [doc](https://docs.scipy.org/doc/numpy-1.13.0/reference/generated/numpy.argmax.html)



#### 构造矩阵
+ arange()/linspace()
+ numpy.zeros，numpy.ones，numpy.eye, numpy.empty((2,3)), numpy.full((2,2),7)
   ```python
   >>> print np.zeros((3,4))
[[ 0.  0.  0.  0.]
 [ 0.  0.  0.  0.]
 [ 0.  0.  0.  0.]]
   >>> print np.ones((3,4))
[[ 1.  1.  1.  1.]
 [ 1.  1.  1.  1.]
 [ 1.  1.  1.  1.]]
   >>> print np.eye(3)
[[ 1.  0.  0.]
 [ 0.  1.  0.]
 [ 0.  0.  1.]]
```

#### 矩阵indexing
1. automatic reshaping
   ```python3
   >>> a = np.arange(30)
   >>> a.shape = 2,-1,3  # -1 means "whatever is needed"
   >>> a.shape
(2, 5, 3)
```

2. Indexing with Arrays of Indices
+ Suppose a and idx is a np.array, then `a[i].shape == idx.shape`
+ Supose a, idx_i and idx_j is a np.array, if `idx_i.shape == idx_j.shape`, then `a[i,j].shape ==  idx_i.shape`, idx_i is the first axis index of array a, idx_j is the second axis index of array a. 
   ```python
list_ij=[i,j]
a[list_ij] == a[i,j] # this statement is true
```

3. Indexing with Boolean Arrays
   ```python
   >>> a = np.arange(12).reshape(3,4)
   >>> b = a > 4
   >>> b                                          # b is a boolean with a's shape
array([[False, False, False, False],
       [False,  True,  True,  True],
       [ True,  True,  True,  True]], dtype=bool)
   >>> a[b]                                       # 1d array with the selected elements
array([ 5,  6,  7,  8,  9, 10, 11])
   >>> a[b]=0
   >>> a
array([[0, 1, 2, 3],
       [4, 0, 0, 0],
       [0, 0, 0, 0]])
```
Note that a[b] is a 1d array! But a[b]=0 is a 2d array! This is because if you don't assign a value to the 'False' element, there is no value for that element.


#### 数据添加与拷贝
+ `c=a.copy`深拷贝
+ vstack和hstack函数：
vstack、hstack是==深拷贝==
   ```python
   >>> a = np.ones((2,2))
   >>> b = np.eye(2)
   >>> print np.vstack((a,b))
[[ 1.  1.]
 [ 1.  1.]
 [ 1.  0.]
 [ 0.  1.]]
```

+ `row_stack(matrix,a_row)` 向二维矩阵尾部添加一行

#### numpy.linalg
   ```python
   >>> import numpy.linalg as nplg
   >>> a = np.array([[1,0],[2,3]])
   >>> print nplg.eig(a)
(array([ 3.,  1.]), array([[ 0.        ,  0.70710678],
       [ 1.        , -0.70710678]]))
```

#### comparison
+ a == b #逐个元素比较
+ a < 2
+ `np.array_equal(a,b)`

#### arithmetic operation
+ \+, \-, \*, / #element-wise
+ np.dot(a,b) # matrix multiply

#### I/O
+ np.save('myarray',a)
+ np.savez('myarray.npz',a,b)
+ np.save('myarray.npy',a)
+ np.loadtxt/savetxt/genfromtxt


