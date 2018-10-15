## hf kill

Kill one or more running containers

<!-- usage -->

### Usage

```
Usage:
  hf kill [OPTIONS] CONTAINER [CONTAINER...]

Flags:
  -h, --help            help for kill
  -s, --signal string   Signal to send to the container (default "KILL")

```
<!-- description and examples -->


### Description

The `hf kill` subcommand kills one or more containers. The main process
inside the container is sent `SIGKILL` signal (default), or the signal that is
specified with the `--signal` option. You can kill a container using the
container's ID, ID-prefix, or name.

> **Note**: `ENTRYPOINT` and `CMD` in the *shell* form run as a subcommand of
> `/bin/sh -c`, which does not pass signals. This means that the executable is
> not the container’s PID 1 and does not receive Unix signals.

### Examples


#### Send a KILL signal  to a container

The following example sends the default `KILL` signal to the container named
`c4bfba59427e`:

```bash
$ hf kill c4bfba59427e
```

#### Send a custom signal  to a container

The following example sends a `SIGHUP` signal to the container named
`c4bfba59427e`:

```bash
$ hf kill --signal=SIGHUP  c4bfba59427e
```


You can specify a custom signal either by _name_, or _number_. The `SIG` prefix
is optional, so the following examples are equivalent:

```bash
$ hf kill --signal=SIGHUP c4bfba59427e
$ hf kill --signal=HUP c4bfba59427e
$ hf kill --signal=1 c4bfba59427e
```

Refer to the [`signal(7)`](http://man7.org/linux/man-pages/man7/signal.7.html)
man-page for a list of standard Linux signals.


