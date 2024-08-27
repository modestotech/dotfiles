# User specific aliases and functions
source ~/.bash_aliases

# Git stuff is adapted for running git bash on Windows Terminal

# Convert Windows-style path to Unix-style path
# To handle /c/ and C:/
function win_to_unix_path() {
  echo "$1" | sed 's|C:|/c|; s|\\|/|g'
}

function git_prompt_dir() {
  local git_root
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ $? -eq 0 ]; then
    local git_root_clean
    local pwd_clean

    # Convert Git root path to Unix-style
    git_root_clean=$(win_to_unix_path "$git_root")
    # Convert pwd path to Unix-style
    pwd_clean=$(win_to_unix_path "$(pwd)")

    # Strip Git root from current working directory
    local relative_path="${pwd_clean#$git_root_clean}"

    # Handle case where the path is just the Git root
    if [ -z "$relative_path" ]; then
      echo "🏠"
    else
      echo "🏠$relative_path"
    fi
  else
    # Not in a Git repository, show absolute path
    echo "$(win_to_unix_path "$PWD")"
  fi
}

function get_path() {
  local git_root
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ $? -eq 0 ]; then
    # In a Git repository
    local relative_path
    relative_path=$(git_prompt_dir)
    printf "$relative_path"
  else
    # Not in a Git repository
    printf "%s" "$(win_to_unix_path "$PWD")"
  fi
}

function get_branch() {
  local git_root
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ $? -eq 0 ]; then
    local branch
    branch="$(__git_ps1 "%s")"
    printf " 🔹 🌱 %s" "$branch"
  else
    # Not in a Git repository
    printf ""
  fi
}

function get_status() {
  local git_root
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ $? -eq 0 ]; then
    local status_emoji
    status_emoji=$(if [[ -n "$(git status --porcelain)" ]]; then echo "🛠️"; else echo "✅"; fi)
    printf " 🔹 🗂️ %s" "$status_emoji"
  else
    # Not in a Git repository
    printf ""
  fi
}

# Don't be tempted to move this into one big function as it messed up the terminal line wrapping when setting color codes inside a function
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\] 🔹 \[\033[01;33m\]$(get_path)\[\033[00m\]\[\033[01;34m\]$(get_branch)\[\033[00m\]$(get_status) \$ '

# Some formatting of history
export HISTFILE=~/.bash_history
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=300
export HISTTIMEFORMAT='%b %d %R -> '
export HISTIGNORE="?:??:pwd:exit:df:ls:ls -la:ll"

# Add more commands with ;
PROMPT_COMMAND='history -a' # Save the history after each command