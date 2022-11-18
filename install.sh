#!/bin/zsh
usage='usage: install.sh [options]
    copy scripts to ~/bin
    alias to "install.sh --yes" if no options provided
options:
    --help    - show this usage message
    --yes, -y - default to input `y` for prompts
    -i        - ask for input when prompts
returns:
    0 - ok
    1 - usage error
    2 - cp error
    3 - cannot cd to repository root'

root=$(readlink -f $(dirname $0))
cd $root; err=$?
if test $err -ne 0; then
    echo "cd exited with $err"
    return 3
fi

if test $# -eq 0; then
    ./install.sh --yes
    return $?
fi

if test $# -eq 1; then
    if test $1 = '--help'; then
        echo $usage
        return 0
    fi

    if test $1 = '--yes' -o $1 = '-y'; then
        for f in ./bin/*; do
            echo y | cp $f ~/bin; err=$?
            echo y
        done
        if test $err -ne 0; then
            echo "cp exited with $err"
            return 2
        fi
        return 0
    fi

    if test $1 = '-i'; then
        cp ./bin/* ~/bin; err=$?
        if test $err -ne 0; then
            echo "cp exited with $err"
            return 2
        fi
        return 0
    fi
fi

echo usage
return 1
