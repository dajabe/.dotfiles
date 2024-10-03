function nomacs
    set -l nomacs_path "/Applications/nomacs.app/Contents/MacOS/nomacs"
    
    if not test -x $nomacs_path
        echo "Error: nomacs executable not found at $nomacs_path"
        return 1
    end

    # Options that should run nomacs normally (not as daemon)
    set -l normal_options -v --version -h --help --batch --batch-log --import-settings

    # Check if any of the normal options are present
    for opt in $normal_options
        if contains -- $opt $argv
            $nomacs_path $argv
            return
        end
    end

    # If no normal options are present, run as daemon
    nohup $nomacs_path $argv </dev/null >/dev/null 2>&1 &
    disown
end
