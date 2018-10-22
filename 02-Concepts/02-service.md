# Service

In Hyperform, a service consists of multiple containers, and the container will run in the VM.

For AWS, a container will run in a EC2 instance.  Hyperform supports two types of EC2 instances:
- On-Demand Instance
- [Spot Instance](https://aws.amazon.com/ec2/spot)

The Spot Instance can help you to reduce costs, but AWS can stop your Spot Instance anytime. So Hyperform use ASG for each service. When a instance is stopped, a new instance will be created by ASG.

Hyperform will create two AWS [ASG](https://aws.amazon.com/autoscaling/)s for each service.  One is for running on-demand instance and the other is for running spot instance.  

You can control the instance number of a service.  
Here is a service sample in compose yaml:
```yaml
services:
  web:
    image: nginx
    ports:
      - 8000:80
    deploy:
      replicas: 2
      preemptible: 1
```

>  **replicas** is the total number of instances: on-demand instances + spot instances  
> **preemptible** is the count of the spot instance, it can be 0.  
>  **preemptible** should be less than or equal to the **replicas**


## Service Discovery

In order for services to be accessible to each other, service discovery and load balancing are required.

For AWS, Hyperform use `Route 53`, `CloudWatch Events` and `Lambda` as the [solution](https://aws.amazon.com/blogs/compute/building-a-dynamic-dns-for-route-53-using-cloudwatch-events-and-lambda/).


### Related cloud resources

Each project has the following AWS Resources:
- `Route 53 Hosted zones` with the name `<project-name>.<region-name>.internal`
- `CloudWatch`
   - `Event Rule`:  for "EC2 Instance State-change Notification" (watch "running" and "terminated" only)
   - `Event Target`:  associate CloudWatch Rule and Lambda Function
   - `Log Group`: store logs for lambda function
- `Lambda Function` with the name `update_r53_record-<project-name>`


### Lambda Function

`update_r53_record` function will be triggered when an instance state changes:

If the Instance-state is "running":
 - Describe current Instance to get privateIp and Tags(contains service-name and stack-name)
 - Get DNS Record Set for  `<service-name>.<stack-name>.<project-name>.internal`
 - Append privateIp to current DNS Record Set

If the instance-state is "terminated"  
 - Describe current Instance to get privateIp and Tags(contains service-name and stack-name)
 - Get DNS Record Set for  `<service-name>.<stack-name>.<project-name>.internal`
 - Describe all running instances in this service, get all privateIps
    - If there are running instances
       - Update these privateIps to the current DNS Record Set
    - otherwise
       - Delete current DNS Record Set


### DNS resolution in container

Hyperform setup DNS Resolution with "/etc/resolv.conf" in container. The contents will be like this:
```
 # cat /etc/resolv.conf
search <stack-name>.<project-name>.<region-name>.internal  <project-name>.<region-name>.internal
nameserver 172.28.0.2
```


### Example

For example, project-name is `prj-demo`, stack-name is `st-wordpress`, region is `us-east-1`.

Here are two services sample in compose yaml:
```yaml
services:
   db:
     image: mysql:5.7
     ports:
       - 3306:3306
     environment:
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: password

   wordpress:
     image: wordpress:latest
     deploy:
       replicas: 2
       preemptible: 1
     ports:
       - 80:80
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: password
```

After the stack was deployed, three EC2 Instance will be launched.
One `db` instance(eg: privateIp is `172.28.3.90`), two `wordpress` instance(eg: privateIp is `172.28.80.10` and `172.28.10.3` ), the DNS Record Set will be
- db.st-wordpress.prj-demo.us-east-1.internal
   - Value: 172.28.3.90
- wordpress.st-wordpress.prj-demo.us-east-1.internal
   - Value: 172.28.80.10, 172.28.10.3

So the wordpress container can connect to the mysql in db container via `db:3306`
