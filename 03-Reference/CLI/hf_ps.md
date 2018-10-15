## hf ps

List containers

<!-- usage -->

### Usage

```
Usage:
  hf ps [OPTIONS]

Flags:
  -a, --all              Show all containers (default shows just running)
  -f, --filter filter    Filter output based on conditions provided
      --format string    Pretty-print containers using a Go template
  -h, --help             help for ps
  -n, --last int         Show n last created containers (includes all states) (default -1)
  -l, --latest           Show the latest created container (includes all states)
      --no-trunc         Don't truncate output
  -q, --quiet            Only display numeric IDs
      --service string   Service name
  -s, --size             Display total file sizes
      --stack string     Stack name

```
<!-- description and examples -->


### Examples

#### List all running containers

```
$ hf ps
STACK               SERVICE             ZONE                INSTANCE              PUBLIC IP           CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                  NAMES
nginx-basic         nginx               ap-northeast-1c     i-07ed29e21bcb7a187   54.92.46.214        c4bfba59427e        nginx:alpine        "nginx -g 'daemon of…"   About a minute ago   Up About a minute   0.0.0.0:8000->80/tcp   nginx-basic.nginx.i-07ed29e21bcb7a187
myweb               nginx               ap-northeast-1d     i-0f96636c64ae5f166   13.114.28.239       2d1d5938b3cd        nginx:alpine        "nginx -g 'daemon of…"   21 minutes ago       Up 21 minutes       0.0.0.0:8000->80/tcp   myweb.nginx.i-0f96636c64ae5f166
```

`hf ps` groups exposed ports into a single range if possible. E.g., a
container that exposes TCP ports `100, 101, 102` displays `100-102/tcp` in
the `PORTS` column.

#### Filtering

The filtering flag (`-f` or `--filter`) format is a `key=value` pair. If there is more
than one filter, then pass multiple flags (e.g. `--filter "foo=bar" --filter "bif=baz"`)

The currently supported filters are:

| Filter                | Description                                                                                                                          |
|:----------------------|:-------------------------------------------------------------------------------------------------------------------------------------|
| `id`                  | Container's ID                                                                                                                       |
| `name`                | Container's name                                                                                                                     |
| `label`               | An arbitrary string representing either a key or a key-value pair. Expressed as `<key>` or `<key>=<value>`                           |
| `exited`              | An integer representing the container's exit code. Only useful with `--all`.                                                         |
| `status`              | One of `created`, `restarting`, `running`, `removing`, `paused`, `exited`, or `dead`                                                 |
| `ancestor`            | Filters containers which share a given image as an ancestor. Expressed as `<image-name>[:<tag>]`,  `<image id>`, or `<image@digest>` |
| `before` or `since`   | Filters containers created before or after a given container ID or name                                                              |
| `volume`              | Filters running containers which have mounted a given volume or bind mount.                                                          |
| `publish` or `expose` | Filters containers which publish or expose a given port. Expressed as `<port>[/<proto>]` or `<startport-endport>/[<proto>]`          |


##### label

The `label` filter matches containers based on the presence of a `label` alone or a `label` and a
value.

The following filter matches containers with the `color` label regardless of its value.

```bash
$ hf ps --filter "label=role"

STACK               SERVICE             ZONE                INSTANCE              PUBLIC IP           CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                  NAMES
nginx-basic         nginx               ap-northeast-1c     i-07ed29e21bcb7a187   54.92.46.214        c4bfba59427e        nginx:alpine        "nginx -g 'daemon of…"   About a minute ago   Up About a minute   0.0.0.0:8000->80/tcp   nginx-basic.nginx.i-07ed29e21bcb7a187
myweb               nginx               ap-northeast-1d     i-0f96636c64ae5f166   13.114.28.239       2d1d5938b3cd        nginx:alpine        "nginx -g 'daemon of…"   21 minutes ago       Up 21 minutes       0.0.0.0:8000->80/tcp   myweb.nginx.i-0f96636c64ae5f166
```

The following filter matches containers with the `color` label with the `blue` value.

```bash
$ hf ps --filter "label=role=test"

STACK               SERVICE             ZONE                INSTANCE              PUBLIC IP           CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
nginx-basic         nginx               ap-northeast-1c     i-07ed29e21bcb7a187   54.92.46.214        c4bfba59427e        nginx:alpine        "nginx -g 'daemon of…"   7 minutes ago       Up 7 minutes        0.0.0.0:8000->80/tcp   nginx-basic.nginx.i-07ed29e21bcb7a187
```

##### name

The `name` filter matches on all or part of a container's name.

The following filter matches all containers with a name containing the `nostalgic_stallman` string.

```bash
$ hf ps --filter "name=myweb.nginx.i-0f96636c64ae5f166"
  STACK               SERVICE             ZONE                INSTANCE              PUBLIC IP           CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
  myweb               nginx               ap-northeast-1d     i-0f96636c64ae5f166   13.114.28.239       2d1d5938b3cd        nginx:alpine        "nginx -g 'daemon of…"   29 minutes ago      Up 29 minutes       0.0.0.0:8000->80/tcp   myweb.nginx.i-0f96636c64ae5f166
```

You can also filter for a substring in a name as this shows:

```bash
$ hf ps --filter "name=myweb"
  STACK               SERVICE             ZONE                INSTANCE              PUBLIC IP           CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
  myweb               nginx               ap-northeast-1d     i-0f96636c64ae5f166   13.114.28.239       2d1d5938b3cd        nginx:alpine        "nginx -g 'daemon of…"   29 minutes ago      Up 29 minutes       0.0.0.0:8000->80/tcp   myweb.nginx.i-0f96636c64ae5f166

```

##### status

The `status` filter matches containers by status. You can filter using
`created`, `restarting`, `running`, `removing`, `paused`, `exited` and `dead`. For example,
to filter for `running` containers:

```bash
$ hf ps --filter status=running

STACK               SERVICE             ZONE                INSTANCE              PUBLIC IP           CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
nginx-basic         nginx               ap-northeast-1c     i-07ed29e21bcb7a187   54.92.46.214        c4bfba59427e        nginx:alpine        "nginx -g 'daemon of…"   11 minutes ago      Up 11 minutes       0.0.0.0:8000->80/tcp   nginx-basic.nginx.i-07ed29e21bcb7a187
myweb               nginx               ap-northeast-1d     i-0f96636c64ae5f166   13.114.28.239       2d1d5938b3cd        nginx:alpine        "nginx -g 'daemon of…"   32 minutes ago      Up 32 minutes       0.0.0.0:8000->80/tcp   myweb.nginx.i-0f96636c64ae5f166
```

##### ancestor

The `ancestor` filter matches containers based on its image or a descendant of
it. The filter supports the following image representation:

- `image`
- `image:tag`
- `image:tag@digest`
- `short-id`
- `full-id`

If you don't specify a `tag`, the `latest` tag is used. For example, to filter
for containers that use the latest `nginx:alpine` image:

```bash
$ hf ps --filter ancestor=nginx:alpine

STACK               SERVICE             ZONE                INSTANCE              PUBLIC IP           CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
nginx-basic         nginx               ap-northeast-1c     i-07ed29e21bcb7a187   54.92.46.214        c4bfba59427e        nginx:alpine        "nginx -g 'daemon of…"   11 minutes ago      Up 11 minutes       0.0.0.0:8000->80/tcp   nginx-basic.nginx.i-07ed29e21bcb7a187
myweb               nginx               ap-northeast-1d     i-0f96636c64ae5f166   13.114.28.239       2d1d5938b3cd        nginx:alpine        "nginx -g 'daemon of…"   32 minutes ago      Up 32 minutes       0.0.0.0:8000->80/tcp   myweb.nginx.i-0f96636c64ae5f166
```

##### publish and expose

The `publish` and `expose` filters show only containers that have published or exposed port with a given port
number, port range, and/or protocol. The default protocol is `tcp` when not specified.

The following filter matches all containers that have published port of 80:

```bash
$ hf ps --filter publish=80

STACK               SERVICE             ZONE                INSTANCE              PUBLIC IP           CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
nginx-basic         nginx               ap-northeast-1c     i-07ed29e21bcb7a187   54.92.46.214        c4bfba59427e        nginx:alpine        "nginx -g 'daemon of…"   14 minutes ago      Up 14 minutes       0.0.0.0:8000->80/tcp   nginx-basic.nginx.i-07ed29e21bcb7a187
myweb               nginx               ap-northeast-1d     i-0f96636c64ae5f166   13.114.28.239       2d1d5938b3cd        nginx:alpine        "nginx -g 'daemon of…"   35 minutes ago      Up 35 minutes       0.0.0.0:8000->80/tcp   myweb.nginx.i-0f96636c64ae5f166
```

#### Formatting

The formatting option (`--format`) pretty-prints container output using a Go
template.

Valid placeholders for the Go template are listed below:

| Placeholder   | Description                                                                                     |
|:--------------|:------------------------------------------------------------------------------------------------|
| `.Stack`      | Stack                                                                                           |
| `.Service`    | Service                                                                                   |
| `.Zone`       | Zone of cloud provider                                                                                    |
| `.Instance`   | Instance Id in cloud provider                                                                                    |
| `.PublicIp`   | Public IP address of cloud instance                                                                                    |
| `.ID`         | Container ID                                                                                    |
| `.Image`      | Image ID                                                                                        |
| `.Command`    | Quoted command                                                                                  |
| `.CreatedAt`  | Time when the container was created.                                                            |
| `.RunningFor` | Elapsed time since the container was started.                                                   |
| `.Ports`      | Exposed ports.                                                                                  |
| `.Status`     | Container status.                                                                               |
| `.Size`       | Container disk size.                                                                            |
| `.Names`      | Container names.                                                                                |
| `.Labels`     | All labels assigned to the container.                                                           |
| `.Label`      | Value of a specific label for this container.                                                   |
| `.Mounts`     | Names of the volumes mounted in this container.                                                 |

When using the `--format` option, the `ps` command will either output the data
exactly as the template declares or, when using the `table` directive, includes
column headers as well.

The following example uses a template without headers and outputs the `ID`, `Stack`, `Service`, and
`PublicIp` entries separated by a colon for all running containers:

```bash
$ hf ps --format "table {{.ID}}\t{{.Stack}}\t{{.Service}}\t{{.PublicIP}}"

CONTAINER ID        STACK               SERVICE             PUBLIC IP
c4bfba59427e        nginx-basic         nginx               54.92.46.214
2d1d5938b3cd        myweb               nginx               13.114.28.239
```

