# tmux
abbr -a tns     tmux new-session -s 
abbr -a tec     tmux new-session -As config -c $HOME/.config nvim
abbr -a tks     tmux kill-session
abbr -a tls     tmux list-session

# Fish
alias reload='source $HOME/.config/fish/config.fish'
alias refish='exec fish'

# Vim
alias vi=nvim

# ls
alias ls=lsd
alias l='ls -l'
alias la='ls -a'
alias lt='ls --tree'
alias ll='ls -Alh'

# Espanso
alias ee='espanso edit'

# gh
abbr -a ghpr  gh pr create --fill

# git
alias git=hub
alias gcd='cd $(git rev-parse --show-toplevel)'
abbr -a g     git
abbr -a ga    git add
abbr -a gaa   git add .
abbr -a gbd   git branch -d
abbr -a gbl   git branch --list
abbr -a gc    git commit
abbr -a gca   git commit --amend
abbr -a gcam  git commit -am
abbr -a gcl   git clone
abbr -a gcm   git commit -m
abbr -a gco   git checkout
abbr -a gcop  git checkout -p
abbr -a gcs   git checkout - 
abbr -a gd    git diff
abbr -a gdi   "git --no-pager -c diff.image.textconv=imgcat -c diff.image.command=imgdiff diff"
abbr -a gds   git diff --staged
abbr -a gf    git fetch
abbr -a gfc   git findcommit
abbr -a gfm   git findmessage
abbr -a gl    git log
abbr -a gll   git log --name-status HEAD^..HEAD
abbr -a glol  "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
abbr -a gm    git merge
abbr -a gmm   git merge main 
abbr -a gp    git push
abbr -a gpf    git push --force-with-lease
abbr -a gpl   git pull
abbr -a gpull git pull
abbr -a gpush git push
abbr -a gr    git remote
abbr -a grb   git rebase
abbr -a grba   git rebase --abort
abbr -a grbc   git rebase --continue
abbr -a grbm   git rebase main
abbr -a gres  git restore --staged
abbr -a grv   git remote -v
abbr -a gs    git status
abbr -a gss    git status -sb
abbr -a gstl    git stash list
abbr -a gstp    git stash pop
abbr -a gst    git stash

