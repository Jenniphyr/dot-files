arr=("${(@f)$(/opt/homebrew/bin/brew outdated)}")
if [ -n "${arr[*]}" ]; then
    echo "The following are outdated:"
    printf "%s\n" "${arr[@]}"
    if read -q "REPLY?Run brew upgrade? [Y/N]: "; then
        /opt/homebrew/bin/brew upgrade
    fi
fi
