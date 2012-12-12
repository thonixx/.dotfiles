# set the right locale env for myself
export LC_ALL="de_CH.UTF-8"

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
bindkey "^F" "ls -alFh --color=auto^J"
bindkey "^J" accept-line
bindkey "^K" kill-line
bindkey "^L" clear-screen
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
bindkey "^W" backward-kill-word
bindkey "^U" undo
bindkey "^Z" "^Ussh mitan@mitan.nine.ch || ssh mitan@login.nine.ch^J"
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

# some helpful aliases and keybindings for myself
bindkey -s '^F' 'ls -alFh --color=auto\n'
alias pubkey='cat ~/.ssh/id_rsa.pub'
alias acs='apt-cache search'
alias update='sudo apt-get update && sudo apt-get upgrade -y'
alias ll='ls -alFh --color=auto'
alias speed='wget -O/dev/null speedtest.pixelwolf.ch'
alias pw='vi /home/wolf/Ubuntu\ One/sync/Passwörter.gpg'
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
alias size='du -sch'
alias l='ll'
alias hosts='sudo vim /etc/hosts'
# this shows the default ip address where your traffic goes out
alias ipaddr='ip addr show dev $(ip route show | grep default | awk '\{print $5\}') | grep inet | awk '\{print $2\}' | awk -F\/ '\{print $1\}' | head -n 1'

# company aliases and things (www.nine.ch)
bindkey -s '^Z' '^Ussh mitan@mitan.nine.ch\n'
alias nine='ssh mitan.nine.ch'
alias tel='cat /home/wolf/nine/daten/verwaltung/telefonliste | grep -i '
alias pikett='echo "# Legende:    / A=Arbeitstag  W=Wochenende/Feiertag
#             |    / 1st Pikett (ab Alert 1)
#             |    |     / 2nd Pikett (ab Alert 3)
#             |    |     |     / 1st Servicedesk
#             |    |     |     |     / 2nd Servicedesk
#             |    |     |     |     |     / 3rd Servicedesk" && cat /home/wolf/nine/daten/verwaltung/pikettplan | egrep "[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,4}" | grep -B 3 -A 14 --color=always "`date +%d.%m.%Y`"'
alias s='ssh'
alias nssh='ssh -q -o StrictHostKeyChecking=false -o UserKnownHostsFile=/dev/null'
alias svnprop='svn propset svn:keywords "Id"' # some company thing
alias pp='cd /home/`whoami`/nine/puppetsvn/production/manifests/nodes'
alias clients='cd /home/`whoami`/nine/puppetsvn/production/clients'
alias nineman='cd /home/`whoami`/nine/miraculix/usr/share/man/man1'
alias marvin="ssh -t marvin \" cd /etc/bind/zonen/; /bin/bash -i\""
alias classup="ssh -t puppet \"nine-foreman-update-classes\""
alias gogetchain='echo "-----BEGIN CERTIFICATE-----
MIIENjCCAx6gAwIBAgIBATANBgkqhkiG9w0BAQUFADBvMQswCQYDVQQGEwJTRTEU
MBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFkZFRydXN0IEV4dGVybmFs
IFRUUCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBFeHRlcm5hbCBDQSBSb290
MB4XDTAwMDUzMDEwNDgzOFoXDTIwMDUzMDEwNDgzOFowbzELMAkGA1UEBhMCU0Ux
FDASBgNVBAoTC0FkZFRydXN0IEFCMSYwJAYDVQQLEx1BZGRUcnVzdCBFeHRlcm5h
bCBUVFAgTmV0d29yazEiMCAGA1UEAxMZQWRkVHJ1c3QgRXh0ZXJuYWwgQ0EgUm9v
dDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALf3GjPm8gAELTngTlvt
H7xsD821+iO2zt6bETOXpClMfZOfvUq8k+0DGuOPz+VtUFrWlymUWoCwSXrbLpX9
uMq/NzgtHj6RQa1wVsfwTz/oMp50ysiQVOnGXw94nZpAPA6sYapeFI+eh6FqUNzX
mk6vBbOmcZSccbNQYArHE504B4YCqOmoaSYYkKtMsE8jqzpPhNjfzp/haW+710LX
a0Tkx63ubUFfclpxCDezeWWkWaCUN/cALw3CknLa0Dhy2xSoRcRdKn23tNbE7qzN
E0S3ySvdQwAl+mG5aWpYIxG3pzOPVnVZ9c0p10a3CitlttNCbxWyuHv77+ldU9U0
WicCAwEAAaOB3DCB2TAdBgNVHQ4EFgQUrb2YejS0Jvf6xCZU7wO94CTLVBowCwYD
VR0PBAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wgZkGA1UdIwSBkTCBjoAUrb2YejS0
Jvf6xCZU7wO94CTLVBqhc6RxMG8xCzAJBgNVBAYTAlNFMRQwEgYDVQQKEwtBZGRU
cnVzdCBBQjEmMCQGA1UECxMdQWRkVHJ1c3QgRXh0ZXJuYWwgVFRQIE5ldHdvcmsx
IjAgBgNVBAMTGUFkZFRydXN0IEV4dGVybmFsIENBIFJvb3SCAQEwDQYJKoZIhvcN
AQEFBQADggEBALCb4IUlwtYj4g+WBpKdQZic2YR5gdkeWxQHIzZlj7DYd7usQWxH
YINRsPkyPef89iYTx4AWpb9a/IfPeHmJIZriTAcKhjW88t5RxNKWt9x+Tu5w/Rw5
6wwCURQtjr0W4MHfRnXnJK3s9EK0hZNwEGe6nQY1ShjTK3rMUUKhemPR5ruhxSvC
Nr4TDea9Y355e6cJDUCrat2PisP29owaQgVR1EX1n6diIWgVIEM8med8vSTYqZEX
c4g/VhsxOBi0cQ+azcgOno4uG+GMmIPLHzHxREzGBHNJdmAPx/i9F4BrLunMTA5a
mnkPIAou1Z5jJh5VkpTYghdae9C8x49OhgQ=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIE5TCCA82gAwIBAgIQB28SRoFFnCjVSNaXxA4AGzANBgkqhkiG9w0BAQUFADBv
MQswCQYDVQQGEwJTRTEUMBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFk
ZFRydXN0IEV4dGVybmFsIFRUUCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBF
eHRlcm5hbCBDQSBSb290MB4XDTEyMDIxNjAwMDAwMFoXDTIwMDUzMDEwNDgzOFow
czELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxGTAXBgNV
BAMTEFBvc2l0aXZlU1NMIENBIDIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQDo6jnjIqaqucQA0OeqZztDB71Pkuu8vgGjQK3g70QotdA6voBUF4V6a4Rs
NjbloyTi/igBkLzX3Q+5K05IdwVpr95XMLHo+xoD9jxbUx6hAUlocnPWMytDqTcy
Ug+uJ1YxMGCtyb1zLDnukNh1sCUhYHsqfwL9goUfdE+SNHNcHQCgsMDqmOK+ARRY
FygiinddUCXNmmym5QzlqyjDsiCJ8AckHpXCLsDl6ez2PRIHSD3SwyNWQezT3zVL
yOf2hgVSEEOajBd8i6q8eODwRTusgFX+KJPhChFo9FJXb/5IC1tdGmpnc5mCtJ5D
YD7HWyoSbhruyzmuwzWdqLxdsC/DAgMBAAGjggF3MIIBczAfBgNVHSMEGDAWgBSt
vZh6NLQm9/rEJlTvA73gJMtUGjAdBgNVHQ4EFgQUmeRAX2sUXj4F2d3TY1T8Yrj3
AKwwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEQYDVR0gBAow
CDAGBgRVHSAAMEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwudXNlcnRydXN0
LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LmNybDCBswYIKwYBBQUHAQEEgaYw
gaMwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9BZGRUcnVz
dEV4dGVybmFsQ0FSb290LnA3YzA5BggrBgEFBQcwAoYtaHR0cDovL2NydC51c2Vy
dHJ1c3QuY29tL0FkZFRydXN0VVROU0dDQ0EuY3J0MCUGCCsGAQUFBzABhhlodHRw
Oi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQCcNuNOrvGK
u2yXjI9LZ9Cf2ISqnyFfNaFbxCtjDei8d12nxDf9Sy2e6B1pocCEzNFti/OBy59L
dLBJKjHoN0DrH9mXoxoR1Sanbg+61b4s/bSRZNy+OxlQDXqV8wQTqbtHD4tc0azC
e3chUN1bq+70ptjUSlNrTa24yOfmUlhNQ0zCoiNPDsAgOa/fT0JbHtMJ9BgJWSrZ
6EoYvzL7+i1ki4fKWyvouAt+vhcSxwOCKa9Yr4WEXT0K3yNRw82vEL+AaXeRCk/l
uuGtm87fM04wO+mPZn+C+mv626PAcwDj1hKvTfIPWhRRH224hoFiB85ccsJP81cq
cdnUl4XmGFO3
-----END CERTIFICATE-----"'

export puppet='/home/wolf/nine/puppetsvn/'
export clients='/home/wolf/nine/puppetsvn/production/clients'

# colors are beautiful
# even if I do not understand what this command means exactly
autoload -U colors
colors

####################
#################### my custom functions
####################

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
	
	# check for dig installed
	if [ -z "$(which dig)" ]
	then
		echo "Please install dig, we need it:"
		echo "sudo apt-get install dnsutils (for Ubuntu/Debian)"
		return
	fi

	# decide if its an ip or name
	if [ "$(echo $request | egrep -o '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}')" ]
	then
		# would be an IP
		echo -n "$(echo $request | egrep -o '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}') > "
		
		# assume there are multiple PTR records
		check="false"
		for r in "$(dig +short -x $request 2> /dev/null)"
		do 
			if [ $check == "true" ]
			then
				echo -n " / "
			fi

			echo -n "$r"
			
			if [ ! -z "$r" ]
			then
				check="true"
			else
				check="false"
			fi
		done

		# check if any ptr was found
		if [ $check == "false" ]
		then
			echo -ne "No reverse entry.\n"
		else
			echo -ne "\n"
		fi
	else
		# would be a hostname

		# check if any output there
		if [ -z "$(dig a +search +short $request 2> /dev/null)" ]
		then
			echo "There was no A record."
			return
		else
			# loop through A records
			for i in $(dig a +search +short $request 2> /dev/null)
			do
				# print hostname
				echo -n "$request > "
				# print ip
				echo -n "$i > "
				 
				# assume there are multiple PTR records
				check="false"
				for r in "$(dig +short -x $i 2> /dev/null)"
				do 
					if [ $check == "true" ]
					then
						echo -n " / "
					fi

					echo -n "$r"
					
					if [ ! -z "$r" ]
					then
						check="true"
					else
						check="false"
					fi
				done

				# check if any ptr was found
				if [ $check == "false" ]
				then
					echo -ne "No reverse entry.\n"
				else
					echo -ne "\n"
				fi
			done
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

####################
#################### some functions used in my company
####################


# show me the .my.cnf file in roots home folder
# used to show the root password of mysql and plesk pass
mycnf() {
	# scripted by mitan
	ssh $1 "cat ~/.my.cnf"
}

# check for puppet
pup() {
	# scripted by mitan
	ssh $1 "which puppet > /dev/null && echo 'Puppet is there'"
}

# ssl pp
sslpp() {
	# scripted by mitan
	if [ ! "$1" ]
	then
		echo 'I need a domain to continue'
		return
	fi

	if [ ! -r "/usr/share/doc/nine/ssl.pp" ]
	then
		echo "Y u no have ssl pp template in /usr/share/doc/nine?\n"
		echo "Go here and grab it:\nhttps://hq.nine.ch/dokuwiki/technical/management/ssl/cert_in_apache_einrichten"
		return
	fi

	dir=$(pwd)
	client=$(echo $dir | awk -F_ '{print $2}' | awk -F/ '{print $1}')
	domain=$1
	escdomain=$(echo $1 | sed 's/\./_/g')

	cp "/usr/share/doc/nine/ssl.pp" "$client"_ssl_"$escdomain".pp
	
	sed -i "s/\$client/$client/g" "$client"_ssl_"$escdomain".pp 
	sed -i "s/\$domain/$domain/g" "$client"_ssl_"$escdomain".pp 
	sed -i "s/\$escapeddomain/$escdomain/g" "$client"_ssl_"$escdomain".pp 
}

# lookup backup server and change to correct folder
backup () {
	# scripted by mitan
        if [ -z "$@" ]
        then
                echo "Gimme some input, a server name would be nice."
                return
        fi

        output=$(ssh $@ "ls /var/spool/z_backup*" | awk -F_ '{print $4}' | head -n 1)
        hostname=$(ssh $@ "hostname")

        # echo "Backup should be located at: $output"
        ssh -t $output "cd /home/backup/$hostname; echo \"Here are the dates\"; echo \"**\";  ls *date*; /bin/bash -i"
}

# go to the correct mail path
mailserver () {
	# scripted by mitan
        if [ -z "$@" ]
        then
                echo "I'm happy with an email address."
                return
        fi
        if [ -z $(echo "$@" | grep "@") ]
        then
                echo "An email has to contain an @.. Do not try to betray me :("
                return
        fi

        domain=$(echo "$@" | awk -F@ '{print $2}')
        user=$(echo "$@" | awk -F@ '{print $1}')
        vmail=$(nine-mailadmin-find $domain 2> /dev/null)
		
		if [ -z "$vmail" ] ; then echo "The domain does not seem to exist o.O" ; return ; fi
        ssh -t "$vmail" "cd /srv/vmail/$domain/; if [ -d \"/srv/vmail/$domain/$user\" ] ; then echo -e \"User mailbox size: \"; cd $user; du -ch .; else echo \"Mailbox does not exist. Available mailboxes:.\"; cd /srv/vmail/$domain ; echo \"*
*\"; ls ; fi;  /bin/bash -i"
}

# go to our ssl proxy, pick up the right certificate line and give out the server name
pound () {
	# scripted by mitan
	output=`host $(ssh poundlb1 "nine-pound-config --list | grep $@" | tail -n 1 | awk '{print $3}' | awk -F\/ '{print $4}') 2&>/dev/null | awk '{print $5}'`
	if [ -z "$output" ] ; then echo 'no server :('; else echo "$output"; fi
}


# gimme the output of the pem file for pound
poundify() {
	# scripted by mitan
	if [ -z "$@" ]
	then
		echo "hey gimme a domain"
		#exit 1 # FAIL!!!
	fi
	
	if [ -f "SSL_$@.crt" ] && [ -f "SSL_$@.key" ]; then cat "SSL_$@.crt" > "/tmp/$@.pem"; else return ; fi
	if [ -f "SSL_$@.chain.crt" ] ; then cat "SSL_$@.chain.crt" >> "/tmp/$@.pem"; fi
	cat "SSL_$@.key" >> "/tmp/$@.pem"
	
	# copy to management server
	scp "/tmp/$@.pem" mitan.nine.ch:/tmp/
	ssh mitan.nine.ch "scp /tmp/$@.pem poundlb1:/tmp/"

	rm "/tmp/$@.pem"
	ssh mitan.nine.ch "rm /tmp/$@.pem"
	#exit 0 # yay.. this would be a success.. otherwise you FAILED!
	# wuhu.. the command above closes your fuckin shell.. so you would always fail xD
}

####################
#################### finish company functions
####################


try_ssh() {
	if [ "$(host $@ 2> /dev/null | grep 'not found' | wc -l)" == "0" ]
	then
		return "false"
	else
		return "true"
	fi
}

# add ssh keys to ssh-agent if running		
if [ "$(pidof ssh-agent)" ]
then
	ssh-add
fi

# my nice prompt template

function precmd() {

	# prompt for right side of screen
	RPROMPT='[%*]'
	
	# Stuff for git
		parse_git_branch () {
			git branch 2> /dev/null | grep "*" | sed -e 's/* \(.*\)/\1/g'
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
		if [ $(git status 2> /dev/null | grep -i modified | wc -l) -gt 0 ] || [ $(git status 2> /dev/null | grep -i deleted | wc -l) -gt 0 ]
		then
			# i wanted to have the cool thing that it calculates the untracked files but i will do it later
			local deletedfiles=$(git status 2> /dev/null | grep -i deleted | wc -l)
			local modifiedfiles=$(git status 2> /dev/null | grep -i modified | wc -l)
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
	local exit="%(?,%{$fg[green]%}✔%{$reset_color%},%{$fg[red]%}✘%{$reset_color%})"
	
	# parse pwd structure and build something nice out of it
	dire=$(dirs | sed 's/\// › /g') # »
	dire=" $dire"
	
	# for all other hosts (local and unknown)
	local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[red]%}%M%{$fg[white]%}:%y ${exit} %{$fg[magenta]%}(%h)%{$fg[white]%}${git}${mod}${untracked}${svn}"
	local secondline="%{$fg[yellow]%}${dire} %{$fg[white]%}%% %{$reset_color%}"

	# for host mitan
	if [ "`hostname`" == "mitan" ]
	then
		local firstline="%{$fg[green]%}%n%{$fg[white]%}@%{$fg[blue]%}%M%{$fg[white]%}:%y ${exit} %{$fg[magenta]%}(%h)%{$fg[white]%}${git}${mod}${untracked}${svn}"
	fi

	# for host zotherserv
	if [ "`hostname`" == "zotherserv" ]
	then
		local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} WEBSERVER ${exit} %{$fg[magenta]%}(%h)%{$fg[white]%}${git}${mod}${untracked}${svn}"
	fi

	# for host mailserv
	if [ "`hostname`" == "mailserv" ]
	then
		local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} MAILSERVER ${exit} %{$fg[magenta]%}(%h)%{$fg[white]%}${git}${mod}${untracked}${svn}"
	fi

	# for kvm host
	if [ "`hostname`" == "woulfserv.pixelwolf.ch" ]
	then
		local firstline="%{$fg[blue]%}%n%{$fg[white]%}@%{$fg[yellow]%}%M%{$fg[white]%} KVMHOST ${exit} %{$fg[magenta]%}(%h)%{$fg[white]%}${git}${mod}${untracked}${svn}"
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
ZSH_HIGHLIGHT_PATTERNS+=('sudo' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta'
# To have commands starting with `rm -rf` in red:
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf*' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rfv*' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('rm -rv*' 'fg=white,bold,bg=red')
