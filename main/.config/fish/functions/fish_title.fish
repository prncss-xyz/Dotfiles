function fish_title
    if set -q TERMINUSOPEN
        echo (basename $PWD)"/"
    else
        set pat (realpath --relative-base=$HOME $PWD)
        if [ "$pat" = "." ]
            set pat "~"
        end
        set branch (git branch --show-current 2>/dev/null)
        if [ -n "$branch" ]
            echo "$pat — $branch"
            #      echo  " $branch — $pat"
        else
            echo $pat
        end
    end
end
