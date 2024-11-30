bindkey -e
bindkey 'b' emacs-backward-word
bindkey 'f' emacs-forward-word
bindkey '^U' backward-kill-line
bindkey '^W' kill-word

# https://stackoverflow.com/questions/10847255/how-to-make-zsh-forward-word-behaviour-same-as-in-bash-emacs
autoload -U select-word-style
select-word-style bash
