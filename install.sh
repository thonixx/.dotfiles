#!/bin/bash

# define directory where zsh is stored
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# check for env var HOME or assume /home/USER
if [ "$HOME" ]
then
	home="$HOME"
else
	home="/home/`whoami`/"
fi

# path to zshrc configuration
zshrc="$home/.zshrc"

# backup zshrc if file exists or unlink it
if [ -h "$zshrc" ]
then
	unlink $zshrc && echo ".zshrc is now unlinked."
else
	mv $zshrc "$zshrc".bak && echo ".zshrc backed up."
fi

# backup tmuxconf if file exists or unlink it
if [ -h "$home/.tmux.conf" ]
then
	unlink $home/.tmux.conf && echo ".tmux.conf is now unlinked."
else
	mv $home/.tmux.conf $home/.tmux.conf.bak && echo ".tmux.conf backed up."
fi

# link zshrc
ln -s $dir/zshrc $zshrc && echo ".zshrc is now installed"
# link tmux.conf
ln -s $dir/tmux.conf $home/.tmux.conf && echo ".tmux.conf is now installed"

# updating submodules
git submodule init > /dev/null && git submodule update > /dev/null && echo "configured submodules"
