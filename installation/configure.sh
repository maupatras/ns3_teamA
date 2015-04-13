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

symlink_compiler () {

	sudo rm /usr/bin/g++
	sudo rm /usr/bin/gcc

	sudo ln -s /usr/bin/gcc-$1 /usr/bin/gcc
	sudo ln -s /usr/bin/g++-$1 /usr/bin/g++

	echo ""
	echo $blue"-- Current gcc/g++ Compiler's Symbolic Link--"$reset
	echo ""
	gcc --version
	g++ --version

}

compilers_install () {

	# gcc check
	if dpkg -s gcc-$1 &>/dev/null
	then 	echo $green"gcc-$1 compiler installed"$reset
	else 	echo $red"gcc-$1 compiler not installed"$reset
		sudo apt-get install gcc-$1
		echo ""
		echo $green"gcc-$1 installed succesfully"$reset
	fi	
	# g++ check
	if dpkg -s g++-$1 &>/dev/null
	then 	echo $green"g++-$1 compiler installed"$reset
	else 	echo $red"g++-$1 compiler not installed"$reset
		sudo apt-get install g++-$1
		echo ""
		echo $green"g++-$1 installed succesfully"$reset
	fi

}

symlink_python () {

	sudo rm /usr/bin/python

	sudo ln -s /usr/bin/python$1 /usr/bin/python
	
	echo ""
	echo $blue"-- Current Python Symbolic Link --"$reset
	echo ""
	python --version
	echo ""
}

python_install () {

	# python2.7 check
	if dpkg -s python$1 &>/dev/null
	then 	echo $green"python$1 compiler installed"$reset
	else 	echo $red"python$1 compiler not installed"$reset
		sudo apt-get install python$1
		echo ""
		echo $green"python$1 installed succesfully"$reset
	fi	

}
