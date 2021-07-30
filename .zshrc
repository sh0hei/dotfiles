# .zshrc (macOS only)

# Basic Settings {{{
#-------------------------------------------------------------------------------
## aliases
alias ls="ls -G"
alias l="ls -CF"
alias ll="ls -lh"
alias la="ls -A"
alias lla='ls -lA'

##  history
HISTSIZE=10000
SAVEHIST=10000
# }}}

# zplug {{{
#-------------------------------------------------------------------------------
## zplug
source ~/.zplug/init.zsh

# zplug 'dracula/zsh', as:theme
# zplug 'eendroroy/alien', as:theme
zplug 'halfo/lambda-mod-zsh-theme', as:theme
# zplug 'marszall87/lambda-pure'
zplug "zsh-users/zsh-history-substring-search"
zplug "chrissicool/zsh-256color"
zplug load
# }}}

