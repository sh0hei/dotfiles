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

# git-completion.bash
source $HOME/.git-prompt.sh
source $HOME/.git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true

# for setting history length and format see HISTSIZE and HISTFILESIZE and HISTTIMEFORMAT in bash(1)
HISTSIZE=99999
HISTFILESIZE=99999
HISTTIMEFORMAT='%Y-%m-%d %T '

# Change the window title of X terminals 
none='\e[0m'
Black='\e[0;30m'
Red='\e[0;31m'
Green='\e[0;32m'
Blue='\e[0;34m'
Purple='\e[0;35m'
Cyan='\e[0;36m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
yellow='\e[1;33m'

# set prompt format
prompt="\[$LIGHTGREEN\]\t\[$none\] \u@\h:\w\[$Red\]$(__git_ps1)\[$none\]\[$LIGHTGREEN\]\$\[$none\] "

case ${TERM} in
	linux|xterm*|rxvt*|Eterm*|aterm*|kterm*|gnome*|interix)
		PS1=${prompt}
		;;
	screen*)
		PS1=${prompt}
		PROMPT_COMMAND='echo -ne "\ek\e\\"'
		;;
esac
