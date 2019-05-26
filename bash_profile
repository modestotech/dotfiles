if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Machine: ${machine}"
echo ""

case "${unameOut}" in
    Linux*)     
		
		;;
    Darwin*)    

		# Use bash completion if it's available
		if [ -f $(brew --prefix)/etc/bash_completion ]; then
			. $(brew --prefix)/etc/bash_completion
		fi

		# Note that ~/.bash_rc is not read by any program, and ~/.bashrc is the configuration file of interactive instances of bash. You should not define environment variables in ~/.bashrc. The right place to define environment variables such as PATH is ~/.profile (or ~/.bash_profile if you don't care about shells other than bash). 

		;;
esac
