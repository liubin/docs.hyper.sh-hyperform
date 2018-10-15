## hf config show

Show configs

<!-- usage -->

### Usage

```
Usage:
  hf config show [OPTIONS]

Flags:
      --cloud string   [Optional] The name of cloud type
  -h, --help           help for show

```
<!-- description and examples -->

### Description

Show cloud configuration summray infomation.

Fox example:

```
$ hf config show
cloud: aws
default: aws-tokyo
profiles:
- aws-tokyo
- default

```

This will show the cloud provider now using, and the profiles of the cloud provider.

Now supported cloud providers including:

* AWS


<!-- see also -->

### SEE ALSO

* [hf config](hf_config.md)	 - Manage cloud configs

