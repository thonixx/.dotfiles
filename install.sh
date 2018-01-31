#!/bin/bash

################################################################################
##### CONFIG

# define directory where all files are stored
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# check for env var HOME or assume /home/USER
if [ "$HOME" ]
then
    home="$HOME"
else
    home="/home/$USER"
fi

################################################################################
##### PREPARATIONS (backup, move, etc)

# path to zshrc configuration
zshrc="$home/.zshrc"

# backup zshrc if file exists or unlink it
if [ -h "$zshrc" ]
then
    unlink $zshrc && echo ".zshrc is now unlinked."
else
    mv $zshrc "$zshrc".bak 2> /dev/null && echo ".zshrc backed up."
fi

# backup tmuxconf if file exists or unlink it
if [ -h "$home/.tmux.conf" ]
then
    unlink $home/.tmux.conf && echo ".tmux.conf is now unlinked."
else
    mv $home/.tmux.conf $home/.tmux.conf.bak 2> /dev/null && echo ".tmux.conf backed up."
fi

# backup vim if file exists or unlink it
if [ -h "$home/.vimrc" ]
then
    unlink $home/.vimrc && echo ".vimrc is now unlinked."
else
    mv $home/.vimrc $home/.vimrc.bak 2> /dev/null && echo ".vimrc backed up."
fi

# backup vim folder if file exists or unlink it
if [ -h "$home/.vim" ]
then
    unlink $home/.vim && echo ".vim is now unlinked."
else
    mv $home/.vim $home/.vim.bak 2> /dev/null && echo ".vim backed up."
fi

################################################################################
##### IRSSI INSTALL

# backup irssi if folder exists or unlink it
if [ -h "$home/.irssi" ]
then
    unlink $home/.irssi && echo ".irssi is now unlinked."
else
    mv $home/.irssi $home/.irssi.bak 2> /dev/null && echo ".irssi backed up."
fi

################################################################################
##### ZSH INSTALL

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

################################################################################
##### GIT INSTALL

# find out git version before doing git configuration
gitversion="$(git --version | grep -Eo "\ [1-9]\.[0-9]" | sed 's/\ //')"

# only append gpg encrypted content if not already there
if [[ -z "$(grep -s email ~/.gitconfig)" ]]
then
    # backup gitconfig if file exists or unlink it
    if [ -h "$home/.gitconfig" ]
    then
        unlink $home/.gitconfig && echo ".gitconfig is now unlinked."
    else
        mv $home/.gitconfig $home/.gitconfig.bak 2> /dev/null && echo ".gitconfig backed up."
    fi

    # ask whether use personal or work settings
    echo -n "type 'personal' or 'work' and press enter: "
    read env

    # check for input
    if [ -z "$env" ]
    then
        echo "no input given. skipping gitconfig."
    else
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
    fi
fi

# remove push setting for older git versions
if [ "$(echo "$gitversion" | sed 's/\ //' | egrep "1\.[1-7]")" ] && [ -e "$home/.gitconfig" ]
then
    # push setting not supported, so removing it
    sed -i '/\[push\]/d;/default\ =\ /d;' ~/.gitconfig
    echo "removed push default setting due to low version"
fi

################################################################################
##### VIM INSTALL

ln -s $dir/vim $home/.vim && echo ".vim folder installed"
ln -s $dir/vim/vimrc $home/.vimrc && echo ".vimrc installed"
if [[ -z "$(grep -A 3 tlib.git .git/config | grep "ignore = dirty")" ]]
then
    sed -i.bak 's/tlib.git$/tlib.git\
    ignore = dirty/g' .git/config && echo "added ignore option to tlib submodule"
fi

################################################################################
##### LINK DOTFILES FOLDER

# link dotfiles folder
if [ ! -d "$home/.dotfiles" ]
then
    ln -s $dir $home/.dotfiles && echo ".dotfiles folder installed"
fi

################################################################################
##### INSTALL SUBMODULES

# updating submodules
git submodule init > /dev/null && git submodule update > /dev/null && echo "configured submodules"

################################################################################
##### DO MAC SPECIFIC THINGS

# now some configs only for mac
if [[ "$(uname -s)" = "Darwin" ]]
then
    # disable mouse scrolling inertia, this sucks, i want only one speed
    defaults write .GlobalPreferences com.apple.scrollwheel.scaling -1
    defaults write .GlobalPreferences com.apple.mouse.scaling -1
fi

################################################################################
##### END MAC THINGS

echo

# hint about cronjob
echo "How about adding a cronjob to stay in sync?"
echo "*/5 *  *   *   *  bash -c 'git -C $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) pull'"
echo

# end script
echo "vim should be ready to use. maybe install the 256 color ability for your terminal (ncurses-term)."
echo "script ended"
