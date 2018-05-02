#coding:utf-8

import sys
import time
import random


# binggui, O(nlogn), O(n)
# def msort(seq):
#     if len(seq) <= 1:
#         return seq
#     mid = len(seq) // 2
#     left = msort(seq[:mid])
#     right = msort(seq[mid:])
#     return merge(left, right)
#
# def merge(left, right):
#     result = []
#     i, j = 0, 0
#     while i < len(left) and j < len(right):
#         if left[i] <= right[j]:
#             result.append(left[i])
#             i += 1
#         else:
#             result.append(right[j])
#             j += 1
#     result += left[i:]
#     result += right[i:]
#     return result

# dui, O(nlogn), O(1)
# def msort(lst):
#     def sift_down(start, end):
#         root = start
#         while True:
#             child = 2 * root + 1
#             if child > end:
#                 break
#             if child + 1 <= end and lst[child] < lst[child + 1]:
#                 child += 1
#             if lst[root] < lst[child]:
#                 lst[root], lst[child] = lst[child], lst[root]
#                 root = child
#             else:
#                 break
#     for start in range((len(lst) - 2) // 2, -1, -1):
#         sift_down(start, len(lst) - 1)
#     for end in range(len(lst) - 1, 0, -1):
#         lst[0], lst[end] = lst[end], lst[0]
#         sift_down(0, end - 1)
#     return lst


# kuaisu, O(nlogn~n^2), O(logn~n)
# def msort(mlist):
#     if len(mlist) <= 1:
#         return mlist
#     less = []
#     greater = []
#     base = mlist.pop()
#     for x in mlist:
#         if x < base:
#             less.append(x)
#         else:
#             greater.append(x)
#     return msort(less) + [base] + msort(greater)


# maopao1, O(n^2), O(1)
# def msort(mlist):
#     n = len(mlist)
#     for i in range(n-1):
#         change = False
#         for j in range(n-i-1):
#             if mlist[j] < mlist[j+1]:
#                 mlist[j], mlist[j+1] = mlist[j+1], mlist[j]
#                 change = True
#         if not change:
#             break
#     return mlist

# maopao2, O(n^2), O(1)
# def msort(mlist):
#     n = len(mlist)
#     for i in range(n-1):
#         change = False
#         idx = n-i-1
#         for j in range(idx):
#             if mlist[j] < mlist[j+1]:
#                 mlist[j], mlist[j+1] = mlist[j+1], mlist[j]
#                 change = True
#                 idx = j
#         if not change:
#             break
#     return mlist

# xuanze, O(n^2), O(1)
# def msort(mlist):
#     n = len(mlist)
#     for i in range(n-1):
#         max_idx = 0
#         for j in range(n-i):
#             if mlist[j] > mlist[max_idx]:
#                 max_idx = j
#         mlist[n-i-1], mlist[max_idx] = mlist[max_idx], mlist[n-i-1]
#     return mlist

# charu, O(n^2), O(1)
# def msort(mlist):
#     n = len(mlist)
#     for i in range(1, n):
#         tmp = mlist[i]
#         j = i
#         while j > 0 and mlist[j-1] > tmp:
#             mlist[j] = mlist[j-1]
#             j -= 1
#         mlist[j] = tmp
#     return mlist

mlist = random.sample(range(9999), 9999)
# mlist = [3,2,1,4,5]
ts = time.time()
result = msort(mlist)
te = time.time()
print(result)
print(te-ts)
