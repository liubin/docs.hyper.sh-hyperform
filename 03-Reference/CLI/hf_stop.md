## hf stop

Stop one or more running containers

<!-- usage -->

### Usage

```
Usage:
  hf stop [OPTIONS] CONTAINER [CONTAINER...]

Flags:
  -h, --help       help for stop
  -t, --time int   Seconds to wait for stop before killing it (default 10)

```
<!-- description and examples -->


### Description

The main process inside the container will receive `SIGTERM`, and after a grace period, `SIGKILL`.

### Examples

```bash
$ hf stop c4bfba59427e
```


