---
layout: post
date: 2016-02-18 18:30
title: "Change Nginx Timezone in CentOS"
tag: Dev
comments: true
---


I recently had an issue with setting up a correct timezone in Nginx logs. A simple googling gave
me an answer that I should either set the environmental variable `TZ` or change the startup script
(e.g., for CentOS it's `/etc/init.d/nginx`). The first one for some reason didn't work for me and the second
seemed as a hack (and may not survive an update).

As it appeared, Nginx uses `/etc/localtime`, which in turn can be set with `timedatectl` command.
It led to the following solution:

```sh
rm /etc/localtime  # remove previous value
timedatectl set-timezone Europe/Berlin  # set new timezone
ls -l /etc/localtime  # check if everything is alright

reload nginx -s reload
```