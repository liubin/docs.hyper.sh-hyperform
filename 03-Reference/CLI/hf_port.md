## hf port

List port mappings or a specific mapping for the container

<!-- usage -->

### Usage

```
Usage:
  hf port CONTAINER [PRIVATE_PORT[/PROTO]]

Flags:
  -h, --help   help for port

```
<!-- description and examples -->


### Examples

#### Show all mapped ports

You can find out all the ports mapped by not specifying a `PRIVATE_PORT`, or
just a specific mapping:

```bash
$ hf ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                            NAMES
b650456536c7        busybox:latest      top                 54 minutes ago      Up 54 minutes       0.0.0.0:1234->9876/tcp, 0.0.0.0:4321->7890/tcp   test
$ hf port test
7890/tcp -> 0.0.0.0:4321
9876/tcp -> 0.0.0.0:1234
$ hf port test 7890/tcp
0.0.0.0:4321
$ hf port test 7890/udp
2014/06/24 11:53:36 Error: No public port '7890/udp' published for test
$ hf port test 7890
0.0.0.0:4321
```


