# syntax = docker/dockerfile:1

FROM ruby:3.2.3

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libvips \
    pkg-config \
    nodejs \
    postgresql-client \
    libpq-dev

RUN mkdir /stonks
WORKDIR /stonks

RUN gem install bundler

COPY Gemfile* ./
RUN bundle install --jobs 20 --retry 5

# Install app
COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["./bin/rails", "server", "--port", "3000", "--binding", "0.0.0.0"]
