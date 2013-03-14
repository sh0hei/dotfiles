#!/bin/sh

# 1.execute [git clone git://github.com/sh0hei/dotfiles.git]
# 2.execute this script

# files for management with git
FILELIST="
.bashrc
.screenrc
.vimrc
"

# escape current files and directories
if [ ! -e ~/dotfiles_old ]; then
	mkdir ~/dotfiles_old
	for FILE in ${FILELIST};
	do
		mv ~/${FILE} ~/dotfiles_old/
	done
fi

# create symbolic link
for FILE in ${FILELIST};
do
	rm -rf ~/${FILE}
	ln -s ~/dotfiles/${FILE} ~/${FILE}
done
