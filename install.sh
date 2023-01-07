#!/bin/sh

set -e

default="\033[39m"
black="\033[30m"
red="\033[0;31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
magenta="\033[35m"
cyan="\033[36m"
light_gray="\033[37m"
dark_gray="\033[90m"
light_red="\033[91m"
light_green="\033[92m"
light_yellow="\033[93m"
light_blue="\033[94m"
light_magenta="\033[95m"
light_cyan="\033[96m"
white="\033[97m"

CONFIG="$HOME/linux_config"
DOTFILES="$CONFIG/dotfiles"
XDG_CONFIG_HOME="$HOME/.config"
CONFIGFILES="$CONFIG/configfiles"

getfilename()
{
    echo ${1##*/}
}

myprint()
{
    printf "$green%s$default\n" "$@"
}

install_dot_files()
{
    export -f getfilename
    filenames=$(find "$DOTFILES" -type f -exec bash -c "getfilename \"{}\"" \;)
    for filename in $filenames; do
        ln -sf "$DOTFILES/$filename" "$HOME/.$filename"
        myprint "$HOME/.$filename created"
    done
}

install_config_files()
{
    cp "$CONFIGFILES/i3/config" "$XDG_CONFIG_HOME/i3/"
    myprint "$XDG_CONFIG_HOME/i3/config created"
    cp "$CONFIGFILES/kitty/kitty.conf" "$XDG_CONFIG_HOME/kitty/"
    myprint "$XDG_CONFIG_HOME/kitty/kitty.conf created"

}

install_dot_files
install_config_files
