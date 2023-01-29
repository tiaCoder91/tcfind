#!/bin/bash

. dir_1.6.sh > /dev/null 2>&1
#. tcfind_1.3.sh

tcdir
printFoundPath

for n_path in "${ARR_PATH[@]}" ; do
    echo "n_path = $n_path"
    #bash tcfind_1.3.sh -dir "$n_path"  
done
