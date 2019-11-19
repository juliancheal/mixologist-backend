FROM arm32v6/ruby:2.6.5-alpine3.9

WORKDIR /application

RUN apk update \
    && apk add --virtual build-dependencies \
        build-base \
        gcc

COPY . /application

RUN bundle install

CMD ["ruby", "pump.rb"]
