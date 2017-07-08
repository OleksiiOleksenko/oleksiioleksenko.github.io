Title: Automated Deployment on Every Commit to Master Branch
Date: 2016-02-10 17:30
Category: IT Ops
Tags: git, vcs

A simple and common workflow for deployment of small applications is
to pull changes to the server on every commit to the master (especially,
if something like [Git Workflow](http://nvie.com/posts/a-successful-git-branching-model/) is used).

If done manually and in the most straightforward way, it looks like this:

* on local machine:

```sh
git commit [...]
git push origin master
```

* on server:

```sh
git pull origin master
```

Doing that manually is a bit too tedious, even for small one-man projects.
But, as it appears, it can be easily automated 
with [git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks). 

At first, we will set up a repository on the server side.

## Server

Let's say our working directory is in `/var/www`.
We will begin with setting up a bare git repository (for the version control files):

```sh
mkdir -p /var/www/repo/.git
cd /var/www/repo/.git
git --bare init
```

Then, we can create a non-bare repository (for the project files):

```sh
mkdir -p /var/www/site
```

Finally, to tell git where to transfer files, we will use a post-receive hook for the version control repository.
Create a file `/var/www/repo/.git/hooks/post-receive`:

```sh
#!/bin/sh

git --work-tree=/var/www/site --git-dir=/var/repo/.git checkout -f
```

and set permissions:

```sh
chmod +x post-commit
```

### Local machine

Suppose, we have a repository on `~/my_repo/`. To setup a path to the server we will add a remote to git:

```sh
git remote add server ssh://usr@domain.com/var/www/repo/.git
```

This allows us to push directly to the server by:

```sh
git push server master
```

To automate this action we add another hook which will be called after each commit.
On local machine, create a file `~/my_repo/.git/hooks/post-commit`:

```sh
#!/bin/sh

git push server master
```

and again set the permission to execute:

```sh
chmod +x post-commit
```

This hook, however, will be executed on every commit, not only to the master branch.
That's why we should add a check for branch:

```sh
#!/bin/sh

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

if [ "${BRANCH_NAME}" = "master" ]; then
    echo "Deploying to server..."
    git push server master
fi;
```

Now, after each commit to the master branch changes will be deployed to the server.
