#!/bin/bash -
from_file="$HOME/.bashrc"
to_file="ding_"
tmp_file="./ding_update.tmp"
version=""
func_list=(
		"__ding_cmd"
		"__ding_cmd_HUB"
		"ding"
		"2ding"
)
#查找当前.bashrc中新的ding的version，作为文件名一部分
grep "Version" ~/.bashrc | head -1 | sed "s/^.*Version //g" | sed "s/\"//g" > $tmp_file
version=`cat $tmp_file`
rm $tmp_file
to_file="$to_file$version"
echo -e "update to: $to_file"
#开始写文件
#写入DING_FILE_PATH
grep "^complete -F __ding_cmd_HUB" $from_file > $to_file

function find_func
{
	func="function $1"
	awk 'BEGIN{str="'"$func"'"; eprint=0}
		{
			if($0==str) { 
				eprint=1;
			}
			if(eprint)
				print;
			if(eprint == 1 && $0 == "}") {
				eprint=0;
			}
		}' $from_file >> $to_file
}

for func in ${func_list[@]}
do
	find_func $func
done
