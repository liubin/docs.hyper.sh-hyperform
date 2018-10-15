## hf service ls

List services

<!-- usage -->

### Usage

```
Usage:
  hf service ls [OPTIONS]

Aliases:
  ls, list

Flags:
      --format string   Pretty-print services using a Go template
  -h, --help            help for ls
  -q, --quiet           Only display IDs

```
<!-- description and examples -->


### Description

This command when run targeting a manager, lists services are running in the
swarm.

### Examples

On a manager node:

```bash
$ hf service ls

STACK               NAME                REPLICAS/SPOT       IMAGE               DNSNAME                                                          PORTS
myweb               nginx               1/0                 nginx:alpine        myproject-myweb-lb-1339050635.ap-northeast-1.elb.amazonaws.com   80,443
nginx-basic         nginx               1/0                 nginx:alpine
```

The `REPLICAS` column shows both the desired *total* and *spot* instances(contianers) number of tasks for
the service.

* `REPLICAS`: total replicas of the service.
* `SPOT`: containers number that running in spot instances.
* `DNSNAME`: if the service is using a cloud loadbalancer, it will be displayed here.
* `PORTS`: ports in loadbalaner's listeners.


```

#### Formatting

The formatting options (`--format`) pretty-prints services output
using a Go template.

Valid placeholders for the Go template are listed below:

Placeholder | Description
------------|------------------------------------------------------------------------------------------
`.Name`     | Service name
`.Replicas` | Service replicas
`.Image`    | Service image
`.DnsName`  | Cloud loadbalancer's DNS name if cloud loadbalancers is used
`.Ports`    | Service ports published in ingress mode

When using the `--format` option, the `service ls` command will either
output the data exactly as the template declares or, when using the
`table` directive, includes column headers as well.

The following example uses a template without headers and outputs the
`Stack`, `Name`, `DnsName` and `Ports` entries separated by a colon for all services:

```bash
$  hf service ls --format "table {{.Stack}}\t{{.Name}}\t{{.DnsName}}:{{.Ports}}"
STACK               NAME                DNSNAME:PORTS
myweb               nginx               myproject-myweb-lb-2339050635.ap-northeast-1.elb.amazonaws.com:80,443
nginx-basic         nginx               :

```


<!-- see also -->

### SEE ALSO

* [hf service](hf_service.md)	 - Manage services

