#!/bin/bash

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
home=$(echo $HOME)

ln -s $dir/vimrc $home/.vimrc && echo "symlinked to $home/.vimrc"
git submodule init && echo "initialized submodules"
git submodule update && echo "updated submodules"
sed -i.bak "s/tlib.git$/tlib.git\n\tignore = dirty/g" .git/config && echo "added ignore option to tlib submodule"
touch $dir/vimrc.local

echo "vim should be ready to use. maybe install the 256 color ability for your terminal (ncurses-term)."
