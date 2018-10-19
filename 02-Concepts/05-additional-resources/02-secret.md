# Secrets

Secrets are intended to hold sensitive information, such as
passwords, OAuth tokens, and ssh keys.  Putting this information in a `secret`
is safer and more flexible than putting it in a `service` definition or in
a Docker image, putting it in a Secret object allows for
more control over how it is used, and reduces the risk of accidental exposure.

Hyperform support two kinds of secret

- `docker_registry` secret
- `normal` secret

If you want to use a private docker image, you can use a secret with `type` option setting to `docker_registry`.

## Define Secrets

In compose file, secrets are defined as `secrets` object.

```
secrets:
  dockerregistry1:
    type: docker_registry
    registry: index.docker.io
    username: $DOCKERHUB_USERNAME
    email: $DOCKERHUB_EMAIL
    password: $DOCKERHUB_PASSWORD
  dockerregistry2:
    type: docker_registry
    registry: myregistry.com
    username: abc
    email: abc@abc.com
    password: abc123
  normal_secret:
    file: ./wp_db_password.txt
```

If `type` option is unset, the secret will be a norml secret based on file.

If the secret is a normal secret, you need only use a `file` to refere to files that contains the secret content.

### Docker registry secrets

Secrets for Docker registry(public or private), you need provide below information.

* `type` of secret must to be `docker_registry`
* `registry` address
* `username` and `password` to access the registry
* and an `email` address if needed

### Normal secrets

Normal secrets are files that contain any content.

```
$ echo 'pass1234' > wp_db_password.txt
```

## Use secrets in services

Secrets will be mounted into cloud instances and then container running in the instance, and defined in services' spec:

```
services:
   db:
     image: mysql:5.7
     secrets:
       - wp_db_password
       - mysql_root_password
```

In this example, service `db` will use two secrets, and they will be mount as file to:

- /run/secrets/wp_db_password
- /run/secrets/mysql_root_password

**Note:**

Docker registry secret will not be mounted to `/run/secrets`.

## See also

- [Wordpress example](../../01-GettingStarted/03-first-project/03-deploy-stack-wordpress.md)
- [Compose file reference](../../03-Reference/compose_file/03-secret.md)
