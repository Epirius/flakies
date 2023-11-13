#!/usr/bin/env zsh
# switch between keyboard layoutsname

# If an explicit layout is provided as an argument, use it. Otherwise, select the next layout from
# the set [us, no].
if [[ -n "$1" ]]; then
    setxkbmap $1
else
    layout=$(setxkbmap -query | grep "layout" | tail -c 3) # awk 'END{print $2}')
    case $layout in
        us)
                setxkbmap no
            ;;
        no)
                setxkbmap us
            ;;
        *)
                setxkbmap us
            ;;
    esac
fi
