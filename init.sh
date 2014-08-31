#!/bin/sh

DOT_FILES=(
  .bash_profile \
  .bashrc       \
  .screenrc     \
  .vimrc        \
)

# Set Symbolic Link
for file in ${DOT_FILES[@]}
do
  if [ -a $HOME/$file ]; then
    echo "Already exists file: $file"
  else
    ln -s $HOME/dotfiles/${file} $HOME/${file}
    echo "Put Symbolic Link: $file"
  fi
done

# Install neobundle.vim
if [ ! -e $HOME/.vim/neobundle.vim -a -x "`which git`" ]; then
  git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/neobundle.vim
fi
