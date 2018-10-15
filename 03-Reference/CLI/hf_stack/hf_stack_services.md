## hf stack services

List the services in the stack

<!-- usage -->

### Usage

```
Usage:
  hf stack services [OPTIONS] STACK

Flags:
      --format string   Pretty-print services using a Go template
  -h, --help            help for services
  -q, --quiet           Only display IDs

```
<!-- description and examples -->


### Description

Lists the services that are running as part of the specified stack.

### Examples

The following command shows all services in the `myapp` stack:

```bash
$ hf stack services myapp

STACK               NAME                REPLICAS/SPOT       IMAGE               DNSNAME                                                          PORTS
myweb               nginx               1/0                 nginx:alpine        myproject-myweb-lb-1339050635.ap-northeast-1.elb.amazonaws.com   80,443
nginx-basic         nginx               1/0                 nginx:alpine
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

When using the `--format` option, the `stack services` command will either
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

* [hf stack](hf_stack.md)	 - Manage Docker stacks

