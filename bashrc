# ~/.bashrc
# shellcheck disable=SC2016
# shellcheck disable=SC1090
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -d ~/afs/bin ] ; then
	export PATH=~/afs/bin:$PATH
fi

if [ -d ~/.local/bin ] ; then
	export PATH=~/.local/bin:$PATH
fi

export LANG=en_US.utf8
export NNTPSERVER="news.epita.fr"

export EDITOR=vim
#export EDITOR=emacs

# Color support for less
#export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
#export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
#export LESS_TERMCAP_me=$'\E[0m'           # end mode
#export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
#export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
#export LESS_TERMCAP_ue=$'\E[0m'           # end underline
#export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

alias ls='ls --color=auto'
alias grep='grep --color -n'
alias ssh_vps='ssh hugo@45.90.161.135'
PS1='[\u@\h \W]\$ '
command -V opam &> /dev/null && eval "$(opam env)"

parse_git_branch () { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'; }

TIME='\033[01;31m\]\t \033[01;34m\]'
LOCATION=' - \W \033[00m\033] '
BRANCH='\033[01;33m\]$(parse_git_branch)\033[00m\]\n\$ '

PS1="$TIME$USER$LOCATION$BRANCH"
alias flags='gcc -Wall -Werror -Wextra -std=c99 -pedantic -g -fsanitize=address'
alias gccc='gcc -Wall -Werror -Wextra -std=c99 -pedantic -g'
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias glold='git lold'
