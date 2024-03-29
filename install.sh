#!/bin/bash 

set -uo pipefail
shopt -s dotglob
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

echo "installing dotfiles.."

# install git if not installed already
if ! command -v git >/dev/null 2>&1; then
    echo "Installing git"
    apt-get update
    apt-get install git -y
fi

git submodule update --init --recursive

# install tmux
if ! command -v tmux >/dev/null 2>&1; then
    echo "installing tmux"
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

# shells
source "$HOME/dotfiles/shells/install"

# configs
mkdir -p "$HOME"/.config
for dir in "$HOME/dotfiles/config"/*; do
    ln -svf "$dir" "$HOME/.config"
done

# out-of-xdg confings
ln -svf "$HOME/dotfiles/.tmux.conf" "$HOME"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


tmux source-file ~/.tmux.conf
source ~/.zshrc

echo "Done!"

