#!/bin/bash

##
## GITHUB PROJECT, 2020
## s1mpleTEK
## Description:
## Setup your computer for run.sh
##

##########################################VARIABLEs#############################################

HELP=0
cmd=('-h' '--help')

################################################################################################

###########################################FUNCTIONS############################################

######################TIER HE############################
function help()
{
    echo "USAGE"
    echo "    ./setup.sh"
    echo -e "\nCOMMAND\n"
    echo "    -h, --help       Help for use setup.sh"
    echo -e "\nDESCRIPTION\n"
    echo "    This is a shell script to reset your Github username, public email and Blih email from your computer"
    return 0
}

function error()
{
    if [ $# -gt 1 ]; then
        echo "error: too many arguments: $#"
        exit 1
    fi
    for i in "$@"; do
        case $i in
            ${cmd[0]} | ${cmd[1]})
                HELP=1
                ;;
            *)
                echo "error: $i: command not found"
                echo "info: run with -h or --help"
                exit 1
                ;;
        esac
    done
    return 0
}
##################################################

####################TIER S_b######################
function reset_email_b()
{
    git config --global blih.email ""
    echo "Your Blih email has been remove from your computer"
    return 0
}
##################################################

####################TIER S_g######################
function reset_user_g()
{
    git config --global github.user ""
    echo "Your Github username has been remove from your computer"
    return 0
}

function reset_email_g()
{
    git config --global github.email ""
    echo "Your Github public email has been remove from your computer"
    return 0
}
##################################################

####################TIER M########################
function main()
{
    echo "RESET START"
    error "$@"
    if [ $HELP -eq 1 ]; then
        help
        echo "RESET FINISH"
        return 0
    fi
    git config --global epitech-folder.pwd ""
    git config --global blih.name ""
    reset_user_g
    reset_email_g
    reset_email_b
    echo "RESET FINISH"
    return 0
}
##################################################

################################################################################################

#######################################PROGRAM START############################################

main "$@"

################################################################################################