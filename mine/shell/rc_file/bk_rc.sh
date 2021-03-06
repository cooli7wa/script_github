#!/bin/bash -

bk_files=(
	~/.bashrc
	~/.vimrc
	~/.inputrc
)

bk_fold=`pwd`

for file in ${bk_files[@]}
do
	cp $file $bk_fold/`echo $file | grep -o "[^\/]\+$" | tr -d "^."`
done
echo -e "\033[032mcp bk_files to $bk_fold, ok\033[0m"

#echo -e "\033[032mbegin to add changes to git\033[0m"
#cd $bk_fold
#git add ./
#git commit -m "update bk_files"
#git push origin master
#if [ $? -eq 0 ];then
#	echo -e "\033[032mgit ok\033[0m"
#fi
