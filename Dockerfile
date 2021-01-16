FROM ruby:2.7

# throw errors if Gemfile has been modified since Gemfile.lock
ENV BUNDLE_FROZEN=1

WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ip_whitelist_rack.gemspec ./
COPY lib/ip_whitelist_rack/version.rb lib/ip_whitelist_rack/version.rb

RUN bundle install

COPY . .

USER 1001

# this image expects the traefik dynamic configuration file to be in yaml format
# this file must be named dynamic_conf.yml
VOLUME /traefik
CMD ["bundle", "exec", "rackup", "ip_whitelist_rack.ru", "--host", "0.0.0.0"]
