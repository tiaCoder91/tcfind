#!/bin/bash

# =============================================================== DESCRIPTION ============================================================
#
#   Questo programma prende come input una directory, lista tutte le sue sottodirectory e le salva in ARR_PATH
#   
#
# ========================================================================================================================================

data="$HOME/Desktop/${BASH_SOURCE[0]%.${BASH_SOURCE##*.}}.txt"
found_path="$HOME/Desktop/found_path.txt"

if [[ -e "$data" ]] ; then
  rm "$data"
fi

if [[ -e "$found_path" ]] ; then
  rm "$found_path"
fi

if [[ "$1" =~ ^[a-zA-Z1-9_-.]+$ ]] ; then
   ENTRY_PATH="$PWD/$1"                     # Aggiunge PWD nel caso ci sia solo il nome della directory
   else
     ENTRY_PATH="$1"                        # Path completa senza PWD
fi
echo "ENTRY_PATH = $ENTRY_PATH"


ARR_PATH=()
# Listare la prima directory e salvare le path con le directory
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


tcdir() {  
# Da la partenza per il salvataggio delle directory perchè per far
#   partire il ciclo ha bisogno di ARR_DIR non vuoto e anche perchè
#   ENTRY_PATH verrà usato solo una volta come input iniziale 
ARR_PATH+=( "$ENTRY_PATH" )
listing "$ENTRY_PATH"

# Finche ARR_DIR non è vuoto aggiorna, con listing l'array, la path assemblata con la super path e salva tutto in ARR_PATH 
while [[ -n "${ARR_DIR[@]}" ]] ; do
    for (( i=0 ; i < "${#ARR_PATH[@]}" ; i++ )) ; do              # ARR_PATH è l'aggiornamento dell'array delle path con o_path
        o_path="${ARR_PATH[$i]}"
        #echo "o_path = $o_path  &&  i = $i"
        listing "$o_path"                                         # o_path es.: "Dir1 &/Dir2" "Dir1 &/Dir3 copia" oppure path completa
    done
done #>> "$data"
}


printFoundPath() {
    # La quantità di directory trovate
    echo "Path found = ${#ARR_PATH[@]}" >> "$found_path"

    # Stampa in found_path tutte le directory trovate
    for n_path in "${ARR_PATH[@]}" ; do
        echo "n_path = $n_path"
    done >> "$found_path"
}


#tcdir
#printFoundPath


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