#!/bin/bash

################################################################################
##### CONFIG

# define directory where all files are stored
SCRIPT_NAME="${0##*/}"
SCRIPT_PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# check for env var HOME or assume /home/USER
if [ "$HOME" ]
then
    home="$HOME"
else
    home="/home/$USER"
fi

################################################################################
##### PREPARATIONS (backup, move, etc)

function backup(){

    # backup config if file exists or unlink it
    config="$1"
    path="$home/$config"

    # do the magic
    if [ -h "$path" ]
    then
        # remove symlink
        rm "$path" && echo "$config: symlink removed"
    elif [ -e "$path" ]
    then
        # backup config
        mv "$path" "$path.bak" && echo "$config: backup done"
    else
        # do nothing
        echo "$config: no previous config, continuing"
    fi
}

backup .irssi
backup .zshrc
backup .tmux.conf
backup .vimrc
backup .vim
backup .ssh/config
# backup .gitconfig # should be removed/backed up
backup .config/zathura

################################################################################
##### INSTALL CONFIGS

function putconfig(){
    # arguments
    source="$SCRIPT_PWD/$1"
    target="$2"

    # link it
    config="$(basename "$target")"
    test -e "$source" && ln -s "$source" "$target" && echo "$config: linked"
}

# irssi
putconfig irssi "$home/.irssi"

# tmux
putconfig tmux/tmux.conf "$home/.tmux.conf"

# link zshrc
putconfig zsh/zshrc "$home/.zshrc"

# link vim
putconfig vim "$home/.vim"

# link vimrc
putconfig vim/vimrc "$home/.vimrc"

# link ssh config
putconfig ssh/ssh_default_config "$home/.ssh/config"

# link zathura config
putconfig zathura "$home/.config/zathura"

################################################################################
##### POST INSTALL STUFF

# modify tlib dir option
if [[ -z "$(grep -A 3 tlib.git .git/config | grep "ignore = dirty")" ]]
then
    sed -i.bak 's/tlib.git$/tlib.git\
    ignore = dirty/g' .git/config && echo "added ignore option to tlib submodule"
fi

# link dotfiles folder
if [ ! -d "$home/.dotfiles" ]
then
    ln -s "$SCRIPT_PWD" "$home/.dotfiles" && echo ".dotfiles folder linked"
fi

################################################################################
##### GIT INSTALL

# find out git version before doing git configuration
gitversion="$(git --version | grep -Eo "\ [1-9]\.[0-9]" | sed 's/\ //')"

# only append gpg encrypted content if not already there
if [[ -z "$(grep -s email ~/.gitconfig)" ]]
then
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
        gpg < "$SCRIPT_PWD/git/gitconfig.$type.gpg" > "$home/.gitconfig" && echo ".gitconfig.$type is now installed"
        # append gitconfig content
        cat "$SCRIPT_PWD/git/gitconfig" >> "$home/.gitconfig" && echo ".gitconfig content appended"
    fi
else
    # config is there already, displaying a diff if there are changed settings from dotfiles repo
    echo
    echo 'Here is a possible diff of your local config compared to the remote repo config:'
    diff "$home/.gitconfig" "$SCRIPT_PWD/git/gitconfig"
    echo
    echo 'You can decide later which settings you want to apply.'
    echo
fi

# remove push setting for older git versions
if [ "$(echo "$gitversion" | sed 's/\ //' | egrep "1\.[1-7]")" ] && [ -e "$home/.gitconfig" ]
then
    # push setting not supported, so removing it
    sed -i '/\[push\]/d;/default\ =\ /d;' ~/.gitconfig
    echo "removed push default setting due to low version"
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
echo

# hint about cronjob
echo "How about adding a cronjob to stay in sync?"
echo "*/5 *  *   *   *  bash -c 'git -C $SCRIPT_PWD pull'"
echo
