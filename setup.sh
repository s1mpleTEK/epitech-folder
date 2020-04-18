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
USERNAME=`git config --global github.user`
EMAIL=`git config --global github.email`
BLIH=`git config --global blih.email`
PWD=`git config --global epitech-folder.pwd `pwd``
ID=""
ID_LEN=""

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
    echo "This is a shell script to set up run.sh"
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
function setup_email_b()
{
    echo "Your current Epitech email on your computer: $BLIH"
    if [[ $BLIH == "" ]]; then
        read -p "What is it your Epitech email ? " ANWSER
        git config --global blih.email "$ANWSER"
        BLIH=`git config --global blih.email`
        echo "Your new current Epitech email on your computer: $BLIH"
    fi
    read -p "Is it your good Epitech email ? (y/n) " ANWSER
    case $ANWSER in
        y | Y)
            ;;
        n | N)
            read -p "What is it your Epitech email ? " ANWSER
            git config --global blih.email "$ANWSER"
            echo "Your new current Epitech email on your computer: $BLIH"
            ;;
        *)
            echo "syntax error: not correct anwser"
            setup_email_b
            ;;
    esac
    return 0
}
##################################################

####################TIER S_g######################
function setup_user_g()
{
    echo "Your current Github username on your computer: $USERNAME"
    if [[ $USERNAME == "" ]]; then
        read -p "What is it your Github username ? " ANWSER
        git config --global github.user "$ANWSER"
        USERNAME=`git config --global github.user`
        echo "Your new current Github username on your computer: $USERNAME"
    fi
    read -p "Is it your good Github user ? (y/n) " ANWSER
    case $ANWSER in
        y | Y)
            ;;
        n | N)
            read -p "What is it your Github username ? " ANWSER
            git config --global github.user "$ANWSER"
            USERNAME=`git config --global github.user`
            echo "Your new current Github username on your computer: $USERNAME"
            ;;
        *)
            echo "syntax error: not correct anwser"
            setup_user_g
            ;;
    esac
    return 0
}

function setup_email_g()
{
    echo "Your current Github public email on your computer: $EMAIL"
    if [[ $EMAIL == "" ]]; then
        echo "Please wait ..."
        curl -f -u $USERNAME https://api.github.com/users/$USERNAME >> .id_output
        if [ $? -ne 0 ];then
            rm .id_output
            echo "error: github.email not found"
            echo "info: run 'git config --global github.email <<github user id>+<username>@users.noreply.github.com>'"
            exit 1
        fi
        ID=`grep -E '"id": ' ./.id_output`
        read var1 var2 <<< $ID
        ID=$var2
        rm ./.id_output
        echo "$ID" >> .id_output
        ID_LEN=${#ID}
        let "ID_LEN = $ID_LEN - 1"
        ID=`cut -b -$ID_LEN .id_output`
        rm .id_output
        git config --global github.email "$ID+$USERNAME@users.noreply.github.com"
        EMAIL=`git config --global github.email`
        echo "Your new current Github public email on your computer: $EMAIL"
    fi
    return 0
}
##################################################

####################TIER M########################
function main()
{
    echo "SETUP START"
    error "$@"
    if [ $HELP -eq 1 ]; then
        help
        echo "SETUP FINISH"
        return 0
    fi
    setup_user_g
    setup_email_g
    setup_email_b
    echo "SETUP FINISH"
    return 0
}
##################################################

################################################################################################

#######################################PROGRAM START############################################

main "$@"

################################################################################################