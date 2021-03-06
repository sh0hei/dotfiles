#!/bin/sh

DOT_FILES=(
  .bash_profile        \
  .bashrc              \
  .screenrc            \
  .vimrc               \
)

echo "Installing dotfiles.."

# If we're on a Mac, let's install and setup homebrew.
if [ "$(uname)" == "Darwin" ]; then
    echo "Running on OSX"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

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

echo "Done :)"
