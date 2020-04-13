#!/bin/bash

##
## GITHUB PROJECT, 2020
## s1mpleTEK
## Description:
## Make your own repository with the pickups BLIH and/or SARA
##

##########################################VARIABLEs#############################################

LANGUAGE="en"
DEBUG=0
HELP=0
cmd=('-h' '--help' '-d' '--debug' '-dh' '-hd' '--help--debug' '--debug--help')

################################################################################################

###########################################DEBUG CHECK##########################################

for i in "$@"; do
    case $i in
        ${cmd[2]} | ${cmd[3]})
            DEBUG=1
            ;;
        ${cmd[4]} | ${cmd[5]})
            DEBUG=1
            ;;
        ${cmd[6]} | ${cmd[7]})
            DEBUG=1
            ;;
    esac
done

################################################################################################

###########################################FUNCTIONS############################################

function help()
{
    if [ $DEBUG -eq 1 ]; then
        echo "/*Enter in help function*/"
    fi
    if [ $LANGUAGE == "en" ]; then
        cat ./en/help
    fi
    if [ $DEBUG -eq 1 ]; then
        echo "/*Return help function: 0*/"
    fi

    return 0
}

function error()
{
    if [ $DEBUG -eq 1 ]; then
        echo "/*Enter in error function*/"
    fi
    if [ $# -gt 2 ]; then
        echo "error: too many arguments: $#"
        if [ $DEBUG -eq 1 ]; then
        echo "/*Exit error function: 1*/"
        fi
        exit 1
    fi
    for i in "$@"; do
        if [[ $i == ${cmd[0]} || $i == ${cmd[1]} ]]; then
            HELP=1
        elif [[ $i == ${cmd[4]} || $i == ${cmd[5]} ]]; then
            HELP=1
        elif [[ $i == ${cmd[6]} || $i == ${cmd[7]} ]]; then
            HELP=1
        else
            case $i in
                ${cmd[2]} | ${cmd[3]} | ${cmd[4]} | ${cmd[5]} | ${cmd[6]} | ${cmd[7]})
                    ;;
                *)
                    echo "error: unknown option: $i"
                    if [ $DEBUG -eq 1 ]; then
                    echo "/*Exit error function: 1*/"
                    fi
                    exit 1
                    ;;
            esac
        fi
    done
    if [ $DEBUG -eq 1 ]; then
        echo "/*Return error function: 0*/"
    fi
    return 0
}

function main()
{
    if [ $DEBUG -eq 1 ]; then
        echo "/*Language: $LANGUAGE*/"
        echo "/*Number of arguments: $#*/"
        echo "/*Enter in main function*/"
    fi
    error "$@"
    if [ $HELP -eq 1 ]; then
        help
        if [ $DEBUG -eq 1 ]; then
            echo "/*Return main function: 0*/"
        fi
        return 0
    fi
    if [ $DEBUG -eq 1 ]; then
        echo "/*Return main function: 0*/"
    fi
    return 0
}

################################################################################################

#########################################PROGRAM START##########################################

main "$@"

################################################################################################