## hf config aws set

Manage the aws profile config file

<!-- usage -->

### Usage

```
Usage:
  hf config aws set [OPTIONS]

Flags:
      --access-key string     The AWS access key to use
      --default-zone string   [Optional] The AWS availabilityZone to use (default "us-east-1a")
  -h, --help                  help for set
      --private-key string    The local path of the private key
      --profile string        [Optional] The name of the profile (default "default")
      --project string        [Optional] The name of the project
      --public-key string     The local path of the public key
      --region string         [Optional] The AWS region to use (default "us-east-1")
      --secret-key string     The AWS secret key to use

```
<!-- description and examples -->

### Description

`hf config aws set` is used for setting account configuration for AWS cloud.

### Examples


```
$ hf config aws set \
    --access-key=$YOUR_AWS_ACCESS_KEY \
    --secret-key=$YOUR_AWS_SECRET_KEY \
    --private-key=~/.ssh/id_rsa \
    --public-key=~/.ssh/id_rsa.pub \
    --region=ap-northeast-1b
    --default-zone=ap-northeast-1
    --project=myproject
    --profile=aws-tokyo
```


<!-- see also -->

### SEE ALSO

* [hf config aws](hf_config_aws.md)	 - Manage the aws profile config file

