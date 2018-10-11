# Deploy Your First Project


## Create project directory and `cd` to it
```
[root@centos ~]# mkdir my-first-project
[root@centos ~]# cd my-first-project
[root@centos my-first-project]#
```

**Note: The following operations are all executed under the project directory.**


## Generate project config
```
[root@centos my-first-project]# hf config aws set \
                                  --access-key=$YOUR_AWS_ACCESS_KEY \
                                  --secret-key=$YOUR_AWS_SECRET_KEY \
                                  --private-key=$PATH_TO_YOUR_SSH_PRIVATE_KEY \
                                  --public-key=$PATH_TO_YOUR_SSH_PUBLIC_KEY \
                                  --region=$ONE_AWS_REGION_YOU_CHOSE
INFO[0000] Saved aws profile "default".
```

To view the config, just run 'hf config aws show' or 'cat .hyperform/aws'.


## Init cloud environment for project
```
[root@centos my-first-project]# hf init
```

A series of AWS resources will be created. Check the output for details.


## Deploy a stack from compose file

Generate compose file:
```
[root@centos my-first-project]# cat > nginx-basic.yaml << EOF
version: '3.8'

stack: nginx-basic

services:
   nginx:
     image: nginx:alpine
     deploy:
       public: true
     ports:
       - "8000:80"
EOF
```

Do deploy:
```
[root@centos my-first-project]# hf stack deploy -c nginx-basic.yaml
```

Verify:
```
# list stacks
[root@centos my-first-project]# hf stack ls
PROJECT             NAME                SERVICES
my-first-project    nginx-basic         1

# list services
[root@centos my-first-project]# hf service ls
STACK               NAME                REPLICAS/SPOT       IMAGE               DNSNAME             PORTS
nginx-basic         nginx               1/0                 nginx:alpine                            

# list containers
[root@centos my-first-project]# hf ps
STACK               SERVICE             ZONE                INSTANCE              PUBLIC IP           CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
nginx-basic         nginx               us-east-2a          i-030d8e62a1efcd9da   18.191.150.243      c4908d07bb50        nginx:alpine        "nginx -g 'daemon of…"   2 minutes ago       Up 2 minutes        0.0.0.0:8000->80/tcp   nginx-basic.nginx.i-030d8e62a1efcd9da

```

Now you can access the nginx service via 'PUBLIC IP' (in this demo it's 18.191.150.243):
```
$ curl http://18.191.150.243:8000
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

```


## Remove 'nginx-basic' stack
```
[root@centos my-first-project]# hf stack rm nginx-basic --force
```


## Clean up cloud environment for project
```
[root@centos my-first-project]# hf destroy
```
