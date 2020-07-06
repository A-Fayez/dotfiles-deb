# gets custom zsh completions from 
# https://github.com/zsh-users/zsh-completions/
# Usage: add_completion <completion_plugin_name>
add_completion() {

    if [ -z $1 ]
    then
        echo "No argument supplied"
        return 1
    fi

    curl -sfSL https://raw.githubusercontent.com/zsh-users/zsh-completions/master/src/_$1 > ~/dotfiles/zsh-completions/_$1

    if [ $? -ne 0 ]; then
        echo "No such completion file or name"
        rm -f ~/dotfiles/zsh-completions/_$1
    else
        echo "Added _$1 succussfully to ~/dotfiles/zsh-completions"
    fi
}