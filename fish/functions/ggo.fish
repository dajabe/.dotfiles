function ggo
  set git_dir $argv[1]

  if test -d $git_dir
    set git_owner (git -C "$git_dir" remote -v| sed -E 's#.*[:/]([^/]+)/[^/]+(\.git)?$#\1#'| uniq)
  else
    set git_owner (git remote -v| sed -E 's#.*[:/]([^/]+)/[^/]+(\.git)?$#\1#'| uniq)
  end

  echo $git_owner | pbcopy
  echo $git_owner
end
