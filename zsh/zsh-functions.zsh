# Copied from https://github.com/ChristianChiarulli/Machfiles/blob/master/zsh/.config/zsh/zsh-functions

# Function to source files if they exist
function zsh_add_file() {
    [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

function zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
        # For plugins
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
            zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
    fi
}


function zsh_add_completion() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
        # For completions
        completion_file_path=$(ls $ZDOTDIR/plugins/$PLUGIN_NAME/_*)
        fpath+="$(dirname "${completion_file_path}")"
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    else
        git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
        fpath+=$(ls $ZDOTDIR/plugins/$PLUGIN_NAME/_*)
        [ -f $ZDOTDIR/.zccompdump ] && $ZDOTDIR/.zccompdump
    fi
    completion_file="$(basename "${completion_file_path}")"
    if [ "$2" = true ] && compinit "${completion_file:1}"
}

function timezsh() {
    shell=${1-$SHELL}
    for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

function fwg {
    switch="$1"
    if [[ $switch == "enable" ]]; then
        sudo ufw allow in on wg0
        sudo ufw allow out on wg0
    elif [[ $switch == "disable" ]]; then
        sudo ufw deny in on wg0
        sudo ufw deny out on wg0
    fi
}

function copy() {
    command="${@}"
    if [[ $(uname -r) == *"WSL"* ]]; then
        eval $command | /mnt/c/Windows/SysWOW64/clip.exe
    elif [[ $WAYLAND_DISPLAY ]]; then
        eval $command | wl-copy
    else
        eval $command | xclip -sel c
    fi
}

function copycat() {
    filename="$1"
    [ ! -f $filename ] && echo "File not found" && return
    copy cat $filename
}

#0->not activated, 1-> activated
python_env_state=0
function venv-update() {
    if command -v deactivate &> /dev/null
    then
        #Checks if an initial env is running
        python_env_state=1
    fi

    if [ $python_env_state -eq 0 ]
    then
        if [ -f env/bin/activate ]
        then
            source env/bin/activate
        else
            echo "Not in virtual environment"
        fi
    elif [ $python_env_state -eq 1 ]
    then
        deactivate
        python_env_state=0
    fi
}

function new-session() {
    current=$(pwd)
    # zi $1
    zoxide query --interactive -- $1
    if  [ $? -ne 0 ]
    then
        return
    fi
    zellij --session "$(basename $(pwd))"
    cd $current
}

function zellij-session() {
    current=$(pwd)

    change=$(zoxide query --interactive -- $1)
    if  [ $? -ne 0 ]
    then
        return
    fi
    cd $change
    name=$(git-top-level)
    item=$(zellij ls 2> /dev/null | grep $name)
    if [ $? -ne 0 ]
    then
        zellij --session "$name"
    else
        zellij a "$name"
    fi
        
    cd $current
}

function git-top-level() {
    item=$(git rev-parse --show-toplevel)
    if [ $? -eq 0 ]
    then
        echo $(basename $item)
    else 
        echo $(basename $(pwd))
    fi
}



function zellij-list () {
    if [ -z "$1" ]
    then
        item=$(zellij ls -s )
    else
        item=$(zellij ls -s | grep $1)
    fi
    if [ $? -ne 0 ]
    then
        new-session $1
    else 
        echo $item | fzf | xargs -o zellij a
    fi
}

function zellij-session-create() {
    zellij --session "$(git-top-level)"
}

function zellij-delete() {
    items=$(zellij ls -s)
    echo $items | fzf | xargs -o zellij d
}

function gshash() {
    if [ -z "$1" ]
    then
        folder=$(gsutil ls gs:// | fzf)
    else
        folder=$(gs://$1)
    fi
    items=$(gsutil ls $folder)
    if [ $? -eq 0 ]
    then
        echo $items | fzf | xargs -o gsutil hash -m -h | grep "Hash (md5)" | cut -d ":" -f 2 | tr -d '[:space:]'
    fi
}

function bbrowse() {
    remote=$(git remote get-url origin)
    branch=$(git branch --show-current)
    if [[ $remote == *"bitbucket"* ]]; then
        repo=$(echo $remote | cut -d ":" -f 2 | cut -d "." -f 1)
        open https://bitbucket.org/$repo/src/$branch/
    else
        echo "Not a bitbucket repo"
    fi
}

function ansible-comp() {
    eval $(register-python-argcomplete ansible)
    eval $(register-python-argcomplete ansible-config)
    eval $(register-python-argcomplete ansible-console)
    eval $(register-python-argcomplete ansible-doc)
    eval $(register-python-argcomplete ansible-galaxy)
    eval $(register-python-argcomplete ansible-inventory)
    eval $(register-python-argcomplete ansible-playbook)
    eval $(register-python-argcomplete ansible-pull)
    eval $(register-python-argcomplete ansible-vault)
}

