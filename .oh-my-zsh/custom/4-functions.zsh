function download() {
    local -a PREMIUM_FLAGS
    #PREMIUM_FLAGS=(--cookies-from-browser "firefox:$HOME/Library/Application Support/Firefox/Profiles/fh3dhswl.default-1472409901684")
    for label in "$@"; do
        ( yt-dlp ${PREMIUM_FLAGS[@]} --no-mtime -f m4a    "https://www.youtube.com/watch?v=$label" || \
          yt-dlp ${PREMIUM_FLAGS[@]} --no-mtime -t mp4 -x "https://www.youtube.com/watch?v=$label" ) &
    done
    wait
}

function fix() {
    for file in "$@"; do
        local prefix=${file%.*}
        local suffix=${file#"$prefix"}
        ffmpeg -i "$file" "${prefix}${suffix/./.fixed.}"
    done
}

function emacs {
    if [ $# -eq 0 ]; then
        $EDITOR
    else
        local files=("$@")
        files=("${files[@]//\"/\\&}")
        files=("${files[@]/%/&\"}")
        files=("${files[@]/#/&\"}")
        $EDITOR --eval "(mapc #'(lambda (file) (find-file-noselect file t)) '(${files[*]}))" -e "(find-file ${files[0]})"
    fi
}

function up {
    local OLD_PWD="$PWD"
    unsetopt AUTO_PUSHD
    for i in "$(seq ${1:-1})"; do
        cd ../
    done
    setopt AUTO_PUSHD
    cd -s $OLD_PWD
    cd $OLDPWD
}

function direct_math {
    echo "scale=4; $*" | \bc -l
}

function remac {
    sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z
    sudo ifconfig en0 ether "$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')"
    sudo networksetup -detectnewhardware
    ifconfig en0 | grep ether
}

function forward {
    local local=$1
    local server
    local remote

    if [[ $2 =~ .*:[0-9]+ ]]
    then
        server=$(echo "$2" | cut -f1 -d:)
        remote=$(echo "$2" | cut -f2 -d:)
    else
        server=$2
        remote=$3
    fi
    \ssh -NL "$local:localhost:$remote" "$server"
}

function csudo {
    local login

    while getopts 'Aa:BbC:c:D:Eeg:Hh::iKklnPp:r:SsT:t:U:u:Vv' opt
    do
        # shellcheck disable=SC2220,SC2213
        case $opt in
            i) login=true ;;
        esac
    done

    if [[ ${login:-false} == "true" || ${*: $OPTIND:1} == su ]]; then
        read -rp "Did you want sudo -s? [Yn] " yn
        case $yn in
            [Nn]* ) \sudo "$@";;
            * ) \sudo -s ;;
        esac
    elif [[ ${*: $OPTIND:1} == echo ]]; then
        echo "You probably want echo | sudo tee" >&2
        \sudo -v
        builtin echo "${@: (($OPTIND+1))}"
    else
        \sudo "$@"
    fi
}

function cscp {
    if echo "$@" | xargs getopt '346BCpqrTvc:F:i:J:l:o:P:S:' -- | { read -r c; [[ "${c}" =~ --\ .*:.*\ .*:.* ]]; }; then
        # 2 remotes, cannot use rsync, try: https://unix.stackexchange.com/questions/183504/how-to-rsync-files-between-two-remotes
        \scp -3 "$@"
    else
        # shellcheck disable=SC2034
        local RSYNC_RSH="/usr/bin/ssh -oRequestTTY=no -oRemoteCommand=none"
        until rsync -aLvz --append-verify --partial --progress --timeout=10 "$@"; do sleep 1; echo retrying; done
    fi
}

function cps {
    if [ $# == 1 ]; then
        pgrep -fil "$1"
    else
        ps "$@"
    fi
}

function cfind {
    if [ "$(uname)" = "Darwin" ]; then
        find -x "$@"
    else
        #handle multiple search locations
        PLACE="$1"
        shift 1
        find "$PLACE" -xdev "$@"
    fi
}

function cdiff {
    if hash git &>/dev/null; then
        git diff --no-index --color-words "$@"
    else
        diff "$@"
    fi
}

function ramdrive {
    # diskutil erasevolume HFS+ 'ramdisk' $(hdiutil attach -nomount ram://$(echo '4 * 1024 ^ 3 / 512' | bc)) 2>/dev/null
    diskutil partitionDisk "$(hdiutil attach -nomount "ram://$(echo '4 * 1024 ^ 3 / 512' | bc)")" 1 GPTFormat APFS 'ramdisk' '100%'
}

function clocate {
    if [ "$(uname)" = "Darwin" ]; then
        mdfind "name:$*"
    else
        cdllocate "$*"
    fi
}

function csed {
    if [ "$(uname)" = "Darwin" ]; then
        sed -E "$@"
    else
        sed -r "$*"
    fi
}

function getIp {
    if [ $# -gt 0 ]; then
        if [ "$1" = "-6" ]; then
            getIpv6
        elif [ "$1" = "-4" ]; then
            getIpv4
        else
            echo "Usage: getIp [-4] [-6]"
        fi
    else
        getIpv4
    fi
}

function getIpv4 {
    getIpv 4
}

function getIpv6 {
    getIpv 6
}

function getIpv {
    # dig +short myip.opendns.com @resolver1.opendns.com
    \curl "-$1" -s http://icanhazip.com/s
}

function unix {
    date -r "$1"
}

function ctar {
    local CREATE
    local FILE

    while getopts 'aBb:C:cf:HhI:JjkLlmnOoPpqrSs:T:tUuvW:wX:xyZz' opt
    do
        # shellcheck disable=SC2220,SC2213
        case $opt in
            c) CREATE=true ;;
            f) FILE=$OPTARG ;;
        esac
    done

    if ! [[ ${CREATE:-false} == "true" ]]; then
        tar "$@"
    else
        if ! [[ "${FILE:-x}" =~ .*\.t?gz ]]; then
            set -- "${*/.tar/.tgz}"
        fi
        tar "${@: 1:$((OPTIND -1))}" --use-compress-program pigz "${@: $OPTIND}"
    fi
}

function cpbcopy {
    if [ $# -ge 1 ]; then
        pbcopy < "$*"
    else
        pbcopy
    fi
}

function vergte() {
    echo -e "$1\n$2" | sort -rCV
}
function verlte() {
    echo -e "$2\n$1" | sort -rCV
}
function vergt() {
    ! verlte "$@"
}
function verlt() {
    ! vergte "$@"
}

function update() {
    brew update
    brew upgrade
    rbenv list | grep -Fvf <(rbenv versions --bare) | xargs -n1 rbenv install
    gem update
    npm update -g
    rustup update
    cargo install --list | awk '/^[[:alnum:]_-]+ v[0-9.]+:$/{print $1}' | xargs cargo install
    sudo softwareupdate --install --all --restart
}

function xcode-clean() {
    rm -rf ~/Library/Developer/Xcode/DerivedData
    rm -rf ~/Library/Developer/Xcode/Archives
    rm -rf ~/Library/Developer/Xcode/*\ DeviceSupport
    rm -rf ~/Library/Caches/com.apple.dt.Xcode
    xcrun simctl shutdown all && xcrun simctl erase all
}

function functions() {
    declare -F | \sed -Ee 's/declare -f ([^ ]+)/\1/' | grep -Eve '^(git_prompt|gp|shell_session)?_'
}

function aliases() {
    alias | \sed -Ee 's/alias ([^=]+)=.*/\1/'
}

function variables() {
    declare | rg '^[^ \t].*=.' | rg -vie '[ _]IFS' -e COMPREPLY | \sed -Ee 's/^([^=]+)=.*/\1/'
    # declare | rg = | cut -d= -f 1 | awk '{print $NF}' | tr -d "'" | sort
}
