#!/bin/bash

dir=($(ls -F))

echo ${dir[@]} "1"

IFS=""

for ((i = 0; i < ${#dir[@]}; i++)) ; do
    #printf "$i\n"
    #if [[ "${dir[$i]}" =~ ^[A-Za-z0-9_%+-/]+$ ]] ; then # ^[A-Za-z0-9_%+-]+\.[a-zA-Z]{1,2}$
       #echo "${dir[$i]} - $i"
    #fi
    printf "${dir[$i]} - $i\n"
done

<<zzz
for jpg in ${dir[*]}
do
    echo "${jpg}"
done
zzz

<<com
FILES=("2011-09-04 21.43.02.jpg"
       "2011-09-05 10.23.14.jpg"
       "2011-09-09 12.31.16.jpg"
       "2011-09-11 08.43.12.jpg")
IFS="-. "
for jpg in ${FILES[*]}
do
    printf "${jpg}\n"
done
com
