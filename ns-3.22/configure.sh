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
	echo $blue"-- Current Python Symbolic Link--"$reset
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

netanim_install () {

	read -r -p "Do you want to install NetAnimator? [y/N] " response
	case $response in
	    [yY][eE][sS]|[yY]) 

			case "$version" in

				3.20 | 3.21 | 3.22) 
					netanim_version=3.105
					;;
				3.18 | 3.17 | 3.16)
					netanim_version=3.103
					;;
				3.19)
					netanim_version=3.104
					;;
				3.15)
					netanim_version=3.101
					;;
				*)
					echo $red"No NetAnimator found..."$reset
					;;
			esac
	        
	        # echo $netanim_version
	        cd
			cd ns$1/ns-allinone-$1/netanim-$netanim_version
			make clean
			qmake NetAnim.pro
			make

			read -r -p "Do you want to run NetAnimator? [y/N] " response1
			case $response1 in
			    [yY][eE][sS]|[yY])

					./NetAnim 
	        		;;
	        	*)
					continue
					;;
			esac
			;;
	    *)
	        exit
	        ;;
	esac		
}

pyviz_install () {

	read -r -p "Do you want to start PyViz installation? [y/N] " response
	case $response in
	    [yY][eE][sS]|[yY])
			cd
			sudo apt-get install python-dev python-kiwi python-pygoocanvas python-pygraphviz
			sudo apt-get install python-gnome2 python-gnomedesktop python-rsvg

			cd ns$version/ns-allinone-$version
			#ls
			./build.py --enable-examples --enable-tests
			#ls
			# --Example--
			read -r -p "Do you want to run a PyViz Example? [y/N] " response
			case $response in
			    [yY][eE][sS]|[yY])

					cd ns-$1
					./waf --run examples/tutorial/third --vis
					;;
				*)
					continue
					;;
			esac
			;;
		*)
			exit
			;;
	esac

}

ns-3_install () {

	read -r -p "Are you sure you want to continue? [y/N] " response
	case $response in
	    [yY][eE][sS]|[yY])

			# installing prerequisites
			prerequisites
			# installing compilers
			compilers_install $compiler
			# change compiler's symbolic link 
			symlink_compiler $compiler
			# installing python
			python_install $python
			# change compiler's symbolic link 
			symlink_python $python

			echo $blue"Installing ns-$version..."$reset
			cd
			rm -rf ns$version
			mkdir ns$version
			cd ns$version

			wget --no-check-certificate http://www.nsnam.org/release/ns-allinone-$version.tar.bz2
			tar xjf ns-allinone-$version.tar.bz2
			cd ns-allinone-$version/
			# ls
			./build.py --enable-examples --enable-tests
			cd ns-$version
			# ls
			./waf -d debug --enable-examples --enable-tests configure
			./waf
			# ./test.py
		;;
	*)
		exit
		;;
	esac

}

case "$version" in

	3.15 | 3.16 | 3.17)
		
		# assign gcc/g++ & python version compiler
		compiler=4.7
		python=2.7

		# installing ns-3
		ns-3_install $version $compiler $python

		# installing NetAnimator
		netanim_install $version

		# installing PyViz
		pyviz_install $version
		
		echo ""
		echo $green"ns-$version installed succesfully"$reset
		echo ""

		;;
		
	3.18 | 3.19 | 3.20 | 3.21 | 3.22) 
		
		# assign gcc/g++ & python version compiler
		compiler=4.8
		python=2.7

		# installing ns-3
		ns-3_install $version $compiler $python

		# installing NetAnimator
		netanim_install $version

		# installing NetAnimator
		pyviz_install $version

		echo ""
		echo $green"ns-$version installed succesfully"$reset
		echo ""

		;;
	*)
		
		echo ""
		echo $red"No available version of ns-$version installation guide, try again !"$reset
		echo "Available versions: 3.15, 3.16, 3.17, 3.18, 3.19, 3.20, 3.21, 3.22"
		./configure.sh
		;;
esac
