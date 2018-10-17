# Service configuration reference

A service definition contains configuration that is applied to each container started for that service.

Options specified in the Dockerfile, such as `CMD`, `EXPOSE`, `ENV`, are respected by default - you don't need to specify them again.

This section contains a list of all configuration options supported by a service definition.


## command

Override the default command.

    command: bundle exec thin -p 3000

The command can also be a list:

    command: ["bundle", "exec", "thin", "-p", "3000"]


## deploy

Specify configuration related to the deployment and running of services. 

    services:
      web:
        image: nginx
        deploy:
          replicas: 2
          preemptible: 1
          public: true
          size: t2.micro
          restart_policy:
            condition: on-failure
          labels:
            label-1: "a"
            label-2: "b"

Several sub-options are available:

#### labels

Specify labels for the service. These labels are *only* set on the service,
and *not* on any containers for the service.

    version: "3"
    services:
      web:
        image: web
        deploy:
          labels:
            com.example.description: "This label will appear on the web service"

To set labels on containers instead, use the `labels` key outside of `deploy`:

    version: "3"
    services:
      web:
        image: web
        labels:
          com.example.description: "This label will appear on all containers for the web service"

#### replicas

Specify the number of containers that should be running at any given time.

#### size

Configures container instance size. The available value depends on the cloud provider:

- [AWS](https://aws.amazon.com/ec2/instance-types/): by default `t2.micro` 

#### preemptible

Preemptible replicas use low-cost spot instances to reduce the bill (up to 90% less). These containers are subject to interruptions. Therefore a good use case of preemptible replicas is ***Stateless workload***, where container loss is tolerable.  

This parameter allows you to configure the number of preemptible replicas in the service. For a service of 4 replicas, you may want all of them are preemptible to minimize the cost (`preemptible: 4`), or none (default), or 2 to make sure at least two replicas will not be interrupted to avoid complete service down.

```
version: '3'
services:
  vote:
    image: nginx
    deploy:
      replicas: 4
      preemptible: 2
```

In the case that interruption happens, some preemptible replicas (or all) will receive a graceful period to exit (depending on the cloud, 2 minutes on AWS). When the replica is terminated, Hyper will automatically attempt to launch new replicas to to ensure your desired capacity. It will try to launch preemptible instance first, and if not working, fallback regular instances, and opportunistically will revert to preemptible instances when it is available again.

#### public

Configures whether the service is public accessible. If `true`, every container of the service will receive a public IPv4 address (shown in `hf ps`). By default `false`.

#### zone

Configures the availability zones the containers will spread. This helps you improve HA of your application by distributing replicas in multiple zones. If absent, the containers will be placed in all zones of the project region.

> The available value depends on the cloud provider and region.

```
version: '3'
services:
  vote:
    image: nginx
    deploy:
      replicas: 2
      zone:
      - us-east-1a
      - us-east-1b
```

#### restart_policy

Configures if and how to restart containers when they exit.

- `condition`: One of `none`, `on-failure` or `any` (default: `any`).
- `max_attempts`: How many times to attempt to restart a container before giving
  up (default: never give up).

```
version: "3"
services:
  redis:
    image: redis:alpine
    deploy:
      restart_policy:
        condition: on-failure
        max_attempts: 3
```

## entrypoint

Override the default entrypoint.

    entrypoint: /code/entrypoint.sh

The entrypoint can also be a list, in a manner similar to dockerfile:

    entrypoint:
        - php
        - -d
        - zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so
        - -d
        - memory_limit=-1
        - vendor/bin/phpunit

> **Note**: Setting `entrypoint` both overrides any default entrypoint set
> on the service's image with the `ENTRYPOINT` Dockerfile instruction, *and*
> clears out any default command on the image - meaning that if there's a `CMD`
> instruction in the Dockerfile, it is ignored.

## env_file

Add environment variables from a file. Can be a single value or a list.

Paths in `env_file` are relative to the project directory.

Environment variables declared in the [environment](#environment) section
_override_ these values &ndash; this holds true even if those values are
empty or undefined.

    env_file: .env

    env_file:
      - ./common.env
      - ./apps/web.env
      - /opt/secrets.env

Hyperform expects each line in an env file to be in `VAR=VAL` format. Lines
beginning with `#` are treated as comments and are ignored. Blank lines are
also ignored.

    # Set Rails/Rack environment
    RACK_ENV=development

The value of `VAL` is used as is and not modified at all. For example if the
value is surrounded by quotes (as is often the case of shell variables), the
quotes are included in the value passed to Hyperform.

Keep in mind that _the order of files in the list is significant in determining
the value assigned to a variable that shows up more than once_. The files in the
list are processed from the top down. For the same variable specified in file
`a.env` and assigned a different value in file `b.env`, if `b.env` is
listed below (after), then the value from `b.env` stands. For example, given the
following declaration in compose file:

```
services:
  some-service:
    env_file:
      - a.env
      - b.env
```

And the following files:

```
# a.env
VAR=1
```

and

```
# b.env
VAR=hello
```

$VAR is `hello`.

## environment

Add environment variables. You can use either an array or a dictionary. Any
boolean values; true, false, yes no, need to be enclosed in quotes to ensure
they are not converted to True or False by the YML parser.

    environment:
      RACK_ENV: development
      SHOW: 'true'
      SESSION_SECRET:

    environment:
      - RACK_ENV=development
      - SHOW=true
      - SESSION_SECRET

## expose

Expose ports without publishing them to the host machine - they'll only be
accessible to linked services. Only the internal port can be specified.

    expose:
     - "3000"
     - "8000"

## extra_hosts

Add hostname mappings. Use the same values as the docker client `--add-host` parameter.

    extra_hosts:
     - "somehost:162.242.195.82"
     - "otherhost:50.31.209.229"

An entry with the ip address and hostname is created in `/etc/hosts` inside containers for this service, e.g:

    162.242.195.82  somehost
    50.31.209.229   otherhost

## image

Specify the image to start the container from. Can either be a repository/tag or
a partial image ID.

    image: redis
    image: ubuntu:14.04
    image: tutum/influxdb
    image: example-registry.com:4000/postgresql
    image: a4bc65fd

## labels

Add metadata to containers using Docker labels. You can use either an array or a dictionary.

It's recommended that you use reverse-DNS notation to prevent your labels from conflicting with those used by other software.

    labels:
      com.example.description: "Accounting webapp"
      com.example.department: "Finance"
      com.example.label-with-empty-value: ""

    labels:
      - "com.example.description=Accounting webapp"
      - "com.example.department=Finance"
      - "com.example.label-with-empty-value"

## ports

Expose ports.

#### Short syntax

Either specify both ports (`HOST:CONTAINER`), or just the container
port (an ephemeral host port is chosen).

> **Note**: When mapping ports in the `HOST:CONTAINER` format, you may experience
> erroneous results when using a container port lower than 60, because YAML
> parses numbers in the format `xx:yy` as a base-60 value. For this reason,
> we recommend always explicitly specifying your port mappings as strings.

    ports:
     - "3000"
     - "3000-3005"
     - "8000:8000"
     - "9090-9091:8080-8081"
     - "49100:22"
     - "127.0.0.1:8001:8001"
     - "127.0.0.1:5000-5010:5000-5010"
     - "6060:6060/udp"

#### Long syntax

The long form syntax allows the configuration of additional fields that can't be
expressed in the short form.

- `target`: the port inside the container
- `published`: the publicly exposed port
- `protocol`: the port protocol (`tcp` or `udp`)
- TBD `mode`: `host` for publishing a host port on each node, or `ingress` for a swarm
   mode port to be load balanced.

```
ports:
  - target: 80
    published: 8080
    protocol: tcp
    mode: host

```

## secrets

Grant access to secrets on a per-service basis using the per-service `secrets`
configuration.

> **Note**: The secret must be defined in the [top-level `secrets` configuration](03-secrets.md)
> of this compose file, or stack deployment fails.

Hyperform support two types of secrets: `docker_registry` and normal secret.

The following example grants the `redis` service access to the `normal_secret`and
`dockerregistry1` secrets. The value of `normal_secret` is set to the contents of the file
`./my_secret.txt`, and will be mounted at `/run/secrets/normal_secret` within the container.
The `dockerregistry1` secrets will be used to login to the registry when pulling image.

```
services:
  redis:
    image: xxxx/redis:latest
    deploy:
      replicas: 1
    secrets:
      - normal_secret
      - dockerregistry1
secrets:
  dockerregistry1:
    type: docker_registry
    registry: index.docker.io
    username: $DOCKERHUB_USERNAME
    email: $DOCKERHUB_EMAIL
    password: $DOCKERHUB_PASSWORD
  normal_secret:
    file: ./my_secret.txt
```

You can grant a service access to multiple secrets and you can mix docker_registry
and normal secret. Defining a secret does not imply granting a service access to it.

## ulimits

Override the default ulimits for a container. You can either specify a single
limit as an integer or soft/hard limits as a mapping.


    ulimits:
      nproc: 65535
      nofile:
        soft: 20000
        hard: 40000

## volumes

Mount cloud volumes (or cloud disks) defined in the [top-level `volumes` configuration] (02-volume.md),
specified as sub-options to a service.

This example shows a named volume (`mydata`) being used by the `web` service.

```
services:
  web:
    image: nginx:alpine
    volumes:
      - mysql-data:/data

volumes:
  mydata:
```

## domainname, hostname, ipc, mac\_address, privileged, read\_only, shm\_size, stdin\_open, tty, user, working\_dir

Each of these is a single value, analogous to its `docker run` counterpart.

    user: postgresql
    working_dir: /code

    domainname: foo.com
    hostname: foo
    ipc: host
    mac_address: 02:42:ac:11:65:43

    privileged: true

    read_only: true
    shm_size: 64M
    stdin_open: true
    tty: true

