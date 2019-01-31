# Lock computer by putting it to sleep
alias lock='pmset displaysleepnow'

# Basic stuff
alias home='cd ~'
alias temp='cd ~/Desktop/tmp/'
alias up='cd ..'
alias ll='ls -lahG'
alias h='history'
alias g='git'
alias c='clear'
alias cl='clear'

# Cheat sheets
alias cheatvim='mdless ~/cheatsheets/vim.md'
alias cheatbash='mdless ~/cheatsheets/bash.md'
alias cheattmux='mdless ~/cheatsheets/tmux.md'
alias cheatless='mdless ~/cheatsheets/less.md'

hf() {
  history | grep -i $1
}

dirSize() {
  du -hd 0 $1
}

fetchGithubFile() {
	curl -H "Accept: application/vnd.github.VERSION.raw" https://api.github.com/repos/$1/$2/contents/$3
}

fetchGithubGistFile() {
  curl -H "Accept: application/vnd.github.VERSION.raw" https://gist.githubusercontent.com/$1/$2/raw/$3 

}

mdless() {
	pandoc -s -f markdown -t man $1 | groff -T utf8 -man | less
}
