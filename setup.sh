#!/bin/bash

##
## GITHUB PROJECT, 2020
## s1mpleTEK
## Description:
## Setup run.sh
##

sudo apt-get install xdg-utils

read -p "What is your username in Github ? " USERNAME
git config --global github.user $USERNAME