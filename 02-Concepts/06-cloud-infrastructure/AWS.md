# Infrastructure under the detail

<!-- toc -->

## Key Pairs

Key pirs is used to connect remote EC2 instances using SSH protocol.

```
aws ec2 describe-key-pairs
```

Will output:

```

---------------------------------------------------------------------------------
|                               DescribeKeyPairs                                |
+-------------------------------------------------------------------------------+
||                                  KeyPairs                                   ||
|+--------------------------------------------------+--------------------------+|
||                  KeyFingerprint                  |         KeyName          ||
|+--------------------------------------------------+--------------------------+|
||  7f:04:79:93:05:53:62:a9:e7:65:5a:88:a7:cd:f1:d3 |  HYPERFORM-KP-hfproject  ||
|+--------------------------------------------------+--------------------------+|
```

Before start deploy, you should use `hf init` to configurate your SSH key.

## EC2 Instances

In Hyperform, one EC2 instance is running for onlhy one container, which based a customed image with Docker pre-installed. This instance is customed for minimum overhead.

There too types of EC2 instances:

* Normal(or on demand) instances
* Spot instances

For more about spot instances, please see the [official document](https://aws.amazon.com/ec2/spot/).

You can set `replicas` for a servcie, and use `preemptible` to specific the number of spot instances, for the wordpress example, the service `wordpress` has a `replicas` to 2, and `preemptible` to 1, so there will be 1 normal instance and one spot instance.

Hyperform will not operate EC2 instances directly, alternatively Hyperform use auto scaling groups(ASG) to manage EC2 instances. 


```

aws ec2 describe-instances --region ap-northeast-1  --output table \
  --filters "Name=tag-key,Values=CreatedBy" "Name=tag-value,Values=hyperform.sh" \
  --query "Reservations[].Instances[].{InstanceId:InstanceId,InstanceType:InstanceType,PublicIpAddress:PublicIpAddress,Spot:InstanceLifecycle,AZ:Placement.AvailabilityZone,State:State.Name,Tags:Tags[?Key=='Name' || Key=='Project' || Key=='Stack' || Key=='Service']}" 

```

Will output:

```

--------------------------------------------------------------------------------------------------
|                                        DescribeInstances                                       |
+-----------------+----------------------+---------------+------------------+--------+-----------+
|       AZ        |     InstanceId       | InstanceType  | PublicIpAddress  | Spot   |   State   |
+-----------------+----------------------+---------------+------------------+--------+-----------+
|  ap-northeast-1c|  i-0270c30093a332b16 |  t2.micro     |  13.231.239.59   |  None  |  running  |
+-----------------+----------------------+---------------+------------------+--------+-----------+
||                                             Tags                                             ||
|+---------------+------------------------------------------------------------------------------+|
||      Key      |                                    Value                                     ||
|+---------------+------------------------------------------------------------------------------+|
||  Service      |  db                                                                          ||
||  Name         |  HYPERFORM-ASG_ON_DEMAND-hfproject-wordpress-db                              ||
||  Stack        |  wordpress                                                                   ||
||  Project      |  hfproject                                                                   ||
|+---------------+------------------------------------------------------------------------------+|
|                                        DescribeInstances                                       |
+-----------------+----------------------+---------------+------------------+--------+-----------+
|       AZ        |     InstanceId       | InstanceType  | PublicIpAddress  | Spot   |   State   |
+-----------------+----------------------+---------------+------------------+--------+-----------+
|  ap-northeast-1c|  i-0bc486ca2b1eb2bf9 |  t2.micro     |  54.250.62.118   |  None  |  running  |
+-----------------+----------------------+---------------+------------------+--------+-----------+
||                                             Tags                                             ||
|+--------------+-------------------------------------------------------------------------------+|
||      Key     |                                     Value                                     ||
|+--------------+-------------------------------------------------------------------------------+|
||  Stack       |  wordpress                                                                    ||
||  Name        |  HYPERFORM-ASG_ON_DEMAND-hfproject-wordpress-wordpress                        ||
||  Service     |  wordpress                                                                    ||
||  Project     |  hfproject                                                                    ||
|+--------------+-------------------------------------------------------------------------------+|
|                                        DescribeInstances                                       |
+-----------------+----------------------+---------------+------------------+--------+-----------+
|       AZ        |     InstanceId       | InstanceType  | PublicIpAddress  | Spot   |   State   |
+-----------------+----------------------+---------------+------------------+--------+-----------+
|  ap-northeast-1c|  i-02eca3186b81f0f8e |  t2.micro     |  13.114.193.165  |  spot  |  running  |
+-----------------+----------------------+---------------+------------------+--------+-----------+
||                                             Tags                                             ||
|+---------------+------------------------------------------------------------------------------+|
||      Key      |                                    Value                                     ||
|+---------------+------------------------------------------------------------------------------+|
||  Project      |  hfproject                                                                   ||
||  Name         |  HYPERFORM-ASG_SPOT-hfproject-wordpress-wordpress                            ||
||  Service      |  wordpress                                                                   ||
||  Stack        |  wordpress                                                                   ||
|+---------------+------------------------------------------------------------------------------+|
```

For the wordpress example in getting started, there will be 3 intances, 2 for `wordpress` service, and 1 for `db` service.

You can confirm if the instance is a spot instance by the `Spot` output.

## Volumes

EC2 instances's root device will have a size of 5GiB, so if you need a big size to save data, you should use a volume.

If Hyperform a Volume is a AWS EBS Volume.

```
aws ec2 describe-volumes --region ap-northeast-1 --output table \
  --filters "Name=tag-key,Values=CreatedBy" "Name=tag-value,Values=hyperform.sh" \
  --query "Volumes[].{CreateTime:CreateTime,Iops:Iops,Size:Size,State:State,VolumeId:VolumeId,VolumeType:VolumeType,AZ:AvailabilityZone,State:State,InstanceId:Attachments[0].InstanceId}"

```

Will output:

```

--------------------------------------------
|              DescribeVolumes             |
+-------------+----------------------------+
|  AZ         |  ap-northeast-1c           |
|  CreateTime |  2018-10-18T04:33:06.000Z  |
|  InstanceId |  i-0270c30093a332b16       |
|  Iops       |  100                       |
|  Size       |  10                        |
|  State      |  in-use                    |
|  VolumeId   |  vol-03519d56fbe6fc074     |
|  VolumeType |  io1                       |
+-------------+----------------------------+
```

Re-runging above command without the `--fitler` option and you will see 4 volumes including 3 root device for EC2 instances also.

```
aws ec2 describe-volumes --region ap-northeast-1 --output table \
  --query "Volumes[].{CreateTime:CreateTime,Iops:Iops,Size:Size,State:State,VolumeId:VolumeId,VolumeType:VolumeType,AZ:AvailabilityZone,State:State,InstanceId:Attachments[0].InstanceId}"
```

Will output:

```
-----------------------------------------------------------------------------------------------------------------------------------------
|                                                            DescribeVolumes                                                            |
+-----------------+---------------------------+----------------------+-------+-------+---------+-------------------------+--------------+
|       AZ        |        CreateTime         |     InstanceId       | Iops  | Size  |  State  |        VolumeId         | VolumeType   |
+-----------------+---------------------------+----------------------+-------+-------+---------+-------------------------+--------------+
|  ap-northeast-1c|  2018-10-18T04:33:06.000Z |  i-0270c30093a332b16 |  100  |  10   |  in-use |  vol-03519d56fbe6fc074  |  io1         |
|  ap-northeast-1c|  2018-10-18T04:33:38.088Z |  i-0270c30093a332b16 |  100  |  5    |  in-use |  vol-04ea06dc3ffa946e9  |  gp2         |
|  ap-northeast-1c|  2018-10-18T04:33:37.855Z |  i-0bc486ca2b1eb2bf9 |  100  |  5    |  in-use |  vol-040119b35b3771008  |  gp2         |
|  ap-northeast-1c|  2018-10-18T04:33:38.200Z |  i-02eca3186b81f0f8e |  100  |  5    |  in-use |  vol-0d2391c4f3bb5743c  |  gp2         |
+-----------------+---------------------------+----------------------+-------+-------+---------+-------------------------+--------------+

```

## Load Balancers

A service in Hyperform may have many replicas, and many EC instances. If the service provide external service by public address, use a loadbalancer provided by cloud provider will be very simple and convenience.

In the wordpress example, service `wordpress` will use an ELB and 2 instances as backend.

```

aws elb describe-load-balancers --region ap-northeast-1 --output table \
  --query "LoadBalancerDescriptions[].{DNSName:DNSName,Instances:Instances[].InstanceId,LoadBalancerName:LoadBalancerName,SourceSecurityGroup:SourceSecurityGroup.GroupName}"

```

Will output:

```

------------------------------------------------------------------------------------------------------------------------------------------
|                                                          DescribeLoadBalancers                                                         |
+---------------------------------------------------------------------+-------------------------+----------------------------------------+
|                               DNSName                               |    LoadBalancerName     |          SourceSecurityGroup           |
+---------------------------------------------------------------------+-------------------------+----------------------------------------+
|  hfproject-wordpress-lb-2146649239.ap-northeast-1.elb.amazonaws.com |  hfproject-wordpress-lb |  HYPERFORM-ELB_SG-hfproject_wordpress  |
+---------------------------------------------------------------------+-------------------------+----------------------------------------+
||                                                               Instances                                                              ||
|+--------------------------------------------------------------------------------------------------------------------------------------+|
||  i-02eca3186b81f0f8e                                                                                                                 ||
||  i-0bc486ca2b1eb2bf9                                                                                                                 ||
|+--------------------------------------------------------------------------------------------------------------------------------------+|
```

From the result we can confirm the DNS name `hfproject-wordpress-lb-2146649239.ap-northeast-1.elb.amazonaws.com`, 2 EC2 instanes, and the security group.

## Security Groups

Hyperform use cloud security groups for network access control fro service.

```
aws ec2 describe-security-groups --region ap-northeast-1 --output json \
  --filters "Name=tag-key,Values=CreatedBy" "Name=tag-value,Values=hyperform.sh" \
  --query "SecurityGroups[].{Description:Description,GroupName:GroupName,IpPermissions:IpPermissions[].{FromPort:FromPort,ToPort:ToPort,CidrIp:IpRanges[].CidrIp,GroupId:UserIdGroupPairs[].GroupId},Name:Tags[?Key=='Name'].Value}"
```

Will output:

```
[
    {
        "IpPermissions": [
            {
                "ToPort": 22, 
                "FromPort": 22, 
                "GroupId": [], 
                "CidrIp": [
                    "0.0.0.0/0"
                ]
            }
        ], 
        "GroupName": "default", 
        "Description": "default VPC security group", 
        "Name": [
            "HYPERFORM-GLOBAL_SG-hfproject"
        ]
    }, 
    {
        "IpPermissions": [
            {
                "ToPort": null, 
                "FromPort": null, 
                "GroupId": [
                    "sg-00a79e8e4d8ced089"
                ], 
                "CidrIp": []
            }, 
            {
                "ToPort": 3306, 
                "FromPort": 3306, 
                "GroupId": [
                    "sg-00a79e8e4d8ced089"
                ], 
                "CidrIp": []
            }
        ], 
        "GroupName": "HYPERFORM-SG-hfproject-wordpress-db", 
        "Description": "sg for hfproject-wordpress-db", 
        "Name": [
            "HYPERFORM-SG-hfproject-wordpress-db"
        ]
    }, 
    {
        "IpPermissions": [
            {
                "ToPort": 80, 
                "FromPort": 80, 
                "GroupId": [], 
                "CidrIp": [
                    "0.0.0.0/0"
                ]
            }, 
            {
                "ToPort": null, 
                "FromPort": null, 
                "GroupId": [
                    "sg-00a79e8e4d8ced089"
                ], 
                "CidrIp": []
            }
        ], 
        "GroupName": "HYPERFORM-SG-hfproject-wordpress-wordpress", 
        "Description": "sg for hfproject-wordpress-wordpress", 
        "Name": [
            "HYPERFORM-SG-hfproject-wordpress-wordpress"
        ]
    }, 
    {
        "IpPermissions": [
            {
                "ToPort": null, 
                "FromPort": null, 
                "GroupId": [], 
                "CidrIp": [
                    "0.0.0.0/0"
                ]
            }
        ], 
        "GroupName": "HYPERFORM-ELB_SG-hfproject_wordpress", 
        "Description": "sg for elb hfproject_wordpress", 
        "Name": [
            "HYPERFORM-ELB_SG-hfproject_wordpress"
        ]
    }
]

```

In wordpress example, we will get above security groups created.

Service `db` is an internal service, so port `3306` can only access from in the `sg-00a79e8e4d8ced089`.

In contrast servcie `wordpress` will expose it to public internet, so port `80` can access from anywhere(by `CidrIp` is set to `0.0.0.0`).

## Launch Templates

A launch template is used by asg to create instances. One user container will run in one EC2 instance.

```
aws ec2 describe-launch-templates \
  --region ap-northeast-1 --output table \
  --filters "Name=tag-key,Values=CreatedBy" "Name=tag-value,Values=hyperform.sh" \
  --query "LaunchTemplates[].{LaunchTemplateName:LaunchTemplateName,CreateTime:CreateTime,Tags:Tags}"

```

Will output:

```
--------------------------------------------------------------------------------------
|                               DescribeLaunchTemplates                              |
+---------------------------------+--------------------------------------------------+
|           CreateTime            |               LaunchTemplateName                 |
+---------------------------------+--------------------------------------------------+
|  2018-10-18T04:33:28.000Z       |  terraform-20181018043327712400000006            |
+---------------------------------+--------------------------------------------------+
||                                       Tags                                       ||
|+-------------+--------------------------------------------------------------------+|
||     Key     |                               Value                                ||
|+-------------+--------------------------------------------------------------------+|
||  Project    |  hfproject                                                         ||
||  Service    |  db                                                                ||
||  TfId       |  aws_launch_template.LAUNCH_TEMPLATE_ON_DEMAND                     ||
||  CreatedBy  |  hyperform.sh                                                      ||
||  Name       |  HYPERFORM-LAUNCH_TEMPLATE_ON_DEMAND-hfproject-wordpress-db        ||
||  Stack      |  wordpress                                                         ||
|+-------------+--------------------------------------------------------------------+|
|                               DescribeLaunchTemplates                              |
+---------------------------------+--------------------------------------------------+
|           CreateTime            |               LaunchTemplateName                 |
+---------------------------------+--------------------------------------------------+
|  2018-10-18T04:33:27.000Z       |  terraform-20181018043326115800000003            |
+---------------------------------+--------------------------------------------------+
||                                       Tags                                       ||
|+------------+---------------------------------------------------------------------+|
||     Key    |                                Value                                ||
|+------------+---------------------------------------------------------------------+|
||  Project   |  hfproject                                                          ||
||  Service   |  wordpress                                                          ||
||  TfId      |  aws_launch_template.LAUNCH_TEMPLATE_SPOT                           ||
||  CreatedBy |  hyperform.sh                                                       ||
||  Name      |  HYPERFORM-LAUNCH_TEMPLATE_SPOT-hfproject-wordpress-wordpress       ||
||  Stack     |  wordpress                                                          ||
|+------------+---------------------------------------------------------------------+|
|                               DescribeLaunchTemplates                              |
+---------------------------------+--------------------------------------------------+
|           CreateTime            |               LaunchTemplateName                 |
+---------------------------------+--------------------------------------------------+
|  2018-10-18T04:33:27.000Z       |  terraform-20181018043326115800000002            |
+---------------------------------+--------------------------------------------------+
||                                       Tags                                       ||
|+-----------+----------------------------------------------------------------------+|
||    Key    |                                Value                                 ||
|+-----------+----------------------------------------------------------------------+|
||  Project  |  hfproject                                                           ||
||  Service  |  wordpress                                                           ||
||  TfId     |  aws_launch_template.LAUNCH_TEMPLATE_ON_DEMAND                       ||
||  CreatedBy|  hyperform.sh                                                        ||
||  Name     |  HYPERFORM-LAUNCH_TEMPLATE_ON_DEMAND-hfproject-wordpress-wordpress   ||
||  Stack    |  wordpress                                                           ||
|+-----------+----------------------------------------------------------------------+|
|                               DescribeLaunchTemplates                              |
+---------------------------------+--------------------------------------------------+
|           CreateTime            |               LaunchTemplateName                 |
+---------------------------------+--------------------------------------------------+
|  2018-10-18T04:33:28.000Z       |  terraform-20181018043327713500000008            |
+---------------------------------+--------------------------------------------------+
||                                       Tags                                       ||
|+--------------+-------------------------------------------------------------------+|
||      Key     |                               Value                               ||
|+--------------+-------------------------------------------------------------------+|
||  Project     |  hfproject                                                        ||
||  Service     |  db                                                               ||
||  TfId        |  aws_launch_template.LAUNCH_TEMPLATE_SPOT                         ||
||  CreatedBy   |  hyperform.sh                                                     ||
||  Name        |  HYPERFORM-LAUNCH_TEMPLATE_SPOT-hfproject-wordpress-db            ||
||  Stack       |  wordpress                                                        ||
|+--------------+-------------------------------------------------------------------+|

```

## Spot Requests

If you set `preemptible` larger than zero, a spot ASG will then create a spot request internally to manage spot instances.

List all spot requests:

```
aws ec2 describe-spot-instance-requests \
  --region ap-northeast-1 --output table \
  --query "SpotInstanceRequests[].{Status:Status.Code,InstanceId:InstanceId,SpotInstanceRequestId:SpotInstanceRequestId,State:State,SpotPrice:SpotPrice}"

```

Output

```
--------------------------------------------------------------------------------------
|                            DescribeSpotInstanceRequests                            |
+----------------------+-------------------------+------------+---------+------------+
|      InstanceId      |  SpotInstanceRequestId  | SpotPrice  |  State  |  Status    |
+----------------------+-------------------------+------------+---------+------------+
|  i-02eca3186b81f0f8e |  sir-2regbj4h           |  0.015200  |  active |  fulfilled |
+----------------------+-------------------------+------------+---------+------------+
```


## Auto Scaling Groups

Hyperform will not operate EC2 instances directly, alternatively Hyperform use auto scaling groups(ASG) to manage EC2 instances. 

```
aws autoscaling describe-auto-scaling-groups \
  --region ap-northeast-1 --output json \
  --query "AutoScalingGroups[].{LaunchTemplateName:LaunchTemplate.LaunchTemplateName,AutoScalingGroupName:AutoScalingGroupName,MinSize:MinSize,MaxSize:MaxSize,Instances:Instances[].InstanceId}"
```

Will output:

```
[
    {
        "MinSize": 1, 
        "AutoScalingGroupName": "tf-asg-2018101804332943490000000a", 
        "MaxSize": 1, 
        "LaunchTemplateName": "terraform-20181018043326115800000002", 
        "Instances": [
            "i-0bc486ca2b1eb2bf9"
        ]
    }, 
    {
        "MinSize": 1, 
        "AutoScalingGroupName": "tf-asg-2018101804333073970000000b", 
        "MaxSize": 1, 
        "LaunchTemplateName": "terraform-20181018043326115800000003", 
        "Instances": [
            "i-02eca3186b81f0f8e"
        ]
    }, 
    {
        "MinSize": 0, 
        "AutoScalingGroupName": "tf-asg-2018101804333142500000000c", 
        "MaxSize": 0, 
        "LaunchTemplateName": "terraform-20181018043327713500000008", 
        "Instances": []
    }, 
    {
        "MinSize": 1, 
        "AutoScalingGroupName": "tf-asg-2018101804333143850000000d", 
        "MaxSize": 1, 
        "LaunchTemplateName": "terraform-20181018043327712400000006", 
        "Instances": [
            "i-0270c30093a332b16"
        ]
    }
]

```

For one service, Hyperform will create 2 ASG, one for normal(on demand) instances, and one for spot instances.

If your servcies have `preemptible` to be set to zero, the `MinSize` and `MaxSize` of that ASG will be set to `0`.

## S3 buckets

S3 buckets is used to save logs for ELB, if enabled in the compose file.

```
aws s3 ls /
```

Will output:

```
2018-10-18 12:33:11 hyperform-152533395541-ap-northeast-1-hfproject-wordpress
```

## R53

R53 is mainly used for service discovery.

List hosted zones.

```
aws route53 list-hosted-zones --output json
```

Will output:

```
{
    "HostedZones": [
        {
            "ResourceRecordSetCount": 4, 
            "CallerReference": "terraform-20181018041948253300000001", 
            "Config": {
                "Comment": "R53 Zone for project hfproject in region ap-northeast-1", 
                "PrivateZone": true
            }, 
            "Id": "/hostedzone/Z1JQ7K8G8Y91AC", 
            "Name": "hfproject.ap-northeast-1.internal."
        }
    ]
}

```

For one project, Hyperform will create one zone.

After stack is deployed, Hyperform will add some DNS record to R53.

List all DNS records.

```
aws route53 list-resource-record-sets --output table --hosted-zone-id Z1JQ7K8G8Y91AC
```

Will output:

```
-----------------------------------------------------------------------------------------
|                                ListResourceRecordSets                                 |
+---------------------------------------------------------------------------------------+
||                                 ResourceRecordSets                                  ||
|+---------------------------------------------------------+---------------+-----------+|
||                          Name                           |      TTL      |   Type    ||
|+---------------------------------------------------------+---------------+-----------+|
||  hfproject.ap-northeast-1.internal.                     |  172800       |  NS       ||
|+---------------------------------------------------------+---------------+-----------+|
|||                                  ResourceRecords                                  |||
||+-----------------------------------------------------------------------------------+||
|||                                       Value                                       |||
||+-----------------------------------------------------------------------------------+||
|||  ns-1536.awsdns-00.co.uk.                                                         |||
|||  ns-0.awsdns-00.com.                                                              |||
|||  ns-1024.awsdns-00.org.                                                           |||
|||  ns-512.awsdns-00.net.                                                            |||
||+-----------------------------------------------------------------------------------+||
||                                 ResourceRecordSets                                  ||
|+------------------------------------------------------------+----------+-------------+|
||                            Name                            |   TTL    |    Type     ||
|+------------------------------------------------------------+----------+-------------+|
||  hfproject.ap-northeast-1.internal.                        |  900     |  SOA        ||
|+------------------------------------------------------------+----------+-------------+|
|||                                  ResourceRecords                                  |||
||+-----------------------------------------------------------------------------------+||
|||                                       Value                                       |||
||+-----------------------------------------------------------------------------------+||
|||  ns-1536.awsdns-00.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400  |||
||+-----------------------------------------------------------------------------------+||
||                                 ResourceRecordSets                                  ||
|+-----------------------------------------------------------------+--------+----------+|
||                              Name                               |  TTL   |  Type    ||
|+-----------------------------------------------------------------+--------+----------+|
||  db.wordpress.hfproject.ap-northeast-1.internal.                |  300   |  A       ||
|+-----------------------------------------------------------------+--------+----------+|
|||                                  ResourceRecords                                  |||
||+-----------------------------------------------------------------------------------+||
|||                                       Value                                       |||
||+-----------------------------------------------------------------------------------+||
|||  172.28.6.93                                                                      |||
||+-----------------------------------------------------------------------------------+||
||                                 ResourceRecordSets                                  ||
|+-------------------------------------------------------------------+-------+---------+|
||                               Name                                |  TTL  |  Type   ||
|+-------------------------------------------------------------------+-------+---------+|
||  wordpress.wordpress.hfproject.ap-northeast-1.internal.           |  300  |  A      ||
|+-------------------------------------------------------------------+-------+---------+|
|||                                  ResourceRecords                                  |||
||+-----------------------------------------------------------------------------------+||
|||                                       Value                                       |||
||+-----------------------------------------------------------------------------------+||
|||  172.28.1.188                                                                     |||
|||  172.28.6.67                                                                      |||
||+-----------------------------------------------------------------------------------+||

```

We can see that `db.wordpress.hfproject.ap-northeast-1.internal.` is point to `172.28.6.93` and host in the same DNS domain(instances in one project or stack is in the same domain) can use `db` to access the service.

If you want to access servcie in other stack, you should use `service-name.other-stack`.

## Lambda && Events

Lambda function mainly used to update DNS redords when services(EC instances) re-created.

### Event rules

DNS update will be triggered directly be Event, you can view the event rule for details.

List event rules:

```
aws events list-rules --output json \
  --query "Rules[].{Name:Name,EventPattern:EventPattern}"
```

Will output:

```
[
    {
        "EventPattern": "{\"detail\":{\"state\":[\"running\",\"terminated\"]},\"detail-type\":[\"EC2 Instance State-change Notification\"],\"source\":[\"aws.ec2\"]}", 
        "Name": "HYPERFORM-CLW_EVT_RULE-hfproject"
    }
]

```

### Lambda function



```
aws lambda list-functions --output table \
  --query "Functions[].{FunctionName:FunctionName,MemorySize:MemorySize,Runtime:Runtime,Variables:Environment.Variables}"
```

Will output:

```

---------------------------------------------------------------------------------------------
|                                       ListFunctions                                       |
+------------------------------------------------+---------------------+--------------------+
|                  FunctionName                  |     MemorySize      |      Runtime       |
+------------------------------------------------+---------------------+--------------------+
|  update_r53_record-hfproject                   |  128                |  python2.7         |
+------------------------------------------------+---------------------+--------------------+
||                                        Variables                                        ||
|+----------------+-------------------------------------+---------------+------------------+|
||   dns_zone_id  |            dns_zone_name            | project_name  |   region_name    ||
|+----------------+-------------------------------------+---------------+------------------+|
||  Z1JQ7K8G8Y91AC|  hfproject.ap-northeast-1.internal  |  hfproject    |  ap-northeast-1  ||
|+----------------+-------------------------------------+---------------+------------------+|

```

FunctionName is `update_r53_record-hfproject`, and the execution logs will be send to AWS cloudwatch Logs(`/aws/lambda/update_r53_record-hfproject`).

### Function execution log

```
aws logs describe-log-groups \
  --query "logGroups[].{logGroupName:logGroupName}"
```

Will output:

```
---------------------------------------------
|             DescribeLogGroups             |
+-------------------------------------------+
|               logGroupName                |
+-------------------------------------------+
|  /aws/lambda/update_r53_record-hfproject  |
+-------------------------------------------+
```

Lambda function executions will save by log streams.

Get log streams for `/aws/lambda/update_r53_record-hfproject`:

```
aws logs describe-log-streams --log-group-name /aws/lambda/update_r53_record-hfproject  --query "logStreams[].{creationTime:creationTime,logStreamName:logStreamName,firstEventTimestamp:firstEventTimestamp,lastEventTimestamp:lastEventTimestamp,lastIngestionTime:lastIngestionTime}"
```

Will output:

```
---------------------------------------------------------------------------------------------------------------------------------------------
|                                                            DescribeLogStreams                                                             |
+---------------+----------------------+---------------------+--------------------+---------------------------------------------------------+
| creationTime  | firstEventTimestamp  | lastEventTimestamp  | lastIngestionTime  |                      logStreamName                      |
+---------------+----------------------+---------------------+--------------------+---------------------------------------------------------+
|  1539863788027|  1539863788109       |  1539863793347      |  1539863803174     |  2018/10/18/[$LATEST]2a3fefc0d9ce4b6c8ac2034485971df5   |
|  1539863787703|  1539863788051       |  1539863810675      |  1539863823183     |  2018/10/18/[$LATEST]93af6e7f9160467188795f4120d5a0f5   |
|  1539837237394|  1539837237731       |  1539837242991      |  1539837252840     |  2018/10/18/[$LATEST]b53de8ae823b43babd941e9b2e5bff17   |
|  1539837239787|  1539837240027       |  1539837247888      |  1539837255127     |  2018/10/18/[$LATEST]ee63309608f246bb868550dd789b2892   |
|  1539837238751|  1539837239000       |  1539837244170      |  1539837254068     |  2018/10/18/[$LATEST]f51acc0893da4d60842a84428b7522ff   |
+---------------+----------------------+---------------------+--------------------+---------------------------------------------------------
```

Get all logs for one function execution:

```
aws logs get-log-events \
  --log-group-name /aws/lambda/update_r53_record-hfproject \
  --log-stream-name '2018/10/18/[$LATEST]2a3fefc0d9ce4b6c8ac2034485971df5'
```

And you will see the events(logs) saved in this log stream.

## IAM roles and policies

Hyperform create two roles/policies for EC2 instances and Lambda.

Roles/policies for EC2 let EC2 instances to attach volume, fetch secrets, and modify it's tags.

Roles/policies for Lambda mainly used to let Lambda function to update DNS records in R53 and save logs to cloudwatch.

### Roles

List roles created by Hyperform:

```
aws iam list-roles --output table \
  --query "Roles[?starts_with(RoleName,'HYPERFORM')][].{Service:AssumeRolePolicyDocument.Statement[0].Principal.Service,RoleName:RoleName}"
```

Will output:

```
------------------------------------------------------------------------------------------
|                                        ListRoles                                       |
+---------------------------------------------------------------+------------------------+
|                           RoleName                            |        Service         |
+---------------------------------------------------------------+------------------------+
|  HYPERFORM-IAM_ROLE_FOR_EC2_INSTANCE-ap-northeast-1-hfproject |  ec2.amazonaws.com     |
|  HYPERFORM-IAM_ROLE_FOR_LAMBDA-ap-northeast-1-hfproject       |  lambda.amazonaws.com  |
+---------------------------------------------------------------+------------------------+
```

### Policies

Policies for ec2 instances:

```
aws iam list-role-policies \
  --role-name HYPERFORM-IAM_ROLE_FOR_EC2_INSTANCE-ap-northeast-1-hfproject
```

Will output:

```
----------------------------------------------------------------------
|                          ListRolePolicies                          |
+--------------------------------------------------------------------+
||                            PolicyNames                           ||
|+------------------------------------------------------------------+|
||  HYPERFORM-IAM_POLICY_FOR_EC2_INSTANCE-ap-northeast-1-hfproject  ||
|+------------------------------------------------------------------+|
```

Policies details for ec2 instances:

```
aws iam get-role-policy \
  --role-name HYPERFORM-IAM_ROLE_FOR_EC2_INSTANCE-ap-northeast-1-hfproject \
  --policy-name HYPERFORM-IAM_POLICY_FOR_EC2_INSTANCE-ap-northeast-1-hfproject 
```

Will output:

```
------------------------------------------------------------------------------------------------------------------------------------
|                                                           GetRolePolicy                                                          |
+-----------------------------------------------------------------+----------------------------------------------------------------+
|                           PolicyName                            |                           RoleName                             |
+-----------------------------------------------------------------+----------------------------------------------------------------+
|  HYPERFORM-IAM_POLICY_FOR_EC2_INSTANCE-ap-northeast-1-hfproject |  HYPERFORM-IAM_ROLE_FOR_EC2_INSTANCE-ap-northeast-1-hfproject  |
+-----------------------------------------------------------------+----------------------------------------------------------------+
||                                                         PolicyDocument                                                         ||
|+-------------------------------------------------------+------------------------------------------------------------------------+|
||  Version                                              |  2012-10-17                                                            ||
|+-------------------------------------------------------+------------------------------------------------------------------------+|
|||                                                           Statement                                                          |||
||+--------------------------------------------------------+---------------------------------------------------------------------+||
|||                         Effect                         |                              Resource                               |||
||+--------------------------------------------------------+---------------------------------------------------------------------+||
|||  Allow                                                 |  *                                                                  |||
||+--------------------------------------------------------+---------------------------------------------------------------------+||
||||                                                           Action                                                           ||||
|||+----------------------------------------------------------------------------------------------------------------------------+|||
||||  ec2:DescribeTags                                                                                                          ||||
||||  ec2:CreateTags                                                                                                            ||||
||||  ec2:DeleteTags                                                                                                            ||||
||||  ec2:DescribeVolumes                                                                                                       ||||
||||  ec2:AttachVolume                                                                                                          ||||
||||  ec2:DetachVolume                                                                                                          ||||
||||  secretsmanager:Describe*                                                                                                  ||||
||||  secretsmanager:Get*                                                                                                       ||||
||||  secretsmanager:List*                                                                                                      ||||
|||+----------------------------------------------------------------------------------------------------------------------------+|||
```

Policies for lambda:

```
aws iam list-role-policies \
  --role-name  HYPERFORM-IAM_ROLE_FOR_LAMBDA-ap-northeast-1-hfproject
```

Will output:

```
----------------------------------------------------------------
|                       ListRolePolicies                       |
+--------------------------------------------------------------+
||                         PolicyNames                        ||
|+------------------------------------------------------------+|
||  HYPERFORM-IAM_POLICY_FOR_LAMBDA-ap-northeast-1-hfproject  ||
|+------------------------------------------------------------+|
```

Policies details for lambda:

```
aws iam get-role-policy \
  --role-name HYPERFORM-IAM_ROLE_FOR_LAMBDA-ap-northeast-1-hfproject \
  --policy-name HYPERFORM-IAM_POLICY_FOR_LAMBDA-ap-northeast-1-hfproject
```

Will output:

```
------------------------------------------------------------------------------------------------------------------------
|                                                     GetRolePolicy                                                    |
+-----------------------------------------------------------+----------------------------------------------------------+
|                        PolicyName                         |                        RoleName                          |
+-----------------------------------------------------------+----------------------------------------------------------+
|  HYPERFORM-IAM_POLICY_FOR_LAMBDA-ap-northeast-1-hfproject |  HYPERFORM-IAM_ROLE_FOR_LAMBDA-ap-northeast-1-hfproject  |
+-----------------------------------------------------------+----------------------------------------------------------+
||                                                   PolicyDocument                                                   ||
|+--------------------------------------------------+-----------------------------------------------------------------+|
||  Version                                         |  2012-10-17                                                     ||
|+--------------------------------------------------+-----------------------------------------------------------------+|
|||                                                     Statement                                                    |||
||+---------------------------------------------------+--------------------------------------------------------------+||
|||                      Effect                       |                          Resource                            |||
||+---------------------------------------------------+--------------------------------------------------------------+||
|||  Allow                                            |  [u'*']                                                      |||
||+---------------------------------------------------+--------------------------------------------------------------+||
||||                                                     Action                                                     ||||
|||+----------------------------------------------------------------------------------------------------------------+|||
||||  ec2:DescribeInstances                                                                                         ||||
||||  ec2:CreateNetworkInterface                                                                                    ||||
||||  ec2:AttachNetworkInterface                                                                                    ||||
||||  ec2:DescribeNetworkInterfaces                                                                                 ||||
||||  ec2:DeleteNetworkInterface                                                                                    ||||
|||+----------------------------------------------------------------------------------------------------------------+|||
||||                                                    Resource                                                    ||||
|||+----------------------------------------------------------------------------------------------------------------+|||
||||  *                                                                                                             ||||
|||+----------------------------------------------------------------------------------------------------------------+|||
|||                                                     Statement                                                    |||
||+---------------------------------------------------+--------------------------------------------------------------+||
|||                      Effect                       |                          Resource                            |||
||+---------------------------------------------------+--------------------------------------------------------------+||
|||  Allow                                            |  *                                                           |||
||+---------------------------------------------------+--------------------------------------------------------------+||
||||                                                     Action                                                     ||||
|||+----------------------------------------------------------------------------------------------------------------+|||
||||  logs:CreateLogGroup                                                                                           ||||
||||  logs:CreateLogStream                                                                                          ||||
||||  logs:PutLogEvents                                                                                             ||||
|||+----------------------------------------------------------------------------------------------------------------+|||
||||                                                    Resource                                                    ||||
|||+----------------------------------------------------------------------------------------------------------------+|||
|||                                                     Statement                                                    |||
||+---------------------------------------------------+--------------------------------------------------------------+||
|||                      Effect                       |                          Resource                            |||
||+---------------------------------------------------+--------------------------------------------------------------+||
|||  Allow                                            |  *                                                           |||
||+---------------------------------------------------+--------------------------------------------------------------+||
||||                                                     Action                                                     ||||
|||+----------------------------------------------------------------------------------------------------------------+|||
||||  route53:Get*                                                                                                  ||||
||||  route53:List*                                                                                                 ||||
||||  route53:TestDNSAnswer                                                                                         ||||
||||  route53:ChangeResourceRecordSets                                                                              ||||
|||+----------------------------------------------------------------------------------------------------------------+|||
||||                                                    Resource                                                    ||||
|||+----------------------------------------------------------------------------------------------------------------+|||


```

## VPC and subnets

VPC is used for isolation and access control.

### VPC

List VPC:

```
aws ec2 describe-vpcs --region ap-northeast-1  --output table \
  --filters "Name=tag-key,Values=CreatedBy" "Name=tag-value,Values=hyperform.sh" \
  --query "Vpcs[].{VpcId:VpcId,DhcpOptionsId:DhcpOptionsId,CidrBlock:CidrBlock,IsDefault:IsDefault,Tags:Tags}"
```

Will output:

```

-----------------------------------------------------------------------------------
|                                  DescribeVpcs                                   |
+---------------+--------------------------+------------+-------------------------+
|   CidrBlock   |      DhcpOptionsId       | IsDefault  |          VpcId          |
+---------------+--------------------------+------------+-------------------------+
|  172.28.0.0/16|  dopt-0e7867d2b38a4c533  |  False     |  vpc-04f44ca12d28dc7cd  |
+---------------+--------------------------+------------+-------------------------+
||                                     Tags                                      ||
|+------------------------+------------------------------------------------------+|
||           Key          |                        Value                         ||
|+------------------------+------------------------------------------------------+|
||  Name                  |  HYPERFORM-VPC-hfproject                             ||
||  CreatedBy             |  hyperform.sh                                        ||
||  Project               |  hfproject                                           ||
|+------------------------+------------------------------------------------------+|

```

In AWS console, you can review the route table, DHCP options, Network ACL and more details about this VPC.

### Subnet

List subnets:

```
aws ec2 describe-subnets --region ap-northeast-1  --output table \
  --filters "Name=tag-key,Values=CreatedBy" "Name=tag-value,Values=hyperform.sh" \
  --query "Subnets[].{VpcId:VpcId,AvailabilityZone:AvailabilityZone,CidrBlock:CidrBlock,State:State,SubnetId:SubnetId}"
```

Will output:

```
----------------------------------------------------------------------------------------------------------
|                                             DescribeSubnets                                            |
+------------------+-----------------+------------+----------------------------+-------------------------+
| AvailabilityZone |    CidrBlock    |   State    |         SubnetId           |          VpcId          |
+------------------+-----------------+------------+----------------------------+-------------------------+
|  ap-northeast-1d |  172.28.16.0/20 |  available |  subnet-09cd7daa70848913b  |  vpc-04f44ca12d28dc7cd  |
|  ap-northeast-1c |  172.28.0.0/20  |  available |  subnet-05247ef8151caab6f  |  vpc-04f44ca12d28dc7cd  |
+------------------+-----------------+------------+----------------------------+-------------------------+
```

## Secrets

Secrets like secrets in Swarm or k8s, used to store sensitive information.

List secrets created for services:

```
aws secretsmanager list-secrets --output table \
  --query "SecretList[].{Name:Name,Description:Description,LastChangedDate:LastChangedDate}"

```

Will output:

```
----------------------------------------------------------------------------
|                                ListSecrets                               |
+-------------+-------------------+----------------------------------------+
| Description |  LastChangedDate  |                 Name                   |
+-------------+-------------------+----------------------------------------+
|  None       |  1539837194.55    |  HYPERFORM-SECRET-hfproject_wordpress  |
+-------------+-------------------+----------------------------------------+
```

Secrets is stored in AWS and used Hyperform in EC2 instances.
