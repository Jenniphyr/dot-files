export EMACS_SOCKET_NAME="${TMPDIR}/emacs$(id -u)/server"
export EDITOR="/opt/homebrew/bin/emacsclient -t"
export SUDO_EDITOR=mg

export PAGER=/usr/share/vim/vim*/macros/less.sh
export MANPAGER="/usr/bin/less -r"
export GIT_PAGER="/usr/bin/less -r"
export HOMEBREW_NO_ENV_HINTS=true
export LANG="en_CA.UTF-8"
export LESS='-R -i'
export MORE='-R -i'

if JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null); then
    export JAVA_HOME
fi

export DO_NOT_TRACK=1
export __CF_USER_TEXT_ENCODING="0x1F5:0x8000100:0x52"
export CLICOLOR=1
export GREP_OPTIONS='--binary-file=without-match --color=auto --line-buffered --exclude=*.xhprof'
export RSYNC_RSH="ssh -oRequestTTY=no -oRemoteCommand=none"
export SHELL_SESSION_HISTORY=1
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export GZIP="-9"
export PIGZ="$GZIP"
export GZIP_OPT="$GZIP"
export XZ_OPT="$GZIP"
export RIPGREP_CONFIG_PATH=~/.ripgrep.rc

export MANSECT=0:1:2:3:4:5:6:7:8:9
export INFOPATH="/usr/local/share/info:/opt/homebrew/share/info:${INFOPATH:-}";
export MANPATH="$JAVA_HOME/man:$MANPATH"

export GIT_CEILING_DIRECTORIES=/Users
export CPATH=/opt/homebrew/include
export LIBRARY_PATH=/opt/homebrew/lib
export LD_LIBRARY_PATH=$LIBRARY_PATH
