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
            gnome-terminal|roxterm)
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

# some helpful aliases
alias sgrep='cat /var/log/syslog | grep'
alias sigrep='cat /var/log/syslog | grep -i'
alias zshreload='. ~/.zshrc'
alias greprn='grep -rn'
alias greprin='grep -rin'
alias desc='apt-cache show'
alias agent='ssh -A'
alias remove='sudo aptitude remove'
alias install='sudo aptitude install'
alias extip='curl icanhazip.com'
alias vihosts='sudo vi /etc/hosts'
alias gitdiff='git diff HEAD^ HEAD'
alias proctime='ps -eo pid,user,cmd,etime | grep --color=never -i'
alias release='lsb_release -a'
alias gco='git commit -a -m'
alias gs='git status'
alias gabort='git checkout -f && git clean -f -d'
alias swap='for file in /proc/*/status ; do awk '"'"'/VmSwap|Name/{printf $2 " " $3}END{ print ""}'"'"' $file; done | sort -k 2 -n -r | less'
alias rainbow='for c in {0..255} ; do echo -e "\e[38;05;${c}m ${c} Raiiiiinbooooow" ; sleep 0.01 ; done'
alias grepcolors='for i in 1 2 4 7 8 9 30 31 32 33 34 35 36 37 38 41 42 43 44 45 46 47 90 91 92 93 94 95 96 97 100 101 102 103 104 105 106 107; do echo -n "GREP_COLOR=$i  " ; GREP_COLOR=$i grep -oE "[^\"]{1,15}" /var/log/syslog --color=always | head -n 1 ; done'
alias findproc='ps faux | head -n1; ps faux | grep -i'
# alias gitup="git pull -v --all --progress"
alias gitup="git pull -v --progress"
# alias stopwatch='since=$(date +%s); while true ; do eval "echo -n \$((\$(date +%s) - $since))" ; echo -n " " ; sleep 1 ; done'
alias toptables="mysql -e "\""SELECT CONCAT(table_schema, '.', table_name),
       CONCAT(ROUND(table_rows / 1000000, 2), 'M')                                    rows,
       CONCAT(ROUND(data_length / ( 1024 * 1024 * 1024 ), 2), 'G')                    DATA,
       CONCAT(ROUND(index_length / ( 1024 * 1024 * 1024 ), 2), 'G')                   idx,
       CONCAT(ROUND(( data_length + index_length ) / ( 1024 * 1024 * 1024 ), 2), 'G') total_size,
       ROUND(index_length / data_length, 2)                                           idxfrac
FROM   information_schema.TABLES
ORDER  BY data_length + index_length DESC
LIMIT  10;"\"""
alias inst='dpkg -l | grep "ii" | grep --color=auto -i'
alias a2gr='apache2ctl graceful'
alias a2en='cd /etc/apache2/sites-enabled'
alias lll='for i in *; do echo "`ls -1aRi  $i | awk "/^[0-9]+ / { print $1 }" | sort -u | wc -l` $i" ; done | sort -n'
alias sysl='tail -f -n 1000 /var/log/syslog'
alias pubkey='cat ~/.ssh/id_rsa.pub'
alias acs='apt-cache search'
alias update='sudo apt-get update && sudo apt-get upgrade'
alias ll='ls -alFh --color=auto'
alias speed='wget -O/dev/null speedtest.pixelwolf.ch'
alias nano='sl 2> /dev/null || echo "Nano is baaaaad!!"' # for trolling myself using nano (nano is bad)
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias zgrep='zgrep --color=auto'
alias mplayer='mplayer -lavdopts threads=4' # whats that??
alias woulfserv='ssh thonixx@pixelwolf.ch'
alias mailserv='ssh thonixx@mail.pixelwolf.ch'
alias destroy='shred -uvn 35 -z --random-source=/dev/urandom' # destroying is helpful
alias pass='openssl rand -base64 15'
alias apple='chmod +x ~/Ubuntu\ One/sync/mkapple && ~/Ubuntu\ One/sync/mkapple' # for my apple keyboard
alias dusch='du -sch'
alias l='ll'
# this shows the default ip address where your traffic goes out
alias ipaddr="ip addr show dev $(ip route show | grep default | awk '{print $5}') | grep inet | awk '{print \$2}' | awk -F/ '{print \$1}' | head -n 1"
alias s='ssh'
alias nssh='ssh -q -o StrictHostKeyChecking=false -o UserKnownHostsFile=/dev/null'

# source local config (testing or so)
if [ -f ~/.zsh/zshrc.local ]
then
	source ~/.zsh/zshrc.local
fi
# source autojump if installed
if [ -f /usr/share/autojump/autojump.sh ]
then
	source /usr/share/autojump/autojump.sh
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
function chwhois() {
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
	echo "makessl -d $domain -o \"$org\" -c \"$c\" -l \"$l\" -s \"$s\""
}

# spellit
# spell everything in german
function spellit() {
	$(which bash) -c "echo \"$1\" | while IFS= read -r -n1 c; do [ \"\$c\" ] && echo -n \"\$c \"; [ \"\$c\" ] && echo 'anton
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


# show expiration and subject information from a x509 formatted certificate
# scripted by github.com/thonixx
certexp () {
	openssl x509 -text -noout -in "$1" | egrep "(Not|Subject:)"
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
	 
	(echo "helo test"
	sleep 2
	echo "MAIL FROM:<info@test.com>"
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
	if [ -z "$1" ]
	then
		return
	fi

	cmd="$1"

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

try_ssh() {
	if [ "$(host $@ 2> /dev/null | grep 'not found' | wc -l)" == "0" ]
	then
		return "false"
	else
		return "true"
	fi
}

# start ssh-agent if none is started
if [ -z "$(pidof ssh-agent)" ]
then
	# load ssh-agent and save the information into a temporary file
        sh -c "ssh-agent > /tmp/agent.env"
	# delete echo line (don't want this)
	sed -r -i "s%echo(.*)%%g" /tmp/agent.env
fi
# check for running ssh-agent and if env var exists
if [ "$(pidof ssh-agent)" ] && [ -z "$SSH_AUTH_SOCK" ] && [ -f "/tmp/agent.env" ]
then
	# source existing agent
	. /tmp/agent.env
fi
# add ssh keys to ssh-agent if running
if [ "$(pidof ssh-agent)" ] && [ "$(ssh-add -l | wc -l)" -lt "$(ls -l ~/.ssh/ | grep -E "(.key|id_[dr]sa)$" | wc -l)" ]
then
	ssh-add ~/.ssh/*.key 2> /dev/null
	ssh-add ~/.ssh/id_rsa 2> /dev/null
	ssh-add ~/.ssh/id_dsa 2> /dev/null
fi

# my nice prompt template

function precmd() {

	# prompt for right side of screen
	RPROMPT='[%*]'
	
	# Stuff for git
		parse_git_branch () {
			git branch 2> /dev/null | grep --color=auto "*" | sed -e 's/* \(.*\)/\1/g'
		}
	
		# display git stuff at the right side if anything detected
		if [ "$(parse_git_branch)" ]
		then
			local git=" %{$fg[green]%}git %{$fg[cyan]%}⎇  $(parse_git_branch)%{$reset_color%}"
		fi
	
		# look for untracked files in git repo
		if [ $(git status 2> /dev/null | grep -i untracked | wc -l) -gt 0 ]
		then
			# i wanted to have the cool thing that it calculates the untracked files but i will do it later
			#untrackedfiles=$(expr $(git status 2> /dev/null | wc -l ) - 5)
			local untracked=" " # ⁇ ⁂ ● ⚛ ⁙ ᛭ ⚫ ⚪ ✓ ×    
		fi
		# look for modified/deleted files in git repo
		if [ $(git status 2> /dev/null | grep -E "(modified|new|deleted|renamed)" | wc -l) -gt 0 ] || [ $(git status 2> /dev/null | grep -E "(modified|new)" | wc -l) -gt 0 ]
		then
			# i wanted to have the cool thing that it calculates the untracked files but i will do it later
			local deletedfiles=$(git status 2> /dev/null | grep -i deleted | wc -l)
			local modifiedfiles=$(git status 2> /dev/null | grep -E "(modified|new|renamed)" | wc -l)
			local mod=" %{$fg[red]%}×$(expr $deletedfiles + $modifiedfiles)%{$reset_color%}"
		else if [ $(git status 2> /dev/null | grep -i modified | wc -l) -eq 0 ] && [ $(git status 2> /dev/null | grep -i deleted | wc -l) -eq 0 ] && [ "$(parse_git_branch)" ]
			then
				local deletedfiles=""
				local modifiedfiles=""
				local mod=" %{$fg[green]%}✓%{$reset_color%}"
			fi
		fi

	# Stuff for svn
		parse_svn_repo () {
			svn info 2> /dev/null | grep 'URL' | awk -F\/ '{print $3}' #| awk -F@ '{print $2}'
		}
		# display svn stuff at the right side if anything detected
		if [ "$(parse_svn_repo)" ]
		then
			local svn=" %{$fg[green]%}svn-%{$fg[cyan]%}($(parse_svn_repo))%{$reset_color%}"
		fi

	# needed for exit status smiley/char
	# local exit="%(?,%{$fg[green]%}✔%{$reset_color%},%{$fg[red]%}✘%{$reset_color%})"
	local exit="%(?..%{$fg[red]%}✘%{$reset_color%} )"
	
	# parse pwd structure and build something nice out of it
	dire=$(dirs | sed 's/\// › /g') # »
	dire=" $dire"
	
	# check if user is root
	local root=""
	if [ "$(whoami)" == "root" ]
	then
		local root=" %{$fg[white]%}%{$bg[red]%}root%{$reset_color%}"
	fi

	# for all other hosts (local and unknown)
	local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[red]%}%M%{$fg[white]%}:%y ${exit}%{$fg[magenta]%}(%h)%{$fg[white]%}${git}${mod}${untracked}${svn}${root}"
	local secondline="%{$fg[yellow]%}${dire} %{$fg[white]%}%% %{$reset_color%}"

	# for host mitan
	if [ "`hostname`" == "mitan" ]
	then
		local firstline="%{$fg[green]%}%n%{$fg[white]%}@%{$fg[blue]%}%M%{$fg[white]%}:%y ${exit}%{$fg[magenta]%}(%h)%{$fg[white]%}${git}${mod}${untracked}${svn}${root}"
	fi

	# for host zotherserv
	if [ "`hostname`" == "zotherserv" ] || [ "`hostname`" == "pixelwolf" ]
	then
		local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} WEBSERVER ${exit}%{$fg[magenta]%}(%h)%{$fg[white]%}${git}${mod}${untracked}${svn}${root}"
	fi

	# for host mailserv
	if [ "`hostname`" == "mailserv" ]
	then
		local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} MAILSERVER ${exit}%{$fg[magenta]%}(%h)%{$fg[white]%}${git}${mod}${untracked}${svn}${root}"
	fi

	# for kvm host
	if [ "`hostname`" == "woulfserv.pixelwolf.ch" ]
	then
		local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} KVMHOST ${exit}%{$fg[magenta]%}(%h)%{$fg[white]%}${git}${mod}${untracked}${svn}${root}"
	fi

	# finish the prompt
	PS1="$firstline
$secondline"
	
}

# END FOR PROMT STYLING

# my main editor should always be vim
export EDITOR="vim"

# fix broken chmod 777 colors
LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=01;34:ow=01;34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.svgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:"

# include the awesome and colorful zsh highlighting
source ~/.zsh/highlighting/zsh-syntax-highlighting.zsh
# tweak the highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=grey' # bug with cursor color on gnome shell
# pattern highlight
ZSH_HIGHLIGHT_PATTERNS+=('sudo' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf*' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rfv*' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rv*' 'fg=white,bold,bg=red')
