FROM ubuntu:16.04

ENV RUBY_MAJOR="2.3" \
    RUBY_VERSION="2.3.1" \
    RUBY_PACKAGES="ruby2.3 ruby2.3-dev"

# Ruby & Rails libs
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential \
      curl \
      libffi-dev \
      libgdbm-dev \
      libncurses-dev \
      libreadline6-dev \
      libssl-dev \
      libyaml-dev \
      zlib1g-dev

# Install ruby
RUN echo 'gem: --no-document' >> /.gemrc
RUN mkdir -p /tmp/ruby \
  && curl -L "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
      | tar -xjC /tmp/ruby --strip-components=1 \
  && cd /tmp/ruby \
  && ./configure --disable-install-doc \
  && make \
  && make install \
  && gem update --system \
  && rm -r /tmp/ruby

RUN gem install --no-document bundler

RUN apt-get install -y fonts-ipafont-gothic
