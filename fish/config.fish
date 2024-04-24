source ~/.config/fish/alias.fish

# Environment specific options go here
if test -e "$HOME/.config/env.fish"
  source "$HOME/.config/env.fish"
end

set fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Pathing
fish_add_path -m --path ~/.local/bin
fish_add_path ~/.local/share/mise/shims
fish_add_path -m --path $HOME/bin

# Import one password plugins
source /home/djb/.config/op/plugins.sh

mise activate fish | source
starship init fish | source  
zoxide init fish | source
