---
layout: post
date: 2016-03-04 12:00
title: Normalize Path without Following Symbolic Links
tag: "IT Ops"
comments: true
---

Recently I got into a trouble with relative paths used in combination with symbolic links. The situation was following. I have a link:

```
/path/to/symlink -> /linked/path
```

And I have a file, path to which has to be relative to the symlink:

```sh
RELATIVE_FILE_PATH="/path/to/symlink/foo/../../file"
```

The task was to resolve the path and get a normalized one, that is, `/path/to/file`. The default shell behavior, however, is to follow symlinks (which is correct, but not what I need). For example, if I try to test if this file exists

```sh
if [ ! -x ${RELATIVE_FILE_PATH} ]; then
    echo Error!
if
```

I would get an error, even though the file is there. The solution I found was to use `cd` command, since it doesn't follow symlinks. The resulting function:

```sh
function get_path() {
    relative_path="$1"
    normalized_path="$(cd $(dirname ${relative_path});pwd)/$(basename relative_path})"
    echo ${normalized_path}
}
```

And the test itself looks like:

```sh
if [ ! -x $(get_path "${RELATIVE_FILE_PATH}") ]; then
    echo Error!
if
```







