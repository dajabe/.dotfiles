function e
  set -l edit_cmd nvim
  if test -e $EDITOR
    set -l edit_cmd $EDITOR
  end
  if test (count $argv) -eq 0
    $edit_cmd .
  else
    $edit_cmd $argv
  end
end
