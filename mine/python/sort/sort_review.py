#coding:utf-8

import sys
import time
import random

# maopao
def msort0(mlist):
    # n = len(mlist)
    # for i in range(n-1):
    #     change = False
    #     for j in range(n-1-i):
    #         if mlist[j] > mlist[j+1]:
    #             mlist[j], mlist[j+1] = mlist[j+1], mlist[j]
    #             change = True
    #     if not change:
    #         break
    return mlist

# xuanze
def msort1(mlist):
    # n = len(mlist)
    # for i in range(n-1):
    #     max_idx = 0
    #     for j in range(n-i):
    #         if mlist[j] > mlist[max_idx]:
    #             max_idx = j
    #     mlist[max_idx], mlist[n-1-i] = mlist[n-1-i], mlist[max_idx]
    return mlist

# charu
def msort2(mlist):
    # n = len(mlist)
    # for i in range(1, n):
    #     tmp = mlist[i]
    #     j = i
    #     while j > 0 and mlist[j-1] > tmp:
    #         mlist[j] = mlist[j-1]
    #         j -= 1
    #     mlist[j] = tmp
    return mlist

# binggui
def msort3(mlist):
#     if len(mlist) <= 1:
#         return mlist
#     n = len(mlist)
#     mid = n // 2
#     left = mlist[:mid]
#     right = mlist[mid:]
#     return merge(msort3(left), msort3(right))
#
# def merge(left, right):
#     i = 0
#     j = 0
#     result = []
#     while i < len(left) and j < len(right):
#         if left[i] < right[j]:
#             result.append(left[i])
#             i += 1
#         else:
#             result.append(right[j])
#             j += 1
#     result += left[i:]
#     result += right[j:]
    return result

# dui
def msort4(mlist):
    return mlist

# kuaisu
def msort5(mlist):
    n = len(mlist)
    if n <= 1:
        return mlist
    less = []
    more = []
    tmp = mlist.pop()
    for x in mlist:
        if x < tmp:
            less.append(x)
        else:
            more.append(x)
    return msort5(less) + [tmp] + msort5(more)

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