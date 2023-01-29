#!/bin/bash

ENTRY_PATH="$1"
echo "ENTRY_PATH = $ENTRY_PATH"


ARR_MUL=()
entryDir() {
current_dir="$1"

    while [[ -n "$current_dir" ]] ; do
        
        cd "$current_dir"
        echo "======================================="
        echo "ENTRATA in $PWD"
        ls

        sleep 1
    
        IFS="/"
        arr_dir=( $(echo "$(ls -F)" | grep "/" | xargs) )     # Crea l'array con la lista della nuova directory 
        current_dir=$(echo "${arr_dir[0]}" | sed 's/^ //g')
        echo "current_dir = $current_dir"

        if (( ${#arr_dir[@]} > 1 )) ; then      # Questo è l'aggiornamento 
           echo "Multiple directory found."
           ARR_MUL+=( "$PWD" )
           # Da correggere ?????????????????????????????????????????
           # Questo salva 
           for (( i=0 ; i < "${#arr_dir[@]}" ; i++ )) ; do    
               n_dir=$(echo "${arr_dir[$i]}" | sed 's/^ //g')
               echo "dir = .$n_dir."
               if [[ "$current_dir" == "$n_dir" ]] ; then
                  ENTRY_PATH="$PWD/"
                  ENTRY_PATH+=$(echo "${arr_dir[$i+1]}" | sed 's/^ //g')
               fi
           done
           # ???????????????????????????????????????????????????????????
        elif (( ${#arr_dir[@]} == 1 )) ; then
           echo "One directory found."
           else
              echo "No directory found."
        fi

    done

}

start() {
entryDir "$ENTRY_PATH" 

echo "*******************************"
echo "ENTRY_PATH = $ENTRY_PATH"

entryDir "$ENTRY_PATH"

echo "ARR_MUL = ${ARR_MUL[@]}"
}

start >> "$HOME/Desktop/data.txt"