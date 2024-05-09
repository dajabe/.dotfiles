source ~/.config/fish/alias.fish

# Environment specific options go here
if test -e "$HOME/.config/env.fish"
  source "$HOME/.config/env.fish"
end

set fish_greeting

if status is-interactive
  mise activate fish | source
else
  mise activate fish --shims | source
end

# Pathing
fish_add_path -m --path ~/.local/bin
# fish_add_path ~/.local/share/mise/shims
fish_add_path -m --path $HOME/bin

# Import one password plugins
if test -e "$HOME/.config/op/plugins.sh"
  source /home/djb/.config/op/plugins.sh
end

zoxide init fish | source
fzf --fish | source
# mise activate fish | source
starship init fish | source  
