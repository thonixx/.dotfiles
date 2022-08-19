#!/bin/bash

################################################################################
##### CONFIG

# define directory where all files are stored
SCRIPT_NAME="${0##*/}"
SCRIPT_PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# check for env var HOME or assume /home/USER
if [ "${HOME}" ]
then
    home="${HOME}"
else
    home="/home/${USER}"
fi

################################################################################
##### PREPARATIONS (backup, move, etc)

function backup(){

    # backup config if file exists or unlink it
    config="${1}"
    path="${home}/${config}"

    # do the magic
    if [ -h "${path}" ]
    then
        # remove symlink
        rm "${path}" && echo "${config}: symlink removed"
    elif [ -e "${path}" ]
    then
        # backup config
        mv "${path}" "${path}.bak" && echo "${config}: backup done"
    else
        # do nothing
        echo "${config}: no previous config, continuing"
    fi
}

backup .irssi
backup .zshrc
backup .tmux.conf
backup .vimrc
backup .vim
backup .ssh/config
backup .ssh/ssh.local
# backup .gitconfig # should be removed/backed up
backup .config/zathura
backup .gnupg/gpg-agent.conf
backup .gnupg/gpg.conf
backup .config/redshift
backup .xscreensaver
backup .xsessionrc
backup .Xresources
backup .themes/Ambiant-MATE-Dark
backup .icons/Ambiant-MATE

################################################################################
##### INSTALL CONFIGS

function putconfig(){
    # arguments
    source="${SCRIPT_PWD}/${1}"
    target="${2}"

    # link it
    config="$(basename "${target}")"
    test -e "${source}" && ln -s "${source}" "${target}" && echo "${config}: linked"
}

# irssi if installed
dpkg -l irssi 2> /dev/null | grep -qE '^ii' && {
    putconfig irssi "${home}/.irssi"
}

# tmux
putconfig tmux/tmux.conf "${home}/.tmux.conf"

# link zshrc
putconfig zsh/zshrc "${home}/.zshrc"

# link vim
putconfig vim "${home}/.vim"

# link vimrc
putconfig vim/vimrc "${home}/.vimrc"

# link ssh config
putconfig ssh/ssh_default_config "${home}/.ssh/config"
putconfig ssh.local "${home}/.ssh/ssh.local"

# link zathura config
dpkg -l zathura 2> /dev/null | grep -qE '^ii' && {
    putconfig zathura "${home}/.config/zathura"
}

# link gpg-agent config
putconfig gpg/gpg-agent.conf "${home}/.gnupg/gpg-agent.conf"

# create gpg.conf
echo
gpg -K
echo
read -p 'Provide your main GPG key id for gpg conf for hidden-ecrypt-to (format 0x...) for GPG config: ' gpg
echo "hidden-encrypt-to $gpg" > $HOME/.gnupg/gpg.conf

# link redshift config if installed
dpkg -l redshift 2> /dev/null | grep -qE '^ii' && {
    putconfig redshift "${home}/.config/redshift"
}

# link xscreensaver config if installed
dpkg -l xscreensaver 2> /dev/null | grep -qE '^ii' && {
    putconfig xscreensaver/xscreensaver "${home}/.xscreensaver"
    putconfig xscreensaver/xsessionrc "${home}/.xsessionrc"
    putconfig xscreensaver/Xresources "${home}/.Xresources"
}

# themes/icons
putconfig themes/Ambiant-MATE-Dark "${home}/.themes/Ambiant-MATE-Dark"
putconfig icons/Ambiant-MATE "${home}/.icons/Ambiant-MATE"

################################################################################
##### POST INSTALL STUFF

# modify tlib dir option
if [[ -z "$(grep -A 3 'tlib.git' .git/config | grep 'ignore = dirty')" ]]
then
    sed -i.bak 's/tlib.git$/tlib.git\
    ignore = dirty/g' .git/config && echo 'added ignore option to tlib submodule'
fi

# link dotfiles folder
if [ ! -d "${home}/.dotfiles" ]
then
    ln -s "${SCRIPT_PWD}" "${home}/.dotfiles" && echo '.dotfiles folder linked'
fi

################################################################################
##### GIT INSTALL

# find out git version before doing git configuration
gitversion="$(git --version | grep -Eo '\ [1-9]\.[0-9]' | sed 's/\ //')"

# only append gpg encrypted content if not already there
if [[ -z "$(grep -s 'email' ~/.gitconfig)" ]]
then
    # ask whether use personal or work settings
    echo -n 'type "personal" or "work" and press enter: '
    read env

    # check for input
    if [ -z "${env}" ]
    then
        echo .no input given. skipping gitconfig..
    else
        # copy type specific git config
        case ${env} in
            'work')
                type='work'
            ;;
            'personal'|*)
                type='personal'
            ;;
        esac

        # add header
        cat "${SCRIPT_PWD}/git/gitconfig_head" > "${home}/.gitconfig" && echo ..gitconfig head is now installed.

        # decrypt and save it
        gpg < "${SCRIPT_PWD}/git/gitconfig.${type}.gpg" >> "${home}/.gitconfig" && echo ".gitconfig ${type} appended"

        # append gitconfig content
        cat "${SCRIPT_PWD}/git/gitconfig_body" >> "${home}/.gitconfig" && echo ..gitconfig body appended.

    fi
else
    # config is there already, displaying a diff if there are changed settings from dotfiles repo
    echo
    echo 'Diffing git config file...'

    # create a temporary git config for diffing
    tempfile="$(mktemp)"

    # add head & body
    cat "${SCRIPT_PWD}/git/gitconfig_head" "${SCRIPT_PWD}/git/gitconfig_body" > ${tempfile}

    # do the diff
    vimdiff ${tempfile} "${home}/.gitconfig"
fi

# remove push setting for older git versions
if [ "$(echo "${gitversion}" | sed 's/\ //' | egrep '1\.[1-7]')" ] && [ -e "${home}/.gitconfig" ]
then
    # push setting not supported, so removing it
    sed -i '/\[push\]/d;/default\ =\ /d;' ~/.gitconfig
    echo 'removed push default setting due to low version'
fi

# notify about packages to be installed
echo "For syntax highlighting, don't forget to install:"
echo 'yamllint puppet-lint jsonlint'
echo

# hint about cronjob
echo "How about adding a cronjob to stay in sync?"
echo "*/5 *  *   *   *  bash -c 'git -C ${SCRIPT_PWD} pull'"
echo
