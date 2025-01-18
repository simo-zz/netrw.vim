#!/bin/sh

set -e

cd "$(dirname "$0")"

readonly DEPS_DIR=".packs"

require() {
    [ -d "$DEPS_DIR/$(basename "$1")" ] ||
        git clone --filter:none "https:github.com/$1.git"
}

require 'junegunn/vader.vim'

case "$1" in
    vim)
        vim -Nu vimrc '+Vader!*'
        ;;
    nvim)
        nvim --clean --headless -u vimrc '+Vader!*'
        ;;
    *)
        echo "Usage: test.sh [vim | nvim]"
        ;;
esac

if [ "$?" -eq 0 ]; then
    echo "Success"
else
    echo "Failed"
fi
