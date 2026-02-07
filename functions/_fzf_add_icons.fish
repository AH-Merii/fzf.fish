function _fzf_add_icons --description "Decorate file paths with icons from fzf_icon_cmd."
    set -l batch
    set -l batch_size 100

    while read -l path
        set -a batch "$path"
        if test (count $batch) -ge $batch_size
            set -l decorated ($fzf_icon_cmd $batch 2>/dev/null)
            if test (count $decorated) -eq (count $batch)
                for i in (seq (count $batch))
                    printf '%s\t%s\n' "$decorated[$i]" "$batch[$i]"
                end
            else
                for path in $batch
                    printf '%s\t%s\n' "$path" "$path"
                end
            end
            set batch
        end
    end
    # flush remainder
    if test (count $batch) -gt 0
        set -l decorated ($fzf_icon_cmd $batch 2>/dev/null)
        if test (count $decorated) -eq (count $batch)
            for i in (seq (count $batch))
                printf '%s\t%s\n' "$decorated[$i]" "$batch[$i]"
            end
        else
            for path in $batch
                printf '%s\t%s\n' "$path" "$path"
            end
        end
    end
end
