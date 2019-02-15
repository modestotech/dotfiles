echo -n "Uptime: "; uptime
echo ""

source ~/.bash_aliases

# For printing the current git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
 }

export PS1="\W\$(parse_git_branch) $ "
export EDITOR="/usr/local/bin/vim"

# Some formatting of history
export HISTSIZE=300
export HISTTIMEFORMAT='%b %d %R -> '
export HISTIGNORE="?:??:history:pwd:exit:df:ls:ls -la:ll"
