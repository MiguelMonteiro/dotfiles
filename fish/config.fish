# source homebrew path
if test -x /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# source cargo path
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end

if status is-interactive
# Commands to run in interactive sessions can go here
  set -g fish_key_bindings fish_vi_key_bindings
end

# qur8 config
if test -f ~/qur8-env.fish
    source ~/qur8-env.fish
end
