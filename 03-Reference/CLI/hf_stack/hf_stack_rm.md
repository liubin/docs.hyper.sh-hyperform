## hf stack rm

Remove one or more stacks

<!-- usage -->

### Usage

```
Usage:
  hf stack rm [OPTIONS] STACK [STACK...]

Aliases:
  rm, remove, down

Flags:
  -f, --force   Force the removal of a stack without confirmation
  -h, --help    help for rm

```
<!-- description and examples -->


### Description

Remove the stack from cloud.

### Examples

#### Remove a stack

This will remove the stack with the name `myweb`. Services, loadblancers, volumes, and secrets associated with the stack will be removed.

```bash
$ hf stack rm --force myweb

Removing service myapp_redis
Removing service myapp_web
Removing service myapp_lb
Removing network myapp_default
Removing network myapp_frontend
```


<!-- see also -->

### SEE ALSO

* [hf stack](hf_stack.md)	 - Manage Docker stacks

