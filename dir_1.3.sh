#!/bin/bash

#. tcfind_1.3.sh > /dev/null 2>&1

func1() {
   echo ""
   echo "Entrata in $1"
}

func2() {
   echo "2"
}

MYPATH="$1"
data="$HOME/Desktop/dir_1.3.txt"

if [[ -e "$data" ]] ; then
   rm "$data"
fi

echo "$MYPATH"

entrate=0
last_multiple_dir=""
while [[ -n "$MYPATH" ]] ; do    # Questo ciclo per adesso fa le entrate nelle directory

    cd "$MYPATH"
    entrate=$(($entrate+1))

    sleep 1
    func1 "$PWD"
    
    IFS="/"
    arr_dir=( $(echo "$(ls -F)" | grep "/" | xargs) )
    MYPATH=$(echo "${arr_dir[0]}" | sed 's/^ //g')
    
    echo ".$MYPATH. entrate = $entrate"
    echo "arr_dir = ${arr_dir[@]}  lenght = ${#arr_dir[@]}"

    for dir in "${arr_dir[@]}" ; do
      dir=$(echo "$dir" | sed 's/^ //g')
      echo "$dir"
    done

    if (( ${#arr_dir[@]} > 1 )) ; then
       echo "Multiple directory found."
       last_multiple_dir="$PWD"
       elif (( ${#arr_dir[@]} == 0 )) ; then
           echo "No directory found."
         else
           echo "One directory found."
    fi

    if [[ -z "$MYPATH" ]] ; then
       echo "***********************************"
    fi

    #sleep 1
    #func2
done  

uscite=0
while (( $uscite < $entrate-1 )) ; do     # Questo ciclo per adesso fa le uscite a seconda di quante entrate a fatto in precedenza
    sleep 1
    func1 "$PWD"

    uscite=$(($uscite+1))
    echo "uscite = $uscite"

    cd ..
    ls
    
done


