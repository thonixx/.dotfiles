#!/bin/bash

# define directory where zsh is stored
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# ask whether use personal or work settings
echo -n "type 'personal' or 'work' and press enter: "
read env

# check for input
if [ -z "$env" ]; then echo "no input given. cancelling script."; exit 1; fi

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

# backup gitconfig if file exists or unlink it
if [ -h "$home/.gitconfig" ]
then
	unlink $home/.gitconfig && echo ".gitconfig is now unlinked."
else
	mv $home/.gitconfig $home/.gitconfig.bak && echo ".gitconfig backed up."
fi

# link zshrc
ln -s $dir/zshrc $zshrc && echo ".zshrc is now installed"

# link tmux.conf
if [ -f "$dir/tmux.conf.local" ]
then
	ln -s $dir/tmux.conf.local $home/.tmux.conf && echo ".tmux.conf.local is now installed"
else
	ln -s $dir/tmux.conf $home/.tmux.conf && echo ".tmux.conf is now installed"
fi

# copy gitconfig.$type
case $env in
	'work')
		type='work'
	;;
	'personal'|*)
		type='personal'
	;;
esac
# decrypt and save it
gpg < $dir/gitconfig.$type.gpg > $home/.gitconfig && echo ".gitconfig.$type is now installed"
# append gitconfig content
cat $dir/gitconfig >> $home/.gitconfig && echo ".gitconfig content appended"

# updating submodules
git submodule init > /dev/null && git submodule update > /dev/null && echo "configured submodules"

# end script
echo "script ended"
exit 0
