#!/bin/bash

arrDir=("File" "documenti" "scrivania" "ultimi" "Preventivi" "Nuovi Preventivi" "Vecchi Preventivi" "Immagini")
name="img"
ext="png"

i=0
for dir in "${arrDir[@]}" ; do
echo "0"
echo "$dir" " - ${arrDir[0]}"
    if [[ "$dir" == "${arrDir[0]}" ]] ; then
    echo "1"
      mkdir "$dir"
    i=$(($i+1))
    elif [[ "$dir" != "${arrDir[0]}" ]] ; then
    echo "2"
        if [[ $i == 1 ]] ; then
          cd "${arrDir[0]}"
        fi
        mkdir "$dir"

        n=1
        cd "$dir"
        while [[ $n -le 10 ]] ; do
            touch "$name$n.$ext"
            echo "n = $n"
            n=$(($n+1))
        done
        cd ..
        i=$(($i+1))
    fi
done

<<ecc
n=0
while [ $n -le 10 ] ; do
    echo "n = $n"
    ((n++))
done
ecc