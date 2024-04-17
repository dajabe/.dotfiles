function tec
    if tmux has-session -t 'config'
        echo "Attaching to existing config session"
        tmux attach-session -t 'config'
        return
    end

    if set -q REPOSITORY_DIR
        set repo_dir "$REPOSITORY_DIR"
    else
        set repo_dir "$HOME/dev"
    end

    set work_dots_dir "$repo_dir/.ds-dots"
    set dots_dir "$repo_dir/.dotfiles"

    #
    if type $EDITOR > /dev/null 2>&1
        set open_editor "$EDITOR ."
    else
        echo "Falling back to vi"
        if type vi > /dev/null 2>&1
            set open_editor 'vi .'
        else
            echo 'vi not available and EDITOR not specified in environment'
            return 1
        end
    end

    # Check for espanso
    if not type espanso > /dev/null 2>&1
        set espanso_config ""
    else
        set espanso_config "$(espanso path config)"
    end

    if not test -d $HOME/.config
        echo 'No ~/.config directory found!!! Creating...'
        mkdir $HOME/.config
    end

    # Launch tmux session
    tmux new-session -dAs config -n 'home/config' -c $HOME/.config $open_editor

    # Add new window for dotfiles if the directory exists
    if test -d $dots_dir
        tmux new-window -dSc $dots_dir -n 'dots' $open_editor
    end

    # Add new window for ds-dots if the directory exists
    if test -d $work_dots_dir
        tmux new-window -dSc $work_dots_dir -n 'work-dots' $open_editor
    end

    # Add a new window for espanso config if the directory exists and espanso is installed
    if test -n "$espanso_config"; and test -d "$espanso_config"
        tmux new-window -dSc "$espanso_config" -n 'espanso' $open_editor
    end

    # Add another window for dotfiles-shell if the directory exists
    if test -d $repo_dir/.dotfiles
        tmux new-window -dSc $repo_dir/.dotfiles -n 'dotfiles-shell'
    else
        tmux new-window -dSc $HOME/.config -n 'config-shell'
    end

    # Select the 'dotfiles' window if it exists, otherwise select the first window
    if tmux list-windows | grep -q 'dotfiles'
        tmux select-window -t 'dots'
    else
        tmux select-window -t 'home/config'
    end
    tmux attach-session -t 'config'
end
