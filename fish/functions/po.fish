function po
  set -l project_owner "dajabe"
  set -l dev_dir "$HOME/dev"

  argparse 'h/help' 'o/owner=' 'n/new' -- $argv
  or return

  if set -q _flag_help
    printf "po - Project Open\n"
    printf "Opens a tmux session to a existing project or creates a new project\n"
    printf "\v"
    printf "-n, --new\tCreate a new project\n"
    printf "-o, --owner\tSet project owner (default is %s)\n" $project_owner
    printf "-h, --help\tDisplay this help\n"
    return
  end

  # Check if fzf is installed
  if not type -q fzf
      echo "Error: fzf is not installed. Please install it to use fuzzy finding."
      return 1
  end

  # set owner_dirs (find $dev_dir -mindepth 1 -maxdepth 1 -type d)
  if set -q _flag_owner
    set project_owner $_flag_owner
    set project_owner_dir "$dev_dir/$project_owner"
    if test -d $project_owner_dir
      echo "found project owner directory"
    else
      printf "Owner directory %s doesn't exist.\n" $project_owner_dir
      read -P "Create directory? (y/N): " create_owner
      if test "$create_owner" = y -o "$create_owner" = Y
        printf "Creating directory %s\n" $project_owner_dir
        mkdir $project_owner_dir
      else
        echo "Please create project owner directory or provide correct project owner"
        return 1
      end
    end
  else
    set project_owner_dir "$dev_dir/$project_owner"
  end

  set project_name (string lower (string join '-' $argv))
  if set -q _flag_new
    set project_dir "$project_owner_dir/$project_name"
    if test -d $project_dir
      printf "Project directory exists: %s" $project_dir
    else
      printf "Creating project directory: %s" $project_dir
      mkdir $project_dir
    end
  else
    set fzf_opts --height '20%' --border --reverse --preview 'tree -L 1 {}' --preview-window right:40%:wrap

    if test (count $argv) -eq 0
      set project_dir (find $dev_dir -mindepth 2 -maxdepth 2 -type d | fzf $fzf_opts)
    else
      set query (string join ' ' $argv)
      set project_dir (find $dev_dir -mindepth 2 -maxdepth 2 -type d | fzf $fzf_opts -1 -0 --query "$query")
      if test $status -ne 0
        set project_dir "$project_owner_dir/$project_name"
        printf "No project found at:\n\t %s" $project_dir
        read -P "Create project? (y/N): " create_project
        if test "$create_project" = y -o "$create_project" = Y
          printf "Creating project directory %s\n" $project_dir
          mkdir $project_dir
        else
          echo "No project found or created"
          return 1
        end
      end
    end
  end

  if test -z "$project_dir"
    # This should never happen. If it does something is fucked
    echo "No directory selected. Cannot create or attach to session."
    return 1
  end

  ## TMUX
  if test -d $project_dir
    set owner_name (basename (dirname $project_dir))
    set project_name (basename $project_dir)
    set session_name "$owner_name/$project_name"  # Take care if you change the separator here it did funky things for me
    set edit_cmd 'e' # This is another fish function I use to launch my editor

    # You can change this part to launch VS Code or whatever you want instead and just cd to the directory
    # Create session if it doesn't exist
    if not tmux has-session -t "$session_name" 2>/dev/null
      tmux new-session -d -c "$project_dir" -s "$session_name" -n 'editor'
      tmux send-keys -t "$session_name:editor" "$edit_cmd" C-m
      tmux new-window -t "$session_name" -c "$project_dir" -n 'shell'
      tmux select-window -t "$session_name:editor"
    end

    if test -z "$TMUX"
      # Outside tmux, attach to the session
      tmux attach-session -t "$session_name"
    else
      # Inside tmux, switch to the session
      tmux switch-client -t "$session_name"
    end
  else
    # This should never happen. If it does something is fucked
    echo "Directory doesn't exists something fucked up"
  end
end
