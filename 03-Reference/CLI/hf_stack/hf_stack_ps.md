## hf stack ps

List the tasks in the stack

<!-- usage -->

### Usage

```
Usage:
  hf stack ps [OPTIONS] STACK

Flags:
      --format string   Pretty-print tasks using a Go template
  -h, --help            help for ps
      --no-trunc        Do not truncate output
  -q, --quiet           Only display task IDs

```
<!-- description and examples -->


### Description

Lists the tasks that are running as part of the specified stack. This
command has to be run targeting a manager node.

### Examples

#### List the tasks that are part of a service

The following command shows all the tasks that are part of the `redis` service:

```bash
$ hf service ps myweb
  ID                                SERVICE             NAME                  IMAGE               NODE                  PUBLIC IP           DESIRED STATE       CURRENT STATE               ERROR               PORTS
  myweb.nginx.i-0f96636c64ae5f166   nginx               i-0f96636c64ae5f166   nginx:alpine        i-0f96636c64ae5f166   13.114.28.239       Running             Running about an hour ago

```

#### Formatting

The formatting options (`--format`) pretty-prints tasks output
using a Go template.

Valid placeholders for the Go template are listed below:

Placeholder     | Description
----------------|------------------------------------------------------------------------------------------
`.ID`           | Task ID(Stack + Service + Instance)
`.Name`         | Service name
`.Image`        | Task image
`.Name`         | Instance ID
`.Node`         | Instance ID
`.DesiredState` | Desired state of the task (`running`, `shutdown`, or `accepted`)
`.CurrentState` | Current state of the task
`.Error`        | Error
`.Ports`        | Task published ports
`.PublicIP`     | Public IP address of the instance

When using the `--format` option, the `service ps` command will either
output the data exactly as the template declares or, when using the
`table` directive, includes column headers as well.

The following example uses a template without headers and outputs the
`Name` and `Image` entries separated by a colon for all tasks:

```bash
$ hf service ps --format "{{.PublicIP}}: {{.Image}}" myweb

13.114.28.239: nginx:alpine
```


<!-- see also -->

### SEE ALSO

* [hf stack](hf_stack.md)	 - Manage Docker stacks

