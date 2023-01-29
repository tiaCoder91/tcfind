#!/bin/bash

data="$HOME/Desktop/data.txt"
if [[ -e "$data" ]] ; then
   rm "$data"
fi

# Controllo dei parametri in entrata
arr_command=("$@")
for ((i = 0; i < ${#@}; i++)) ; do
    
    if [[ "${arr_command[$i]}" == "-ext" ]] ; then
        ext="${arr_command[$i+1]}"
        echo "ext = $ext"
    fi

    if [[ "${arr_command[$i]}" == "-name" ]] ; then
        name="${arr_command[$i+1]}"
        echo "name = $name"
    fi

    if [[ "${arr_command[$i]}" == "-dir" ]] ; then
        entry_dir="${arr_command[$i+1]}"
        echo "entry_dir = $entry_dir"
        if [[ -d "$entry_dir" ]] ; then
           cd "$entry_dir"
           else
              entry_dir="$PWD"
        fi
    fi

done

arr_file=$(ls -F)

echo "$arr_file = arr_file ( è una stringa )"

# Formattazione della stringa con puntatore finale nella variabile save_hex ( è una stringa, non è un esadacimale )
for ((i = 0; i < ${#arr_file}; i++)) ; do
    echo "${arr_file:$i:1}"
    echo -n "${arr_file:$i:1}" | xxd -p  

    char_hex=$(echo -n "${arr_file:$i:1}" | xxd -p)

    if [[ "$char_hex" == "0a" ]] ; then
        echo "ok !!!"
        echo "$save_hex"
        for ((n = 0; n < "${#save_hex}"; n++)) ; do
           echo "${save_hex:$n:1}"
           echo "$(($n+1)) - ${#save_hex}"
            if (( $n+1 == ${#save_hex} )) ; then
               echo "FINALE !!!"
               if [[ "${save_hex:$n:1}" == "*" || "${save_hex:$n:1}" == "/" || "${save_hex:$n:1}" == "|" ]] ; then
                  echo "pass!!!"
                  else
                     save_hex+="¬"
                     break
               fi
            fi
        done
           else 
               save_hex+="${arr_file:$i:1}"
    fi

    arr_bit+=$(echo -n "${arr_file:$i:1}" | xxd -p)

    if (( $i+1 == ${#arr_file} )) ; then
        #for ((n = 0; n < "${#save_hex}"; n++)) ; do
           #echo "${save_hex:$n:1}"
           #echo "$(($n+1)) - ${#save_hex}"
            if (( $i+1 == ${#save_hex} )) ; then   # $n+1 vecchio dato
               echo "FINALE !!!"
               if [[ "${save_hex:$n:1}" == "*" || "${save_hex:$n:1}" == "/" || "${save_hex:$n:1}" == "|" ]] ; then
                  echo "pass!!!"
                  else
                     save_hex+="¬"
                     break
               fi
            fi
        #done
        echo "save_hex = $save_hex"
    fi
done

#echo "***** $arr_bit = arr_bit *****"

directory=()
eseguibili=()
altri_file=()
pipe_file=()

# Distinzione tra file e directory con salvataggio dati in array, divisi per tipologia ( es.: directory = "dir1" "dir 2", ecc... )
for ((i = 0; i < "${#save_hex}"; i++)) ; do
    echo "save_hex = ${save_hex:$i:1}"
    if [[ "${save_hex:$i:1}" == "/" ]] ; then
       directory+=("$distr")
       distr=""
    elif [[ "${save_hex:$i:1}" == "*" ]] ; then
       eseguibili+=("$distr")
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

echo "================= Seconda parte del programma ====================="

echo "directory = ${directory[@]}"
echo "eseguibili = ${eseguibili[@]}"
echo "altri_file = ${altri_file[@]}"
echo "pipe_file = ${pipe_file[@]}"

echo "================= FILE =====================  $PWD" >> "$HOME/Desktop/data.txt"

# Questo prende l'array dei file e fa il riconoscimento dei file in base all'estensione
for file in "${altri_file[@]}" ; do
    echo "* file = $file" >> "$HOME/Desktop/data.txt"

    ext_file="${file##*.}"
    echo "  - file extension = $ext_file" >> "$HOME/Desktop/data.txt"
    
    name_file="${file%.${file##*.}}"
    echo "  - file name = $name_file" >> "$HOME/Desktop/data.txt"
    
    # Qui ci andrà il 
done

echo "================= DIRECTORY ====================="

# - Il ciclo che dovrà far parte della ricerca dei file e delle directory dovrà:
#    - al primo passaggio dovrà cercare tutti i FILE nelle directory di partenza ( entrata directory - salvataggio file - uscita directory )
#    - al secondo passaggio dovrà entrare nella prima directory, controllare se sono presenti directory e fare il ciclo 
#      del salvataggio dei file

for dir in "${directory[@]}" ; do
    echo ".$dir."
    if [[ -d "$dir" ]] ; then
       cd "$dir"
       echo " -- $dir = ENTRATA ***********  $PWD" >> "$HOME/Desktop/data.txt"
       ls >> "$HOME/Desktop/data.txt"
       echo " -- $dir = USCITA *************  $PWD" >> "$HOME/Desktop/data.txt"
       cd .. 
    fi
done

<<com
# ======================= SIMPLE FIFO =======================
    FIFO="myfifo"
    if [[ ! -e "$FIFO" ]] ; then
        mkfifo "$FIFO" 
    fi
    echo "$file" > $FIFO &
com

<<com
# ?????????????????????  PER ORA NON VIENE USATO  ???????????????????????
for ((i = 0; i < ${#arr_bit}; i++)) ; do
    echo "$i = ${arr_bit:$i:1}"
done  
com

<<com
# =============== REPEAT FILE WITH FIFO ================  ( ps.: Dopo che viene letto il fifo cancella il contenuto ( dal sistema ) per la prossima scrittura )
FIFO="myfifo"

if [ ! -e "$FIFO" ]; then
    mkfifo "$FIFO"
fi

echo "0" > $FIFO &

while read count ; do
    echo $count
    save=$count
done < "$FIFO"

echo "------ $save"

if (( $save == 1 )) ; then
   echo "Stop"
   rm $FIFO
   else
     rm $FIFO 
     mkfifo  $FIFO
     save=$(($save+1))
     echo $save > $FIFO &
     echo "================================= RINVIO ================================"
     $HOME/Desktop/tcfind_1.2.sh
fi
com