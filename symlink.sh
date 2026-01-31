#!/bin/bash
# symlinks to config files
ln -sf $HOME/dotfiles/tmux.conf $HOME/tmux.conf
mkdir -p $HOME/.config/alacritty
ln -sf $HOME/dotfiles/alacritty.toml $HOME/.config/alacritty/alacritty.toml
mkdir -p $HOME/.config/nvim
ln -sf $HOME/dotfiles/nvim $HOME/.config/nvim
ln -sf $HOME/dotfiles/Brewfile $HOME/Brewfile
mkdir -p $HOME/.config/karabiner
ln -sf $HOME/dotfiles/karabiner.json $HOME/.config/karabiner/karabiner.json


