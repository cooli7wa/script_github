#!/bin/bash -
to_file="$HOME/.bashrc"
from_file="./goto"
bak_file="$HOME/.bashrc.bak.`date +\%Y_\%m_\%d_\%H_\%M_\%S`"
tmp_file="./goto_install_bashrc.tmp"
tmp_file1="./goto_install_bashrc.tmp1"
func_list=(
    "goto"
	"__goto_cmd"
	"__goto_cmd_HUB"
)
alias_list=(
)
echo "install: $from_file"
cp $to_file $bak_file
cp $to_file $tmp_file

#==== del complete ====
sed -i "/complete -F __goto_cmd_HUB goto/d" $tmp_file

#==== del old alias ====
for ali in ${alias_list[@]}
do
	sed -i "/alias $ali/d" $tmp_file
done

#==== del old funcs ====
function del_func
{
    func="function $1"
	awk 'BEGIN{str="'"$func"'";a=0; eprint=1}
	{
		if($0==str){
			eprint=0;
		}
		if(eprint)
			print;
		if(eprint==0){
			if($0~/.*\{.*/){
				a++;
			}
			if($0~/.*\}.*/){
				a--;
				if(a==0){
					eprint=1;
				}
			}
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

