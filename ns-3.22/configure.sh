#!/bin/bash

# gcc check
if dpkg -s gcc &>/dev/null
then 	echo "c compiler installed"
else 	echo "c compiler not installed"
	sudo apt-get install g++
fi

# g++  check
if dpkg -s g++ &>/dev/null || dpkg -s icpc &>/dev/null
then	echo "c++ compiler installed"
else 
	echo "c++ compiler not installed"
	echo "Installing g++..."
	sudo apt-get install g++
	echo "g++ installation complete"
fi