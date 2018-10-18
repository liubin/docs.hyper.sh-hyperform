## hf



<!-- usage -->

### Usage

```
Usage:
  hf [command]

Available Commands:
  config      Manage cloud configs
  cp          Copy files/folders between a container and the local filesystem
  destroy     Destroy all cloud resources for project
  diff        Inspect changes to files or directories on a container's filesystem
  exec        Run a command in a running container
  help        Help about any command
  init        Config for cloud and create cloud resources for project
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  logs        Fetch the logs of a container
  port        List port mappings or a specific mapping for the container
  ps          List containers
  restart     Restart one or more containers
  service     Manage services
  stack       Manage Docker stacks
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  top         Display the running processes of a container

Flags:
  -h, --help   help for hf

Use "hf [command] --help" for more information about a command.

```
<!-- description and examples -->


### Examples

#### Display help text

To list the help on any command just execute the command, followed by the
`--help` option.

    $  hf deploy --help

      Usage:	hf deploy [OPTIONS]

      Deploy a new stack or update an existing stack

      Options:
        -c, --compose-file strings   Path to a Compose file, or "-" to read from stdin
            --dry-run                Do compose file validation only
            --refresh                Refresh cloud resources first
            --reset                  Recreate the terraform state dir

#### Option types

Single character command line options can be combined, so rather than
typing `hf exec -i -t busybox sh`,
you can write `hf exec -it busybox sh`.

##### Boolean

Boolean options take the form `-d=false`. The value you see in the help text is
the default value which is set if you do **not** specify that flag. If you
specify a Boolean flag without a value, this will set the flag to `true`,
irrespective of the default value.

For example, running `hf stack rm -f` will set the value to `true`, options which default to `true` can only be
set to the non-default value by explicitly setting them to `false`.

##### Multi

You can specify options like `-e=[]` multiple times in a single command line,
for example in these commands:

```bash
$ hf exec -e evn1=val1 -e env2=val2 -it ubuntu /bin/bash
```

##### Strings and Integers

Options like `--log-level""` expect a string, and they
can only be specified once. Options like `-n=1`
expect an integer, and they can only be specified once.


<!-- see also -->

### SEE ALSO

* [hf config](hf_config/hf_config.md)	 - Manage cloud configs
* [hf cp](hf_cp.md)	 - Copy files/folders between a container and the local filesystem
* [hf destroy](hf_destroy.md)	 - Destroy all cloud resources for project
* [hf diff](hf_diff.md)	 - Inspect changes to files or directories on a container's filesystem
* [hf exec](hf_exec.md)	 - Run a command in a running container
* [hf init](hf_init.md)	 - Config for cloud and create cloud resources for project
* [hf inspect](hf_inspect.md)	 - Return low-level information on Docker objects
* [hf kill](hf_kill.md)	 - Kill one or more running containers
* [hf logs](hf_logs.md)	 - Fetch the logs of a container
* [hf port](hf_port.md)	 - List port mappings or a specific mapping for the container
* [hf ps](hf_ps.md)	 - List containers
* [hf restart](hf_restart.md)	 - Restart one or more containers
* [hf service](hf_service/hf_service.md)	 - Manage services
* [hf stack](hf_stack/hf_stack.md)	 - Manage Docker stacks
* [hf start](hf_start.md)	 - Start one or more stopped containers
* [hf stats](hf_stats.md)	 - Display a live stream of container(s) resource usage statistics
* [hf stop](hf_stop.md)	 - Stop one or more running containers
* [hf top](hf_top.md)	 - Display the running processes of a container

