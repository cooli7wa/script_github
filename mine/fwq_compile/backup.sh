#!/bin/bash -
from_file="$HOME/.bashrc"
to_file="./fwq_compile"
func_list=(
    "fwq"
    "_fwq_rm_folder"
	"_fwq_umount_rm_folder"
	"_fwq_create_folder"
	"_fwq_mount_folder"
	"_fwq_clean_folder"
	"_fwq_make_folder"
	"_fwq_post_flow"
	"fwq_mount"
)
alias_list=(
)
echo "backup: $from_file"

#==== clean to_file ====
> $to_file

#==== backup complete ====

#==== backup alias ====
for ali in ${alias_list[@]}
do
	grep "alias $ali" >> $to_file
done

#==== backup funcs ====
function backup_func
{
    func="function $1"
	awk 'BEGIN{str="'"$func"'";a=0; eprint=0}
	{
		if($0==str){
			eprint=1;
		}
		if(eprint)
			print;
		if(eprint==1){
			if($0~/.*\{.*/){
				a++;
			}
			if($0~/.*\}.*/){
				a--;
				if(a==0){
					eprint=0;
				}
			}
		}
	}' $from_file >> $to_file
}

for func in ${func_list[@]}
do
    backup_func $func
done
