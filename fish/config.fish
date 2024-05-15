source ~/.config/fish/alias.fish

# Set a path to a secodary config file that is specific to a machine
set -l custom_fish "$HOME/.config/env.fish"
if test -e $custom_fish
  # echo "Found custom environment config loading $custom_fish"
  source $custom_fish
end

set fish_greeting

# Pathing
fish_add_path -m --path ~/.local/bin
# fish_add_path ~/.local/share/mise/shims
fish_add_path -m --path $HOME/bin

if status is-interactive
  mise activate fish | source
else
  mise activate fish --shims | source
end


# Import one password plugins
if test -e "$HOME/.config/op/plugins.sh"
  source /home/djb/.config/op/plugins.sh
end

zoxide init fish | source
fzf --fish | source
# mise activate fish | source
starship init fish | source  
