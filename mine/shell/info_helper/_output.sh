#!/bin/bash -

# $1 source_file

# convert str to array
# $1 str
# $2 separator
# $3 out_var name
function str_to_array
{
	local str=$1
	local separator=$2
	local out_var=$3
	local rr='($str)'
	local ORI_IFS=$IFS

	IFS="$separator"
	eval "$out_var=$rr"
	IFS="$ORI_IFS"
}


# $1: col array
# $2: out_var name
function cal_max_len
{
	local array=$1
	local out_var=$2
	local max=0
	local s=''
	local n=0
	local ORI_IFS=$IFS

	# Line maybe contain space,
	# so modify IFS to ensure split correct
	# Can't use "echo $array | while read s"
	# because this will start a subshell
	IFS='
	'
	for s in $array
	do
		n=${#s}
		if [ $n -gt $max ]; then
			max=$n
		fi
	done
	IFS=$ORI_IFS
	eval $out_var=$max
}

# output table line
# +---+---+
# $1: length array
function output_table
{
	local array=$1
	local out_str=''
	local len=0
	local pad_len=0
	local i=0

	out_str+='+'
	for len in $array
	do
		pad_len=$len+2*$PAD_LEN
		for ((i=0; i<$pad_len; i++))
		do
			out_str+='-'
		done
		out_str+='+'
	done
	echo $out_str
}

# output context line
# |TA_Name |UUID |
# $1: context array
# $2: length array
# $3: enable color

function output_context
{
	local context_str=$1
	# ensure context_array is a local var
	local context_array=()
	local length_array=($2)
	local enable_color=$3
	local out_str=''
	local n=0
	local i=0
	local j=0
	local space=" "
	local pad_str=""

	str_to_array "$context_str" ":" "context_array"

	for ((i=0; i<$PAD_LEN; i++))
	do
		pad_str+=$space
	done

	out_str+='|'
	for ((i=0; i<${#context_array[@]}; i++))
	do
		out_str+=$pad_str
		n=$((${length_array[$i]}-${#context_array[$i]}))
		out_str+=${context_array[$i]}
		for ((j=0; j<$n; j++))
		do
			out_str+=$space
		done
		out_str+=$pad_str
		out_str+='|'
	done
	if [ $enable_color == 0 ]; then
		echo "$out_str"
		return
	fi
	if [ $color == 1 ]; then
		echo -e "\033[36m$out_str\033[0m"
		color=0
	else
		echo -e "\033[35m$out_str\033[0m"
		color=1
	fi
}


TITLE_LINE=`head -1 $1`
str_to_array "$TITLE_LINE" ":" "TITLES"
COL_NUM=${#TITLES[@]}
ROW_NUM=`sed -n '$ =' $1`
CONTEXT_ROW_NUM=$((ROW_NUM-1))

# calculate each col's max length
MAX_LEN=()
for ((i=1; i<=$COL_NUM; i++))
do
	max_len=0
	col_array=`cat $1 | cut -d : -f $i`
	cal_max_len "$col_array" "max_len"
	MAX_LEN[$i]=$max_len
done

# begin to output table
color=0
PAD_LEN=1
output_table "${MAX_LEN[*]}"
output_context "$TITLE_LINE" "${MAX_LEN[*]}" 0
output_table "${MAX_LEN[*]}"
for ((i=2; i<=$ROW_NUM; i++))
do
	output_context "`sed -n ${i}p $1`" "${MAX_LEN[*]}" 1
done
output_table "${MAX_LEN[*]}"
