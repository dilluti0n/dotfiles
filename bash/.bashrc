# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
export HISTCONTROL="ignoreboth"
export HISTSIZE="99999"
export DMENU_FONT="Iosevka Term:size=10"
export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GPG_TTY="$(tty)"

export PS1='[\u@\h \[\e[32m\]\W\[\e[m\]]\$ '
export EDITOR='/bin/vi'

alias mv='mv -i'
alias cp='cp -i'
alias lvi='NVIM_APPNAME=lazyvim nvim'
alias nvc='NVIM_APPNAME=nvchad nvim'
alias fcd='cd $(fd --type=directory --exclude='.git' -H |fzf)'
alias eclean-kernel='eclean-kernel -A'

cpapi() {
    local prefix="${1^^}"
    local target_key="${prefix}_API_KEY"

    local value=$(pass show api/llm | grep "export $target_key=" | sed "s/.*=['\"]\(.*\)['\"]/\1/")

    if [ -n "$value" ]; then
        echo -n "$value" | wl-copy
    else
        return 1
    fi
}

edt() {
    XMODIFIRES=@im=none GTK_IM_MODULE=gtk-im-context-simple setsid emacs &>/dev/null $@
}

magit() {
    local _path=$(realpath "${1:-.}")

    if git -C "${_path}" rev-parse --is-inside-work-tree >/dev/null; then
        setsid -f emacs --eval "(progn (magit-status \"${_path}\") \
(delete-other-windows))" &>/dev/null
    else
        echo "Not a git repository: ${_path}" >&2
    fi
    return $?
}

stopwatch() {
    while true; do
        printf "%s\r" $(TZ=UTC date --date now-$now +%H:%M:%S.%N)
        sleep 0.1
    done
}

show-deps() {
    if (( "$#" < 1 )); then
        echo "Usage: $0 <package-name>"
        echo "Prints installed packages that depend on given package."
        exit 1
    fi
    comm -12 <(equery -q d -D --format '$cp' "$1" |sed 's/-[0-9][^/]*$//' |sort -u) \
    <(sort /var/lib/portage/world)
}

xnames() {
    xprop | awk '
    	/^WM_CLASS/{sub(/.* =/, "instance:"); sub(/,/, "\nclass:"); print}
	/^WM_NAME/{sub(/.* =/, "title:"); print}'
}

fdkconfig() {
    zgrep -i $1 /proc/config.gz
}

s0ix-perf() {
    local dur=${1:-60}
    local statfile='/sys/kernel/debug/amd_pmc/s0ix_stats'

    # when access, counter is reset
    sudo cat "$statfile" >/dev/null
    sudo rtcwake -m mem -s "$dur"

    local exit_time=$(sudo awk '/Residency Time:/ {print $NF}' "$statfile")
    local exit_sec=$(echo "scale=6; ${exit_time}/1000000" |bc)

    echo "time: ${exit_sec} sec"
    echo "scale=2; ${exit_sec} / ${dur} * 100" |bc
}

txt2pdf() {
    if (( $# == 2 )); then
        $2='-'
    fi
    enscript $1 -o - | ps2pdf - $2
}

fncat() {
    for f in "${@:1}"; do
        [[ -r "$f" ]] || { printf 'skip: %s (unreadable)\n' "$f" >&2; continue; }
        printf '#### %s\n' "$f"
        printf '```\n'
        cat -- "$f"
        printf '\n```\n\n'
    done
}

alias fdcat='fncat $(fd -0 -t f |xargs -0)'

dcexp() {
    docker run -e DISCORD_TOKEN="$DISCORD_TOKEN" --rm -v "$1":/out tyrrrz/discordchatexporter:stable "${@:2}" --fuck-russia
}

sqlstart() {
    [ "$(docker inspect -f '{{.State.Running}}' mysql8 2>/dev/null)" = "true" ] || docker start mysql8
    docker exec -it \
        -e LANG=C.UTF-8 -e LC_ALL=C.UTF-8 \
        mysql8 sh -lc 'stty iutf8; mysql --default-character-set=utf8mb4 -uroot -p'
}

calc() {
    python -c "print($@)"
}

api() {
    local crd="api/$1"
    . <(pass show "$crd")
    export PS1="($crd) $PS1"
}

getlink() {
    base64 --decode <<<"$(wl-paste -p)" | wl-copy
}

luks-tpm-update() {
    LUKS_BLK_DEV=/dev/nvme0n1p2
    sudo systemd-cryptenroll "$LUKS_BLK_DEV" --wipe-slot=tpm2 &&
        sudo systemd-cryptenroll "$LUKS_BLK_DEV" \
          --tpm2-device=auto \
          --tpm2-pcrs=4+9+12 \
          --tpm2-with-pin=no
}

# ssh-agent
_ssh() {
    eval $(keychain --eval --agents ssh 2>/dev/null)

    # Check if there is loaded key
    ssh-add -l &>/dev/null

    if [ $? -ne 0 ]; then
        pass show ssh/eps | ssh-add -
        pass show ssh/guru | ssh-add -
    fi
}

_ssh
unset -f _ssh
