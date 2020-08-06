# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


export PATH=/mnt/hdd/npm/npm-global/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin
export XDG_CONFIG_HOME=

export PATH="$HOME/.cargo/bin:$PATH"
