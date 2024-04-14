source ~/.config/fish/alias.fish

set fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Pathing
fish_add_path -m --path ~/.local/bin
fish_add_path ~/.local/share/mise/shims
fish_add_path -m --path $HOME/bin

set -gx EDITOR /usr/bin/nvim

source /home/djb/.config/op/plugins.sh
mise activate fish | source
starship init fish | source  
