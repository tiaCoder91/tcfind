#!/bin/bash

ENTRY_PATH="$1"
echo "ENTRY_PATH = $ENTRY_PATH"


LAST_DIR=""
ARR_ENTRY_DIR=()
# Passerà all'interno delle directory e le sotto directory
forward() {
   current_dir="$1"
   while [[ -n "$current_dir" ]] ; do
       
        cd "$current_dir"
        echo "======================================="
        echo "ENTRATA in $PWD"
        ls

        sleep 0.5
    
        IFS="/"
        arr_dir=( $(echo "$(ls -F)" | grep "/" | xargs) )     # Crea l'array con la lista delle nuove directory 
        current_dir=$(echo "${arr_dir[0]}" | sed 's/^ //g')
        echo "current_dir = $current_dir"

        if (( "${#arr_dir[@]}" > 1 )) ; then
           LAST_DIR="$PWD"
           ARR_ENTRY_DIR+=( "$PWD@" )
           echo "Multiple directory found."
        elif (( ${#arr_dir[@]} == 1 )) ; then
           ARR_ENTRY_DIR+=( "$PWD*" )
           echo "One directory found."
           else
              ARR_ENTRY_DIR+=( "$PWD?" )
              echo "No directory found."
        fi

   done
}

backwards() {
    echo "LAST_DIR = $LAST_DIR"
    for f_dir in "${ARR_ENTRY_DIR[@]}" ; do
        sleep 0.5
        echo "f_dir = $f_dir"
        last_char="${f_dir:$((${#f_dir}-1)):1}"
        if [[ "$last_char" == "@" ]] ; then
           forward "${f_dir:0:$((${#f_dir}-1))}"
           echo "Path con directory multiple."
        elif [[ "$last_char" == "*" ]] ; then
           echo "Path con una sola directory."
        elif [[ "$last_char" == "?" ]] ; then
           echo "Path senza directory."
        fi
    done
}

forward "$ENTRY_PATH"

echo "ARR_ENTRY_DIR = ${ARR_ENTRY_DIR[@]}"

backwards "${ARR_ENTRY_DIR[@]}"

