#!/bin/zsh
root=$(readlink -f $(dirname $0))
cd $root || return $?

cp ./src/* ~/bin
