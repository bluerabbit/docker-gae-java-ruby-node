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

# git
RUN apt-get update && apt-get install -y git

# RUN gem install --no-document bundler

# Install MySQL Client
RUN apt-get install -y mysql-client --no-install-recommends && apt-get install -y libmysqld-dev

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

# nodebrew + nodejs
ENV HOME /root
WORKDIR /root
ENV NODE_VERSION 0.10.31
RUN curl -L git.io/nodebrew | perl - setup
ENV PATH $HOME/.nodebrew/current/bin:$PATH
RUN echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> $HOME/.bashrc
RUN nodebrew install-binary $NODE_VERSION
RUN nodebrew use $NODE_VERSION

# --unsafe-perm
# https://github.com/Medium/phantomjs/issues/707#issuecomment-326380366
RUN npm install -g phantomjs@2.1.1 --unsafe-perm

# golang
RUN apt-get install -y golang
ENV GOPATH $HOME/.go
ENV PATH  $GOPATH/bin:$PATH

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
qt5-default \
libqt5webkit5-dev \
gstreamer1.0-plugins-base \
gstreamer1.0-tools \
gstreamer1.0-x

# set timezone
RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
ENV TZ Asia/Tokyo
RUN apt-get update \
  && apt-get install -y tzdata \
  && rm -rf /var/lib/apt/lists/* \
  && echo "${TZ}" > /etc/timezone \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

# lang
RUN apt-get update && apt-get install -y language-pack-ja
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8 LC_ALL=ja_JP.UTF-8

RUN apt-get install -y vim
