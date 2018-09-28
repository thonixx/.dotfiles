### Installing
Just execute 'install.sh' to link the necessary files and initialize the repo for the first time.

### Info
At this stage the zsh configuration with its mods and the tmux.conf are synchronized within this repo.

#### Sync
To stay in sync I have the following cronjob activated:

    */5 *  *   *   *  git -C /home/user/.dotfiles/ pull

#### git
Local config: not available

#### irssi
Local config: not available

#### mutt
Local config: not available

#### ssh / ssh.local
Local config: ~/dotfiles/ssh.local/\*

#### tmux
The tmux config applies works from version 1.8.
Local config: not available

#### vim
In the folder vim/ a file called vimrc.local can be created for testing purposes
Local config: ~/.dotfiles/vim/vimrc.local

#### zsh
The zsh config is designed to work on 256-colours terminals, therefore install "ncurses-term" to get the colours working.
Local config: ~/.dotfiles/zsh/zshrc.local
