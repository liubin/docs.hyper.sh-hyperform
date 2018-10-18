# Prerequisites

## 1. AWS account and credential

Currently, hyperform only supports AWS.

For hyperform to work correctly, your AWS IAM user should have these permissions:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:*Role*",
                "iam:*InstanceProfile*",
                "iam:*Certificate*",

                "ec2:*Instance*",
                "ec2:*Volume*",
                "ec2:*SecurityGroup*",
                "ec2:*Subnet*",
                "ec2:*DhcpOptions*",
                "ec2:*Route*",
                "ec2:*KeyPair*",
                "ec2:*InternetGateway*",
                "ec2:*Vpc*",
                "ec2:*NetworkAcl*",
                "ec2:*Dns*",
                "ec2:*Tag*",
                "ec2:*AvailabilityZone*",
                "ec2:*LaunchTemplate*",
                "ec2:*NetworkInterface*",

                "route53:*Tag*",
                "route53:*HostedZone*",
                "route53:*RecordSet*",

                "lambda:*Function*",
                "lambda:*Permission*",
                "lambda:*Policy*",

                "events:*",
                "logs:*LogStream*",
                "logs:*Tag*",
                "logs:*LogGroup*",
                "logs:*LogEvents*",

                "elasticloadbalancing:*",

                "autoscaling:*",

                "s3:Get*",
                "s3:*Tag*",
                "s3:*Bucket*",
                "s3:*Replication*",
                "s3:*AccelerateConfiguration*",

                "secretsmanager:Get*",
                "secretsmanager:*Secret*",
                "secretsmanager:TagResource",
                "secretsmanager:UntagResource"
            ],
            "Resource": "*"
        }
    ]
}
```



## 2. SSH keys

Secure Shell (as SSH) is a cryptographic protocol which allows users to communicate with network services over an unsecured network. SSH keys provide a more secure way than using a password. While a password can eventually be cracked with a brute force attack, SSH keys are nearly impossible to decipher by brute force alone.

If you don't have a SSH key ready, you can use `ssh-keygen` to generate one.

```
$ ssh-keygen -t rsa -b 4096
```

When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.

```
Enter a file in which to save the key (/Users/you/.ssh/id_rsa): [Press enter]
```

At the prompt, type a secure passphrase or press enter for no passphrase.

```
Enter passphrase (empty for no passphrase): [Type a passphrase]
Enter same passphrase again: [Type passphrase again]
```

## 3. Terraform installed

Please follow https://www.terraform.io/intro/getting-started/install.html

After you have installed terraform, you can verify your installation with this command.


```
$ terraform -v
Terraform v0.11.8

```

If you receive this output, congratulations, you have a terraform correctly installed.
