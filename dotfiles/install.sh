#!/bin/sh

export pwd=`pwd`
rm -rf ~/.vim
rm -rf ~/.vimrc
rm -rf ~/.gemrc
rm -rf ~/.zshrc
rm -rf ~/.zshenv
rm -rf ~/.vimrc.local
rm -rf ~/.irbrc
rm -rf ~/.gvimrc


ln -sf $pwd/dotvim/.vim ~/.vim
ln -sf $pwd/dotvim/.vimrc ~/.vimrc
ln -sf $pwd/zshrc ~/.zshrc
ln -sf $pwd/gemrc ~/.gemrc
ln -sf $pwd/zsh/env ~/.zshenv
ln -sf $pwd/zsh/env ~/.zshenv
ln -sf $pwd/zsh/env ~/.zshenv
ln -sf $pwd/gvimrc ~/.gvimrc
ln -sf $pwd/vimrc.local ~/.vimrc.local
ln -sf $pwd/irbrc ~/.irbrc
