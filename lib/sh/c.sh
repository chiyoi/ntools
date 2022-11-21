usage='usage: c [<command> | <shortcut>] ...
    cl shortcuts
commands:
    -reg  - register target path
            usage  : c -reg <shortcut> <target-path>
            example: c -reg neko03 ~/Projects/neko03
    -rm   - remove registered shortcut
            usage  : c -rm <shortcut>
            example: c -rm neko03
    -ls   - list shortcuts
    -help - show this usage message
returns:
    0 - ok
    1 - usage error
files:
    $HOME/.ntools.cfg
        [c]
        <shortcut>
        ...'

if test $# -eq 0; then
    echo "path:"
    return 0
fi

scr_common="from configparser import ConfigParser, DuplicateSectionError, NoOptionError
import os.path as path

fp = path.expanduser('~/.ntools.cfg')
cfg = ConfigParser()
cfg.read(fp)
try:
    cfg.add_section('c')
except DuplicateSectionError:
    pass
"

scr_reg="$scr_common
cfg.set('c', '$2', '$3')
with open(fp, 'w') as f:
    cfg.write(f)
"

scr_rm="$scr_common
cfg.remove_option('c', '$2')
with open(fp, 'w') as f:
    cfg.write(f)
"

scr_ls="$scr_common
for k in cfg.options('c'):
    print('{}={}'.format(k, cfg.get('c', k)))
"

scr_get="$scr_common
try:
    print(cfg.get('c', '$1'))
except NoOptionError:
    exit(1)
"

case $1 in
    -reg)
        if test $# -ne 3; then
            echo $usage
            return 1
        fi
        python -c $scr_reg
        return 0
        ;;
    -rm)
        if test $# -ne 2; then
            echo $usage
            return 1
        fi
        python -c $scr_rm
        return 0
        ;;
    -ls)
        if test $# -ne 1; then
            echo $usage
            return 1
        fi
        python -c $scr_ls
        return 0
        ;;
    -help | --help)
        echo $usage
        return 0
        ;;
esac

fp=$(python -c $scr_get)
if test $? -ne 0; then
    echo "path:$1"
    return 0
fi
echo "path:$fp"
return 0
