#!/bin/sh

set -x

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
	echo "$PWD"
	cat "../../rumpsteak.patch"
	patch Cargo.toml < ../../rumpsteak.patch
	cd "$INIT_PATH"
}

#1 install path
prepare_cargo_patch() {
	INSTALL_DIR_SUBST="$(echo $INSTALL_DIR | sed "s,/,\\\\/,g")$"
	sed "s/INSTALL_DIR/$INSTALL_DIR_SUBST/" Cargo.toml.patch.template > Cargo.toml.patch
}

init
get_install_path
create_install_dir "$INSTALL_DIR" || (echo "abort install"; exit -1)
install_futures
install_rumpsteak
prepare_cargo_patch
