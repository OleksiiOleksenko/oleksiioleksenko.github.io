Title: Writing an Activation Script
Date: 2016-02-25 12:00
Category: IT Ops
Tags: shell

Sometimes when working on a project there is a need to temporary change the environment of the shell. One of the options for that is to use a so-called _activation script_:

```sh
source ./activate.sh
```

Activation scripts may not be that common, but they are a convenient tool in some cases. For example, they can be encountered in the Python [virtualenv](https://github.com/pypa/virtualenv) as a way of starting a virtual environment. I've also found them useful for en- and disabling a debug mode (e.g., here - [DockerizedDjango](https://github.com/OleksiiOleksenko/dockerized-django)). So how does one make such script?

The main goal of it is to store the old environment (usually, environmental variables) and setup a new one. Let's assume that we want to temporary change the variable `PATH`. Saving old value is as simple as:

```sh
_OLD_PATH="$PATH"
PATH="/usr/bin"
export PATH
```

To deactivate the environment and restore the old `PATH` we will provide a function:

```sh
deactivate () {
    if [ -n "$_OLD_PATH" ] ; then
        PATH=$_OLD_PATH
        export PATH
        unset _OLD_PATH
    fi
}
```

When we combine these two in the single script `activate.sh`, the usage is:

```sh
>> source ./activate.sh  # to activate the environment
>> echo $PATH
/usr/bin 
>> deactivate  # to deactivate it
```

That already accomplishes the task, but there is one issue. Sometimes it gets confusing whether you've already activated environment or not. To make it explicit, we will change the prompt by prepending the `(basename \"my_env\")` to the `PS1` variable. It means, that when the environment is activated, the prompts will look like this:

```sh
old_prompt >> source ./activate.sh
(my_env) old_prompt >> deactivate
old_prompt >>
```

The final script looks like this:

```sh
# Enable environment
# save old path
_OLD_PATH="$PATH"
PATH="/usr/bin"
export PATH

# make nice prompt
_OLD_PS1="$PS1"
PS1="(`basename \"my_env\"`) $PS1"
export PS1

# Disable environment
deactivate () {
    # reset old path
    if [ -n "$_OLD_PATH" ] ; then
        PATH=$_OLD_PATH
        export PATH
        unset _OLD_PATH
    fi

    # restore prompt
    if [ -n "$_OLD_PS1" ] ; then
        PS1="$_OLD_PS1"
        export PS1
        unset _OLD_PS1
    fi
}
```
