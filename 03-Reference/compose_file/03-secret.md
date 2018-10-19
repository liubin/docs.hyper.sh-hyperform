# Secret Configuration Reference

Now hyperform support two kinds of secret: `docker_registry` and `normal` secret.

If you want to use a private docker image, you can use a secret with `type` option setting to `docker_registry`.

If `type` option is unset, the secret will be a norml secret based on file.

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

If the secret is a normal secret, you need only use a `file` to refere to files that contains the secret content.

Secrets for Docker registry(public or private), you need provide below information.

* `type` of secret must to be `docker_registry`
* `registry` address
* `username` and `password` to access the registry
* and an `email` address if needed
