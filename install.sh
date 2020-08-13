#!/usr/bin/env sh

set -uo pipefail
shopt -s dotglob
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

echo "Installing dotfiles.."

# install git if not installed already
if ! command -v git >/dev/null 2>&1; then
    echo "Installing git"
    apt-get update
    apt-get install git -y
fi

git submodule update --init --recursive

# install tmux
if ! command -v tmux >/dev/null 2>&1; then
    echo "Installing tmux"
    apt-get install tmux -y
fi

# install zsh 
if ! command -v zsh >/dev/null 2>&1; then
    echo "Installing zsh"
    apt install zsh -y
elif ! [[ $SHELL =~ .*zsh.* ]]; then
    echo "Configuring zsh as default shell"
    chsh -s "$(command -v zsh)"
fi

zsh_path="$( command -v zsh )"

if ! grep "$zsh_path" /etc/shells; then
    echo "adding $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells
fi

# sourcing and symlinking files
for file in $(pwd)/*; do
    if [ ! -d "$file" ] && ["$file" != "$(pwd)/.gitignore"] && ["$file" != "$(pwd)/.gitmodules"] && ["$file" != "$(pwd)/.directory"]; then
        ln -sv "$file" "$HOME"
    fi
done

tmux source-file ~/.tmux.conf
source ~/.zshrc

echo "Done!"

# scripts

for script in "${pwd}/bin"; do
    ln -sv "$script" "/usr/local/bin"
fi

# TODO: alacritty and nvim
