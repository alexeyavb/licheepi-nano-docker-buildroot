alias "ls"="ls -alh --color"
alias "df"="df -h"
alias "du"="du -hs ."
alias "free"="free -h"
# Gentoo (/etc/bash/bashrc)
if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi


# CentOS or Fedora (/etc/bashrc)
# [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "

# Debian (/etc/bash.bashrc)
# PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '


