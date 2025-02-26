FROM ruby:3.4.1-alpine3.21
WORKDIR /backend
RUN apk update && apk upgrade
RUN apk add bash bash-completion build-base curl git postgresql-client postgresql-dev tzdata

ENV RUBY_YJIT_ENABLE=1
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
