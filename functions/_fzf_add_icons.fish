function _fzf_add_icons --description "Decorate file paths with icons from fzf_icon_cmd."
    while read -l path
        set -l decorated ($fzf_icon_cmd "$path" 2>/dev/null)
        if test (count $decorated) -eq 1
            printf '%s\t%s\n' "$decorated" "$path"
        else
            printf '%s\t%s\n' "$path" "$path"
        end
    end
end
