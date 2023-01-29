#!/bin/bash

. dir_1.6.sh -dir "$1" -pr
. tcfind_1.3.sh -r

for n_path in "${CLEAN_ARR_PATH[@]}" ; do
    echo "n_path = $n_path"
    bash tcfind_1.3.sh -dir "$n_path" -p
done