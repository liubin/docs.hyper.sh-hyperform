# Init Project


## Create project directory and `cd` to it
```
[root@centos ~]# mkdir my-first-project
[root@centos ~]# cd my-first-project
[root@centos my-first-project]#
```

**Note: The following operations are all executed under the project directory.**


## Generate project config
**Note: Please replace the variables with your real values.**

```
[root@centos my-first-project]# hf config aws set \
                                  --access-key=$YOUR_AWS_ACCESS_KEY \
                                  --secret-key=$YOUR_AWS_SECRET_KEY \
                                  --private-key=$PATH_TO_YOUR_SSH_PRIVATE_KEY \
                                  --public-key=$PATH_TO_YOUR_SSH_PUBLIC_KEY \
                                  --region=$THE_AWS_REGION_YOU_CHOSE
INFO[0000] Saved aws profile "default".
```

To view the config, just run `hf config aws show` or `cat .hyperform/aws`.


## Init cloud environment for project
```
[root@centos my-first-project]# hf init
```

A series of AWS resources will be created. Check the output for details.

