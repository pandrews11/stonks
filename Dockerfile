FROM ruby:3.2.3-slim-bookworm AS assets

WORKDIR /app

ARG UID=1000
ARG GID=1000

RUN bash -c "set -o pipefail && apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl git libpq-dev \
  && curl -sL https://deb.nodesource.com/setup_21.x | bash - \
  && apt-get update && apt-get install -y --no-install-recommends nodejs \
  && corepack enable \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && groupadd -g \"${GID}\" ruby \
  && useradd --create-home --no-log-init -u \"${UID}\" -g \"${GID}\" ruby \
  && mkdir /node_modules && chown ruby:ruby -R /node_modules /app"

USER ruby

COPY --chown=ruby:ruby Gemfile* ./
RUN gem install bundler -v 2.5.5 && \
    bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install -j4 && \
    rm -rf /app/vendor/bundle/ruby/*/cache/* /app/vendor/bundle/ruby/*/gems/*/ext && \
    rm -rf /home/ruby/.bundle/cache

COPY --chown=ruby:ruby package.json *yarn* ./
RUN yarn set version 4.1.0 && yarn install

ARG RAILS_ENV="production"
ARG NODE_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}" \
    NODE_ENV="${NODE_ENV}" \
    PATH="${PATH}:/home/ruby/.local/bin:/node_modules/.bin" \
    USER="ruby"

COPY --chown=ruby:ruby . .

RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

CMD ["bash"]

##############################

FROM ruby:3.2.3-slim-bookworm AS app

WORKDIR /app

ARG UID=1000
ARG GID=1000

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && groupadd -g "${GID}" ruby \
  && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" ruby \
  && chown ruby:ruby -R /app

USER ruby

COPY --chown=ruby:ruby ./bin ./bin
RUN chmod 0755 bin/*

ARG RAILS_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}" \
    PATH="${PATH}:/home/ruby/.local/bin" \
    USER="ruby"

# $BUNDLE_APP_CONFIG set to '/usr/local/bundle' in base image.
COPY --chown=ruby:ruby --from=assets /usr/local/bundle /usr/local/bundle
COPY --chown=ruby:ruby --from=assets /app/vendor /app/vendor
COPY --chown=ruby:ruby --from=assets /app/public /app/public
COPY --chown=ruby:ruby . .

ENTRYPOINT ["/app/bin/docker-entrypoint"]
EXPOSE 3000

CMD ["bundle", "exec", "rails", "server"]
