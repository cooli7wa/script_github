#!/bin/bash -
NAME="vcmd"
to_file="$HOME/.bashrc"
from_file="./$NAME"
bak_file="$HOME/.bashrc.bak.`date +\%Y_\%m_\%d_\%H_\%M_\%S`"
tmp_file="./"$NAME"_install_bashrc.tmp"
tmp_file1="./"$NAME"_install_bashrc.tmp1"
func_list=(
    "$NAME"
)
echo "install: $from_file"
cp $to_file $bak_file
cp $to_file $tmp_file

#==== del complete ====
sed -i "/complete -c $NAME/d" $tmp_file

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

