## hf service open

Open service in browser

<!-- usage -->

### Usage

```
Usage:
  hf service open [OPTIONS] SERVICE

Flags:
  -h, --help           help for open
  -p, --port int       Which port to access (default -1)
  -s, --stack string   Stack which services belongs to

```
<!-- description and examples -->

### Description

Open web service in browser if the service is using a HTTP loadbalancer.

### Examples

There is a service that using a loadbalancer and listen on port `80` and `443`.
```
$ hf service ls

STACK               NAME                REPLICAS/SPOT       IMAGE               DNSNAME                                                          PORTS
myweb               nginx               1/0                 nginx:alpine        myproject-myweb-lb-1339050635.ap-northeast-1.elb.amazonaws.com   80,443
nginx-basic         nginx               1/0                 nginx:alpine

$ hf service open nginx --stack myweb --port 80
Will open `http://myproject-myweb-lb-1339050635.ap-northeast-1.elb.amazonaws.com:80` in browser
```

You can then check the web page in brower that newly opened.

<!-- see also -->

### SEE ALSO

* [hf service](hf_service.md)	 - Manage services

