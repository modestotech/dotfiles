if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

if command -v brew >/dev/null 2>&1; then
	# Load rupa's z if installed
	[ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
fi

# Note that ~/.bash_rc is not read by any program, and ~/.bashrc is the configuration file of interactive instances of bash. You should not define environment variables in ~/.bashrc. The right place to define environment variables such as PATH is ~/.profile (or ~/.bash_profile if you don't care about shells other than bash). 
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH:/Users/$(whoami)/bin"
