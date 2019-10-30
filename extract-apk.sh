#!/bin/bash

# ASCII CODES for foreground colours and text attributes
readonly NONE="$(tput sgr 0)"               # Reset
readonly RED="$(tput setaf 1)"				# Red
readonly PINK="$(tput setaf 1)"				# Pink
readonly GREEN="$(tput setaf 2)"   			# Yellow
readonly YELLOW="$(tput setaf 3)"			# Green
readonly PURPLE="$(tput setaf 5)"			# Magenta
readonly CYAN="$(tput setaf 6)"				# Cyan
readonly LIGHT_CYAN="$(tput setaf 4)"       # Blue 
readonly WHITE="$(tput setaf 7)"			# White
readonly BOLD="$(tput bold)"				# Bold
readonly UNDERLINE="$(tput smul)"			# Underline

# Check if adb is installed
if [ ! "$(command -v adb)" ]; then
	echo "${RED}ADB not installed. Install adb first${NONE}"
fi	

echo "${GREEN}Enter keyword matching application's name${NONE}"
read -p ">> " app_name

echo ""
echo "${GREEN}Following packages found with the given keyword...${NONE}"
echo "------------------------------------"
echo "${BOLD}"
# Get package names
adb shell pm list packages | grep -i "$app_name" | awk -F':' '{print $2}'
echo "${NONE}"
echo "------------------------------------"

echo "${GREEN}Enter the package name from the above packages. Press q for quit${NONE}"
read -p ">> " package_name

if [ "$package_name" == 'q' ]; then
	exit
fi

package_path="$(adb shell pm path $package_name | awk -F':' '{print $2}')"
echo ""
echo "${BOLD}Path${NONE}: ${CYAN}$package_path${NONE}"
echo ""

echo "${GREEN}Extracting package... Enter name of the package. Default: base.apk${NONE}"
read -ep ">> " package_rename

adb pull "$package_path"

if [ -z "$package_rename" ]; then
    package_rename="base.apk"
else
	mv base.apk "$package_rename"
fi

echo ""
echo "${BOLD}${GREEN}APK extracted with name $package_rename${NONE}"

