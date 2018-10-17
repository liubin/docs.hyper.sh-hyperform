# FAQ

<!-- toc -->

## Why service with `deploy.public` set to false has a public IP address

Hyperform use ssh to communicate with remote Docker daemon through the public IP address of cloud instances.

The `deploy.public` in service spec will controll the security group that a container's port should be exposed to public.

For example service `db` of stack `wordpress` in getting started section that has not set `deploy.public`, therefor the port of `3306` will not accessable from outside of cloud vpc's subnet.

