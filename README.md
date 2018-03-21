# Drupal Compose
Docker Birthday #5 Celebration - La Paz Edition

## Requisitos
* Instalar [Terraform](https://www.terraform.io/)
* [Docker](https://www.docker.com) 17.05 o superior
* [Ansible](https://www.ansible.com/)

## Generando llaves


```bash
$ ssh-key -t rsa -b 2048 -C "nucleognulinux.org"
```

## Desplegando las instancias


```bash
$ terraform plan -out nucleognulinux.org
$ terraform apply nucleognulinux.org
```


## Desplegando Docker usando Ansible

```bash
$ ansible-playbook -i hosts nucleognulinux.yml -e 'ansible_python_interpreter=/usr/bin/python3'
```

## NGINX http Reverse Proxy

```bash
$ docker network create --driver bridge reverse-proxy
$ docker run -d -p 80:80 -p 443:443     --name nginx-proxy     --net reverse-proxy     -v $HOME/certs:/etc/nginx/certs:ro     -v /etc/nginx/vhost.d     -v /usr/share/nginx/html     -v /var/run/docker.sock:/tmp/docker.sock:ro     --label com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy=true     jwilder/nginx-proxy

$ docker run -d --name nginx-letsencrypt --net reverse-proxy --volumes-from nginx-proxy -v $HOME/certs:/etc/nginx/certs:rw -v /var/run/docker.sock:/var/run/docker.sock:ro jrcs/letsencrypt-nginx-proxy-companion

```

## Let's Encrypt 

```bash
$ ansible-playbook -i hosts nucleognulinux.yml -e 'ansible_python_interpreter=/usr/bin/python3'
```

## Drupal 8 - PostgreSQL

```bash
$ docker-compose up -d

$ docker run --name nginx-redirect-www -e SERVER_REDIRECT=www.nucleognulinux.org -e 'LETSENCRYPT_EMAIL=alexandro@autistici.org' -e 'LETSENCRYPT_HOST=nucleognulinux.org' -e 'LETSENCRYPT_HOST=nucleognulinux.org' -d schmunk42/nginx-redirect
```



## Docker Compose UI

```bash
$ docker run --name docker-compose-ui -v $(pwd):$(pwd) -w $(dirname $(pwd)) -p 5000:5000 -v /var/run/docker.sock  francescou/docker-compose-ui:1.11.0