#!/bin/bash

# Output Colors
red="$(tput setaf 1)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"
reset="$(tput sgr 0)"

insert_version () {
echo ""
echo "Choose ns-3 version to install [available versions 3.15 - 3.22]"
echo "or type CTRL-C to EXIT"
echo "(Example: type 3.18)"

read version
}

insert_version
