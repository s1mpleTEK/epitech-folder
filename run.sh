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
GITHUB=0
BLIH=0
API=0
cmd=('-h' '--help' '-d' '--debug' '-dh' '-hd' '--help--debug' '--debug--help')
REPOSITORY_NAME=""
USERNAME=""
ID=""
ID_LEN=""

################################################################################################

###########################################DEBUG CHECK##########################################

for i in "$@"; do
    case $i in
        ${cmd[2]} | ${cmd[3]} | ${cmd[4]} | ${cmd[5]} | ${cmd[6]} | ${cmd[7]})
            DEBUG=1
            ;;
    esac
done

################################################################################################

###########################################FUNCTIONS############################################

######################TIER HE############################
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
        case $i in
            ${cmd[0]} | ${cmd[1]} | ${cmd[4]} | ${cmd[5]} | ${cmd[6]} | ${cmd[7]})
                HELP=1
                ;;
            ${cmd[2]} | ${cmd[3]})
                ;;
            *)
                echo "error: $i: command not found"
                if [ $DEBUG -eq 1 ]; then
                echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
                fi
                exit 1
                ;;
        esac
    done
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function: 0"
    fi
    return 0
}
##################################################

####################TIER G########################
function github_create_repository()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
    fi
    echo "Creates Github repository '$REPOSITORY_NAME' ..."
    curl -f -u $USERNAME https://api.github.com/user/repos -d '{"name":"'$REPOSITORY_NAME'"}' >> .output
    if [ $? -ne 0 ];then
        rm .output
        echo "error: the repository $REPOSITORY_NAME is not created"
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
        fi
        exit 1
    fi
    rm .output
    echo "The Github repository $REPOSITORY_NAME created"
    echo "Puts '$REPOSITORY_NAME' repository in private ..."
    curl -f -u $USERNAME https://api.github.com/repos/$USERNAME/$REPOSITORY_NAME -d '{"private":"'true'"}' >> .output
    if [ $? -ne 0 ];then
        echo "error: the repository $REPOSITORY_NAME is not private"
    else
        rm .output
        echo "The Github repository $REPOSITORY_NAME is private"
    fi
    echo "Sets access at ramassage-tls in '$REPOSITORY_NAME' repository ..."
    curl -f -u $USERNAME https://api.github.com/repos/$USERNAME/$REPOSITORY_NAME/collaborators{/ramassage-tls} -X PUT >> .output
    if [ $? -ne 0 ];then
        echo "error: the repository $REPOSITORY_NAME does not give access to ramassage-tls"
    else
        rm .output
        echo "The Github repository $REPOSITORY_NAME gives accesse to ramassage-tls"
    fi
    echo "Clones Github repository $REPOSITORY_NAME created"
    git clone https://github.com/$USERNAME/$REPOSITORY_NAME.git
    if [ $? -ne 0 ];then
        echo "error: the repository $REPOSITORY_NAME is not cloned"
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
        fi
        exit 1
    fi
    echo "The repository $REPOSITORY_NAME is cloned here: `pwd $REPOSITORY/`"
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
            echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
        fi
        exit 1
    fi
    github_create_repository
    if [ $? -eq 1 ]; then
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
        fi
        exit 1
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
    fi
    read -p "Do you have a Github account ? (y/n) " ANWSER
    local l_ANWSER=$ANWSER
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: anwser: $l_ANWSER"
    fi
    case $l_ANWSER in
        y | Y)
            USERNAME=`git config --global github.user`
            if [[ $USERNAME == "" ]]; then
                echo "error: github.user not found"
                read -p "Do you want to set your github.user ? (y/n) " ANWSER
                local l_ANWSER=$ANWSER
                if [ $DEBUG -eq 1 ]; then
                    echo "DEBUG: anwser: $l_ANWSER"
                fi
                case $l_ANWSER in
                    y | Y)
                        read -p "What is it your Github username ? " ANWSER
                        local l_ANWSER=$ANWSER
                        if [ $DEBUG -eq 1 ]; then
                            echo "DEBUG: anwser: $l_ANWSER"
                        fi
                        git config --global github.user "$l_ANWSER"
                        ;;
                    n | N | *)
                        ;;
                esac
                USERNAME=`git config --global github.user`
                if [[ $USERNAME == "" ]]; then
                    echo "error: github.user not found"
                    echo "info: run 'git config --global github.user <username>'"
                    if [ $DEBUG -eq 1 ]; then
                        echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
                    fi
                    exit 1
                fi
            fi
            echo "Your username on Github: $USERNAME"
            local l_EMAIL=`git config --global github.email`
            if [[ $l_EMAIL == "" ]]; then
                curl -f -u $USERNAME https://api.github.com/users/$USERNAME >> .id_output
                if [ $? -ne 0 ];then
                    rm .id_output
                    echo "error: github.email not found"
                    echo "info: run 'git config --global github.email <<github user id>+<username>@users.noreply.github.com>'"
                    if [ $DEBUG -eq 1 ]; then
                        echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
                    fi
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
            fi
            git config --global github.email
            github_repository
            if [ $? -ne 0 ]; then
                if [ $DEBUG -eq 1 ]; then
                    echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
                fi
                exit 1
            fi
            ;;
        n | N)
            xdg-open 'https://github.com/join?source=header-home' &> //dev/null
            if [ $? -ne 0 ]; then
                echo "error: xdg-open: command not found"
                if [ $DEBUG -eq 1 ]; then
                    echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
                fi
                exit 1
            fi
            if [ $DEBUG -eq 1 ]; then
                echo "DEBUG: return ${FUNCNAME[0]} function: 3"
            fi
            return 3
            ;;
        *)
            echo "syntax error: not correct anwser"
            if [ $DEBUG -eq 1 ]; then
                echo "DEBUG: reload ${FUNCNAME[0]} function"
            fi
            github_user
            if [ $? -ne 0 ]; then
                if [ $DEBUG -eq 1 ]; then
                    echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
                fi
                exit 1
            fi
            ;;
    esac
    if [ $? -ne 0 ]; then
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
        fi
        exit 1
    fi
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function: 0"
    fi
    return 0
}
##################################################

####################TIER B########################
function blih_create_repository()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
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
    echo "Set access at ramassage-tek ..."
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
##################################################

####################TIER I########################
function init_files_repository()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
    fi
    echo "Creating README ..."
    touch $REPOSITORY_NAME/README.md
    echo "# README OF $REPOSITORY_NAME" > $REPOSITORY_NAME/README.md
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
    git -C $REPOSITORY_NAME/ init .
    git -C $REPOSITORY_NAME/ remote add blih "git@git.epitech.eu:$LOGIN/$REPOSITORY_NAME"
    init_files_repository
    git -C $REPOSITORY_NAME/ config user.name $(git -C $REPOSITORY_NAME/ config --global github.user)
    git -C $REPOSITORY_NAME/ config user.email $(git -C $REPOSITORY_NAME/ config --global github.email)
    git -C $REPOSITORY_NAME/ add README.md .gitignore
    git -C $REPOSITORY_NAME/ commit -m "[INIT REPOSITORY]"
    git -C $REPOSITORY_NAME/ push origin master
    git -C $REPOSITORY_NAME/ push blih master
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function"
    fi
    return 0
}
##################################################

####################TIER S########################
function server_important_check()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
    fi
    echo "Please wait ..."
    ping -c 1 api.github.com &> //dev/null
    if [ $? -ne 0 ]; then
        echo "error: https://api.github.com are down or you are not connected to a wifi network or you have a bad wifi network"
        API=0
    else
        API=1
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: https://api.github.com is up"
        fi
    fi
    
    echo "Please wait ..."
    ping -c 1 github.com &> //dev/null
    if [ $? -ne 0 ]; then
        echo "error: https://github.com is down or you are not connected to a wifi network or you have a bad wifi network"
        GITHUB=0
    else
        GITHUB=1
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: https://github.com is up"
        fi
    fi
    echo "Please wait ..."
    ping -c 1 blih.epitech.eu &> //dev/null
    if [ $? -ne 0 ]; then
        echo "error: https://blih.epitech.eu is down or you are not connected to a wifi network or you have a bad wifi network"
        BLIH=0
    else
        BLIH=1
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: https://blih.epitech.eu is up"
        fi
    fi
    if [[ $API -eq 0 && $GITHUB -eq 0 && $BLIH -eq 0 ]]; then
        echo "error: https://api.github.com, https://github.com and https://blih.epitech.eu are down, so this script does not work :("
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: exit ${FUNCNAME[0]} function: 2"
        fi
        exit 2
    elif [[ $API -eq 0 && $BLIH -eq 0 ]]; then
        echo "error: https://api.github.com and https://blih.epitech.eu are down, so this script does not work :("
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: exit ${FUNCNAME[0]} function: 2"
        fi
        exit 2
    elif [[ $GITHUB -eq 0 && $BLIH -eq 0 ]]; then
        echo "error: https://github.com and https://blih.epitech.eu are down, so this script does not work :("
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: exit ${FUNCNAME[0]} function: 2"
        fi
        exit 2
    fi
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function: 0"
    fi
    return 0
}
##################################################

####################TIER M########################
function main()
{
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: number of arguments: $#"
        echo "DEBUG: enter in ${FUNCNAME[0]} function"
    fi
    echo "PROGRAM START"
    server_important_check
    error "$@"
    if [ $HELP -eq 1 ]; then
        help
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: return ${FUNCNAME[0]} function: 0"
        fi
        echo "PROGRAM FINISH"
        return 0
    fi
    if [[ $API -eq 0 || $GITHUB -eq 0 ]]; then
        echo "info: this script does not can you the creation of Github repository because https://api.github.com or/and https://github.com does/do not respond"
    else
        github_user
        if [ $? -eq 1 ]; then
            curl -f https://github.com/$USERNAME/$REPOSITORY_NAME &> //dev/null
            if [ $? -ne 0 ]; then
                echo "error: none Github repository created"
            else
                echo "info: only your Github repository created"
            fi
            if [ $DEBUG -eq 1 ]; then
                echo "DEBUG: exit ${FUNCNAME[0]} function: 1"
            fi
            exit 1
        fi
    fi
    if [ $BLIH -eq 0 ]; then
        echo "info: this script cans not you the creation of Blih repository because https://blih.epitech.eu does not respond"
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
    if [[ $API -ne 0 || $GITHUB -ne 0 || $BLIH -ne 0 ]]; then
        init_repository
    fi
    if [[ $API -eq 1 && $BLIH -eq 0 || $GITHUB -eq 1 && $BLIH -eq 0 ]]; then
        read -p "Do you want to open your repository page on GitHub ? (y/n) " ANWSER
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: anwser: $ANWSER"
        fi
        local l_OPEN=$ANWSER
        case $l_OPEN in
            y | Y)
                xdg-open "https://github.com/$USERNAME/$REPOSITORY_NAME" &> //dev/null
                ;;
            n | N | *)
                ;;
        esac
    elif [[  $API -eq 0 && $BLIH -eq 1 || $GITHUB -eq 0 && $BLIH -eq 1 ]]; then
    read -p "Do you want to clone your repository ? (y/n) "ANWSER
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: anwser: $ANWSER"
        fi
        local l_CLONE=$ANWSER
        git clone git@git.epitech.eu:$LOGIN/$REPOSITORY_NAME
    read -p "and to open your repository page on Blih saumon ? (y/n) " ANWSER
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: anwser: $ANWSER"
        fi
        local l_OPEN=$ANWSER
        case $l_OPEN in
            y | Y)
                xdg-open "https://blih.saumon.io" &> //dev/null
                ;;
            n | N | *)
                ;;
        esac
    else
        read -p "Do you want to open your repository page on GitHub and Blih saumon ? (y/n) " ANWSER
        if [ $DEBUG -eq 1 ]; then
            echo "DEBUG: anwser: $ANWSER"
        fi
        local l_OPEN=$ANWSER
        case $l_OPEN in
            y | Y)
                xdg-open "https://github.com/$USERNAME/$REPOSITORY_NAME" &> //dev/null
                xdg-open "https://blih.saumon.io" &> //dev/null
                ;;
            n | N | *)
                ;;
        esac
    fi
    echo "PROGRAM FINISH"
    if [ $DEBUG -eq 1 ]; then
        echo "DEBUG: return ${FUNCNAME[0]} function: 0"
    fi
    return 0
}
##################################################

################################################################################################

#########################################PROGRAM START##########################################

main "$@"

################################################################################################