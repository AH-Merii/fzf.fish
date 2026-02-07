# Mock icon command that returns wrong number of lines (triggers fallback)
function bad_icon_cmd
    echo "only one line"
end
set fzf_icon_cmd bad_icon_cmd

mock commandline --current-token "echo tests/_resources/multi word dir/"
mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS "--filter=''"

set actual (_fzf_search_directory)
set expected "'tests/_resources/multi word dir/file 1.txt' 'tests/_resources/multi word dir/file 2.txt'"
@test "falls back to plain paths when icon command output count mismatches" "$actual" = $expected
