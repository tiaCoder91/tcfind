#!/bin/bash

# =============================================================== DESCRIPTION ============================================================
#
#   Questo programma suddivide i file e le directory negli appositi array = ( directory, eseguibili, altri_file, pipe_file = fifo )
#   
#
# ========================================================================================================================================

entry_dir="null"
ext="null"
name="null"
print="null"

# ======================================================= INPUT ============================================================================

# Controllo dei parametri in entrata
arr_command=("$@")
for ((i = 0; i < ${#@}; i++)) ; do
    if [[ "${arr_command[$i]}" == "-ext" ]] ; then     # Parametro per la ricerca in base all'estensione
        ext="${arr_command[$i+1]}"
    fi

    if [[ "${arr_command[$i]}" == "-name" ]] ; then    # Parametro per la ricerca in base al nome del file
        name="${arr_command[$i+1]}"
    fi
    
    if [[ "${arr_command[$i]}" == "-dir" ]] ; then     # Parametro per la ricerca nella directory e nelle sotto directory
        entry_dir="${arr_command[$i+1]}"
    fi
    
    if [[ "${arr_command[$i]}" == "-p" ]] ; then       # Parametro per stampare tutti i file e directory trovate
        print="print"
    elif [[ "${arr_command[$i]}" == "-pr" ]] ; then
        print="printERemove"
    elif [[ "${arr_command[$i]}" == "-r" ]] ; then
        print="remove"
    fi

    if [[ -d "$entry_dir" ]] ; then   # Nel caso ci fosse dolo il nome della directory
        cd "$entry_dir"
        entry_dir="$PWD"              # Reset di $entry_dir dopo l'entrata nella directory ( es.: $entry_dir = $PWD = /Users/tia/Desktop/File = -dir File )
    fi

done

#echo "directory = $entry_dir"
#echo "name = $name"
#echo "estensione = $ext"

# ======================================================= FUNZIONI ============================================================================

# Aggiunge un puntatore finale quando l'ultimo non è presente e lo inserisce in altri file
addPointerToList() {

    # Stringa della lista della directory corrente
    if [[ -n "$1" ]] ; then
       string_ls=$(ls -F "$1")
       else
          string_ls=$(ls -F)
    fi

    #echo "$string_ls = string_ls"

    # Formattazione della stringa con puntatore finale nella variabile save_with_point
    for ((i = 0; i < ${#string_ls}; i++)) ; do
        #echo "${string_ls:$i:1}"
        #echo -n "${string_ls:$i:1}" | xxd -p  

        char_hex=$(echo -n "${string_ls:$i:1}" | xxd -p)

        if [[ "$char_hex" == "0a" ]] ; then
            #echo "ok !!!"
            #echo "$save_with_point"
            for ((n = 0; n < "${#save_with_point}"; n++)) ; do
                #echo "${save_with_point:$n:1}"
                #echo "$(($n+1)) - ${#save_with_point}"
                if (( $n+1 == ${#save_with_point} )) ; then
                   #echo "FINALE !!!"
                    if [[ "${save_with_point:$n:1}" == "*" || "${save_with_point:$n:1}" == "/" || "${save_with_point:$n:1}" == "|" ]] ; then
                        #echo "pass"
                        break
                    else
                        save_with_point+="¬"
                        break
                    fi
                fi
            done
        else 
            save_with_point+="${string_ls:$i:1}"          # *******  Salvataggio caratteri  **********
    fi

    if (( $i+1 == ${#string_ls} )) ; then                    # Controllo dell'ultimo carattere nel finale del ciclo iniziale
        for ((n = 0; n < "${#save_with_point}"; n++)) ; do
            #echo "${save_with_point:$n:1}"
            #echo "$(($n+1)) - ${#save_with_point}"
            if (( $n+1 == ${#save_with_point} )) ; then 
                #echo "FINALE !!!"
                if [[ "${save_with_point:$n:1}" == "*" || "${save_with_point:$n:1}" == "/" || "${save_with_point:$n:1}" == "|" ]] ; then
                   #echo "pass"
                   break
                   else
                       save_with_point+="¬"
                       break
                fi
            fi
        done
        #echo "save_with_point = $save_with_point"
    fi
done

echo "$save_with_point"

}


# Ripartiziona i file nell'array corretto ( eseguibile -> altri_file )
sortFile() {
    file="$1"
    arr_file_ext=( "pages" "pdf" )
    for ext in "${arr_file_ext}" ; do
        if [[ "${file##*.}" == "$ext" ]] ; then
           #echo "${file##*.} is equal $ext ( smista )"
           echo "1"
           else
               echo "0"      
        fi
    done
}


# Partiziona i dati negli appositi array.  
#  FATTO { Manca una parte del programma che prima del salvatggio riconosce il file per tipo di estensione } !!!!!
partition() {
    directory=()
    eseguibili=()
    altri_file=()
    pipe_file=()

    # Distinzione tra file e directory con salvataggio dati in array, divisi per tipologia ( es.: directory = "dir1" "dir 2", ecc... )
    save_hex="$1"
    for ((i = 0; i < "${#save_hex}"; i++)) ; do
        #echo "save_hex = ${save_hex:$i:1}"
        if [[ "${save_hex:$i:1}" == "/" ]] ; then
           directory+=("$distr")
           distr=""
        elif [[ "${save_hex:$i:1}" == "*" ]] ; then
           sort=$(sortFile "$distr")
           # Questo blocco ripartiziona i file negli array corretti
           if [[ "$sort" == "0" ]] ; then
              eseguibili+=("$distr")
              elif [[ "$sort" == "1" ]] ; then
                  altri_file+=("$distr")    
           fi
           distr=""
        elif [[ "${save_hex:$i:1}" == "¬" ]] ; then
           altri_file+=("$distr")
           distr=""
        elif [[ "${save_hex:$i:1}" == "|" ]] ; then
           pipe_file+=("$distr")
           distr=""
        else
          distr+="${save_hex:$i:1}"   
        fi
    done
}


removeDataTcfind() {
  if [[ -e "$data" ]] ; then
     rm "$data"
  fi
}


# Stampa tutti i risultati nel data.txt dopo che i dati sono stati riconosciuti da partition()
data="$HOME/Desktop/${BASH_SOURCE[0]%.${BASH_SOURCE##*.}}.txt" 
printDataTcfind() {
   printf "\n PATH = $entry_dir \n========= Lista ============\nlist = $1\n\n" >> "$data"
   for string in "${directory[@]}" ; do
       echo "directory = $string" >> "$data"
   done
   for string in "${eseguibili[@]}" ; do
       echo "eseguibili = $string" >> "$data"
   done
   for string in "${altri_file[@]}" ; do
       echo "altri_file = $string" >> "$data"
   done
   for string in "${pipe_file[@]}" ; do
       echo "pipe_file = $string" >> "$data"
   done
}

# ======================================================= PROGRAMMA ============================================================================



if [[ "$entry_dir" != "null" ]] ; then
    list=$(addPointerToList "$entry_dir")
else
    list=$(addPointerToList)
fi

partition "$list"

if [[ "$print" == "print" ]] ; then
   printDataTcfind "$list"
elif [[ "$print" == "printERemove" ]] ; then
   removeDataTcfind
   printDataTcfind "$list"
elif [[ "$print" == "remove" ]] ; then
   removeDataTcfind
fi
