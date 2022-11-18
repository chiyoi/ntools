#!/bin/zsh
usage='usage: install.sh [options]
    copy scripts to ~/bin
    default to set `--yes`
options:
    --help    - show this usage message
    --yes, -y - default to input `y` for prompts
    -i        - ask for input when prompts
returns:
    0 - ok
    1 - usage error
    2 - sub-command error
    4 - directory destination occupied
    5 - internal error'

#data
help=false
yes=true
bin=~/bin
lib=~/lib


#text
init() {
    root=$(readlink -f $(dirname $0))
    cd $root; err=$?
    if test $err -ne 0; then
        echo "cannot cd to repository root: cd exited with $err"
        return 2
    fi

    mkdir_if_not_exist $bin || return $?
    mkdir_if_not_exist $lib || return $?

    case $# in
        0)
            return 0
            ;;
        1)
            case $1 in
                '--help')
                    help=true
                    return 0
                    ;;
                '--yes' | '-y')
                    yes=true
                    return 0
                    ;;
                '-i')
                    yes=false
                    return 0
                    ;;
            esac
            ;;
    esac
    echo $usage
    return 1
}

mkdir_if_not_exist() {
    if test $# != 1; then
        echo "mkdir_if_not_exist accepts 1 argument"
        return 5
    fi
    dir=$1
    if test ! -d $dir; then
        if test -e $dir; then
            echo "directory destination occupied: $dir"
            return 4
        fi
        mkdir $dir; err=$?
        if test $err -ne 0; then
            echo "mkdir exited with $err"
            return 2
        fi
    fi
}

copy_bin() {
    for f in ./bin/*; do
        if $yes; then
            echo y | cp $f $bin 2>&1 | sed -E 's/([^n])$/\1y\n/g'
            err=${pipestatus[2]}
        else
            cp $f $bin; err=$?
        fi
        if test $err -ne 0 -a $err -ne 1; then
            echo "cp exited with $err"
            return 2
        fi
    done
}

ask_rm() {
    target=$1
    if test -z "$target"; then
        echo "ask_rm accepts 1 argument"
        return 5
    fi

    if test ! -e $target; then
        return 0
    fi

    echo -n "overwrite $target? [y/N] "; read resp
    if test "$resp" = 'y' -o "$resp" = 'Y' -o "$resp" = 'yes'; then
        rm -rf $target; err=$?
        if test $err -ne 0; then
            echo "rm exited with $err"
            return 2
        fi
        return 0
    fi
    return 1
}

copy_lib() {
    if test $# -ne 1; then
        echo "copy_lib accepts 1 argument"
        return 5
    fi
    sub_lib=$1

    dir=$lib/$sub_lib
    if test ! -d $dir; then
        if test -e $dir; then
            echo "mount point occupied: $dir"
            return 4
        fi
        mkdir $dir
    fi

    for pkg in ./lib/$sub_lib/*; do
        pkg_name=$(echo $pkg | sed -E "s;^./lib/$sub_lib/;;g")
        target=$dir/$pkg_name
        if $yes; then
            echo y | ask_rm $target 2>&1 | sed -E 's/([^n])$/\1y\n/g'
            err=${pipestatus[2]}
        else
            ask_rm $target; err=$?
        fi
        if test $err -ne 0 -a $err -ne 1; then
            return 2
        fi
        cp -r $pkg $target
    done
}


#main
init $@ || return $?

if $help; then
    echo $usage
    return 0
fi

copy_bin || return $?
copy_lib python || return $?
copy_lib scpt || return $?
copy_lib templates || return $?
