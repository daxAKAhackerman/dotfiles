#!/bin/bash

if [ ! -t 0 ]; then
	exec /bin/bash "$@"
else
    tmux new-session -A -s main
fi
