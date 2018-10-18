# Volume Configuration Reference

Manages Cloud volumes(or cloud disks).

**For now only AWS EBS Volume is supported.**

```
volumes:
  data:
    provider: aws
    size: 10
    zone: $ZONE
    options:
      iops: 100
      snapshot_id: ""
      type: io1
    tags:
      Usage: data
```

The following arguments are supported:

* `provider` - Now you can use only `aws`.
* `size` - (Optional) The size of the drive in GiBs.
* `fs_type` - (Optional) The file system that will used in this volume, default is `ext4`.
* `zone` - (Optional) The zone of this volume, must be the same as your service that using this volme in AWS.
* `tags` - (Optional) A mapping of tags to assign to the resource.
* `options` - Options is cloud provider independent
  * `iops` - (Optional) The amount of IOPS to provision for the disk.
  * `snapshot_id` (Optional) A snapshot to base the volume off of.
  * `type` - (Optional) The type of EBS volume. For aws it can be "standard", "gp2", "io1", "sc1" or "st1" (Default: "standard").
  * `encrypted` - (Optional) If true, the disk will be encrypted. For AWS only.
  * `kms_key_id` - (Optional) The ARN for the KMS encryption key. When specifying `kms_key_id`, `encrypted` needs to be set to true. For AWS only.

~> **NOTE**: Only one of `size` or `snapshot_id` is required when specifying an EBS volume 

~> **NOTE**: When changing the `size`, `iops` or `type` of an instance, there are [considerations](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/considerations.html) to be aware of that Amazon have written about this.
