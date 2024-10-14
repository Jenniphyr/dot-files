if [[ "$TERM" == "dumb" ]]; then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    if whence -w precmd >/dev/null; then
        unfunction precmd
    fi
    if whence -w preexec >/dev/null; then
        unfunction preexec
    fi
    export PS1='$ '
else
    eval "$(/opt/homebrew/bin/brew shellenv)"
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    autoload -Uz compinit
    compinit
    setopt GLOB_SUBST
    setopt PUSHD_IGNORE_DUPS
    setopt PUSHD_TO_HOME
    setopt AUTO_PUSHD
fi
# more config files at ~/.oh-my-zsh/custom/
