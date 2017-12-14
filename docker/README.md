Dockerfile for run App::mojopaste

* install [docker](https://docs.docker.com/engine/installation/linux/ubuntulinux/)
* git clone [App::mojopaste](https://github.com/jhthorsen/app-mojopaste)
* cd app-mojopaste
* cp cp -R docker/* /some/path/dirforapp
* cd /some/path/dirforapp
* docker build --no-cache -t mojopaste_v1 .
* ./docker-run.sh
* or ./docker-run.sh -d
* http://localhost:5555
