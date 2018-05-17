## patch的问题

patch命令可以将来自于源文件的改修，同步到目标文件中。

patch命令会根据patch文件的上下文信息，在目标文件中找到合适的位置，插入patch。

但是如果源文件和目标文件的上下文有些差别，那么经常会遇到patch失败的情况。

比如原文件和patch如下：

```
# a.c
aa
bb
cc
# b.c
aa
bb
dd
cc
# patch文件diff.patch（diff -U10 a.c b.c > diff.patch）
--- a.c 2018-05-14 16:33:23.133303425 +0800
+++ b.c 2018-05-14 16:33:51.484964501 +0800
@@ -1,3 +1,4 @@
 aa
 bb
+dd
 cc
```

比如将a.c改成下面这样，看看还能否成功：

```
# a.c
aa

bb

cc

# 运行提示
>> patching file a.c
>> Hunk #1 succeeded at 1 with fuzz 2.

# 打完patch的a.c
aa

dd
bb

cc
```

可以看到，本应该在bb后面的dd，现在跑到bb前面去了

其实这种情况，在我们使用patch的时候，经常遇到，因为源文件和目标文件有些空行区别是很正常的事情

再比如下面这种情况，在bb和cc后面，各加了一个空格，然后在bb前面插入了一些空行：

```
# a.c， bb和cc后面各加了一个空格
aa


bb 
cc 

# 运行结果
patching file a.c
Hunk #1 succeeded at 1 with fuzz 2.

# 打完patch的a.c
a

dd

bb 
cc 
```

可以看到，这样打得也不对

这种情况也经常出现，patch同样处理不了这种情况。

但是其实上述的情况都应该是可以避免的，毕竟实际代码没有什么本质的区别。

下面提供一种思路，效果很不错。

## 一种思路

既然这些空格和空行，都不是我们关心的，而且对代码逻辑也没有实际的影响，那么我们就可以想办法忽略掉他们的影响，找到真正的插入patch的位置。

