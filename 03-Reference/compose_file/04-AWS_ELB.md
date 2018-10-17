# AWS ELB configuration reference

If your application will provide service to public, you can use AWS ELB to loadbalance your services.

For example if you want to access your `wordpress` service by an ELB, you can use this configuration. Where `lb` will be parts of the full DNS name for the loadbalancer, and `wordpress` is the service that will be as the backend of this ELB.

```
aws_elb:
  lb:
    services:
      wordpress:
        cross_zone_load_balancing: true
        idle_timeout: 400
        connection_draining: true
        connection_draining_timeout: 500

        tags:
          Env: production
          Role: front
          App: wordpress

        access_logs:
          interval: "5"
          enabled: true

        health_check:
          healthy_threshold: 5
          unhealthy_threshold: 5
          timeout: 5
          target: HTTP:80/readme.html
          interval: 60

        listeners:
        - instance_port: 80
          instance_protocol: HTTP
          lb_port: 443
          lb_protocol: HTTPS
          ssl_certificate_body_file: ./cert/example.io.crt
          ssl_private_key_file: ./cert/example.io.key
        - instance_port: 80
          instance_protocol: HTTP
          lb_port: 80
          lb_protocol: HTTP
```

The following arguments are supported:


* `availability_zones` - (Required for an EC2-classic ELB) The AZ's to serve traffic in.

* `cross_zone_load_balancing` - (Optional) Enable cross-zone load balancing. Default: `false`

* `idle_timeout` - (Optional) The time in seconds that the connection is allowed to be idle. Default: `60`

* `connection_draining` - (Optional) Boolean to enable connection draining. Default: `false`

* `connection_draining_timeout` - (Optional) The time in seconds to allow for connections to drain. Default: `300`

* `tags` - (Optional) A mapping of tags to assign to the resource.

* `access_logs` - (Optional) An Access Logs block. Access Logs documented below.
    * `interval` - (Optional) The publishing interval in minutes. Default: 60 minutes.
    * `enabled` - (Optional) Boolean to enable / disable `access_logs`. Default is `true`

* `health_check` - (Optional) A health_check block. Health Check documented below.
    * `healthy_threshold` - (Required) The number of checks before the instance is declared healthy.
    * `unhealthy_threshold` - (Required) The number of checks before the instance is declared unhealthy.
    * `target` - (Required) The target of the check. Valid pattern is "${PROTOCOL}:${PORT}${PATH}", where PROTOCOL values are:
        * `HTTP`, `HTTPS` - PORT and PATH are required
        * `TCP`, `SSL` - PORT is required, PATH is not supported
    * `interval` - (Required) The interval between checks.
    * `timeout` - (Required) The length of time before the check times out.

* `listener` - (Required) A list of listener blocks. Listeners documented below.
    * `instance_port` - (Required) The port on the instance to route to
    * `instance_protocol` - (Required) The protocol to use to the instance. Valid
      values are `HTTP`, `HTTPS`, `TCP`, or `SSL`
    * `lb_port` - (Required) The port to listen on for the load balancer
    * `lb_protocol` - (Required) The protocol to listen on. Valid values are `HTTP`,
      `HTTPS`, `TCP`, or `SSL`
    * `ssl_certificate_body_file` - (Optional) Certificate file, only need when `lb_protocol` is either HTTPS or SSL**
    * `ssl_private_key_file` - (Optional) Certificate key file, only need when `lb_protocol` is either HTTPS or SSL**




