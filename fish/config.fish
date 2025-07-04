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

fish_add_path -m --path $HOME/.dotnet

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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/djb/mambaforge/bin/conda
    eval /home/djb/mambaforge/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/djb/mambaforge/etc/fish/conf.d/conda.fish"
        . "/home/djb/mambaforge/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/djb/mambaforge/bin" $PATH
    end
end

if test -f "/home/djb/mambaforge/etc/fish/conf.d/mamba.fish"
    source "/home/djb/mambaforge/etc/fish/conf.d/mamba.fish"
end
# <<< conda initialize <<<


