#!/bin/bash


#### Una Funzione che ritorna un array con le directory e come input la path o la directory

MYPATH="$HOME/Desktop/Dir1"

# Salva le directory trovate con la path di input in NEWARR
checkDir() {
  NEWARR=()
  IFS="/"

  arr_dir=( $(echo "$(ls -F "$1")" | grep "/" | xargs) )
  #echo "${arr_dir[@]}"

  for dir in "${arr_dir[@]}" ; do
      dir=$(echo "$dir" | sed 's/^ //g')
      #echo "$dir"
      NEWARR+=( "$dir" )
  done

#echo "${NEWARR[@]}"
}

printNewArr() {
# Stampa le directory salvate
for (( i = 0 ; i < ${#NEWARR[@]}; i++)) ; do
    if (( $i == 0 )) ; then
      printf "NEWARR = \"${NEWARR[$i]}\""
        else
           printf " \"${NEWARR[$i]}\""
    fi
done
echo ""
}

# Ho preso le directory della prima path
checkDir "$MYPATH"
cd "$MYPATH"

# Passa le directory salvate
for n_dir in "${NEWARR[@]}" ; do
   echo "n_dir = $n_dir"
   checkDir "$n_dir"
   printNewArr
done

echo "1"

# Passa le directory salvate
for n_dir in "${NEWARR[@]}" ; do
   echo "n_dir = $n_dir"
   checkDir "$n_dir"
   printNewArr
done

echo "2"

#### Due Funzioni che ripetono l'entrata nella directory finche non trova più directory
