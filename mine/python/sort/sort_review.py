#coding:utf-8

import sys
import time
import random

# maopao
def msort0(mlist):
    return mlist

# xuanze
def msort1(mlist):
    return mlist

# charu
def msort2(mlist):
    return mlist

# binggui
def msort3(mlist):
    return mlist

# dui
def msort4(mlist):
    return mlist

# kuaisu
def msort5(mlist):
    return mlist


ori_list = random.sample(range(9999), 9999)
for i in range(6):
    func_name = 'msort%d' % i
    print('== cur_func: %s =='%func_name)
    mlist = ori_list[:]
    ts = time.time()
    result = eval(func_name)(mlist)
    te = time.time()
    print(result)
    print(te-ts)