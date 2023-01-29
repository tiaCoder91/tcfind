#!/bin/bash

path="$HOME/Desktop/Dir1"

# Salva le directory trovate con la path di entrata in new_arr
checkDir() {
  new_arr=()
  IFS="/"

  arr_dir=( $(echo "$(ls -F "$1")" | grep "/" | xargs) )
  #echo "${arr_dir[@]}"

  for dir in "${arr_dir[@]}" ; do
      dir=$(echo "$dir" | sed 's/^ //g')
      #echo "$dir"
      new_arr+=( "$dir" )
  done

#echo "${new_arr[@]}"
}

checkDir "$path"
cd "$path"
echo "${new_arr[@]}"

old_arr=( "${new_arr[@]}" )
i=0

for old in "${old_arr[@]}" ; do
i=$(($i+1))
   checkDir "$old"

   echo "Entrata in \"$old\""
   cd "$old"

   #ls
   echo "$old --> ${new_arr[@]}"
   
   cd ..
   echo "Uscita in \"$old\""

   if (( $i == ${#old_arr[@]} )) ; then
      echo "$i == ${#old_arr[@]}"
   fi

done
