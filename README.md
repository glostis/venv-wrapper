# venv-wrapper

### zsh plugin defining functions to wrap working with python's builtin venv module

Managing your virtual environments using python's `python -m venv` has the advantage of not requiring any external dependencies (unlike [virtualenv](https://github.com/pypa/virtualenv)), but has the disadvantage of not being very user-friendly/fast.

This plugin provides `zsh` functions to ease the management of your virtual environments.

## Installation

If you use [zgen](https://github.com/tarjoilija/zgen) as your plugin manager, you can simply add `zgen load glostis/venv-wrapper` to the relevant section of your `~/.zshrc` (see [here](https://github.com/tarjoilija/zgen#example-zshrc) for an example `~/.zshrc` using `zgen` to load plugins).


## Usage

To list your existing virtual environments:
```
$ venv
Type `venv name_of_env` to activate a virtual environment.

Here is the list of existing virtual environments:
--------------------------------------------------
my_venv_1
my_venv_2
```

Activating an existing virtual environment:
```
$ venv my_venv_1
(my_venv_1) $
```

Deactivating a virtual environment:
```
(my_venv_1) $ deactivate
$
```

Creating a new virtual environment:
```
$ venv my_venv_3
Virtual environment `my_venv_3` does not exist.
Do you want to create it? [y/n] y
Created and activated venv my_venv_3
(my_venv_3) $
```

(you can also directly call `mkvenv my_venv_3` which will skip the prompt)

Removing a virtual environment:
```
(my_venv_3) $ deactivate  # You must be outside of a venv before removing it
$ rmvenv my_venv_3
Removed venv my_venv_3
```

This plugin autocompletes the names of existing virtual environments (try `venv my_ven<TAB>`)

## Configuration

You can set the `VENV_WRAPPER_PYTHON` environment variable to choose which `python` executable is used to create virtual environments. By default, `python3` is used.
