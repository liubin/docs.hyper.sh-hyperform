# Deploy Stack 'nginx'


## Generate Compose File
```
[root@centos my-first-project]# cat > nginx.yaml << EOF
version: '3.8'

stack: nginx

services:
   nginx:
     image: nginx:alpine
     deploy:
       public: true
     ports:
       - "8000:80"
EOF
```


## Do Deploy
```
[root@centos my-first-project]# hf stack deploy -c nginx.yaml
```


## Verify

Show stacks under the project.

```
[root@centos my-first-project]# hf stack ls
PROJECT             NAME                SERVICES
my-first-project    nginx               1
```

Show services.

```
[root@centos my-first-project]# hf service ls
STACK               NAME                REPLICAS/SPOT       IMAGE               DNSNAME             PORTS
nginx               nginx               1/0                 nginx:alpine
```

Show all running containers.

```
[root@centos my-first-project]# hf ps
STACK               SERVICE             ZONE                INSTANCE              PUBLIC IP           CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                  NAMES
nginx               nginx               ap-southeast-1a     i-0c909acf905dbaebd   13.229.211.254      c76896ac9684        nginx:alpine        "nginx -g 'daemon of…"   About a minute ago   Up About a minute   0.0.0.0:8000->80/tcp   nginx.nginx.i-0c909acf905dbaebd
```


When the nginx service is running, you can access the nginx service via `PUBLIC IP` (In this demo it's `13.229.211.254`):

```
[root@centos my-first-project]# curl http://13.229.211.254:8000
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

