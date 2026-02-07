function _fzf_search_directory --description "Search the current directory. Replace the current token with the selected file paths."
    # Directly use fd binary to avoid output buffering delay caused by a fd alias, if any.
    # Debian-based distros install fd as fdfind and the fd package is something else, so
    # check for fdfind first. Fall back to "fd" for a clear error message.
    set -f fd_cmd (command -v fdfind || command -v fd  || echo "fd")
    set -f --append fd_cmd --color=always $fzf_fd_opts

    set -f fzf_arguments --multi --ansi $fzf_directory_opts
    set -f token (commandline --current-token)
    # expand any variables or leading tilde (~) in the token
    set -f expanded_token (eval echo -- $token)
    # unescape token because it's already quoted so backslashes will mess up the path
    set -f unescaped_exp_token (string unescape -- $expanded_token)

    # Icon mode: when fzf_icon_cmd is set, pipe fd output through _fzf_add_icons
    # which produces tab-separated lines: <icon+path>\t<original_path>
    set -f preview_placeholder '{}'
    if set --query fzf_icon_cmd
        set --prepend fzf_arguments --delimiter=\t --with-nth=1
        set preview_placeholder '{2}'
    end

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match --quiet -- "*/" $unescaped_exp_token && test -d "$unescaped_exp_token"
        set --append fd_cmd --base-directory=$unescaped_exp_token
        # use the directory name as fzf's prompt to indicate the search is limited to that directory
        set --prepend fzf_arguments --prompt="Directory $unescaped_exp_token> " --preview="_fzf_preview_file $expanded_token$preview_placeholder"
        if set --query fzf_icon_cmd
            # Don't prepend base dir yet — strip icon decoration first, then prepend
            set -f file_paths_selected ($fd_cmd 2>/dev/null | _fzf_add_icons | _fzf_wrapper $fzf_arguments)
        else
            set -f file_paths_selected $unescaped_exp_token($fd_cmd 2>/dev/null | _fzf_wrapper $fzf_arguments)
        end
    else
        set --prepend fzf_arguments --prompt="Directory> " --query="$unescaped_exp_token" --preview="_fzf_preview_file $preview_placeholder"
        if set --query fzf_icon_cmd
            set -f file_paths_selected ($fd_cmd 2>/dev/null | _fzf_add_icons | _fzf_wrapper $fzf_arguments)
        else
            set -f file_paths_selected ($fd_cmd 2>/dev/null | _fzf_wrapper $fzf_arguments)
        end
    end

    if test $status -eq 0
        # Strip icon decoration if present, keeping only the original path from field 2
        if set --query fzf_icon_cmd
            set file_paths_selected (string replace --regex '^[^\t]*\t' '' -- $file_paths_selected)
            # Re-prepend base directory if we're in base-directory mode
            if string match --quiet -- "*/" $unescaped_exp_token && test -d "$unescaped_exp_token"
                set file_paths_selected $unescaped_exp_token$file_paths_selected
            end
        end
        commandline --current-token --replace -- (string escape -- $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
