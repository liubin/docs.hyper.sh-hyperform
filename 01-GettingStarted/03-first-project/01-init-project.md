# Init Project


## Create project directory and `cd` to it
```
[root@centos ~]# mkdir my-first-project
[root@centos ~]# cd my-first-project
[root@centos my-first-project]#
```

- **Note:**
  - The following operations are all executed under the project directory.
  - Hyperform will take the basename of current directory as the project name.
    - So if there are two directories in different paths but with the same basename, hyperform will recognize them as the same project.


## Init project
Interactive mode:
```
[root@centos my-first-project]# hf init
Please enter the cloud provider[aws]:
Please enter your AWS access key id[]:********************
Please enter your AWS secret access key[]:********************
Please enter your region[]:us-east-2
Please enter the private key file path of the AWS keypair[]:~/.ssh/demo
Please enter the public key file path of the AWS keypair[]:~/.ssh/demo.pub
INFO[0032] Saved aws profile "default".
```

Or Non-interactive mode:

```
[root@centos my-first-project]# hf init \
                                  --cloud=aws \
                                  --access-key=$YOUR_AWS_ACCESS_KEY \
                                  --secret-key=$YOUR_AWS_SECRET_KEY \
                                  --private-key=$PATH_TO_YOUR_SSH_PRIVATE_KEY_FILE \
                                  --public-key=$PATH_TO_YOUR_SSH_PUBLIC_KEY_FILE \
                                  --region=$THE_AWS_REGION_YOU_CHOSE
INFO[0000] Saved aws profile "default".
```
**Note:** Please replace the variables with your actual values.

To view the config, just run `cat .hyperform/aws`.

