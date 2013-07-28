Prerequisites
====
You need vim and a terminal with 256 colors (ncurses-term).

Installation
====

Clone the repo in your home under .zsh (default as this repo is called .vim).
After cloning, go to that directory (on your terminal of course) and execute install.sh:

    bash install.sh

Note
====
Do whatever you want with this repo. Actually the repo just helps me keeping all servers in sync with my vim settings. I am too lazy to set it up on every new server manually and then syncing all changes manually. So a cronjob with "git pull" is the best thing, I think.

To test vim settings locally I add them in the file "vimrc.local". They are ignored by git and included by the vim configuration. After I finished testing new features I move the lines over to vimrc.
