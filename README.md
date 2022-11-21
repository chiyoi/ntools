# Neko03 Command Line Tools - NTools
aliases for my commonly used commands

---
environments:
```sh
c() {
    resp=$(zsh ~/lib/sh/c.sh $@); err=$?
    if test "${resp:0:5}" = 'path:'; then
        cl ${resp:5:$} || return
    elif test -n "$resp"; then
        echo $resp
    fi
    return $err
}

export PATH=~/bin:$PATH 
export PYTHONPATH=~/lib/python:$PYTHONPATH
```
files:
* config: `~/.ntools.cfg`
