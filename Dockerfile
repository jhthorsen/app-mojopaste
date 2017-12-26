# Install [docker](https://docs.docker.com/engine/installation/linux/ubuntulinux/)
# git clone [App::mojopaste](https://github.com/jhthorsen/app-mojopaste)
# cd app-mojopaste
# docker build --no-cache -t mojopaste .
# mkdir /some/dir/fordata
# docker run -d --restart always --name mojopaste -v /some/dir/fordata:/app/data -p 5555:8080 mojopaste
# http://localhost:5555

FROM ubuntu:16.04
MAINTAINER sklukin <sklukin@yandex.ru>

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
RUN update-locale
RUN mkdir /app
RUN mkdir /app/data
WORKDIR /app
RUN apt-get update \
  && apt-get install -y build-essential libpam0g-dev apt-utils cpanminus \
  && apt-get autoremove -y \
  && rm -r /var/cache/apt/archives/* \
  && rm -r /var/lib/apt/*
RUN cpanm Text::CSV App::mojopaste

ENV PASTE_DIR /app/data
ENV PASTE_ENABLE_CHARTS 1

ENTRYPOINT ["mojopaste", "prefork", "-l", "http://*:8080"]

