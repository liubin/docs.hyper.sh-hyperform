## hf stack ls

List stacks

<!-- usage -->

### Usage

```
Usage:
  hf stack ls [OPTIONS]

Aliases:
  ls, list

Flags:
      --format string       Pretty-print stacks using a Go template
  -h, --help                help for ls
      --namespace strings   Kubernetes namespaces to use

```
<!-- description and examples -->


### Description

Lists the stacks.

### Examples

The following command shows all stacks and some additional information:

```bash
$ hf stack ls
PROJECT             NAME                SERVICES
myproject           myweb               1
myproject           nginx-basic         1

```

#### Formatting

The formatting option (`--format`) pretty-prints stacks using a Go template.

Valid placeholders for the Go template are listed below:

| Placeholder     | Description        |
| --------------- | ------------------ |
| `.Name`         | Stack name         |
| `.Services`     | Number of services |

When using the `--format` option, the `stack ls` command either outputs
the data exactly as the template declares or, when using the
`table` directive, includes column headers as well.

The following example uses a template without headers and outputs the
`Name` and `Services` entries separated by a colon for all stacks:

```bash
$ hf stack ls --format "{{.Name}}: {{.Services}}"
myweb: 1
nginx-basic: 1
```


<!-- see also -->

### SEE ALSO

* [hf stack](hf_stack.md)	 - Manage Docker stacks

