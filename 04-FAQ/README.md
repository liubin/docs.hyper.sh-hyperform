# FAQ

<!-- toc -->

## Why service with `deploy.public` set to false has a public IP address

Hyperform use ssh to communicate with remote Docker daemon through the public IP address of cloud instances.

The `deploy.public` in service spec will controll the security group that a container's port should be exposed to public.

For example service `db` of stack `wordpress` in getting started section that has not set `deploy.public`, therefor the port of `3306` will not accessable from outside of cloud vpc's subnet.

## What can I do when deploy failed?

You can try again with `--refresh` or `--reset` options.

## What permissions are needed in AWS?

To let Hyperform work correctly, your AWS IAM user should have these permissions:

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
