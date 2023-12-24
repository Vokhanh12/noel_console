#!/bin/bash

trap "tput reset; tput cnorm; exit" 2
clear
tput civis
lin=2
col=$(($(tput cols) / 2))
c=$((col-1))
est=$((c-2))
color=0
tput setaf 2; tput bold




function noel() {

    # Tree
    for ((i=1; i<20; i+=2))
    {
        tput cup $lin $col
        for ((j=1; j<=i; j++))
        {
            echo -n \*
        }
        let lin++
        let col--
    }
    
    tput sgr0; tput setaf 3
    
    # Trunk
    for ((i=1; i<=2; i++))
    {
        tput cup $((lin++)) $c
        echo 'mWm'
    }
    new_year=$(date +'%Y')
    let new_year++
    tput setaf 1; tput bold 
    tput cup $lin $((c - 4)); echo ⟏     ⬓       ⧆ 
    tput cup $((lin + 1)) $((c - 7)); echo ⧇   ⧈    ⬓
    let c++
    k=1
    
    # Lights and decorations
    while true; do
        for ((i=1; i<=35; i++)) {
            # Turn off the lights
            [ $k -gt 1 ] && {
                tput setaf 2; tput bold
                tput cup ${line[$[k-1]$i]} ${column[$[k-1]$i]}; echo \*
                unset line[$[k-1]$i]; unset column[$[k-1]$i]  # Array cleanup
            }
    
            li=$((RANDOM % 9 + 3))
            start=$((c-li+2))
            co=$((RANDOM % (li-2) * 2 + 1 + start))
            tput setaf $color; tput bold   # Switch colors
            tput cup $li $co
            echo o
            line[$k$i]=$li
            column[$k$i]=$co
            color=$(((color+1)%8))
            # Flashing text
            sh=1
            for l in G I Á N G - S I N H - V U I - V Ẻ 
            do
                tput cup $((lin+1)) $((c+sh))
                echo $l
                let sh++
                sleep 0.05
            done
        }
        k=$((k % 2 + 1))
    done

}


LINES=$(tput lines)
COLUMNS=$(tput cols)
TIME=0

declare -A snowflakes
declare -A lastflakes

clear

function move_flake() {
    i="$1"

    if [ "${snowflakes[$i]}" = "" ] || [ "${snowflakes[$i]}" = "$LINES" ]; then
        snowflakes[$i]=0
    else
        if [ "${lastflakes[$i]}" != "" ]; then
            printf "\033[%s;%sH \033[1;1H " ${lastflakes[$i]} $i
        fi
    fi

    printf "\033[%s;%sH\u274$[($RANDOM%6)+3]\033[1;1H" ${snowflakes[$i]} $i

    lastflakes[$i]=${snowflakes[$i]}
    snowflakes[$i]=$((${snowflakes[$i]}+1))
}

while :
do
        
    i=$(($RANDOM % $COLUMNS))

    move_flake $i 

    for x in "${!lastflakes[@]}"
    do
        move_flake "$x" 
    done

    sleep 0.3

    # Check if 5 seconds have passed
    if [ $TIME -eq 5 ]; then
        (noel) &  # Gọi hàm noel trong một subshell
        TIME=0    # Reset the timer
    else
        ((TIME++))  # Increment the timer
    fi
done