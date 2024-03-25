#!/bin/sh

init() {
	clear
}

get_install_path() {
	echo "Enter the install path of the toolchain
A directory 'rumpsteak_morello' will be created there, containing all components
of the toolchain"
	read -p "PATH? " INSTALL_DIR
	INSTALL_DIR="$(realpath "$INSTALL_DIR")/rumpsteak_morello"
	echo "install in $INSTALL_DIR"
	INIT_PATH="$PWD"
}

#1 path
create_install_dir() {
	if test -f "$1"
	then
		echo "$1 is a file"
		false
	else
		echo "Creating directory $1"
		mkdir -p "$1"
		true
	fi
}

install_futures() {
	cd "$INSTALL_DIR"
	git clone -b token-bilockimpl https://github.com/exrook/futures-rs.git
	cd "$INIT_PATH"
}

install_rumpsteak() {
	cd "$INSTALL_DIR"
	git clone https://github.com/zakcutner/rumpsteak
	cd rumpsteak
	patch Cargo.toml < ../../rumpsteak.patch
	cd "$INIT_PATH"
}

#1 install path
prepare_cargo_patch() {
	INSTALL_DIR_SUBST="$(echo $INSTALL_DIR | sed "s,/,\\\\/,g")"
	sed "s/INSTALL_DIR/$INSTALL_DIR_SUBST/" Cargo.toml.patch.template > Cargo.toml.patch
}

install() {
	init
	get_install_path
	create_install_dir "$INSTALL_DIR" || (echo "abort install"; exit -1)
	install_futures
	install_rumpsteak
	prepare_cargo_patch
}

#1 command
help() {
	printf "Usage: $1 [CMD]\n\n"
	printf "CMD available:\n"
	printf "\tinstall: \tinstalls everything (default)\n"
	printf "\tclean: \t\tremoves generated files\n"
	printf "\thelp: \t\tprints this help\n\n"
}

clean() {
	rm Cargo.toml.patch
	rm rumpsteak_morello -rf
}

if test "$#" -gt 0
then
	case "$1" in
	install)
		install ;;
	clean)
		clean ;;
	*)
		help "$0" ;;
	esac
else
	install
fi
