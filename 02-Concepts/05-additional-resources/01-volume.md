# Volumes

On-disk files in a container are ephemeral, when the container recreated, the data will lost, this is not suitable for some cases that need data to be persistent.

Docker has a concept of
[volumes](https://docs.docker.com/engine/admin/volumes/), though it is
somewhat looser and less managed.  In Docker, a volume is simply a directory on
disk or in another container. Docker now provides volume
drivers and management sub-commands.

A Hypferform volume, on the other hand, is a cloud volume that managed by cloud provider.

**Note:**

Hyperform volume's limitation:

* No volume management sub-commands.
* Volume has the same lifecycle as stack, and will be deleted when deleting the stack.
* No backup/restore functions, user must do it by cloud tools(`aws` cli or management console)

## Supported volumes

Now Hypferform support these cloud Volumes:

- [AWS EBS Volumes](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumes.html)

## Define volumes

In compose file, volumes are defined as `volumes` object.

```
volumes:
  mysql-data:
    provider: aws
    size: 10
    zone: ${ZONE}
    options:
      iops: 100
      type: io1
    tags:
      App: wordpress
```

Volume definition is composed by two parts:

- common properties
- options properties

### Common properties of volume

Common properties are cloud independent, including `size` and `zone`.

You must set the `provider` to specific which cloud you are using. Now `aws` is the only supported cloud provider.

### Options properties of volume

Options are cloud provider dependent properties, for different cloud, these properties may be changed.

## Use volumes in services

Volumes will be mounted into cloud instances and then container running in the instance, and defined in services' spec:

```

services:
   db:
     image: mysql:5.7
     volumes:
       - mysql-data:/var/lib/mysql
```

**Note:**


## See also

- [Wordpress example](../../01-GettingStarted/03-first-project/03-deploy-stack-wordpress.md)
- [Compose file reference](../../03-Reference/compose_file/02-volume.md)
