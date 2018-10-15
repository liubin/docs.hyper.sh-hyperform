## hf stack deploy

Deploy a new stack or update an existing stack

<!-- usage -->

### Usage

```
Usage:
  hf stack deploy [OPTIONS]

Aliases:
  deploy, up

Flags:
  -c, --compose-file strings   Path to a Compose file, or "-" to read from stdin
      --dry-run                Do compose file validation only
  -h, --help                   help for deploy
      --refresh                Refresh cloud resources first
      --reset                  Recreate the terraform state dir

```
<!-- description and examples -->


### Description

Create and update a stack from a compose-file extended Docker's compose file on any cloud.

### Examples

#### Compose file

The `deploy` command supports compose file version `3.8` and above.

```bash
$ hf stack deploy --compose-file hf-compose.yml

```

You can verify that the services were correctly created:

```bash
$ hf service ls

STACK               NAME                REPLICAS/SPOT       IMAGE               DNSNAME                                                          PORTS
myweb               nginx               1/0                 nginx:alpine        myproject-myweb-lb-1339050635.ap-northeast-1.elb.amazonaws.com   80,443
nginx-basic         nginx               1/0                 nginx:alpine
```


<!-- see also -->

### SEE ALSO

* [hf stack](hf_stack.md)	 - Manage Docker stacks

