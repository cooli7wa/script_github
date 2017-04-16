#!/bin/bash -

SOTER_PATH="/home/cooli7wa/workshop/workshop_new/src/mtk6757_evb/soter"
PKG_PATH=$SOTER_PATH/src/l4/pkg

TARGET_AA=$PKG_PATH/gatekeeper/inner_gatekeeper/Makefile

total_requires_libs=(`grep "REQUIRES_LIBS" $TARGET_AA | sed "s/^[ \t]*#*REQUIRES_LIBS *+\?= *//g"`)

# 查找传入的lib所依赖的不在当前lib列表里的libs
# @param 1: lib
function find_lib
{
	local grep_result
	local lib_makefile
	local i
	cd $PKG_PATH
	grep_result=`grep -r "TARGET *=.* $1.so" `
	if [ ! -z "$grep_result" ];then
		lib_makefile=`echo $grep_result | sed "s/:.*$//"`
		echo $lib_makefile
		local lib_requires_libs=(`grep "REQUIRES_LIBS" $lib_makefile | sed "s/^[ \t]*#*REQUIRES_LIBS *+\?= *//g"`)
		echo ${lib_requires_libs[10]}
		for(( i=0;i<${#lib_requires_libs[@]};i++ ))
		do
			echo $${lib_requires_libs[0]}
		done
	fi
}

find_lib "libuTfs"
