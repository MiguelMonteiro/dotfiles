#!/bin/bash
# symlinks to config files
# tmux
ln -sf $HOME/dotfiles/tmux.conf $HOME/tmux.conf
# alacritty
mkdir -p $HOME/.config/alacritty
ln -sf $HOME/dotfiles/alacritty.toml $HOME/.config/alacritty/alacritty.toml
# neovim
mkdir -p $HOME/.config/nvim
ln -sfn $HOME/dotfiles/nvim/* $HOME/.config/nvim
# homebrew
ln -sf $HOME/dotfiles/Brewfile $HOME/Brewfile
# karabiner
mkdir -p $HOME/.config/karabiner
ln -sf $HOME/dotfiles/karabiner.json $HOME/.config/karabiner/karabiner.json
# fish
mkdir -p $HOME/.config/fish
ln -sfn $HOME/dotfiles/fish/* $HOME/.config/fish


