# tmux
abbr -a tns     tmux new-session -s 
abbr -a tks     tmux kill-session
abbr -a tls     tmux list-session
abbr -a ta      tmux attach

# Weather
alias wthr='curl wttr.in/palmerston+north'
abbr -a wttr    curl wttr.in/

# Fish
alias reload='source $HOME/.config/fish/config.fish'
alias refish='exec fish'

# Vim
alias vi=nvim

# Scratchy
alias scr=scratchy

# ls
alias ls=lsd
alias l='ls -l'
alias la='ls -a'
alias lt='ls --tree'
alias ll='ls -Alh'

# yay
alias yeet='yay -Rcs'

# ps
alias psa='ps -A | grep'

# replace cd with zoxide
# this is currently causing a recursive loop with fish
# alias cd=z

# Espanso
alias ee='espanso edit'

# Convox
alias cv=convox
abbr -a csst "cv switch staging"
abbr -a csus "cv switch us"
abbr -a cseu "cv switch eu"

abbr -a cvr "cv rack"
abbr -a cve "cv exec"
abbr -a cvru "cv run"
abbr -a cvd "cv deploy --wait"
abbr -a cvl "cv logs"
abbr -a cvrs "cv resources"
abbr -a cvsc "cv scale"
abbr -a cvi "cv instances"
abbr -a cvrl "cv releases"
abbr -a cvb "cv builds"
abbr -a cvps "cv ps"

# Ruby
abbr -a rc    bundle exec rubocop
abbr -a rdbm   rake db:migrate
abbr -a rdbr   rake db:rollback

# Bundler
alias b=bundle
abbr -a bu    b update

# Rails
alias r=rails

# Shortcut
alias ss='short story --git-branch-short'

# npm
abbr -a nrd npm run dev

# gh
abbr -a ghpr  gh pr create --fill
abbr -a gpv  gh pr view --web

# git
alias git=hub
alias g=git
alias gcd='cd $(g rev-parse --show-toplevel)'
abbr -a ga      g add
abbr -a gaa     g add .
abbr -a gbd     g branch -d
abbr -a gbl     g branch --list
abbr -a gc      g commit
abbr -a gca     g commit --amend
abbr -a gcam    g commit -am
abbr -a gcl     g clone
abbr -a gcm     g commit -m
abbr -a gco     g checkout
abbr -a gcop    g checkout -p
abbr -a gcs     g checkout - 
abbr -a gd      g diff
abbr -a gdi     "g --no-pager -c diff.image.textconv=imgcat -c diff.image.command=imgdiff diff"
abbr -a gds     g diff --staged
abbr -a gf      g fetch
abbr -a gfc     g findcommit
abbr -a gfm     g findmessage
abbr -a gl      g log
abbr -a gll     g log --name-status HEAD^..HEAD
abbr -a glol    "g log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
abbr -a gm      g merge
abbr -a gmm     g merge main 
abbr -a gp      g push
abbr -a gpf     g push --force-with-lease
abbr -a gpl     g pull
abbr -a gpull   g pull
abbr -a gpush   g push
abbr -a gr      g remote
abbr -a grb     g rebase
abbr -a grba    g rebase --abort
abbr -a grbc    g rebase --continue
abbr -a grbm    g rebase main
abbr -a gres    g restore --staged
abbr -a grv     g remote -v
abbr -a gs      g status
abbr -a gss     g status -sb
abbr -a gstl    g stash list
abbr -a gstp    g stash pop
abbr -a gst     g stash

