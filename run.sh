#!/bin/bash

##
## GITHUB PROJECT, 2020
## s1mpleTEK
## Description:
## Make your own repository with the pickups BLIH and/or SARA
##

##########################################VARIABLEs#############################################

DEBUG=0
HELP=0
cmd=('-h' '--help' '-d' '--debug' '-dh' '-hd' '--help--debug' '--debug--help')
REPOSITORY_NAME=""
USERNAME=""

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
        echo DEBUG: "enter in ${FUNCNAME[0]} function"
    fi
    cat ./help
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function: 0"
    fi

    return 0
}

function error()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
    fi
    if [ $# -gt 2 ]; then
        echo "error: too many arguments: $#"
        if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
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
                    echo "error: $i: command not found"
                    if [ $DEBUG -eq 1 ]; then
                    echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
                    fi
                    exit 1
                    ;;
            esac
        fi
    done
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function: 0"
    fi
    return 0
}

function github_init_repository()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
    fi
    echo "Creating README ..."
    touch $REPOSITORY_NAME/README.md
    echo "README is created"
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function"
    fi
    return 0
}

function github_create_repository()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
    fi
    echo "Creating Github repository '$REPOSITORY_NAME' ..."
    curl -u $USERNAME https://api.github.com/user/repos -d '{"name":"'$REPOSITORY_NAME'"}' 
    curl -u $USERNAME https://api.github.com/repos/$USERNAME/$REPOSITORY_NAME -d '{"private":"'true'"}'
    curl -u $USERNAME https://api.github.com/repos/$USERNAME/$REPOSITORY_NAME/collaborators{/ramassage-tls} -X PUT
    if [ $? -ne 0 ];then
        echo "error: the repository $REPOSITORY_NAME is not created"
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: return ${FUNCNAME[0]} function: 1"
        fi
        return 1
    fi
    echo "The repository $REPOSITORY_NAME is created"
    git clone https://github.com/$USERNAME/$REPOSITORY_NAME.git
    echo "The repository $REPOSITORY_NAME is clonned"
    github_init_repository
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function"
    fi
    return 0
}

function github_repository()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
    fi
    read -p "What is the name of your repository ? " ANWSER
    REPOSITORY_NAME=$ANWSER
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: anwser: $REPOSITORY_NAME"
    fi
    if [ $REPOSITORY_NAME == "" ]; then
        echo "syntax error: this name is not allowed"
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: return ${FUNCNAME[0]} function: 1"
        fi
        return 1
    fi
    github_create_repository
    if [ $? -eq 1 ]; then
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: return ${FUNCNAME[0]} function: 1"
        fi
        return 1
    fi
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function: 0"
    fi
    return 0
}

function github_user()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
        echo "DEBUG: the program ping once github.com"
    fi
    echo "Please wait ..."
    ping -c 1 github.com &> //dev/null
    if [ $? -ne 0 ]; then
        echo "error: github.com is down or you are not connected to a wifi network or you have a bad wifi network"
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: return ${FUNCNAME[0]} function: 1"
        fi
        return 1
    fi
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: github.com is up"
    fi
    read -p "Do you have a Github account ? (y/n) " ANWSER
    local l_ANWSER=$ANWSER
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: anwser: $l_ANWSER"
    fi
    case $l_ANWSER in
        y)
            USERNAME=`git config github.user`
            echo "Your username on Github: $USERNAME"
            if [ $USERNAME == "" ]; then
                echo "error: github.user not found"
                echo "run 'git config --global github.user <username>'"
                if [ $DEBUG -eq 1 ]; then
                    echo "DEBUG: return ${FUNCNAME[0]} function: 1"
                fi
                return 1
            fi
            github_repository
            if [ $? -eq 1 ]; then
                if [ $DEBUG -eq 1 ]; then
                    echo "DEBUG: return ${FUNCNAME[0]} function: 1"
                fi
                return 1
            fi
            ;;
        n)
            xdg-open 'https://github.com/join?source=header-home' &> //dev/null
            ;;
        *)
            echo "syntax error: not correct anwser"
            if [ $DEBUG -eq 1 ]; then
                echo "DEBUG: reload ${FUNCNAME[0]} function"
            fi
            github_user
            ;;
        esac
    if [ $? -eq 1 ]; then
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: return ${FUNCNAME[0]} function: 1"
        fi
        return 1
    fi
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function: 0"
    fi
    return 0
}

function main()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: number of arguments: $#"
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
    fi
    echo "PROGRAM START"
    error "$@"
    if [ $HELP -eq 1 ]; then
        help
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: return ${FUNCNAME[0]} function: 0"
        fi
        return 0
    fi
    github_user
    if [ $? -eq 1 ]; then
        read -p "Do you want to try to create your repository with BLIH ? (y/n) " ANWSER
        local l_ANWSER=$ANWSER
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: anwser: $l_ANWSER"
        fi
        case $l_ANWSER in
            y)
                #blih_user
                ;;
            n | *)
                echo "info: none repository was created"
                echo "PROGRAM FINISH"
                if [ $DEBUG -eq 1 ]; then
                    echo "DEBUG: return ${FUNCNAME[0]} function: 0"
                fi
                return 0
                ;;
        esac
    #else
        #blih_user
    fi
    echo "PROGRAM FINISH"
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function: 0"
    fi
    return 0
}

################################################################################################

#########################################PROGRAM START##########################################

main "$@"

################################################################################################