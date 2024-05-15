function scratchy
  argparse e/edit h/help -- $argv

  if set -ql _flag_help
    echo "scratch v0.0.1"
    echo "SYNTAX"
    echo "scratch [-h|--help]"
    echo "scratch [Title...]"
    echo " "
    echo "If run with no flags create a note with title supplied no quotes needed"
    echo "-e open note file with cursor under front matter"
    echo "-h show this help message"
    return 0
  end

  set -l note_file $(date -I).md; 

  if test -e $note_file
    if set -ql _flag_edit
      nvim $note_file +6
    else
      nvim $note_file +
    end
  else
    echo '---' > $note_file
    echo "title: $argv" >> $note_file
    echo 'description: ' >> $note_file
    echo 'tags: ' >> $note_file
    echo '---' >> $note_file
    echo '' >> $note_file

    if test (count $argv) -eq 0
      nvim $note_file +2 +'norm$'
    else
      nvim $note_file +3 +'norm$'
    end
  end
end
