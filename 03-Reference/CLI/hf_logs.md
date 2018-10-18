## hf logs

Fetch the logs of a container

<!-- usage -->

### Usage

```
Usage:
  hf logs [OPTIONS] CONTAINER

Flags:
      --details        Show extra details provided to logs
  -f, --follow         Follow log output
  -h, --help           help for logs
      --since string   Show logs since timestamp (e.g. 2013-01-02T13:23:37) or relative (e.g. 42m for 42 minutes)
      --tail string    Number of lines to show from the end of the logs (default "all")
  -t, --timestamps     Show timestamps
      --until string   Show logs before a timestamp (e.g. 2013-01-02T13:23:37) or relative (e.g. 42m for 42 minutes)

```
<!-- description and examples -->


### Description

The `hf logs` command batch-retrieves logs present at the time of execution.

The `hf logs --follow` command will continue streaming the new output from
the container's `STDOUT` and `STDERR`.

Passing a negative number or a non-integer to `--tail` is invalid and the
value is set to `all` in that case.

The `hf logs --timestamps` command will add an [RFC3339Nano timestamp](https://golang.org/pkg/time/#pkg-constants)
, for example `2014-09-16T06:17:46.000000000Z`, to each
log entry. To ensure that the timestamps are aligned the
nano-second part of the timestamp will be padded with zero when necessary.

The `hf logs --details` command will add on extra attributes, such as
environment variables and labels, provided to `--log-opt` when creating the
container.

The `--since` option shows only the container logs generated after
a given date. You can specify the date as an RFC 3339 date, a UNIX
timestamp, or a Go duration string (e.g. `1m30s`, `3h`). Besides RFC3339 date
format you may also use RFC3339Nano, `2006-01-02T15:04:05`,
`2006-01-02T15:04:05.999999999`, `2006-01-02Z07:00`, and `2006-01-02`. The local
timezone on the client will be used if you do not provide either a `Z` or a
`+-00:00` timezone offset at the end of the timestamp. When providing Unix
timestamps enter seconds[.nanoseconds], where seconds is the number of seconds
that have elapsed since January 1, 1970 (midnight UTC/GMT), not counting leap
seconds (aka Unix epoch or Unix time), and the optional .nanoseconds field is a
fraction of a second no more than nine digits long. You can combine the
`--since` option with either or both of the `--follow` or `--tail` options.

### Examples

#### Retrieve logs until a specific point in time

In order to retrieve logs before a specific point in time, run:

```bash
$ hf logs -f fc213e37b6fa
172.28.5.73 - - [15/Oct/2018:09:47:32 +0000] "GET / HTTP/1.1" 200 612 "-" "ELB-HealthChecker/1.0" "-"
172.28.5.73 - - [15/Oct/2018:09:48:31 +0000] "GET / HTTP/1.1" 200 612 "-" "ELB-HealthChecker/1.0" "-"
172.28.28.157 - - [15/Oct/2018:09:48:52 +0000] "GET / HTTP/1.1" 200 612 "-" "ELB-HealthChecker/1.0" "-"
172.28.5.73 - - [15/Oct/2018:10:03:31 +0000] "GET / HTTP/1.1" 200 612 "-" "ELB-HealthChecker/1.0" "-"
```

