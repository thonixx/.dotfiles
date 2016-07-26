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
	mv $zshrc "$zshrc".bak 2> /dev/null && echo ".zshrc backed up."
fi

# define directory where zsh is stored
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# backup tmuxconf if file exists or unlink it
if [ -h "$home/.tmux.conf" ]
then
	unlink $home/.tmux.conf && echo ".tmux.conf is now unlinked."
else
	mv $home/.tmux.conf $home/.tmux.conf.bak 2> /dev/null && echo ".tmux.conf backed up."
fi

# define directory where zsh is stored
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# backup gitconfig if file exists or unlink it
if [ -h "$home/.gitconfig" ]
then
	unlink $home/.gitconfig && echo ".gitconfig is now unlinked."
else
	mv $home/.gitconfig $home/.gitconfig.bak 2> /dev/null && echo ".gitconfig backed up."
fi

# define directory where zsh is stored
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# backup irssi if folder exists or unlink it
if [ -h "$home/.irssi" ]
then
	unlink $home/.irssi && echo ".irssi is now unlinked."
else
	mv $home/.irssi $home/.irssi.bak 2> /dev/null && echo ".irssi backed up."
fi

# define directory where zsh is stored
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# install new config
echo ""
echo "beginning with installation:"

# link zshrc
ln -s $dir/zsh/zshrc $zshrc && echo ".zshrc is now installed"

# link irssi directory
ln -s $dir/irssi $home/.irssi && echo ".irssi is now installed"

# link tmux.conf
if [ -f "$dir/tmux.conf.local" ]
then
	ln -s $dir/tmux/tmux.conf.local $home/.tmux.conf && echo ".tmux.conf.local is now installed"
else
	ln -s $dir/tmux/tmux.conf $home/.tmux.conf && echo ".tmux.conf is now installed"
fi

# link dotfiles folder
if [ ! -d "$home/.dotfiles" ]
then
	ln -s $dir $home/.dotfiles && echo ".dotfiles folder installed"
fi

# find out git version before doing git configuration
gitversion="$(git --version | grep -Eo "\ [1-9]\.[0-9]" | sed 's/\ //')"

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
gpg < $dir/git/gitconfig.$type.gpg > $home/.gitconfig && echo ".gitconfig.$type is now installed"
# append gitconfig content
cat $dir/git/gitconfig >> $home/.gitconfig && echo ".gitconfig content appended"

# remove push setting for older git versions
if [ "$(echo "$gitversion" | sed 's/\ //' | egrep "1\.[1-7]")" ] && [ -e "$home/.gitconfig" ]
then
	# push setting not supported, so removing it
	sed -i '/\[push\]/d;/default\ =\ /d;' ~/.gitconfig
	echo "removed push default setting due to low version"
fi

# updating submodules
git submodule init > /dev/null && git submodule update > /dev/null && echo "configured submodules"

# now some configs only for mac
if [[ "$(uname -s)" = "Darwin" ]]
then
	# disable mouse scrolling inertia, this sucks, i want only one speed
	defaults write .GlobalPreferences com.apple.scrollwheel.scaling -1
	defaults write .GlobalPreferences com.apple.mouse.scaling -1
fi

# hint about cronjob
echo "How about adding a cronjob to stay in sync?"
echo "1/5 *  *   *   *  bash -c 'echo \"\$(date) - start zsh git\" >>/tmp/git.log ; cd /home/user/.dotfiles/; git pull 2>> /tmp/git.log; echo \"\$(date) - end zsh git\" >> /tmp/git.log'"

# end script
echo "script ended"
