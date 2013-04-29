# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# append to the history file, don't overwrite if
shopt -s histappend

# enable color support of ls and also add hand aliases
if [ "$TERM" != "dumb" ]; then
	eval "`dircolors -b`"
	alias ls='ls --color=auto'
	alias dir='ls --color=auto --format=vertical'
	alias vdir='ls --color=auto --format=long'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# some more aliases
[[ -x /usr/bin/vim ]] && alias vi='vim'
[[ -x /usr/bin/screen ]] && alias screen='screen -U'
alias l='ls -CF'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'

# for setting history length and format see HISTSIZE and HISTFILESIZE and HISTTIMEFORMAT in bash(1)
HISTSIZE=99999
HISTFILESIZE=99999
HISTTIMEFORMAT='%Y-%m-%d %T '

# Change the window title of X terminals 
none='\e[0m'
cyan='\e[0;36m'
green='\e[0;32m'
yellow='\e[1;33m'
RED='\e[1;31m'
GREEN='\e[1;32m'

prompt="\[$RED\]\t\[$none\] \u@\h:\w\[$RED\]\$\[$none\] "
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm*|kterm*|gnome*|interix)
		PS1=${prompt}
		;;
	screen*)
		PS1=${prompt}
		PROMPT_COMMAND='echo -ne "\ek\e\\"'
		;;
esac
