### Installing
Just execute 'install.sh' to link the necessary files and initialize the repo for the first time.

### Info
At this stage the zsh configuration with its mods and the tmux.conf are synchronized within this repo.

#### Sync
To stay in sync I have the following cronjob activated:

    1/5 *  *   *   *  bash -c 'echo "$(date) - start dotfiles git" >>/tmp/git.log ; cd /home/user/.dotfiles/; git pull &> /tmp/git.log; echo "$(date) - end dotfiles git" >> /tmp/git.log'

#### Zsh
The zsh config is designed to work on 256-colours terminals, therefore install "ncurses-term" to get the colours working.

#### Tmux
The tmux config applies to version 1.8 which is currently only available in Ubuntu 14.04 LTS.
I compiled tmux by myself with version 1.8 to get some config tweaks working.
Compiling tmux is very simple and basically just requires "configure" and "make" - just give it a try ;-).

#### Vim
In the folder vim/ a file called vimrc.local can be created for testing purposes
