#!/bin/bash

# Elimina lo / finale alle directory
IFS="/"

# Preleva tutte le directory nella directory corrente con ls -F, togli lo / con grep e toglie l 0a con xargs
arr_dir=( $(echo "$(ls -F $1)" | grep "/" | xargs) )
absolute_path="$PWD/$1"
cd "$1"
echo "${arr_dir[@]}"

# Entra nelle prime directory ( l'input iniziale = $1 = es.: /Users/tia/Desktop )
for ((i = 0; i < "${#arr_dir[@]}"; i++)) ; do
    # Preleva una directory alla volta e con sed toglie lo spazio iniziale 
    dir="$(echo "${arr_dir[$i]}" | sed 's/^ //g')"
    echo "absolute_path = $absolute_path"
    echo "PWD = $PWD"
    echo "$i - .$dir."
    if ls -F | grep "/" &> /dev/null ; then
        new_dir=( $(echo "$(ls -F $dir)" | grep "/" | xargs) )
        if [[ -n "${new_dir[@]}" ]] ; then
            echo "====== Directory trovate ======="
            echo "new_dir = ${new_dir[@]} --> $dir"
            for d in "${new_dir[@]}" ; do
                n_d="$(echo "$d" | sed 's/^ //g')"
                echo "n_d = $n_d --> $dir"
            done
        fi
    fi
done

<<com
for ((i = 1; i < 11; i++)) ; do
   echo "$i"
   if (( $i == 1 )) ; then
      dir1="Dir$i"
      mkdir "$dir1"
      elif (( $i == 2 )) ; then
         cd "$dir1"
   fi
   if (( $i < 6 && $i > 1 )) ; then
      mkdir "Dir$i"
   fi

   if (( $i >= 6 && $i < 8 )) ; then
      if (( $i == 6 )) ; then
        cd "Dir2"
      fi
      mkdir "Dir$i"
      if (( $i == 7 )) ; then
        cd "Dir$i"
        n=0
        while (( $n < 3 )) ; do
            mkdir "SubDir$n"
            n=$(($n+1))
        done
        cd ..
      fi
   fi

   if (( $i >= 8 && $i < 11 )) ; then
      if (( $i == 8 )) ; then
        cd ..
        cd "Dir5"
      fi
      mkdir "Dir$i"
   fi

   if (( $i == 10 )) ; then
      cd "Dir10"
      n=0
      while (( $n < 3 )) ; do
          mkdir "SubDir$n"
          n=$(($n+1))
      done
   fi
done
com