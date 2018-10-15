## hf inspect

Return low-level information on Docker objects

<!-- usage -->

### Usage

```
Usage:
  hf inspect [OPTIONS] NAME|ID [NAME|ID...]

Flags:
  -f, --format string   Format the output using the given Go template
  -h, --help            help for inspect
  -s, --size            Display total file sizes if the type is container
      --type string     Return JSON for specified type

```
<!-- description and examples -->


### Description

Hyperform inspect provides container's detailed information on constructs controlled by Docker.

By default, `hf inspect` will render results in a JSON array.

### Request a custom response format (--format)

If a format is specified, the given template will be executed for each result.

Go's [text/template](http://golang.org/pkg/text/template/) package
describes all the details of the format.

### Examples

#### Get an instance's IP address

For the most part, you can pick out any field from the JSON in a fairly
straightforward manner.

```bash
$ hf inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTIANER_ID
```

#### Get an instance's image name

```bash
$ hf inspect --format='{{.Config.Image}}' $CONTIANER_ID
```

#### List all port bindings

You can loop over arrays and maps in the results to produce simple text
output:

```bash
$ hf inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' $CONTIANER_ID
```

#### Get a subsection in JSON format

If you request a field which is itself a structure containing other
fields, by default you get a Go-style dump of the inner values.
Docker adds a template function, `json`, which can be applied to get
results in JSON format.

```bash
$ hf inspect --format='{{json .Config}}' $CONTIANER_ID
```


