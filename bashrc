echo -n "Uptime: "; uptime
echo ""

# Use bash completion if it's available
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

source ~/.bash_aliases

# For printing the current git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
 }

export PS1="\W\$(parse_git_branch) $ "

# Some formatting of history
export HISTSIZE=300
export HISTTIMEFORMAT='%b %d %R -> '
export HISTIGNORE="?:??:history:pwd:exit:df:ls:ls -la:ll"

# Some formatting of grep
export GREP_COLOR="34;47"
export GREP_OPTIONS="--color=auto"
