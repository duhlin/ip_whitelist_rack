FROM ruby:2.7

# throw errors if Gemfile has been modified since Gemfile.lock
ENV BUNDLE_FROZEN=1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ip_whitelist_rack.gemspec ./
COPY lib/ip_whitelist_rack/version.rb lib/ip_whitelist_rack/version.rb
RUN bundle install

COPY . .

CMD ["bundle", "exec", "rackup", "ip_whitelist_rack.ru"]
