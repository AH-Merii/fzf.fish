# Define a mock icon command that prefixes each path with an icon
function my_icon_cmd
    for arg in $argv
        echo "F $arg"
    end
end
set fzf_icon_cmd my_icon_cmd

mock commandline --current-token "echo tests/_resources/multi word dir/"
mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS "--filter=''"

set actual (_fzf_search_directory)
set expected "'tests/_resources/multi word dir/file 1.txt' 'tests/_resources/multi word dir/file 2.txt'"
@test "returns original paths when icon mode is enabled" "$actual" = $expected
