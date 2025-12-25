#!/bin/bash
source ./color.sh

echo -e "${B_WHT}How do you want to provide the repository?${RST}"
echo -e "${BLU}1) username/reponame${RST}"
echo -e "${GRN}2) Full URL${RST}"
echo
read -p "Choose 1 or 2: " choice

if [ "$choice" = "1" ]; then
	read -p "Enter github username: " username
	read -p "Enter github reponame: " reponame
	target="$username/$reponame"
	git clone https://www.github.com/$target.git
	echo -e "${GRN}Repository cloned successfully${RST}"
elif [ "$choice" = "2" ]; then
	read -p "Enter Repository URL: " target
	git clone $target
	echo -e "${GRN}Repository cloned successfully${RST}"
else
	echo "Invalid choice. Exiting."
	exit 1
fi
