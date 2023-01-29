#!/bin/bash

dir=$(ls -F)

echo "${dir}" "1"

# Ad ogni / salva la stringa in un array che indica una directory e scarta gli eseguibili *
## Qui ho usato le substring per fargli il salvataggio delle directory
for ((i = 0; i < ${#dir}; i++)) ; do
    printf "${dir:$i:1} - $i\n"
    dir_s+="${dir:$i:1}"

    # Scarta le stringhe che finiscono con * che sarebbero gli eseguibili
    if [[ ${dir:$i:1} == "*" ]] ; then
       dir_s=""
    fi
    # Qui avviene il riconoscimento della directory
    if [[ ${dir:$i:1} == "/" ]] ; then
       echo "fine linea !!! = ${dir_s}"
       arr_dir+=("$dir_s")                # SALVATAGGIO DIRECTORY CON / !!!!
       dir_s=""
    fi
done

echo ${arr_dir[@]}

# Rimuove il primo space se è presente
for ((i = 0; i < ${#arr_dir[@]}; i++)) ; do
    myVar=$(echo "${arr_dir[$i]}" | xargs | sed 's/^ //g')
    echo ".${myVar}."
    arr_with+=("${myVar}")
done

echo ${arr_with[@]} " = arr_with"


# Questo ciclo deve fare in modo di entrare nelle directory e uscire sempre tenendo il conteggio 
#   dell'entrate perchè mi servirà dopo per il ritorno.
echo "================== PARTENZA ======================="
i=0
entrate=0
while [[ $i < ${#arr_with[@]} ]] ; do

   # Toglie lo / alla stringa delle directory
   r_dir="${arr_with[$i]:0:${#arr_with[$i]}-1}"

   # Salva le directory iniziali in un array
   r_arr+=("$r_dir")

   echo " --  $r_dir" "***************  ENTRATA  ********** $i ***********"
   
   cd "$r_dir"                  # Dovrebbe ripetere il ciclo di salvataggio delle directory nuove
   entrare=$(($entrate+1))
   ls 

   echo "***************  USCITA  *********** $i ***********"
   #cd ..
   #ls

   i=$(($i+1))
done

echo "${r_arr[@]}  = r_arr"

for d_str in "${r_arr[@]}" ; do
    echo "$d_str  = d_str"
done
