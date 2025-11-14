#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
NC="\e[0m"

# Detect package manager
detect_pm() {
    if command -v apt >/dev/null 2>&1; then
        echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v yum >/dev/null 2>&1; then
        echo "yum"
    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    elif command -v zypper >/dev/null 2>&1; then
        echo "zypper"
    else
        echo ""
    fi
}

PM=$(detect_pm)

if [ -z "$PM" ]; then
    echo -e "${RED}Unsupported Linux distribution. No known package manager found.${NC}"
    exit 1
fi

echo -e "${BLUE}Detected package manager: ${GREEN}$PM${NC}"
echo -e "${GREEN}Enter one or more packages to install:${NC}"
read -r PKGS

if [ -z "$PKGS" ]; then
    echo -e "${RED}No packages entered. Exiting.${NC}"
    exit 1
fi

echo -e "${BLUE}Packages to install: ${GREEN}$PKGS${NC}"
echo -e "${GREEN}Continue? (y/n):${NC}"
read -r YN
[ "$YN" != "y" ] && echo -e "${RED}Cancelled.${NC}" && exit 0

case "$PM" in
    apt)
        echo -e "${BLUE}Updating package lists...${NC}"
        sudo apt update
        for pkg in $PKGS; do
            if dpkg -s "$pkg" >/dev/null 2>&1; then
                echo -e "${GREEN}$pkg already installed. Skipping.${NC}"
            else
                sudo apt install -y "$pkg"
            fi
        done
        ;;
    dnf|yum)
        sudo $PM install -y $PKGS
        ;;
    pacman)
        sudo pacman -Sy --noconfirm $PKGS
        ;;
    zypper)
        sudo zypper install -y $PKGS
        ;;
esac

echo -e "${GREEN}All operations completed successfully.${NC}"
