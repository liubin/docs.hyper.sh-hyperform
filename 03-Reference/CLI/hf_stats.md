## hf stats

Display a live stream of container(s) resource usage statistics

<!-- usage -->

### Usage

```
Usage:
  hf stats [OPTIONS] CONTAINER

Flags:
  -a, --all             Show all containers (default shows just running)
      --format string   Pretty-print images using a Go template
  -h, --help            help for stats
      --no-stream       Disable streaming stats and only pull the first result
      --no-trunc        Do not truncate output

```
<!-- description and examples -->


### Description

The `hf stats` command returns a live data stream for running containers.
Different to Docker, `hf stats` can view only one contianer's stats.

> **Note**: The `PIDS` column contains the number of processes and kernel threads created by that container. Threads is the term used by Linux kernel. Other equivalent terms are "lightweight process" or "kernel task", etc. A large number in the `PIDS` column combined with a small number of processes (as reported by `ps` or `top`) may indicate that something in the container is creating many threads.

### Examples

Running `hf stats` on all running containers against a Linux daemon.

```bash
$ hf stats c4bfba59427e

CONTAINER ID        NAME                                    CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
c4bfba59427e        nginx-basic.nginx.i-07ed29e21bcb7a187   0.00%               1.992MiB / 996.1MiB   0.20%               1.04kB / 0B         0B / 0B             2
```

If you don't [specify a format string using `--format`](#formatting), the
following columns are shown.

| Column name               | Description                                                                                   |
|---------------------------|-----------------------------------------------------------------------------------------------|
| `CONTAINER ID` and `Name` | the ID and name of the container                                                              |
| `CPU %` and `MEM %`       | the percentage of the host's CPU and memory the container is using                            |
| `MEM USAGE / LIMIT`       | the total memory the container is using, and the total amount of memory it is allowed to use  |
| `NET I/O`                 | The amount of data the container has sent and received over its network interface             |
| `BLOCK I/O`               | The amount of data the container has read to and written from block devices on the host       |
| `PIDs`                    | the number of processes or threads the container has created                                  |

#### Formatting

The formatting option (`--format`) pretty prints container output
using a Go template.

Valid placeholders for the Go template are listed below:

Placeholder  | Description
------------ | --------------------------------------------
`.Container` | Container name or ID (user input)
`.Name`      | Container name
`.ID`        | Container ID
`.CPUPerc`   | CPU percentage
`.MemUsage`  | Memory usage
`.NetIO`     | Network IO
`.BlockIO`   | Block IO
`.MemPerc`   | Memory percentage (Not available on Windows)
`.PIDs`      | Number of PIDs (Not available on Windows)


When using the `--format` option, the `stats` command either
outputs the data exactly as the template declares or, when using the
`table` directive, includes column headers as well.

The following example uses a template without headers and outputs the
`Container` and `CPUPerc` entries separated by a colon for all images:

```bash
$ hf stats --format "{{.Container}}: {{.CPUPerc}}" c4bfba59427e

c4bfba59427e: 0.00%
```

To list all containers statistics with their name, CPU percentage and memory
usage in a table format you can use:

```bash
$ hf stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" c4bfba59427e

CONTAINER           CPU %               MEM USAGE / LIMIT
c4bfba59427e        0.00%               1.992MiB / 996.1MiB
```

The default format is as follows:

    "table {{.ID}}\t{{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}"



