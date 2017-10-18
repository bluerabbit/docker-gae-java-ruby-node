FROM ubuntu:16.04

ENV RUBY_MAJOR="2.3" \
    RUBY_VERSION="2.3.1" \
    RUBY_PACKAGES="ruby2.3 ruby2.3-dev"

# Ruby & Rails libs
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential \
      curl \
      wget \
      libffi-dev \
      libgdbm-dev \
      libncurses-dev \
      libreadline6-dev \
      libssl-dev \
      libyaml-dev \
      zlib1g-dev \
      unzip

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

# install openjdk-7
# add-apt-repositoryコマンドが必要であるためsoftware-properties-commonをインストールする
RUN apt-get install -y software-properties-common &&\
    add-apt-repository ppa:openjdk-r/ppa -y &&\
    apt-get update &&\
    apt-get install -y openjdk-7-jdk

#Install maven
ENV MVN_VERSION 3.1.1
RUN \
   wget http://www.us.apache.org/dist/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.zip -P /tmp/ &&\
   mkdir -p /usr/local/apache-maven &&\
   unzip /tmp/apache-maven-${MVN_VERSION}-bin.zip -d /usr/local/apache-maven/ &&\
   rm -rf /tmp/apache-maven-${MVN_VERSION}-bin.zip

ENV M2_HOME /usr/local/apache-maven/apache-maven-${MVN_VERSION}
ENV M2 $M2_HOME/bin

#Install appengine java sdk
ENV GAE_SDK_VERSION 1.9.54
RUN \
   wget http://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-${GAE_SDK_VERSION}.zip -P /tmp/ &&\
   mkdir -p /usr/local/google/appengine-java-sdk &&\
   unzip /tmp/appengine-java-sdk-${GAE_SDK_VERSION}.zip -d /usr/local/google/appengine-java-sdks/ &&\
   rm -rf /tmp/appengine-java-sdk-${GAE_SDK_VERSION}.zip

ENV PATH ${M2}:/usr/local/google/appengine-java-sdks/appengine-java-sdk-${GAE_SDK_VERSION}/bin:${PATH}
