#!/usr/bin/env bash

readonly SCRIPT_PWD="${SCRIPT_PWD:-$(cd "$(dirname "$0")/.." && pwd)}"
readonly VIM_SRC_DIR="$SCRIPT_PWD/.repos/vim"
readonly NETRW_VERSION=$(git tag | tail -n1 | tr -d v)

if [ -d "$VIM_SRC_DIR" ]; then
    git -C "$VIM_SRC_DIR" pull --depth=1 --rebase origin master
else
    git clone "https://github.com/vim/vim.git" "$VIM_SRC_DIR"
fi

files=(
    'autoload/netrw.vim'
    'autoload/netrwSettings.vim'
    'autoload/netrw_gitignore.vim'
    'syntax/netrw.vim'
    'plugin/netrwPlugin.vim'
    'doc/netrw.txt'
)

for file in ${files[@]}; do
    if grep -q "v$NETRW_VERSION" "$file"; then
        echo "You must update the version before continuing"
        exit 1
    fi
done

for file in ${files[@]}; do
    cp -f "$SCRIPT_PWD/$file" "$VIM_SRC_DIR/runtime/pack/dist/opt/netrw/$file"
done

cd "$VIM_SRC_DIR" || exit 1

git add --all
git commit -e -m "runtime(netrw): upstream snapshot of v$(($NETRW_VERSION + 1))"
