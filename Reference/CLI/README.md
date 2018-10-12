# CLI

```
$ hf

Usage:	hyper [OPTIONS] COMMAND

A serverless runtime for containers

Options:
  -D, --debug              Enable debug mode
      --invalid-cache      Invalid(re-create) all cloud caches
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
  -T, --ssh-timeout int    Set the timeout for remote ssh operations
  -v, --version            Print version information and quit

Management Commands:
  config      Manage cloud configs
  container   Manage containers
  service     Manage services
  stack       Manage Docker stacks

Commands:
  cp          Copy files/folders between a container and the local filesystem
  deploy      Deploy a new stack or update an existing stack
  destroy     Destroy all cloud resources for project
  diff        Inspect changes to files or directories on a container's filesystem
  exec        Run a command in a running container
  init        Create cloud resources for project
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  logs        Fetch the logs of a container
  port        List port mappings or a specific mapping for the container
  ps          List containers
  restart     Restart one or more containers
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  top         Display the running processes of a container

Run 'hyper COMMAND --help' for more information on a command.
```
