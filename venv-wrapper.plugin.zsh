export VENV_HOME="$HOME/.venv"
[[ -d $VENV_HOME ]] || mkdir $VENV_HOME

lsvenv() {
    EXISTING_VENVS=$(ls $VENV_HOME)
    if [ "$EXISTING_VENVS" = "" ]; then
        (>&2 echo "You currently have no virtual environment.")
        (>&2 echo "To make one, type \`mkvenv name_of_env\`")
    else
        (>&2 echo "Here is the list of existing virtual environments:")
        (>&2 echo "--------------------------------------------------")
        (>&2 echo $EXISTING_VENVS)
    fi
}

venv() {
    # Check that exactly one and only one argument was passed to the function
    if [ $# -eq 1 ]; then
        source "$VENV_HOME/$1/bin/activate" 2> /dev/null
        # If previous command returned an error code
        if [ ! $? -eq 0 ]; then
            (>&2 echo "Virtual environment \`$1\` does not exist.")
            while true; do
                read -q "yn?Do you want to create it? [y/n]"
                echo
                if [[ "$yn" = "y" ]]; then
                    mkvenv "$1"
                    break
                elif [[ "$yn" = "n" ]]; then
                    return 1
                fi
            done
        fi
    else
        (>&2 echo "Type \`venv name_of_env\` to activate a virtual environment.\n")
        lsvenv
        return 1
    fi
}

mkvenv() {
    # Check that exactly one and only one argument was passed to the function
    if [ $# -eq 1 ]; then
        VENV_NAME=$(python -c "import sys; import os; assert hasattr(sys, 'base_prefix'); print(os.path.basename(sys.prefix))" 2> /dev/null)
        if [ $? -eq 0 ]; then
            (>&2 echo "You must first deactivate your current virtual environment before creating a new one,")
            (>&2 echo "by typing: \`deactivate\`")
            return 1
        fi
        if [ -d "${VENV_HOME}/$1" ]; then
            (>&2 echo "Virtual environment $1 already exists.")
            (>&2 echo "To remove it, run \`deactivate; rmvenv $1\`")
            return 1
        else
            python3 -m venv $VENV_HOME/$1
            venv $1
            echo "Created and activated venv $1"
        fi
    else
        (>&2 echo "Type \`mkvenv name_of_env\` to make a new virtual environment.")
        return 1
    fi
}

rmvenv() {
    # Check that exactly one and only one argument was passed to the function
    if [ $# -gt 0 ]; then
        for arg in "$@"; do
            _rmvenv "$arg"
        done
    else
        (>&2 echo "Type \`rmvenv name_of_env\` to remove an existing virtual environment.\n")
        lsvenv
        return 1
    fi
}

_rmvenv() {
    VENV_NAME=$(python -c "import sys; import os; assert hasattr(sys, 'base_prefix'); print(os.path.basename(sys.prefix))" 2> /dev/null)
    if [ $? -eq 0 ]; then
        if [ "$VENV_NAME" = "$1" ]; then
            (>&2 echo "You must first deactivate your virtual environment before removing it,")
            (>&2 echo "by typing: \`deactivate; rmvenv $1\`")
            return 1
        fi
    fi
    if [ -d "$VENV_HOME/$1" ]; then
        rm -r $VENV_HOME/$1
        echo "Removed venv $1"
    else
        (>&2 echo "venv $1 does not exist.\n")
        lsvenv
        return 1
    fi
}

function purgenv {
    if $(python -c "import sys; assert hasattr(sys, 'base_prefix')"); then
        echo "You are in the matrix"
        env_name=$(which python | rev | cut -d/ -f3 | rev)
        deactivate
        rmvenv $env_name
        mkvenv $env_name
    else
        echo "You are in the real world"
    fi
}

_venv_completion () {
    _values echo $(ls -1 $VENV_HOME)
}

compdef _venv_completion venv rmvenv
