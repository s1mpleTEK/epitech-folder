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
    echo "USAGE"
    echo "    ./run.sh"
    echo -e "\nCOMMAND\n"
    echo "    -h, --help       Help for use run.sh"
    echo "    -d, --debug      Show debug messages"
    echo -e "\nDESCRIPTION\n"
    echo "This is a shell script for create your own repository, Github and Blih in the same time."
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
        echo "DEBUG: the program ping once https://github.com"
    fi
    echo "Please wait ..."
    ping -c 1 github.com &> //dev/null
    if [ $? -ne 0 ]; then
        echo "error: https://github.com is down or you are not connected to a wifi network or you have a bad wifi network"
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
            if [[ $USERNAME == "" ]]; then
                echo "error: github.user not found"
                echo "run 'git config --global github.user <username>'"
                if [ $DEBUG -eq 1 ]; then
                    echo "DEBUG: return ${FUNCNAME[0]} function: 1"
                fi
                return 1
            fi
            echo "Your username on Github: $USERNAME"
            github_repository
            if [ $? -ne 0 ]; then
                if [ $DEBUG -eq 1 ]; then
                    echo "DEBUG: return ${FUNCNAME[0]} function: 1"
                fi
                return 1
            fi
            ;;
        n)
            xdg-open 'https://github.com/join?source=header-home' &> //dev/null
            if [ $? -ne 0 ]; then
                echo "error: xdg-open: command not found"
                if [ $DEBUG -eq 1 ]; then
                    echo "DEBUG: return ${FUNCNAME[0]} function: 1"
                fi
                return 1
            fi
            if [ $DEBUG -eq 1 ]; then
                echo "DEBUG: return ${FUNCNAME[0]} function: 0"
            fi
            return 0
            ;;
        *)
            echo "syntax error: not correct anwser"
            if [ $DEBUG -eq 1 ]; then
                echo "DEBUG: reload ${FUNCNAME[0]} function"
            fi
            github_user
            ;;
        esac
    if [ $? -ne 0 ]; then
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

function blih_create_repository()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
        echo "DEBUG: the program ping once https://blih.saumon.io"
    fi
    ping -c 1 blih.saumon.io &> //dev/null
    if [ $? -ne 0 ]; then
        echo "error: https://blih.saumon.io is down or you are not connected to a wifi network or you have a bad wifi network"
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: return ${FUNCNAME[0]} function: 1"
        fi
        return 1
    fi
    read -p "What is your Epitech email adress ? " ANWSER
    LOGIN=$ANWSER
    echo "Creating $REPOSITORY_NAME with blih ..."
    blih -u $LOGIN repository create $REPOSITORY_NAME 
    if [ $? -ne 0 ]; then
        echo "error: repository $REPOSITORY_NAME could not create"
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: return ${FUNCNAME[0]} function: 1"
        fi
        return 1
    fi
    blih -u $LOGIN repository setacl $REPOSITORY_NAME ramassage-tek r
    if [ $? -ne 0 ]; then
        echo "error: you can not give rights in repository $REPOSITORY_NAME "
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: return ${FUNCNAME[0]} function: 1"
        fi
        return 1
    fi
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function"
    fi
    return 0
}

function init_files_repository()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
    fi
    echo "Creating README ..."
    touch $REPOSITORY_NAME/README.md
    echo "README OF $REPOSITORY_NAME" > $REPOSITORY_NAME/README.md
    echo "README is created"
    touch $REPOSITORY_NAME/.gitignore
    echo ".vscode" > $REPOSITORY_NAME/.gitignore
    echo ".gitignore is created"
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function"
    fi
    return 0
}

function init_repository()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
    fi
    git -C $REPOSITORY_NAME/ remote add blih "$REPOSITORY_NAME"
    init_files_repository
    git -C $REPOSITORY_NAME/ add README.md .gitignore
    git -C $REPOSITORY_NAME/ commit -m "[INIT REPOSITORY]"
    git -C $REPOSITORY_NAME/ push origin master
    git -C $REPOSITORY_NAME/ push blih master
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function"
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
        echo "error: none repository has created"
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
        fi
        exit 1
    else
        blih_create_repository
        if [ $? -ne 0 ]; then
            "info: repository $REPOSITORY_NAME was not created on https://blih.saumon.io"
            if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: return ${FUNCNAME[0]} function: 1"
            fi
            return 1
        fi
    fi
    init_repository
    read -p "Do you want to open your repository page on GitHub and Blih ? (y/n) " ANWSER
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: anwser: $ANWSER"
    fi
    local l_OPEN=$ANWSER
    case $l_OPEN in
        y)
            xdg-open "https://github.com/$USERNAME/$REPOSITORY_NAME" &> //dev/null
            xdg-open "https://blih.saumon.io" &> //dev/null
            ;;
        n | *)
            ;;
    esac
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