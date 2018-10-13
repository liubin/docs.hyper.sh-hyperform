# Prerequisites

## 1. AWS account and credential

For now hyperform only supports AWS. 

Permissions needed:
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
                "secretsmanager:*Secret*"

            ],
            "Resource": "*"
        }
    ]
}
```



## 2. SSH key-pair


## 3. Terraform installed
Please follow https://www.terraform.io/intro/getting-started/install.html

To verify: run `terraform -v`
