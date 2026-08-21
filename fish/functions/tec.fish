function tec
  set session_name 'config'

  # Determine how to connect to tmux session
  set attach_switch "attach-session"
  if set -q TMUX
    set attach_switch "switch-client"
  end

  if tmux has-session -t $session_name > /dev/null 2>&1
    echo "Attaching to existing $session_name session"
    tmux $attach_switch -t $session_name
    return
  end

  set repo_migration_notice ""
  if set -q REPOSITORY_DIR
    set repo_dir "$REPOSITORY_DIR"
  else if test -d "$HOME/dev/dajabe/.dotfiles"; or test -d "$HOME/dev/dajabe/.ds-dots"
    set repo_dir "$HOME/dev/dajabe"
  else if test -d "$HOME/dev/.dotfiles"; or test -d "$HOME/dev/.ds-dots"
    set repo_dir "$HOME/dev"
    set repo_migration_notice "Config repositories are moving to ~/dev/dajabe. Please move ~/dev/.dotfiles and ~/dev/.ds-dots to ~/dev/dajabe or set REPOSITORY_DIR."
  else
    set repo_dir "$HOME/dev/dajabe"
  end

  set work_dots_dir "$repo_dir/.ds-dots"
  set dots_dir "$repo_dir/.dotfiles"

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

  set preview_command 'lsd --tree --depth 1 --group-directories-first'

  # Launch tmux session
  tmux new-session -x- -y- -dc $HOME/.config -s $session_name -n 'home/config'
  if test -n "$repo_migration_notice"
    tmux send-keys -t $session_name:'cfg' "echo '$repo_migration_notice'" C-m
  end
  tmux send-keys -t $session_name:'cfg' $preview_command C-m

  # Add new window for dotfiles if the directory exists
  if test -d $dots_dir
    tmux new-window -t $session_name -c $dots_dir -n 'dots'
    tmux send-keys -t $session_name:'dots' $preview_command C-m
  end

  # Add new window for ds-dots if the directory exists
  if test -d $work_dots_dir
    tmux new-window -t $session_name -c $work_dots_dir -n 'wk-dots'
    tmux send-keys -t $session_name:'wk-dots' $preview_command C-m
  end

  # Add a new window for espanso config if the directory exists and espanso is installed
  if test -n "$espanso_config"; and test -d "$espanso_config"
    tmux new-window -t $session_name -c "$espanso_config" -n 'espanso'
    tmux send-keys -t $session_name:'espanso' $preview_command C-m
  end

  # Select the 'dotfiles' window if it exists, otherwise select the first window
  if tmux list-windows -t $session_name | grep -q 'dots'
    tmux select-window -t $session_name:'dots'
  else
    tmux select-window -t $session_name:'cfg'
  end

  tmux $attach_switch -t $session_name
end
