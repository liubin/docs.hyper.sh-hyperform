## hf config aws show

Show the aws profile config

<!-- usage -->

### Usage

```
Usage:
  hf config aws show [OPTIONS]

Flags:
  -h, --help             help for show
      --profile string   [Optional] The name of aws default profile

```
<!-- description and examples -->

### Examples

```
hf config aws show
cloud: aws
default: default
profiles:
  default:
    credentials:
      aws_access_key_id: xxx
      aws_secret_access_key: yyy/zzz/aaa
    keypair:
      private_key: ~/.ssh/id_rsa
      public_key: ~/.ssh/id_rsa.pub
    region: ap-northeast-1
    default_zone: ap-northeast-1b
    project: myproject
```

<!-- see also -->

### SEE ALSO

* [hf config aws](hf_config_aws.md)	 - Manage the aws profile config file

