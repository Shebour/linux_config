#!/bin/sh

CONFIG="$HOME/config"
DOTFILES="$CONFIG/dotfiles"
XDG_CONFIG_HOME="$HOME/.config"
CONFIGFILES="$CONFIG/configfiles"

getfilename()
{
    echo ${1##*/}
}

install_dot_files()
{
    export -f getfilename
    filenames=$(find "$DOTFILES" -type f -exec bash -c "getfilename \"{}\"" \;)
    for filename in $filenames; do
        ln -sf "$DOTFILES/$filename" "$HOME/.$filename"
    done
}

install_config_files()
{
    cp "$CONFIGFILES/i3/config" "$XDG_CONFIG_HOME/i3/"
    cp "$CONFIGFILES/kitty/kitty.conf" "$XDG_CONFIG_HOME/kitty/"

}

install_dot_files
install_config_files
