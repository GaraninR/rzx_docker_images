rzx_base is base image for work.
It constaints SSH server for quick run and start to work (for install SQL Servers, Java Application Server, Web-applications and other).

DockerHub link: https://hub.docker.com/r/garaninr/rzx_base/

Build image:
$ docker build --rm -f rzx_base.dockerfile -t garaninr/rzx_base:0.1 .

...or pull image
$ docker pull garaninr/rzx_base:0.1

Run image:
$ docker run -d -p 10022:22 --rm --name rzx_base garanin/rzx_base:0.1

Connect into container from any ssh client:
$ ssh root@127.0.0.1 -p 10022

Default username: root
Default password: 123456
(same for mysql)

! Change it please !

MySQL Access after run: http://127.0.0.1:8801