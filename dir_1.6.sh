#!/bin/bash

# =============================================================== DESCRIPTION ============================================================
#
#   Questo programma prende come input una directory, lista tutte le sue sottodirectory e le salva in ARR_PATH
#   
#
# ========================================================================================================================================

# Controllo dei parametri in entrata
print="null"
arr_command=("$@")
for ((i = 0; i < ${#@}; i++)) ; do

    if [[ "${arr_command[$i]}" == "-p" ]] ; then       # Parametro per stampare tutti i file e directory trovate
        print="print"
    elif [[ "${arr_command[$i]}" == "-pr" ]] ; then
        print="printERemove"
    elif [[ "${arr_command[$i]}" == "-r" ]] ; then
        print="remove"
    fi

    if [[ "${arr_command[$i]}" == "-dir" ]] ; then     # Parametro per la ricerca nella directory e nelle sotto directory
        ENTRY_PATH="${arr_command[$i+1]}"
    fi

done

echo "ENTRY_PATH = $ENTRY_PATH"

<<com
if [[ "$1" =~ ^[a-zA-Z1-9_-.]+$ ]] ; then
    ENTRY_PATH="$PWD/$1"                     # Aggiunge PWD nel caso ci sia solo il nome della directory
else
    ENTRY_PATH="$1"                        # Path completa senza PWD
fi
com

# Listare la prima directory e salvare le path con le directory
ARR_PATH=()
CLEAN_ARR_PATH=()
listing() {

    # Dipende da l'input iniziale ( o la directory o la path ) più aggiornamento path con nuova directory da ciclo while 
    path="$1" 

    IFS="/"

    # Update con le nuove directory
    ARR_DIR=( $(echo "$(ls -F "$path")" | grep "/" | xargs) )

    for dir in "${ARR_DIR[@]}" ; do
        dir=$(echo "$dir" | sed 's/^ //g')
        #echo "dir = .$dir."


        # Aggiornamento array con nuova path assemblata con "$path = old directory / $dir = new directory"
        ARR_PATH+=( "$path/$dir" ) 
    done
}

removeDuplicates() {

rd="$HOME/Desktop/removeDuplicates.txt"
dup="$HOME/Desktop/duplicates.txt"
clean_path="$HOME/Desktop/clean_path.txt"

if [[ -e "$rd" ]] ; then
   rm "$rd"
fi

if [[ -e "$dup" ]] ; then
   rm "$dup"
fi

if [[ -e "$clean_path" ]] ; then
   rm "$clean_path"
fi


    for (( i=0 ; i < "${#ARR_PATH[@]}" ; i++ )) ; do
    stop="no"
        #printf "\n===========================================\n"
        #echo "1 = ${ARR_PATH[$i]}"
        for (( n=0 ; n < "${#ARR_PATH[@]}" ; n++ )) ; do
            #echo "2 = ${ARR_PATH[$n]}"
            if [[ "${ARR_PATH[$i]}" == "${ARR_PATH[$n]}" ]] ; then
               #echo "***************************************  $found"  
               for (( l=0 ; l < "${#CLEAN_ARR_PATH[@]}" ; l++ )) ; do
                    #echo "CLEAN_ARR_PATH object = ${CLEAN_ARR_PATH[$l]}"
                    if [[ "${ARR_PATH[$i]}" == "${CLEAN_ARR_PATH[$l]}" ]] ; then
                       #echo "Path già presente."
                       stop="yes"
                       #echo "${ARR_PATH[$i]} == ${CLEAN_ARR_PATH[$l]}" >> "$dup"
                       break     
                    fi
               done 
               if [[ "$stop" == "no" ]] ; then
                  CLEAN_ARR_PATH+=( "${ARR_PATH[$i]}" )
                  else
                    break
               fi 
            fi
        done
    done #>> "$rd"


    echo "Path trovate ${#CLEAN_ARR_PATH[@]}" >> "$clean_path"
    for (( i=0 ; i < "${#CLEAN_ARR_PATH[@]}" ; i++ )) ; do
        echo "path = ${CLEAN_ARR_PATH[$i]}" >> "$clean_path"
    done

}

tcdir() {  
# Da la partenza per il salvataggio delle directory perchè per far
#   partire il ciclo ha bisogno di ARR_DIR non vuoto e anche perchè
#   ENTRY_PATH verrà usato solo una volta come input iniziale 
ARR_PATH+=( "$ENTRY_PATH" )
listing "$ENTRY_PATH"

# Finche ARR_DIR non è vuoto aggiorna, con listing l'array, la path assemblata con la super path e salva tutto in ARR_PATH 
while [[ -n "${ARR_DIR[@]}" ]] ; do
    for (( i=0 ; i < "${#ARR_PATH[@]}" ; i++ )) ; do              # ARR_PATH è l'aggiornamento dell'array delle path con o_path
        echo "ARR_PATH[i] = ${ARR_PATH[$i]}  &&  next = $i && lenght = ${#ARR_PATH[@]}"
        #i=$((${#ARR_PATH[@]}-1))
        listing "${ARR_PATH[$i]}"
    done
done

removeDuplicates

}

data="$HOME/Desktop/${BASH_SOURCE[0]%.${BASH_SOURCE##*.}}.txt"
found_path="$HOME/Desktop/found_path.txt"
removeDataEFoundPathTcdir() {
    if [[ -e "$data" ]] ; then
      rm "$data"
    fi

    if [[ -e "$found_path" ]] ; then
       rm "$found_path"
    fi
}

printFoundPath() {
    # La quantità di directory trovate
    echo "Path found = ${#ARR_PATH[@]}" >> "$found_path"

    # Stampa in found_path tutte le directory trovate
    for n_path in "${ARR_PATH[@]}" ; do
        echo "n_path = $n_path"
    done >> "$found_path"
}

# ================================================================ PROGRAMMA ======================================================================

tcdir


if [[ "$print" == "print" ]] ; then
   printFoundPath
elif [[ "$print" == "printERemove" ]] ; then
   removeDataEFoundPathTcdir
   printFoundPath
elif [[ "$print" == "remove" ]] ; then
   removeDataEFoundPathTcdir
fi


<<com
# Verifica se le path sono delle directory
i=0
for nn_path in "${ARR_PATH[@]}" ; do
    echo ""
    echo "=============================================="
    if [[ -d "$nn_path" ]] ; then
       i=$(($i+1))
       echo "nn_path = $nn_path with list ${#ARR_PATH[@]} to $i"
    fi
done
com