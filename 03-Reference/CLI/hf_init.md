## hf init

Create cloud resources for project

<!-- usage -->

### Usage

```
Usage:
  hf init

Examples:
/tmp/md-docs-generator init --cloud=aws --access-key=$AWS_ACCESS_KEY_ID --secret-key=$AWS_SECRET_ACCESS_KEY --private-key=~/.ssh/demo --public-key=~/.ssh/demo.pub --region=eu-central-1

Flags:
      --access-key string    The AWS access key to use
      --cloud string         The Cloud type, support 'aws' now (default "aws")
      --deploy               create the global cloud resources for the project
  -h, --help                 help for init
      --private-key string   The local path of the private key
      --profile string       [Optional] The name of the profile (default "default")
      --project string       [Optional] The name of the project
      --public-key string    The local path of the public key
      --refresh              refresh the cloud resources first
      --region string        [Optional] The AWS region to use (default "us-east-1")
      --reset                re-create the terraform state file
      --secret-key string    The AWS secret key to use

```
<!-- description and examples -->

### Description

`hf init` must be run before running any stack and will create all needed cloud resource.

You can use `--reset` or `--refresh` options if there have some troubles that leading fails.





<!-- independent examples -->

### Examples

```
/tmp/md-docs-generator init --cloud=aws --access-key=$AWS_ACCESS_KEY_ID --secret-key=$AWS_SECRET_ACCESS_KEY --private-key=~/.ssh/demo --public-key=~/.ssh/demo.pub --region=eu-central-1
```

