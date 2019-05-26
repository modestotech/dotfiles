echo -n "Uptime: "; uptime


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

case "${unameOut}" in
    Linux*)     
			# User specific environment
			if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
			then
					PATH="$HOME/.local/bin:$HOME/bin:$PATH"
			fi
			export PATH

			# Uncomment the following line if you don't like systemctl's auto-paging feature:
			# export SYSTEMD_PAGER=
		;;
    Darwin*)    
			ORIG_PATH=$PATH
			export PATH="/usr/local/sbin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:$ORIG_PATH:/Users/$(whoami)/bin"
		;;
esac

# User specific aliases and functions
source ~/.bash_aliases

# For printing the current git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
 }

export PS1="\W\$(parse_git_branch) $ "
export EDITOR="/usr/local/bin/vim"

# For making glob * include dotfiles
shopt -s dotglob

# Some formatting of history
export HISTSIZE=300
export HISTTIMEFORMAT='%b %d %R -> '
export HISTIGNORE="?:??:history:pwd:exit:df:ls:ls -la:ll"
