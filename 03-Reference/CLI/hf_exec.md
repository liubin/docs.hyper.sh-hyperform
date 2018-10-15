## hf exec

Run a command in a running container

<!-- usage -->

### Usage

```
Usage:
  hf exec [OPTIONS] CONTAINER COMMAND [ARG...]

Flags:
  -d, --detach               Detached mode: run command in the background
      --detach-keys string   Override the key sequence for detaching a container
  -e, --env list             Set environment variables
  -h, --help                 help for exec
  -i, --interactive          Keep STDIN open even if not attached
      --privileged           Give extended privileges to the command
  -t, --tty                  Allocate a pseudo-TTY
  -u, --user string          Username or UID (format: <name|uid>[:<group|gid>])
  -w, --workdir string       Working directory inside the container

```
<!-- description and examples -->


### Description

The `hf exec` command runs a new command in a running container.

The command started using `hf exec` only runs while the container's primary
process (`PID 1`) is running, and it is not restarted if the container is
restarted.

COMMAND will run in the default directory of the container. If the
underlying image has a custom directory specified with the WORKDIR directive
in its Dockerfile, this will be used instead.

COMMAND should be an executable, a chained or a quoted command
will not work. Example: `hf exec -ti my_container "echo a && echo b"` will
not work, but `hf exec -ti my_container sh -c "echo a && echo b"` will.

### Examples

#### Run `hf exec` on a running container

Execute a command on the container.

```bash
$ hf exec -d c4bfba59427e touch /tmp/execWorks
$ hf exec c4bfba59427e ls -l /tmp/
total 0
-rw-r--r--    1 root     root             0 Oct 15 10:07 execWorks
```

This will create a new file `/tmp/execWorks` inside the running container
`c4bfba59427e`, in the background.

Next, execute an interactive `sh` shell on the container.

```bash
$ hf exec -it c4bfba59427e sh
```

This will create a new Bash session in the container `c4bfba59427e`.

Next, set an environment variable in the current sh session.

```bash
$ hf exec -it -e VAR=1 c4bfba59427e sh
/ # echo $VAR
1
/ #
```

This will create a new Bash session in the container `c4bfba59427e` with environment
variable `$VAR` set to "1". Note that this environment variable will only be valid 
on the current Bash session.

By default `hf exec` command runs in the same working directory set when container was created.

```bash
$ hf exec -it c4bfba59427e pwd
/
```

You can select working directory for the command to execute into

```bash
$ hf exec -it -w /root c4bfba59427e pwd
/root
```


