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

# Set java environment
export JAVA_HOME=/usr/java/latest
pathmunge $JAVA_HOME/bin

unset -f pathmunge
