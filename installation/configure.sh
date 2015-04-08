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

prerequisites () {

	echo ""
	echo $blue"Installing Prerequisites..."$reset
	echo ""
	sudo apt-get install make python python-dev mercurial bzr gdb valgrind gsl-bin libgsl0-dev libgsl0ldbl flex bison tcpdump sqlite sqlite3 libsqlite3-dev libxml2 libxml2-dev libgtk2.0-0 libgtk2.0-dev uncrustify doxygen graphviz imagemagick texlive texlive-latex-extra texlive-generic-extra texlive-generic-recommended texinfo dia texlive texlive-latex-extra texlive-extra-utils texlive-generic-recommended texi2html python-pygraphviz python-kiwi python-pygoocanvas libgoocanvas-dev python-pygccxml 
	sudo apt-get update
	echo ""
	echo $green"Prerequisites installed"$reset
} 
