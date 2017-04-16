#!/bin/bash -

SOTER_PATH="/home/cooli7wa/workshop/workshop_new/src/mtk6757_evb/soter"
#SOTER_PATH="/mnt/hgfs/E/微可信/microtrust/soter"
PKG_PATH=$SOTER_PATH/src/l4/pkg

TARGET_AA=$PKG_PATH/gatekeeper/inner_gatekeeper/Makefile

# 位于第一层循环中的lib
makefile_requires_libs=(`grep "REQUIRES_LIBS" $TARGET_AA | sed "s/^[ \t]*#*REQUIRES_LIBS *+\?= *//g"`)
# 总libs,防止多重包含
total_requires_libs=(`echo ${makefile_requires_libs[@]}`)
echo ${total_requires_libs[@]}
#set -x

layer=1
# 查找传入的lib所依赖的不在当前lib列表里的libs
# @param 1: lib
# @return 0: normal
#	      1: not find target lib
#	      2: not find requires lib
function find_lib
{
	local grep_result
	local lib_makefile
	local i
	local j
	local same_lib=0
	# 用TAB来格式化layer输出
	for ((i=0; i<$layer; i++))
	do
		echo -n "	"
	done
	cd $PKG_PATH
	# 查找TARGET
	grep_result=`grep -r "TARGET[ 	]*=.*[	 ]$1.so"`
	# 提取makefile名
	lib_makefile=`echo "$grep_result" | grep -oP "^.*(?=:)"`
#	echo $lib_makefile
	if [ -z $lib_makefile ];then
		# 如果没找到PKG，那么红色打印LIB名
		echo -e "\033[31m$1\033[0m"
		return 1
	else 
		# 如果已经找到PKG，那么绿色打印LIB名
		echo -e "\033[32m$1\033[0m"
		# 提取需求Lib列表
		local lib_requires_libs=(`grep "^[^#]*REQUIRES_LIBS" $lib_makefile | sed "s/^[ \t]*REQUIRES_LIBS *+\?= *//g"`)
#		echo ${lib_requires_libs[@]}
		if [ -z $lib_requires_libs ];then
#			echo -e "\033[031m not find requires in $1\033[0m"
			return 2
		else
			for ((i=0; i<${#lib_requires_libs[@]}; i++))
			do
#				echo "$i ${lib_requires_libs[$i]}"
				for ((j=0; j<${#total_requires_libs[@]}; j++))
				do
					if [ z${lib_requires_libs[$i]} == z${total_requires_libs[$j]} ];then
#						echo same lib
						same_lib=1
						break 1
					fi
				done
				if [ $same_lib -ne 1 ];then
#					echo new lib
					total_requires_libs[$((j+1))]=${lib_requires_libs[$i]}
#					echo ${total_requires_libs[@]}
					((layer++))
					find_lib ${lib_requires_libs[$i]}
					((layer--))
				fi
				same_lib=0
			done
		fi
	fi

}

for lib in ${makefile_requires_libs[@]}
do
	find_lib $lib
done
