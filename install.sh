#!/bin/bash -e

mkdir -p ~/bin
curl -sL https://github.com/djl/vcprompt/raw/master/bin/vcprompt > ~/bin/vcprompt
chmod 755 ~/bin/vcprompt

CURRENT_DIR="$(pwd -P)/dotfiles"
ln -s -i "${CURRENT_DIR}/irbrc" ~/.irbrc
ln -s -i "${CURRENT_DIR}/dotvim/.vim" ~/.vim
ln -s -i "${CURRENT_DIR}/dotvim/.vimrc" ~/.vimrc
ln -s -i "${CURRENT_DIR}/vimrc.local" ~/.vimrc.local
ln -s -i "${CURRENT_DIR}/zsh/env" ~/.zshenv
ln -s -i "${CURRENT_DIR}/zshrc" ~/.zshrc
ln -s -i "${CURRENT_DIR}/gemrc" ~/.gemrc
ln -s -i "${CURRENT_DIR}/gvimrc" ~/.gvimrc

. ~/.zshrc
