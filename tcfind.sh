#!/bin/bash

dir=$(ls)

echo $dir "1"

arr=( "Mattia" "come" "va" )

i=0

for str in "${arr[@]}" ; do
   printf "$i - $str\n"
   i=$(($i+1))
done

echo ""

i=0

for strDir in "$dir" ; do
#printf "$strDir\n"
  if [[ "${strDir}" =~ ^[A-Za-z0-9_-]+$ ]] ; then # ^[A-Za-z0-9_%+-]+\.[a-zA-Z]{1,2}$
    printf "$strDir - $i\n"
    #cd $strDir
    #echo $(ls)
    i=$(($i+1))
  fi
done

<<com
while [ true ] ; do
  echo "ok"
done
com