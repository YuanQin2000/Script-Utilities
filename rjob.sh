#!/bin/bash

function file_job()
{
	#add you code here

	#demo code
	for file in $*
	do
		if [ -f $file ]; then
#			if [ $file = cam_dantes_*.loc ]; then
#				cat $file $work_dir/face.txt > "$file.new"
			if [ $file = cam_dantes_*.loc.new ]; then
				origin=${file%.*}
				echo $origin
				mv $file $origin
			fi
#			sed s/ZZZZ/AAAA/g $file > "$file.new"
		elif [ -d $file ]; then
			echo "Process in delete file"
			rm -rf $file/*.new
		else
			echo "$file is ERROR!!!"
		fi
	done
}

function dir_job()
{
	#demo code
	wc -l $1/*.h $1/*.cpp $1/*.inl $1/*.mmp $1/*.rss $1/*.inf $1/*.hrh $1/*.rh
}

function usage()
{
	echo "Usage: $0 (-d|-f) filename"
}

function retrive_files()
{
	for file in $*
	do
		if [ -d $file ]; then
			pushd "$PWD" 1>/dev/null
			cd "$file"
			retrive_files $(ls)
			popd 1>/dev/null
		else
			file_job $file
		fi
	done
}

function retrive_dirs()
{
	for file in $*
	do
		if [ -d $file ]; then
			dir_job $file
			pushd "$PWD" 1>/dev/null
			cd "$file"
			retrive_dirs $(ls)
			popd 1>/dev/null
		fi
	done
}

work_dir=$PWD

while getopts "df" opt
do
	case $opt in
	d)
		shift $(($OPTIND-1))
		retrive_dirs $*
		;;
	f)
		shift $(($OPTIND-1))
		retrive_files $*
		;;
	?)
		usage
		;;
	esac
done
