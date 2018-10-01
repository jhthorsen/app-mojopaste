# Install docker https://docs.docker.com/engine/installation/linux/ubuntulinux/
# git clone https://github.com/jhthorsen/app-mojopaste
# cd app-mojopaste
# docker build --no-cache -t mojopaste .
# mkdir /some/dir/fordata
# docker run -d --restart always --name mojopaste -v /some/dir/fordata:/app/data -p 5555:8080 mojopaste
# http://localhost:5555

FROM alpine:3.5
MAINTAINER jhthorsen@cpan.org

RUN mkdir -p /app/data
RUN apk add -U perl perl-io-socket-ssl \
  && apk add -t builddeps build-base curl perl-dev wget \
  && curl -L https://github.com/jhthorsen/app-mojopaste/archive/master.tar.gz | tar xvz \
  && curl -L https://cpanmin.us | perl - App::cpanminus \
  && cpanm -M https://cpan.metacpan.org Text::CSV \
  && cpanm -M https://cpan.metacpan.org --installdeps ./app-mojopaste-master \
  && apk del builddeps curl \
  && rm -rf /root/.cpanm /var/cache/apk/*

ENV MOJO_MODE production
ENV PASTE_DIR /app/data
ENV PASTE_ENABLE_CHARTS 1
EXPOSE 8080

ENTRYPOINT ["/usr/bin/perl", "/app-mojopaste-master/script/mojopaste", "prefork", "-l", "http://*:8080"]
