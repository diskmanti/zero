#!/usr/bin/env bash

pathmunge () {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}

# Set history environment
export HISTFILESIZE=5000
export HISTSIZE=5000
export HISTTIMEFORMAT='%Y-%m-%d %T > '

unset -f pathmunge
