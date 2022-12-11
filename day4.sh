#!/bin/bash
input="input/day4.in"
resSubtask1=0
resSubtask2=0
while IFS= read -r line; do
    line1=$(echo $line | cut -d "," -f 1)
    line2=$(echo $line | cut -d "," -f 2)
    a=$(echo $line1 | cut -d "-" -f 1)
    b=$(echo $line1 | cut -d "-" -f 2)
    c=$(echo $line2 | cut -d "-" -f 1)
    d=$(echo $line2 | cut -d "-" -f 2)

    if [[ $a -le $c  && $b -ge $d ]] || [[ $c -le $a  && $d -ge $b ]]; then
        resSubtask1=$(( $resSubtask1+1 ))
    fi

    if ! [[ $b -lt $c || $a -gt $d ]]; then
        resSubtask2=$(( $resSubtask2+1 ))
    fi

done < "$input"
echo "$resSubtask1 $resSubtask2"