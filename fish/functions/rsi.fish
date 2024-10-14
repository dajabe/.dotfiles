function rsi
    set -l temp_file (mktemp)
    rspec $argv | tee $temp_file >/dev/tty

    set diff_image (cat $temp_file | grep -A 1 'View Image Diff:' | tail -n 1 | string trim)
    set generated_image (cat $temp_file | grep -A 1 'View Generated Image:' | tail -n 1 | string trim)
    set expected_image (cat $temp_file | grep -A 1 'View Expected Image:' | tail -n 1 | string trim)

    rm $temp_file

    function open_if_exists
        if test -f $argv[1]
            # change this to the appropriate open command for your setup i.e. MacOS might be open
            nomacs $argv[1]
        else
            echo "File not found: $argv[1]"
        end
    end

    echo ""
    echo "Which files would you like to open?"
    echo "N - None"
    echo "A - All"
    echo "D - Diff Image"
    echo "G - Generated Image"
    echo "E - Expected Image"
    echo "Or any two-letter combination from DGE"
    echo ""

    read -P "Enter your choice(N): " user_choice

    switch (string lower $user_choice)
        case a
            open_if_exists $diff_image
            open_if_exists $generated_image
            open_if_exists $expected_image
        case d
            open_if_exists $diff_image
        case g
            open_if_exists $generated_image
        case e
            open_if_exists $expected_image
        case dg gd
            open_if_exists $diff_image
            open_if_exists $generated_image
        case de ed
            open_if_exists $diff_image
            open_if_exists $expected_image
        case ge eg
            open_if_exists $generated_image
            open_if_exists $expected_image
        case '*'
            echo "No images selected for opening"
    end
end
