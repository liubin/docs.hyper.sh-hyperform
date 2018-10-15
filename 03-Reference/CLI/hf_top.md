## hf top

Display the running processes of a container

<!-- usage -->

### Usage

```
Usage:
  hf top CONTAINER [ps OPTIONS]

Flags:
  -h, --help   help for top

```
<!-- description and examples -->

### Examples

```bash
$ hf top c4bfba59427e

PID                 USER                TIME                COMMAND
3958                root                0:00                nginx: master process nginx -g daemon off;
4012                chrony              0:00                nginx: worker process
```


