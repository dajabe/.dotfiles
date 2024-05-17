function scratch
  argparse n/new h/help -- $argv

  if set -ql _flag_help
    echo "scratch v0.0.1"
    echo "SYNTAX"
    echo "scratch [-h|--help]"
    echo "scratch [Title...]"
    echo " "
    echo "Create a note with title supplied no quotes needed"
    echo "-h show this help message"
    return 0
  end

alias scr="set -l note_file $(date -I).md; echo 'Your text here' > $note_file && nvim +5:10 $note_file"
  echo "Launching note"
  echo $argv
end
