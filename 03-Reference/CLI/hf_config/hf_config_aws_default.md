## hf config aws default

Set the aws default profile

<!-- usage -->

### Usage

```
Usage:
  hf config aws default [OPTIONS]

Flags:
  -h, --help             help for default
      --profile string   The name of aws default profile

```
<!-- description and examples -->

### Description

`hf config aws default` used to set the default AWS profile if
your have multiple AWS settings.

### Examples

```

$ hf config aws default --profile=aws-tokyo
INFO[0000] Set aws default profile to "aws-tokyo".

$ hf config aws show
cloud: aws
default: aws-tokyo
profiles:
  aws-tokyo:
    credentials:
      aws_access_key_id: xxx
      aws_secret_access_key: yyy/zzz/aaa
    keypair:
      private_key: ~/.ssh/id_rsa
      public_key: ~/.ssh/id_rsa.pub
    region: ap-northeast-1
    default_zone: ap-northeast-1b
    project: myproject
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

