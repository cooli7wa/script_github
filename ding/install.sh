#!/bin/bash -
to_file="$HOME/.bashrc"
from_file=""
bak_file="$HOME/.bashrc.bak.`date +\%Y_\%m_\%d_\%H_\%M_\%S`"
tmp_file="./ding_install_bashrc.tmp"
tmp_file1="./ding_install_bashrc.tmp1"
#==== del old funcs ====
func_list=(
		"__ding_cmd"
		"__ding_cmd_HUB"
		"ding"
		"dingl"
		"dingd"
		"2ding"
)
from_file=`find ding_* | sort -r | head -1`
echo "install: $from_file"
cp $to_file $bak_file
cp $to_file $tmp_file
sed -i "/^DING_FILE_PATH/d" $tmp_file
sed -i "/^complete -F __ding_cmd_HUB/d" $tmp_file

function del_func
{
	func="function $1"
	awk 'BEGIN{str="'"$func"'"; eprint=1}
		{
			if($0==str) { 
				eprint=0;
			}
			if(eprint)
				print;
			if(eprint == 0 && $0 == "}") {
				eprint=1;
			}
		}' $tmp_file > $tmp_file1
}

for func in ${func_list[@]}
do
	del_func $func
	mv $tmp_file1 $tmp_file
done
mv $tmp_file $to_file
#==== copy new funcs ====
cat $from_file >> $to_file
