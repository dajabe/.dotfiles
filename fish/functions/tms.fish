function tms
  set split_size '20'
  set session_name $(basename "$PWD")
  set window_name 'main'
  set edit_cmd 'nvim .'
  set setup_cmd ''

  for cmd in $argv
    if test -z $setup_cmd
      set setup_cmd "$cmd"
    else
      set setup_cmd "$setup_cmd; $cmd"
    end
  end

  if tmux has-session -t "$session_name" > /dev/null 2>&1
    echo 'found session reattaching'
    tmux attach -t "$session_name"
    exit
  end

  if test -z $TMUX
    tmux new-session -x- -y- -dc "$PWD" -s "$session_name" -n $window_name
    tmux send-keys "$edit_cmd" C-m
    tmux split-window -vb -l "$split_size" -c "$PWD"
    if test -n $setup_cmd
      tmux send-keys "$setup_cmd" C-m
    end
    tmux select-pane -t 0
    tmux attach -t "$session_name"
  else
    echo 'launching from inside tmux'
    tmux new-session -d -c "$PWD" -s "$session_name" -n $window_name
    if test -z $setup_cmd
      tmux switch-client -t "$session_name"\; \
        send-keys "$edit_cmd" C-m\; \
        split-window -vb -l "$split_size" -c "$PWD"\; \
        send-keys "$setup_cmd" C-m\; \
        select-pane -t 0
    else
      tmux switch-client -t "$session_name"\; \
        send-keys "$edit_cmd" C-m\; \
        split-window -vb -l "$split_size" -c "$PWD"\; \
        select-pane -t 0
    end
  end
end

