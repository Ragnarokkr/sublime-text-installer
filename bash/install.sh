#!/bin/bash

#
## (Un)Installer script for Sublime Text 2 editor
##
## Based on work of:
##  DamnWidget (https://github.com/DamnWidget/sublime-text)
##
## References:
##  http://standards.freedesktop.org/basedir-spec/latest/index.html
##  http://standards.freedesktop.org/desktop-entry-spec/latest/
##
## Copyright (C) 2013 Marco Trulla <marco@marcotrulla.it>
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

####
## Script informations
#

declare -A SCRIPT

SCRIPT[NAME]='Sublime Text 2 (Un)Installer'
SCRIPT[VERSION]='0.1.0'
SCRIPT[AUTHOR]='Marco Trulla <marco@marcotrulla.it>'
SCRIPT[COPY]='Copyright (c) 2013'


####
## Console color escape codes
#

declare -A COLOR

COLOR[GREEN]='\e[0;32m'
COLOR[RED]='\e[0;31m'
COLOR[YELLOW]='\e[1;33m'
COLOR[WHITE]='\e[1;37m'
COLOR[NONE]='\e[0m'

####
## Messages
#

declare -A MESSAGE

MESSAGE[MSG_CHECK]="\n${COLOR[GREEN]}Checking if a valid host system...${COLOR[NONE]}"
MESSAGE[MSG_DOWNLOAD]="\n${COLOR[GREEN]}Downloading archive...${COLOR[NONE]}"
MESSAGE[MSG_UNZIP]="\n${COLOR[GREEN]}Decompressing archive...${COLOR[NONE]}"
MESSAGE[MSG_INST_BIN]="\n${COLOR[GREEN]}Installing binaries...${COLOR[NONE]}"
MESSAGE[MSG_UNINST_BIN]="\n${COLOR[GREEN]}Uninstalling binaries...${COLOR[NONE]}"
MESSAGE[MSG_INST_ICONS]="\n${COLOR[GREEN]}Installing icons...${COLOR[NONE]}"
MESSAGE[MSG_UNINST_ICONS]="\n${COLOR[GREEN]}Uninstalling icons...${COLOR[NONE]}"
MESSAGE[MSG_INST_DESKTOP]="\n${COLOR[GREEN]}Generating desktop file...${COLOR[NONE]}"
MESSAGE[MSG_UNINST_DESKTOP]="\n${COLOR[GREEN]}Removing desktop file...${COLOR[NONE]}"
MESSAGE[MSG_DONE]="\n${COLOR[GREEN]}Installation successfully terminated.${COLOR[NONE]}"
MESSAGE[MSG_UNDONE]="\n${COLOR[GREEN]}Uninstallation successfully terminated.${COLOR[NONE]}"
MESSAGE[MSG_HELP]="\n\t-i --install\tinstall Sublime Text"\
"\n\t-u --uninstall\tuninstall Sublime Text"\
"\n\t-h --help\tthis help"\
"\n\nThis script installs the Sublime Text 2 package on your system."\
"\nTo work, it requires that your system is FHS and XDG compliant."\
"\n\nFurther informations about FHS can be found at:"\
"\n\thttp://refspecs.linuxfoundation.org/FHS_2.3/fhs-2.3.html"\
"\n\nFurther informations about XDG can be found at:"\
"\n\thttp://www.freedesktop.org/wiki/Specifications/basedir-spec"\
"\n\n\n${COLOR[WHITE]}This program comes with ABSOLUTELY NO WARRANTY."\
"\nThis is free software, and you are welcome to redistribute it"\
"\nunder certain conditions."\
"\n\nPlease, read the LICENSE and README files distributed with this"\
"\npackage for further informations.${COLOR[NONE]}"

MESSAGE[ERROR_OPTION]="\n${COLOR[RED]}Error: missing or unknown option. Use -h or --help.${COLOR[NONE]}"
MESSAGE[ERROR_NO_ROOT]="\n${COLOR[RED]}Error: you must be logged in as root to run this script.${COLOR[NONE]}"
MESSAGE[ERROR_NO_FHS]="\n${COLOR[RED]}Error: your system doesn't seems to be FHS compliant.${COLOR[NONE]}"
MESSAGE[ERROR_NO_XDG]="\n${COLOR[RED]}Error: your system doesn't seems to be XDG compliant.${COLOR[NONE]}"
MESSAGE[ERROR_NOT_INSTALLED]="\n${COLOR[RED]}Error: Sublime Text is not installed on this computer.${COLOR[NONE]}"
MESSAGE[ERROR_DOWNLOAD]="\n${COLOR[RED]}Error: something went wrong during the archive downloading.${COLOR[NONE]}"
MESSAGE[ERROR_OPEN_ARCHIVE]="\n${COLOR[RED]}Error: unable to open the archive file.${COLOR[NONE]}"
MESSAGE[ERROR_UNZIP]="\n${COLOR[RED]}Something went wrong during the decompression. Check the archive and try again.${COLOR[NONE]}"

MESSAGE[WARN_NO_CURL]="\n${COLOR[YELLOW]}Warn: cURL is required to install the package. Please install it and retry.${COLOR[NONE]}"
MESSAGE[WARN_ARCHIVE]="\n${COLOR[YELLOW]}Warn: a valid archive with the same name has been found."\
"\n\nIt will be used for the installation. If it's not the correct archive,"\
"\nplease move it in another place or rename it, then try again."\
"\n\nPress ENTER to continue or CTRL-C to stop.${COLOR[NONE]}"
MESSAGE[WARN_UNINST]="\n${COLOR[YELLOW]}Warn: you're going to remove Sublime Text from your computer."\
"\nThis is the last chance to come back on your steps..."\
"\nTake the Red pill [ENTER] and go ahead,"\
"\nor take the Blue pill [CTRL-C] and everything will be fine...${COLOR[NONE]}"

####
## Required variables to retrieve and install the software.
#

declare -A APP URI DIR

APP[NAME]='Sublime Text'
APP[VERSION]='2.0.1'
APP[ARCH]='x64' # Left the value empty for 32-bit version
APP[DESCRIPTION]='Sophisticated text editor for code, markup and prose.'

DIR[FHS_BIN]='/usr/bin'
DIR[FHS_OPT]='/opt'
DIR[XDG]='/usr/share'
DIR[XDG_ICON]="${DIR[XDG]}/icons/hicolor"
DIR[XDG_DESKTOP]="${DIR[XDG]}/applications"
DIR[APP]='sublime-text-2'
DIR[WORK]="$PWD"
DIR[SRC]="${DIR[WORK]}/Sublime Text 2"
DIR[DEST]="${DIR[FHS_OPT]}/${DIR[APP]}"

URI[BASE]='http://c758482.r82.cf2.rackcdn.com'
URI[SRC]="${APP[NAME]} ${APP[VERSION]} ${APP[ARCH]}.tar.bz2"
URI[TARGET]="${URI[BASE]}/${URI[SRC]// /%20}"
URI[TARGET_FILE]="${DIR[WORK]}/${URI[SRC]// /_}"


####
## GENERIC functions -----------------------------------------------------------
#

debug () {
	echo -e "SCRIPT:\n${SCRIPT[*]}"
	echo "COLOR:"
	echo "${COLOR[*]}"
	echo -e "APP:\n${APP[*]}"
	echo -e "URI:\n${URI[*]}"
	echo -e "DIR:\n${DIR[*]}"
	echo -e "MESSAGE:\n${MESSAGE[*]}"
}

## Prints some informations about the script
print_copyright () {
	echo -e "${SCRIPT[NAME]} v${SCRIPT[VERSION]}\n${SCRIPT[COPY]} ${SCRIPT[AUTHOR]}"
}

## prints a message on stdout
print_msg () {
	if [ ! -z $1 ]; then
		echo -e ${MESSAGE[${1}]}
	fi
}

## Prints help
print_help () {
	print_msg MSG_HELP
	exit 0
}

## If Gnome is installed and running, we use its tools to update the
# icon cache database
xdg_update_icon_db () {
	local gnome_test=$(ps -Aocmd | grep '^gnome-session' &>/dev/null)
	if [ $? -eq 0 ]; then
		gtk-update-icon-cache -f ${DIR[XDG_ICON]}
	fi
}

####
## INSTALL functions -----------------------------------------------------------
#

## This performs all the required checks to figure out if the system is
# correctly configured for the installation.
pre_install () {
	print_msg MSG_CHECK

	# checks if we are logged in as root or not.
	if [ $EUID -ne 0 ] ; then
		print_msg ERROR_NO_ROOT
		exit 1
	fi

	# checks if we're on a FHS compliant GNU/Linux system (Debian, Ubuntu, Gentoo, etc.)
	if [[ ! -d ${DIR[FHS_BIN]} || ! -d ${DIR[FHS_OPT]} ]] ; then
		print_msg ERROR_NO_FHS
		exit 1
	fi

	# checks if we're on a XDG compliant system (Gnome, KDE, etc.)
	if [[ ! -d ${DIR[XDG]} || ! -d ${DIR[XDG_ICON]} || ! -d ${DIR[XDG_DESKTOP]} ]] ; then
		print_msg ERROR_NO_XDG
		exit 1
	fi

	#checks if cURL is installed
	if [ ! -x /usr/bin/curl ]; then
		print_msg WARN_NO_CURL
		exit 1
	fi
}

## Download the compressed archive
download_archive () {
	print_msg MSG_DOWNLOAD

	# check if a previously compressed archive was downloaded
	if [ ! -f ${URI[TARGET_FILE]} ]; then
		curl -f --url ${URI[TARGET]} -o ${URI[TARGET_FILE]}
		if [ $? -gt 0 ]; then
			print_msg ERROR_DOWNLOAD
			exit 1
		fi
	else
		print_msg WARN_ARCHIVE
		read
	fi
}

## Install the archive content to the destination directory
install_binaries () {
	local executable=${DIR[APP]:0:-2}

	if [ -f ${URI[TARGET_FILE]} ]; then
		print_msg MSG_UNZIP
		tar xvf ${URI[TARGET_FILE]}

		if [ $? -eq 0 ]; then
			print_msg MSG_INST_BIN
			mkdir -v ${DIR[DEST]}
			cp -vr "${DIR[SRC]}"/* ${DIR[DEST]}
			ln -vs ${DIR[DEST]}/${executable//-/_} ${DIR[FHS_BIN]}/$executable
			ln -vs ${DIR[FHS_BIN]}/$executable ${DIR[FHS_BIN]}/${executable}-2
			ln -vs ${DIR[FHS_BIN]}/$executable ${DIR[FHS_BIN]}/${executable:0:4}
			if [ ! -x ${DIR[DEST]}/${executable//-/_} ] ; then
				# we assure that the executable has the correct permissions
				chmod 755 ${DIR[DEST]}/${executable//-/_}
			fi
		else
			print_msg ERROR_UNZIP
			exit 1
		fi
	else
		print_msg ERROR_OPEN_ARCHIVE
		exit 1
	fi
}

## Installs .PNGs icons and .desktop files
install_xdg_files () {
	local sizes=(16 32 48 128 256)
	local executable=${DIR[APP]:0:-2}

	print_msg MSG_INST_ICONS

	local size
	for size in ${sizes[*]} ; do
		local ico_file=${DIR[SRC]}/Icon/${size}x$size/${executable//-/_}.png
		local ico_dest=${DIR[XDG_ICON]}/${size}x${size}/apps
		cp -v "$ico_file" $ico_dest
	done

	xdg_update_icon_db

	print_msg MSG_INST_DESKTOP

	echo -e "[Desktop Entry]" \
		"\nType=Application" \
		"\nName=${APP[NAME]}" \
		"\nGenericName=${APP[DESCRIPTION]}" \
		"\nTryExec=${executable:0:4}" \
		"\nExec=${executable:0:4} %U" \
		"\nIcon=${executable//-/_}" \
		"\nTerminal=false" \
		"\nMimeType=text/plain;text/html;text/css;text/x-markdown;application/javascript;" \
		"\nCategories=Utility;TextEditor;" | sed -e 's/ *$//g' > ${executable//-/_}.desktop

	# if the tool to install the desktop file is present, we use it,
	# otherwise we do it by hand
	if [ -x ${DIR[FHS_BIN]}/desktop-file-install ]; then
		desktop-file-install ${executable//-/_}.desktop
	else
		mv -v ${executable//-/_}.desktop ${DIR[XDG_DESKTOP]}/
	fi
}

## Post-install operations
post_install () {
	print_msg MSG_DONE
	exit 0
}


####
## UNINSTALL functions ---------------------------------------------------------
#

## Verifies that the application is installed on the computer
pre_uninstall () {
	print_msg MSG_CHECK

	# Check if we are logged in as root.
	if [ $EUID -ne 0 ] ; then
		print_msg ERROR_NO_ROOT
		exit 1
	fi

	# Check if the binaries are installed
	if [ ! -d ${DIR[DEST]} ] ; then
		print_msg ERROR_NOT_INSTALLED
		exit 1
	fi

	print_msg WARN_UNINST
	read
}

## Uninstalls all the application's binaries
uninstall_binaries () {
	print_msg MSG_UNINST_BIN

	# Removes the application directory
	rm -vr ${DIR[DEST]}

	# Removes the installed symlinks
	local executable=${DIR[APP]:0:-2}
	local symlinks=(${executable:0:4} ${executable} ${executable}-2)
	for symlink in ${symlinks[*]}; do
		if [ -h /usr/bin/$symlink ] ; then
			rm -v /usr/bin/$symlink
		fi
	done
}

## Uninstall icons and desktop file
uninstall_xdg_files () {
	local sizes=(16 32 48 128 256)
	local executable=${DIR[APP]:0:-2}

	print_msg MSG_UNINST_ICONS

	# Removes the icons and rebuilds the icon database
	local size
	for size in ${sizes[*]} ; do
		local ico_dest=${DIR[XDG_ICON]}/${size}x${size}/apps/${executable//-/_}.png
		if [ -f $ico_dest ] ; then
			rm -v $ico_dest
		fi
	done
	xdg_update_icon_db

	print_msg MSG_UNINST_DESKTOP

	# Removes the desktop file
	if [ -f ${DIR[XDG_DESKTOP]}/${executable//-/_}.desktop ] ; then
		rm -v ${DIR[XDG_DESKTOP]}/${executable//-/_}.desktop
	fi
}

post_uninstall () {
	print_msg MSG_UNDONE
	exit 0
}


####
### MAIN
## Entry point a.k.a. Everything Starts Here
#

print_copyright

# check the command line for parameters
case $1 in
	-i|--install)
		pre_install
		download_archive
		install_binaries
		install_xdg_files
		post_install
		;;

	-u|--uninstall)
		pre_uninstall
		uninstall_binaries
		uninstall_xdg_files
		post_uninstall
		;;

	-h|--help)
		print_help
		;;

	*)
		print_msg ERROR_OPTION
		exit 1
esac

## try to keep the environment clean
unset SCRIPT COLOR MESSAGE APP URI DIR
unset -f print_copyright print_help xdg_update_icon_db pre_install post_install \
	download_archive install_binaries install_xdg_files pre_uninstall \
	uninstall_binaries uninstall_xdg_files post_uninstall
