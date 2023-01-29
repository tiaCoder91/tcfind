#!/bin/bash

research() {
IFS="/"
arr=( $(echo "$(ls -F $1)" | grep "/" | xargs) )
echo "${arr[@]}"

for ((i = 0; i < "${#arr[@]}"; i++)) ; do
    var=$(echo "${arr[$i]}" | xargs | sed 's/^ //g')
    echo "$i - .$var."

    cd "$var"
    if ls -F | grep "/" ; then
        echo "=========== $var ==========="
    fi
    cd ..
    echo "============ USCITA in RESEARCH ============"
done
}

IFS="/"
arr=( $(echo "$(ls -F $1)" | grep "/" | xargs) )
echo "${arr[@]}"

for ((i = 0; i < "${#arr[@]}"; i++)) ; do
    var=$(echo "${arr[$i]}" | xargs | sed 's/^ //g')
    echo "$i - .$var."

    cd "$var"
    if ls -F | grep "/" ; then
        echo "=========== $var ==========="
        research
    fi
    echo "============ USCITA da fuori ============"
    cd ..
done
  

# Adesso da qui in poi dovrò creargli il ciclo che dovrà fare l'entrata
#   in tutte le sottodirectory
