# HAProxy Server

## Create a Password for Authentication

Source: https://httpd.apache.org/docs/2.4/misc/password_encryptions.html.

**Make sure** to use a leading space so that the command is not stored in your bash history!

     openssl passwd -crypt -salt rq myPassword

## Add a Certificate Chain

Copy the `pixerapp.com.pem` certificate chain generated from https://github.com/pixerapp/letsencrypt and save it to the location indicated in `config/haproxy.cfg`.

    bind "${FLOATING_IP}":443 ssl crt /etc/ssl/pixerapp.com/pixerapp.com.pem

Since this HAProxy is running as a Docker container, this file should be stored on a host and be linked via a Docker volume as shown below.

The configuration file can also be stored on the host and mapped via a volume. A default configuration file is available within the Docker image.

## Usage

A Docker Compose example:

```
  haproxy:
    image: pixerapp/haproxy:1.2.1-haproxy-1.7.2
    environment:
     - DNS_TCP_ADDR=127.0.0.1
     - DNS_TCP_PORT=53
     - FLOATING_IP=*
    networks:
     - es
    ports:
     - 80:80
     - 443:443
    volumes:
     - /etc/ssl/pixerapp.com/:/etc/ssl/pixerapp.com
     - /root/haproxy/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg
```

## Build a Docker image

    docker build -t="pixerapp/haproxy:1.2.2-haproxy-1.7.2" .

## Reload HAProxy

Source: http://blog.haproxy.com/2015/10/14/whats-new-in-haproxy-1-6/

Before reloading HAProxy, we save the server states using the following command:

    socat /tmp/socket - <<< "show servers state" > /tmp/ha_server_state

Then reload HAProxy as usual.

    haproxy -f /usr/local/etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)
