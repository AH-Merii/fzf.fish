# Mock icon command that reverses argument order (simulates eza's default sorting)
# This catches the batch-reordering bug: if _fzf_add_icons passes multiple paths
# at once, the decorated↔original pairing breaks when the command reorders output.
function reordering_icon_cmd
    set -l reversed
    for i in (seq (count $argv) -1 1)
        set -a reversed $argv[$i]
    end
    for arg in $reversed
        echo "F $arg"
    end
end
set fzf_icon_cmd reordering_icon_cmd

mock commandline --current-token "echo tests/_resources/multi word dir/"
mock commandline "--current-token --replace --" "echo \$argv"
mock commandline \* ""
set --export --append FZF_DEFAULT_OPTS "--filter=''"

set actual (_fzf_search_directory)
set expected "'tests/_resources/multi word dir/file 1.txt' 'tests/_resources/multi word dir/file 2.txt'"
@test "returns original paths when icon command reorders output" "$actual" = $expected
