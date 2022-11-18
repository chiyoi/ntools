#!/bin/zsh
usage='usage: install.sh [options]
    copy scripts to ~/bin
options:
    --help    - show this usage message
    --yes, -y - default to input `y` for prompts
returns:
    0 - ok
    1 - cp error
    2 - unrecognized option'

root=$(readlink -f $(dirname $0))
cd $root || return $?

if test $# -eq 0; then
    cp -f ./bin/* ~/bin; err=$?
    if test $err -ne 0; then
        echo "cp exited with $err"
        return 1
    fi
    return 0
fi

if test $# -eq 1; then
    if test $1 = '--help'; then
        echo $usage
        return 0
    fi

    if test $1 = '--yes' -o $1 = '-y'; then
        for f in ./bin/*; do
            echo y | cp $f ~/bin
            echo y
        done
        return 0
    fi

    echo usage
    return 2
fi
