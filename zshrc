# set the right locale env for myself
# set de_CH.utf*8 or C
export LC_CTYPE="$(locale -a 2>/dev/null | grep -i de_ch | grep -i utf || echo "C")"

# set the right term
if [ "$TERM" = "xterm" ] ; then
    if [ -z "$COLORTERM" ] ; then
        if [ -z "$XTERM_VERSION" ] ; then
            echo "Warning: Terminal wrongly calling itself 'xterm'."
        else
            case "$XTERM_VERSION" in
            "XTerm(256)") TERM="xterm-256color" ;;
            "XTerm(88)") TERM="xterm-88color" ;;
            "XTerm") ;;
            *)
                echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION"
                ;;
            esac
        fi
    else
        case "$COLORTERM" in
            gnome-terminal|roxterm|mate-terminal)
                # Those crafty Gnome folks require you to check COLORTERM,
                # but don't allow you to just *favor* the setting over TERM.
                # Instead you need to compare it and perform some guesses
                # based upon the value. This is, perhaps, too simplistic.
                TERM="gnome-256color"
                ;;
            *)
                echo "Warning: Unrecognized COLORTERM: $COLORTERM"
                ;;
        esac
    fi
fi
SCREEN_COLORS="`tput colors`"
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        screen-*color-bce)
            echo "Unknown terminal $TERM. Falling back to 'screen-bce'."
            export TERM=screen-bce
            ;;
        *-88color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-88color'."
            export TERM=xterm-88color
            ;;
        *-256color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-256color'."
            export TERM=xterm-256color
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        gnome*|xterm*|konsole*|aterm|[Ee]term)
            echo "Unknown terminal $TERM. Falling back to 'xterm'."
            export TERM=xterm
            ;;
        rxvt*)
            echo "Unknown terminal $TERM. Falling back to 'rxvt'."
            export TERM=rxvt
            ;;
        screen*)
            echo "Unknown terminal $TERM. Falling back to 'screen'."
            export TERM=screen
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi

# Set up the prompt
autoload -Uz promptinit
promptinit

# use emacs key binding
bindkey -e

# my other things for keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey -s '^F' 'ls -alFh --color=auto\n'
bindkey "^J" accept-line
bindkey "^K" kill-line
bindkey "^L" clear-screen
bindkey "^R" history-incremental-search-backward
bindkey "^T" history-incremental-search-forward
bindkey -s '^U' 'cd ../\n'
bindkey "^W" backward-kill-word
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey '^[[3;5~' backward-delete-word # ctrl del delete word
# i dont know why my bindkey differs sometimes but it should work with the following ones
bindkey '^[[A' up-line-or-history
bindkey '^[OA' up-line-or-history
bindkey '^[[B' down-line-or-history
bindkey '^[OB' down-line-or-history
bindkey "^[OC" forward-char
bindkey "^[[C" forward-char
bindkey "^[OD" backward-char
bindkey "^[[D" backward-char

# I love history in ZSH
HISTSIZE=100000000
SAVEHIST=100000000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit
# some things i do not understand exactly
# they belong to completion module
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:killall:*' command 'ps -u $USER -o command'

# turn on interactive comments
setopt interactivecomments

# perform path expansion
setopt EQUALS

# it was told me to do that
unsetopt MULTIBYTE

# some more strange things
setopt menu_complete

# correction?? I do not know..
setopt correct

# share history with all terminals open
setopt share_history

# because someday i will learn advanced pattern matching
# # it sounds very useful, like regexps
setopt extended_glob

# ignore duplicates in history
setopt histignoredups

# ignore commands with preceding space in history
# seems not to work :/
setopt histignorespace

# save timestamps of commands
setopt extended_history

# because i love history, appendixes, and appending things
setopt appendhistory

# don't assume i want to cd, that's fucking rude
unsetopt autocd

# seriously why does this shit even exist
unsetopt beep

# DON'T YOU YELL AT ME WHEN YOU CAN'T FIND A MATCH
# THAT'S YOUR PROBLEM, _NOT_ MINE
unsetopt nomatch

# when i put a process in the background,
# it's code for "fuck off and leave me alone"
unsetopt notify

# make automatic / with 2 dots (.)
# useful if: ...... ==> ../../../
rationalise-dot() {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

# lets files beginning with a . be matched without explicitly specifying the dot
setopt globdots

# prevents you from accidentally overwriting an existing file
setopt noclobber

# something with prompt things.. actually i do not know what this does
setopt PROMPT_SUBST

# source aliases
source ~/.dotfiles/zshrc.alias

# exports
export EDITOR="vim"
export GIT_EDITOR="vim +startinsert"
export PAGER="less"
export PATH="/home/wolf/local/bin:$PATH"

# source local config (testing or so)
if [ -f ~/.dotfiles/zshrc.local ]
then
	source ~/.dotfiles/zshrc.local
fi
# source autojump if installed
if [ -f /usr/share/autojump/autojump.sh ]
then
	source /usr/share/autojump/autojump.sh
elif [ -s ~/.autojump/etc/profile.d/autojump.sh ]
then
	source ~/.autojump/etc/profile.d/autojump.sh
fi

# colors are beautiful
# even if I do not understand what this command means exactly
autoload -U colors
colors

####################
#################### my custom functions
####################

# chwhois
# create the makessl command with prefilled whois infos for .ch domains
# have a look at github.com/thonixx/easyssl
function whoiscom() {
	# define .ch domain
	domain="$1"
	# sed for address output of whois request
	output="$(whois "$domain" | grep Registrant)"
	
	# parse organisation/holder
	org="$(echo "$output" | grep -i "Registrant Organization" | awk -F: '{print $2}' | sed -e 's/^[ \t]*//')"
	# parse country code
	c="$(echo "$output" | grep -i "Registrant Country" | awk -F: '{print $2}' | sed -e 's/^[ \t]*//')"
	# parsing a state is difficult so fill with country
	s="$(echo "$output" | grep -i "Registrant State" | awk -F: '{print $2}' | sed -e 's/^[ \t]*//')"
	# parse city
	l="$(echo "$output" | grep -i "Registrant City" | awk -F: '{print $2}' | sed -e 's/^[ \t]*//')"
	
	# print the result
	echo "makessl -p SSL_ -d $(test -z $2 && echo www || echo $2).$domain -o \"$org\" -c \"$c\" -l \"$l\" -s \"$s\""
}

# chwhois
# create the makessl command with prefilled whois infos for .ch domains
# have a look at github.com/thonixx/easyssl
function whoisch() {
	# define .ch domain
	domain="$1"
	# sed for address output of whois request
	output="$(whois "$domain" | sed -n '/Holder of domain name/,/Contractual Language/p' | head -n -2 | tail -n +2)"
	
	# parse organisation/holder
	org="$(echo "$output" | sed -n -e '1p')"
	# parse country code
	c="$(echo "$output" | tail -n 1 | awk -F- '{print $1}')"
	# parsing a state is difficult so fill with country
	s="$c"
	# parse city
	l="$(echo "$output" | tail -n 1 | awk -F- '{print $2}' | sed -r 's/[[:digit:]][\ ]{0,}//g' | sed -r 's/[,](.*)//g')"
	
	# print the result
	echo "makessl -p SSL_ -d $(test -z $2 && echo www || echo $2).$domain -o \"$org\" -c \"$c\" -l \"$l\" -s "
}

# spellit
# spell everything in german
function spellit() {
	input="$(echo $1 | sed 's/\./ /g')"
	$(which bash) -c "echo -n \"$input\" | while IFS= read -r -n1 c; do [ \"\$c\" ] && echo -n \"\$c \"; [ \"\$c\" ] && echo 'anton
berta
cäsar
dora
emil
friedrich
gustav
heinrich
ida
julius
kaufmann
ludwig
martha
nordpol
otto
paula
quelle
richard
samuel
theodor
ulrich
viktor
wilhelm
xaver
ypsilon
zacharias' | grep -iE \"^\$c\" || echo \"\$c\" | head -n1; done"
}

# tputcolors
# source: http://linuxtidbits.wordpress.com/2008/08/11/output-color-on-bash-scripts/
function tputcolors() {
	echo
	echo -e "$(tput bold) reg  bld  und   tput-command-colors$(tput sgr0)"

	for i in $(seq 1 7); do
		echo " $(tput setaf $i)Text$(tput sgr0) $(tput bold)$(tput setaf $i)Text$(tput sgr0) $(tput sgr 0 1)$(tput setaf $i)Text$(tput sgr0)  \$(tput setaf $i)"
	done

	echo ' Bold            $(tput bold)'
	echo ' Underline       $(tput sgr 0 1)'
	echo ' Reset           $(tput sgr0)'
	echo
}

# simple stopwatch function
# scripted by github.com/thonixx
function stopwatch () {
	########
	# config
	
	# initialise seconds and start with second 1
	sec=1
	# define maximum of dots to display
	maxdots=10
	# initialise count for the dots at the beginning
	startdot=1
	# date when stopwatch was started
	startdate=$(date +%s)
	
	# start the first output with current time
	echo "Stopwatch started: $(date -d @$startdate)"

	# while loop to count the seconds
	while [ true ] 
	do
		# calculate the time based on date
		let "sec = $(date +%s) - $startdate + 1"

		# display seconds if under 1 minute
		if [ "$sec" -lt 60 ]
			# fill time with raw seconds
			then time="$sec"
		# switch to minutes if more than 60 seconds
		else min=$(expr $sec / 60)
			# calculate the seconds minus the minutes
			relSec=$(expr $sec - $min \* 60)
			# fill time with minutes and relative seconds
			time="$min"'m'" $relSec"
		fi
		
		# define the dots (just for beauty)
		dotloop=0
		
		# reset the variable
		dotPrint=""
		
		# print the dots
		while [ "$dotloop" -lt "$startdot" ]
		do
			# append
			dotPrint="$dotPrint."
			# increase
			let "dotloop = dotloop + 1"
		done
		
		# calculate required spaces
		actualChars=$(echo -n "$dotPrint" | wc -c)
		spacesToPrint=$(expr $maxdots - $actualChars)
		
		# add the spaces
		spacesAdded=0
		
		# initialise output
		spaces=""
		
		# add the required spaces
		while [ "$spacesAdded" -lt "$spacesToPrint" ]
		do
			# append the white spaces
			spaces="$spaces "
			
			# calculate spaces left
			let "spacesAdded = $spacesAdded + 1"
		done
		
		# merge dots and spaces
		dotPrint="$dotPrint$spaces"
		
		# print the current time
		# http://stackoverflow.com/questions/11283625/bash-overwrite-last-terminal-line
		echo -ne "\e[0K\r   Time: $time"'s'" $dotPrint "
		
		# wait a second before continueing
		sleep 1 || echo "hi"
		
		# calculate the next count for the dots
		startdot=$(if [ "$startdot" -lt "$maxdots" ]; then expr $startdot + 1; else echo "1"; fi)
	done
}

# check which mails were sent for a login
# scripted by github.com/thonixx
mailcheck () {
	# abort if no argument
	if [ -z "$1" ]
	then
		echo "I need a SASL user name"
		return
	fi

	# set ip counter to 0
	ips="0"

	# go through found message ids and logins
	for id in `grep $1 /var/log/mail.log | grep "sasl_method=" | grep "sasl_username=" | egrep -o "[A-Z0-9]{11,12}"`
	do
		# parse for ip
		ip=$(grep $id /var/log/mail.log | grep "sasl_method=" | grep "sasl_username=" | egrep -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | head -n 1)

		# check if the new ip is the same like from the previous loop run
		if [ "$ip" != "$oldip" ]
		then
			# print only output if ip is not empty (at the beginning oldip is empty)
			if [ ! -z "$oldip" ]
			then
				echo "$oldcount mails"
				let total+="$oldcount"
				echo ""
				echo "****************"
				echo "$domains" | sort | uniq -c | sort -n | tail -n 20
				echo "****************"
			fi
					
			echo ""
			echo ""
			# print ip with reverse entry
			echo -n "$ip ($(dig +short -x $ip)) sent "
			# reset variables to start another ip group
			oldcount="0"
			prevdom=""
			domains=""

			# count how much ip addresses
			let ips+="1"
		fi

		# count emails which were sent successfully
		count=$(grep $id /var/log/mail.log | grep sent | grep -E "to=([<>a-zA-Z0-9\.\@_-]*)" | wc -l)
		# the new sum from this loop round
		let newcount="$count"+"$oldcount"

		# used for the checks at the beginning and grouping for ip
		oldip="$ip"
		# feed counter with new total for this group
		oldcount="$newcount"

		# check if variable is empty to append only if something is in it
		if [ ! -z "$domains" ]
		then
			domains="$domains
	$(grep $id /var/log/mail.log | grep sent | grep -E "to=([<>a-zA-Z0-9\.\@_-]*)" | awk -F\@ '{print $2}' | awk -F\> '{print $1}')"
		else
			domains="$(grep $id /var/log/mail.log | grep sent | grep -E "to=([<>a-zA-Z0-9\.\@_-]*)" | awk -F\@ '{print $2}' | awk -F\> '{print $1}')"
		fi
	done

	# for last one output out of loop
	echo "$oldcount mails"
	# count total mails
	let total+="$oldcount"
	echo ""
	echo "****************"
	echo "$domains" | sort | uniq -c | sort -n | tail -n 20
	echo "****************"
	echo ""
	# print total mails sent
	echo "****"
	echo "Total mails sent: $total"
	echo "From $ips different IP addresses"
	echo "****"
}

# test mail delivery
# scripted by github.com/thonixx
function maildelivery {
	domain=$(echo "$1" | awk -F@ '{print $2}')
	mailserver=$(dig mx $domain +short | awk {'print $2'} | head -n 1)
	
	# test if something is in the output
	if [ -z "$mailserver" ]
	then
	    echo "There was no mailserver or no MX record. :("
	    return
	fi

	# custom server to connect to
	if [ ! -z "$2" ]
	then
		mailserver="$2"
	fi
	 
	echo "Email: $1"
	echo "Server: $mailserver"
	echo ""
	 
	(echo "helo $(hostname --fqdn)"
	sleep 2
	echo "MAIL FROM: <info@$(hostname --fqdn)>"
	sleep 2
	echo "RCPT TO:<$1>"
	sleep 2
	echo "QUIT") | netcat $mailserver 25
}

# test smtp login
# scripted by github.com/thonixx
function smtplogin {
	echo -n "Server: "
	read server
	echo ""

	echo -n "Username: "
	read user

	echo -n "Password: "
	read pass
	echo ""

	user64=$(echo -n "$user" | base64)
	pass64=$(echo -n "$pass" | base64)

	(echo "helo test"
	sleep 2
	echo "AUTH LOGIN"
	sleep 2
	echo "$user64"
	sleep 2
	echo "$pass64"
	sleep 2
	echo "QUIT") | netcat $server 25
}

# loop function
# run any command in a while loop with 1 second sleep
function loop() {
	if [ -z "$@" ]
	then
		return
	fi

	cmd="$@"

	while true
	do
		bash -c "$cmd"
		sleep 1
	done
}

# countdown function
# source http://ubuntuforums.org/showpost.php?p=9817891&postcount=9
function countdown() {
    [[ -z $1 ]] && seconds=60 || seconds=$1
    since=$(date +%s)
    remaining=$seconds
    while (( remaining >= 0 ))
    do 
        printf "\r%-10d" $remaining
        sleep 0.5
        remaining=$(( seconds - $(date +%s) + since ))
    done
    echo ""
}

# translation functions
function leo() {
	w3m -dump "http://pda.leo.org/?search=\"$*\"" | sed -n -e :a -e '1,9!{P;N;D;};N;ba' | sed -e '1,14d'
}
function leofr(){
	w3m -dump "http://pda.leo.org/?lp=frde&search=\"$*\"" | sed -n -e :a -e '1,9!{P;N;D;};N;ba' | sed -e '1,14d'
}
function dictcc() {
	w3m -dump "http://pocket.dict.cc?s=\"$*\"" | sed -r -e '/^([ ]{5,}.*)$/d' -e '1,2d' -e '/^$/d' -e '/^\[/d'
}

# do a reverse lookup
reverse() {
	# put request in variable
	request="$1"

	# check for request
	if [ -z "$request" ]
	then
		echo "Please provide an IP or host name.".
		return
	fi
	
	# check for "dig" installed
	if [ -z "$(which dig)" ]
	then
		echo "Please install dig, we need it:"
		echo "sudo apt-get install dig (for Ubuntu/Debian)"
		return
	fi
	
	# decide if its an ip or name
	if [ "$(echo $request | egrep -o '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}')" ]
	then
		# would be an IP

		# for later check of any reverse
		check="false"

		# save/set IFS
		oldifs=$IFS
		IFS=$'\n'
		
		# loop through ptr records
		for r in $(dig +tcp +short -x $request 2> /dev/null)
		do
			# print ip address
			echo -n "$request"

			# print PTR
			echo " > $r"
			
			# set check to true due to at least one PTR
			check="true"
		done

		# set the old IFS
		export IFS=$oldifs

		# check if any ptr was found
		if [ $check == "false" ]
		then
			echo -ne "No reverse entry for $request.\n"
		fi
	else
		# would be a hostname

		# check if any output there
		if [ -z "$(dig a +search +short +tcp $request 2> /dev/null | egrep -o '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}')" ]
		then
			echo "No A records found for $request."
			return
		else
			# continue with a record(s)

			# save/set IFS
			oldifs=$IFS
			IFS=$'\n'

			# loop through A records
			for i in $(dig a +search +short +tcp $request 2> /dev/null | egrep -o '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}')
			do
				# for later check of any reverse
				check="false"

				# loop through ptr records
				for r in $(dig +tcp +short -x $i 2> /dev/null)
				do
					# print request and ip
					echo -n "$request > $i"

					# print PTR
					echo " > $r"
					
					# set check to true due to at least one PTR
					check="true"
				done

				# check if any ptr was found
				if [ $check == "false" ]
				then
					echo -ne "$request > $i > No reverse entry.\n"
				fi

			done

			# set the old IFS
			export IFS=$oldifs
		fi
	fi
}

# check ssl certificate <> private key
sslcheck() {
	echo ""
	# check if its a certificate
	if [ ! "$1" ] || [ ! "$(grep "CERTIFICATE-" $1 2>/dev/null)" ]
	then
		echo 'Give me a certificate.'
		echo ""
		return
	fi
	# check if its a private key
	if [ ! "$2" ] || [ ! "$(grep PRIVATE $2 2> /dev/null)" ]
	then
		echo 'Give me a private key.'
		echo ""
		return
	fi
	
	# better comparing with variables
	
	# try to determine errors with certificate
	openssl x509 -noout -modulus -in "$1" &> /dev/null
	if [ $? -ne 0 ] ; then echo "There was an error with your certificate." ; echo "Maybe rather a CSR? Or malformed certificate?" ; echo "" ; return ; fi
	cert=`openssl x509 -noout -modulus -in "$1" 2>/dev/null | openssl md5`

	# try to determine errors with private key	
	openssl rsa -noout -modulus -in "$2" &> /dev/null
	if [ $? -ne 0 ] ; then echo "There was an error with your private key." ; echo "" ; return ; fi
	key=`openssl rsa -noout -modulus -in "$2" 2>/dev/null | openssl md5`

	# check with openssl command and hashing
	if [ "$cert" == "$key" ]
	then
		echo '  Yay, everything okay.'
	else 
		echo '  Sorry, it does not match.' 
	fi

	echo ""
}

####################
#################### end of my custom functions
####################


# if command not found
if [[ -x /usr/lib/command-not-found ]] ; then
	function command_not_found_handler() {
		/usr/lib/command-not-found --no-failure-msg -- $1
	}
fi

# set $USER if not exists
if [ -z "$USER" ]
then
	USER="$(whoami)"
	export USER="$(whoami)"
fi

# define env file for ssh-agent informations
AGENT_ENV_FILE="/tmp/agent.$USER.env"
PGREP_SSH_AGENT="$(pgrep -u $USER ssh-agent)"

# start ssh-agent if none is started
if [ -z "$PGREP_SSH_AGENT" ]
then
	# remove agent file
	rm $AGENT_ENV_FILE 2> /dev/null
	# write agent info to file
	eval $(ssh-agent | tee $AGENT_ENV_FILE)
	# regrep for ssh-agent process since it is running now
	PGREP_SSH_AGENT="$(pgrep -u $USER ssh-agent)"
elif [ "$PGREP_SSH_AGENT" ] && [ -f "$AGENT_ENV_FILE" ]
then
	# source existing agent
	. $AGENT_ENV_FILE 2> /dev/null
fi

# add ssh keys to ssh-agent if running
if [ "$PGREP_SSH_AGENT" ] && [ "$(ssh-add -l | grep -v "The agent has no identities." | grep -Eio "([0-9A-F]{2}:)+[0-9A-F]{2}" | sort | uniq | wc -l)" -lt "$(ls -l ~/.ssh/ 2>/dev/null | grep -E "(.key|id_[dr]sa)$" | wc -l)" ]
then
	ssh-add ~/.ssh/*.key 2> /dev/null
	ssh-add ~/.ssh/id_rsa 2> /dev/null
	ssh-add ~/.ssh/id_dsa 2> /dev/null
fi

# list tmux sessions if tmux running
pgrep -u $USER tmux 2> /dev/null > /dev/null
if [ $? -eq 0 ]
then
	# reinitialize envs for tmux server
	tmux setenv SSH_AUTH_SOCK $SSH_AUTH_SOCK; tmux setenv SSH_AGENT_PID $SSH_AGENT_PID;
	# list tmux sessions
	echo ""
	echo "Running tmux sessions:"
	tmux ls 2> /dev/null || echo "no tmux session running"
	echo ""
fi


# my nice prompt template

function precmd() {

	# prompt for right side of screen
	RPROMPT='[%*]'
	
	# TMUX <3 stuff
	parse_tmux () {
		test ! -z "$TMUX" && echo "session: $(tmux display-message -p '#S')\nwindow: $(tmux display-message -p '#I')\npane: $(tmux display-message -p '#P')"
	}
	parsetmux="$(parse_tmux)"

	# display tmux stuff
	if [ "$parsetmux" ]
	then
		local c1="$(tput setaf 172)"
		local c2="$(tput setaf 227)"
		local tmuxline=" ${c1}tmux-(${c2}#$(echo "$parsetmux" | grep pane | awk '{print $2}')${c1}@${c2}$(echo "$parsetmux" | grep session | awk '{print $2}')${c1})%{$reset_color%}"
	else
		tmuxline=""
	fi
	
	# GIT stuff
	parse_git_branch () {
		git branch 2> /dev/null | grep --color=auto "*" | sed -e 's/* \(.*\)/\1/g'
	}

	# display git stuff at the right side if anything detected
	if [ "$(parse_git_branch)" ]
	then
		local git=" %{$fg[green]%}git %{$fg[cyan]%}⎇  $(parse_git_branch)%{$reset_color%}"
	
		# get git status
		gitstatus="$(git status --porcelain 2> /dev/null)"

		# colorize gitline
		gitline="${git}"
		# calculate files modified
		count="$(echo "$gitstatus" 2> /dev/null | egrep "^\s{0,}M" | wc -l)"
		[[ "$count" -gt 0 ]] && gitline="${gitline} %{$fg[red]%}×${count}"
		# calculate files newly added
		count="$(echo "$gitstatus" 2> /dev/null | egrep "^\s{0,}A" | wc -l)"
		[[ "$count" -gt 0 ]] && gitline="$gitline %{$fg[green]%}+${count}"
		# calculate files renamed
		count="$(echo "$gitstatus" 2> /dev/null | egrep "^\s{0,}R" | wc -l)"
		[[ "$count" -gt 0 ]] && gitline="$gitline %{$fg[yellow]%}~${count}"
		# calculate files deleted
		count="$(echo "$gitstatus" 2> /dev/null | egrep "^\s{0,}D" | wc -l)"
		[[ "$count" -gt 0 ]] && gitline="$gitline %{$fg[cyan]%}-${count}"
		# calculate files untracked
		count="$(echo "$gitstatus" 2> /dev/null | egrep "^\s{0,}\?\?" | wc -l)"
		[[ "$count" -gt 0 ]] && gitline="$gitline %{$fg[white]%}${count}"
		# some symbols:  # ⁇ ⁂ ● ⚛ ⁙ ᛭ ⚫ ⚪ ✓ ×    
		# reset colors
		gitline="${gitline}%{$reset_color%}"
	else
		gitline=""
	fi

	# SVN stuff
	parse_svn_repo () {
		svn info 2> /dev/null | grep -E "^URL" | awk -F\/ '{print $3}' #| awk -F@ '{print $2}'
	}
	# display svn stuff at the right side if anything detected
	if [ "$(parse_svn_repo)" ]
	then
		local svn=" %{$fg[green]%}svn://%{$fg[cyan]%}$(parse_svn_repo)%{$reset_color%}"
	fi

	# needed for exit status smiley/char
	# local exit="%(?,%{$fg[green]%}✔%{$reset_color%},%{$fg[red]%}✘%{$reset_color%})"
	local exit="%(?..%{ $fg[red]%}✘%{$reset_color%})"
	
	# parse pwd structure and build something nice out of it
	# dire=$(dirs | sed 's/\// › /g') # »
	dire="$(dirs)"
	
	# check if user is root
	local root=""
	if [ "$(whoami)" == "root" ]
	then
		local root=" %{$fg[white]%}%{$bg[red]%}root%{$reset_color%}"
	fi

	# decide which prompt
	case "$(hostname)" in
		mnt[0-9a-z]* )
			local firstline="%{$fg[green]%}%n%{$fg[white]%}@%{$fg[blue]%}%M%{$fg[white]%}:%y" ;;
		"zotherserv" )
			local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} WEBSERVER" ;;
		"pixelwolf" )
			local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} CORE" ;;
		"mailserv" )
			local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} MAILSERVER" ;;
		"woulfserv.pixelwolf.ch" | "woulfserv" )
			local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} KVMHOST" ;;
		"pixelwolf-us" )
			local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} %{$fg[cyan]%}UNITED STATES%{$fg[white]%}" ;;
		"pixelwolf-is" )
			local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} %{$fg[cyan]%}ICELAND%{$fg[white]%}" ;;
		* )
			local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[red]%}%M%{$fg[white]%}:%y" ;;
	esac

	# append git/svn/other things
	firstline="${firstline}${exit}${tmuxline}%{$fg[white]%}${gitline}${svn}${root}"
	
	# define 2nd line globally for all hosts
	local secondline="%{$fg[yellow]%}${dire} %{$fg[white]%}%% %{$reset_color%}"

	# finish the prompt
	PS1="$firstline
$secondline"
	
}

# END FOR PROMT STYLING

# fix broken chmod 777 colors
LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=01;34:ow=01;34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.svgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:"

# include the awesome and colorful zsh highlighting
source ~/.dotfiles/highlighting/zsh-syntax-highlighting.zsh
# tweak the highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=grey' # bug with cursor color on gnome shell
# pattern highlight
ZSH_HIGHLIGHT_PATTERNS+=('sudo' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf*' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rfv*' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rv*' 'fg=white,bold,bg=red')
