#!/bin/bash
# Setting -e in bash script will cause the script to exit if any commands return a non-zero exit status (error)
set -e
rm -fr signatures && mkdir signatures
rm -fr with_parameter_names && mkdir with_parameter_names

# Using FD instead of find. FD is a simple, fast and user-friendly alternative to find.  
# In this script, FD is being used to find all files named "metadata.json"
# The results are then piped into the parallel command where these files are processed using the process-file.sh script
# The {} placeholder is replaced by the current input line (null character separated)
for chain in $(cat DORA_CHAIN_LIST);
do
    echo "==== PULLING RESULTS FOR $chain ===="
    if fd -t d "^$chain$" ../sourcify-snapshot -Iq; 
    then
        time fd "metadata.json" "../sourcify-snapshot/latest/repository/contracts/full_match/$chain" -0 | parallel -0 --bar ./process-file.sh {} \;
    else
        echo "!!!!! NO DATA FOR CHAIN ID: $chain !!!!!"
    fi
done

# Find all files in the './with_parameter_names' directory
# The results are then piped through a series of commands
echo "==== PROCESSING ALL SIGNATURES ===="
time fd . -t f with_parameter_names -0 | parallel -0 --bar sort {} "|" uniq -c "|" sort -nr "|" sort -u -t '!' -k2,2 "|" sort -nr "|" sed "'s/^ *[0-9]\{1,\} //'" "|" sed "'s/\!.*$//'" "|" tr "\"\n\"" "';'" "|" sed "'s/.$//'" "|" sponge {};
