# Destroy Project

Finally, destroy the project:

```
[root@centos my-first-project]# hf destroy
ERRO[0000] There are still stacks in this project:
 nginx
 wordpress
Please remove all stacks before attempting to destroy this project, or use -f(--force).


[root@centos my-first-project]# hf destroy -f
WARN[0000] There are still stacks in this project:
 nginx
 wordpress
All stacks will be removed.
Please confirm to destroy this project[N/y]:y
INFO[0012] 1/1: destroy stack "nginx"
...

```
