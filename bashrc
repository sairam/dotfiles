export PATH=/usr/local/bin:/usr/local/mysql/bin/:/opt/local/bin/:/usr/local/sbin:$PATH

# Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin

# EC2 Stuff
# ec2 command line tools
export JAVA_HOME="$(/usr/libexec/java_home)"
export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.5.5.0/jars/"

alias gti=git
# export RUBY_HEAP_MIN_SLOTS=1000000
# export RUBY_HEAP_SLOTS_INCREMENT=1000000
# export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
# export RUBY_GC_MALLOC_LIMIT=1000000000
# export RUBY_HEAP_FREE_MIN=500000

export HISTCONTROL=erasedups
export HISTSIZE=100000
export EDITOR="mate -w"
#shopt -s histappend
stty -ixon

export LSCOLORS=ExFxCxDxBxegedabagacad
export CLICOLOR=1

export MANPATH=/opt/local/share/man:$MANPATH

export COLOR_NC='\033[0m' # No Color
export COLOR_WHITE='\033[1;37m'
export COLOR_BLACK='\033[0;30m'
export COLOR_BLUE='\033[0;34m'
export COLOR_LIGHT_BLUE='\033[1;34m'
export COLOR_GREEN='\033[0;32m'
export COLOR_LIGHT_GREEN='\033[1;32m'
export COLOR_CYAN='\033[0;36m'
export COLOR_LIGHT_CYAN='\033[1;36m'
export COLOR_RED='\033[0;31m'
export COLOR_LIGHT_RED='\033[1;31m'
export COLOR_PURPLE='\033[0;35m'
export COLOR_LIGHT_PURPLE='\033[1;35m'
export COLOR_BROWN='\033[0;33m'
export COLOR_YELLOW='\033[1;33m'
export COLOR_GRAY='\033[1;30m'
export COLOR_LIGHT_GRAY='\033[0;37m'

BLACK="\[\033[0;38m\]"
RED="\[\033[0;31m\]"
RED_BOLD="\[\033[01;31m\]"
BLUE="\[\033[01;34m\]"
GREEN="\[\033[0;32m\]"

function blue() {
    echo -e "\x1b[34m\x1b[1m"$@"\x1b[0m";
}

function green() {
    echo -e "\x1b[32m\x1b[1m"$@"\x1b[0m";
}

function red() {
    echo -e "\x1b[31m\x1b[1m"$@"\x1b[0m";
}
function hr() {
 printf "%$(tput cols)s\n"|tr ' ' '='
}

# use up down keys to search backward and forward in history when typing
#bind '"\e[A"':history-search-backward
#bind '"\e[B"':history-search-forward

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      rar x $1        ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}


function cd {
  builtin cd "$@" && ls
}

# GIT

function update_all_git {
# Update all git directories below current directory

  HIGHLIGHT="\033[01;34m"
  NORMAL='\033[00m'

  while IFS= read -r d; do
    if [ -d "$d" ]; then
      cd $d/.. > /dev/null
      echo -e "\n${HIGHLIGHT}Updating $d$NORMAL"
      git pull
      cd - > /dev/null
    fi
  done < <(find . -name .git)

}

function gitwebui {
   open `git webui`/$1
}

if [ -f `brew --prefix`/etc/bash_completion.d/git-prompt.sh ]; then source `brew --prefix`/etc/bash_completion.d/git-prompt.sh; fi # for Git completion

# Bash Helpers
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

## create a directory and cd into it
md() { mkdir -p "$@" && cd "$@"; }

## The cd command is so annoying. Why cant you deal with .'s and number ?
## .. 4 ; go 4 directories up
function .. (){
    local arg=${1:-1};
    local dir=""
    while [ $arg -gt 0 ]; do
        dir="../$dir"
        arg=$(($arg - 1));
    done
    cd $dir #>&/dev/null
}

alias ...="cd .. ; cd .."

alias ls="ls -G" # list
alias la="ls -Ga" # list all, includes dot files
alias ll="ls -Gl" # long list, excludes dot files
alias lla="ls -Gla" # long list all, includes dot files

# Volume Controls
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="sudo osascript -e 'set volume 10'"

# Networking
## Get readable list of network IPs
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
## Get my ip address
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
# function myip {
#   curl ifconfig.me
# }
## Flush DNS Cache
alias flush="dscacheutil -flushcache"

# Setup rsync default commands
alias rsync='rsync --archive --recursive --compress --partial --progress --append'

# Auto complete ssh
complete -W "$(echo $(grep ^Host ~/.ssh/config | sed -e 's/Host //' | grep -v "\*"))" ssh

# Better man
## bcat is a ruby gem
bman () {
    gunzip < `man -w $@` | groff -Thtml -man | bcat
}
# open a man page in a preview as pdf
pman () {
    man -t "${1}" | open -f -a /Applications/Preview.app
}
# open a man page in textmate
tman () {
  MANWIDTH=160 MANPAGER='col -bx' man $@ | mate
}
ccat () {
  pygmentize -Ofull,style=colorful -f html $@ | bcat
}
# mdfind - spotlight find from commandline

# invoke control +F via apple script
cfind() { osascript <<END
tell application "System Events" to keystroke "f" using {command down}
END
}

function gemdir {
  if [[ -z "$1" ]] ; then
    echo "gemdir expects a parameter, which should be a valid RVM Ruby selector"
  else
    rvm "$1"
    cd $(rvm gemdir)
    pwd
  fi
}

function md5check() {
    test `md5 $2 |rev| cut -d' ' -f1|rev|tr "[a-z]" "[A-Z]"` = `echo $1|tr "[a-z]" "[A-Z]"` && green [OK] || red [FAIL]
}

alias gdiff="git diff --no-index --color-words"
# Restarting Rails applications via pow
alias ttr="touch tmp/restart.txt"
alias rtr="rm tmp/restart.txt"

function ahttp_proxy {
  enactive=`ifconfig | egrep "(([0-9]{1,3}\.){3})[0-9]+" --color=always -B 4 | grep "^en"|cut -f1 -d:|tail -1`

  case $enactive in
  en0)
     device="Ethernet"
     ;;
  en1)
     device="Wi-Fi"
     ;;
  en4)
     device="Huawei"
     ;;
  esac
  # device="Wi-Fi"
  # device="Ethernet"
  val=`networksetup -getwebproxy $device | head -3 | tail -2  | cut -f2 -d' ' | sed 'N;s/\n/:/'|grep -v ':0'`
  if [[ $val ]]; then
    export http_proxy="http://"$val
  else
    unset http_proxy
  fi
}

export iiit_proxy="proxy.iiit.ac.in"

# Switching between multiple proxies
alias homen="networksetup -setwebproxy Wi-Fi '';networksetup -setwebproxystate Wi-Fi off;ahttp_proxy "
alias iiitn="networksetup -setwebproxy Wi-Fi $iiit_proxy 8080;ahttp_proxy"

alias homelan="networksetup -setwebproxy Ethernet '';networksetup -setwebproxystate Ethernet off;ahttp_proxy"
alias iiitlan="networksetup -setwebproxy Ethernet $iiit_proxy 8080;ahttp_proxy"

# To reset the proxy - use ahttp_proxy
ahttp_proxy

#LC_ALL =
#export LC_MONETARY = "en_IN.UTF-8"
#export LC_NUMERIC = "en_IN.UTF-8"
#export LC_MESSAGES = "en_IN.UTF-8"
#export LC_COLLATE = "en_IN.UTF-8"
#export LC_CTYPE = "en_IN.UTF-8"
#export LC_TIME = "en_IN.UTF-8"
#export LANG = "en_IN.UTF-8"

# $ ssh-keygen -t rsa -C "your_email@youremail.com"

#systemsetup -setusingnetworktime on
#systemsetup -setnetworktimeserver time.asia.apple.com

source `xcode-select --print-path`/usr/share/git-core/git-completion.bash
source `xcode-select --print-path`/usr/share/git-core/git-prompt.sh

# GIT
#source /usr/local/etc/bash_completion.d/git-completion.bash

export PS1="\[\033[01;34m\]\$(~/.rvm/bin/rvm-prompt) \[\033[01;32m\]\w\[\033[00;33m\]\$(__git_ps1 \" (%s)\") \[\033[01;36m\]⚡\[\033[00m\] "

# Source Highlight - brew install source-highlight

alias kat="src-hilite-lesspipe.sh"

# RLWrap the ultimate wrapper for CLI
alias rib="rlwrap -c irb"
alias r="rlwrap -c"

alias add=awk '{s+=$1}END{print s}' 

function dict() {
  echo $1 >> ~/.dict
}
alias sshh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
# Last but not the least - RVM

[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion # for RVM completion
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Load if present
function load_file() {
  if [ -f $@ ]; then
    . $@
  fi
}
function pbsay() {
  pbpaste | say
}
# Access directories w/o telling the path via Autojump
load_file `brew --prefix`/etc/autojump
# Project specific config
#load_file ~/.bash_project_specific.sh
# NVM
#load_file ~/.nvm/nvm.sh

# water - https://github.com/rubychan/water
## The diff washing machine. See your code changes clearly

# gas - git user switch

# DOS a site
# hping3 --rand-source -p 80 -S --flood Victim_ip
# convert a dmg into iso
#  hdiutil convert /path/to/filename.dmg -format UDTO -o /path/to/savefile.iso
# #hdiutil makehybrid -iso -joliet -hfs -o OSXLion.iso Lion.dmg
# source "`brew --prefix grc`/etc/grc.bashrc"

# ^X^E (Ctrl-X Ctrl-E)
# Stop using the arrow keys and navigate the command line more quickly with
#
# ctrl+A: moves to the start of the line
#
# ctrl+E: moves to the end of the line
#
# ctrl+B: move back on character
#
# ctrl+F: move forward one character
#
# esc+B: move back one word
#
# esc+F: move forward one word
#
# ctrl+U: delete from the cursor to the beginning of the line
#
# ctrl+K: delete from the cursor to the end of the line
# Esc + .  ; Esc + Ctrl E

function mkurl(){
	echo $1 
	echo $2
if [ ! -f $2.url ]; then
cat <<EOF > $2.url
[InternetShortcut]
URL=$1
EOF
	echo "created file $2.url"
else
	echo "file already exists"
fi
}
