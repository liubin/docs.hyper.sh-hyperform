## hf service inspect

Display detailed information on one or more services

<!-- usage -->

### Usage

```
Usage:
  hf service inspect [OPTIONS] SERVICE [SERVICE...]

Flags:
  -f, --format string   Format the output using the given Go template
  -h, --help            help for inspect
      --pretty          Print the information in a human friendly format
  -s, --stack string    Stack name

```
<!-- description and examples -->


### Description

Inspects the specified service. This command has to be run targeting a manager
node.

By default, this renders all results in a JSON array. If a format is specified,
the given template will be executed for each result.

Go's [text/template](http://golang.org/pkg/text/template/) package
describes all the details of the format.

### Examples

#### Inspect a service by name

You can inspect a service, only by its *name* now.

For example, given the following service;

```bash
$ hf service ls

STACK               NAME                REPLICAS/SPOT       IMAGE               DNSNAME                                                          PORTS
myweb               nginx               1/0                 nginx:alpine        myproject-myweb-lb-1339050635.ap-northeast-1.elb.amazonaws.com   80,443
nginx-basic         nginx               1/0                 nginx:alpine
```

You can use `hf service inspect nginx --stack myweb` to view the detail of the service.


```none
$ hf service inspect nginx --stack myweb

[
      {
          "ID": "myweb.nginx",
          "Version": {},
          "CreatedAt": "0001-01-01T00:00:00Z",
          "UpdatedAt": "0001-01-01T00:00:00Z",
          "Spec": {
              "Name": "nginx",
              "Labels": {
                  "com.docker.stack.image": "nginx:alpine",
                  "com.docker.stack.namespace": "myweb",
                  "role": "prod"
              },
              "TaskTemplate": {
                  "ContainerSpec": {
                      "Image": "nginx:alpine",
                      "Labels": {
                          "com.docker.stack.namespace": "myweb"
                      },
                      "Privileges": {
                          "CredentialSpec": null,
                          "SELinuxContext": null
                      }
                  },
                  "Resources": {},
                  "Placement": {},
                  "ForceUpdate": 0
              },
              "Mode": {
                  "Replicated": {
                      "Replicas": 1
                  }
              },
              "EndpointSpec": {
                  "Ports": [
                      {
                          "Protocol": "tcp",
                          "TargetPort": 80,
                          "PublishedPort": 8000,
                          "PublishMode": "ingress"
                      }
                  ]
              }
          },
          "Endpoint": {
              "Spec": {}
          }
      }
  ]
```

#### Formatting

You can print the inspect output in a human-readable format instead of the default
JSON output, by using the `--pretty` option:

```bash
$ hf service inspect nginx --stack myweb --pretty

  Stack:		myweb
  Name:		nginx
  Labels:
   com.docker.stack.image=nginx:alpine
   com.docker.stack.namespace=myweb
   role=prod
  Service Mode:	Replicated
   Replicas:	1
  Placement:
  ContainerSpec:
   Image:		nginx:alpine

```

You can also use `--format pretty` for the same effect.


##### Find the number of tasks running as part of a service

The `--format` option can be used to obtain specific information about a
service. For example, the following command outputs the number of replicas
of the "redis" service.

```bash
$  hf service inspect --format='{{.Spec.Mode.Replicated.Replicas}}' --stack myweb nginx
1
```

Or to check the service's image.

```bash
$ hf service inspect --format='{{.Spec.TaskTemplate.ContainerSpec.Image}}' --stack myweb nginx
nginx:alpine
```


<!-- see also -->

### SEE ALSO

* [hf service](hf_service.md)	 - Manage services

