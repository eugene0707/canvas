FROM ruby:2.4.0-alpine

RUN apk update && apk --update add libstdc++ tzdata postgresql-dev \
    libxml2-dev libxslt-dev openssl-dev libc-dev libc6-compat libgcrypt-dev \
    linux-headers nodejs imagemagick curl ca-certificates git

RUN apk --update add --virtual build-dependencies build-base

RUN apk --update add inotify-tools mc htop

RUN apk update && apk add --no-cache fontconfig font-misc-cyrillic ttf-freefont && \
  mkdir -p /usr/share && \
  cd /usr/share \
  && curl -L https://github.com/Overbryd/docker-phantomjs-alpine/releases/download/2.11/phantomjs-alpine-x86_64.tar.bz2 | tar xj \
  && ln -s /usr/share/phantomjs/phantomjs /usr/bin/phantomjs \
  && phantomjs --version

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle \
  TERM=xterm \
  PAGER='busybox less'

RUN bundle config build.nokogiri --use-system-libraries && npm install bower -g

ADD . $APP_HOME
RUN chmod +x $APP_HOME/wait_for
