FROM circleci/ruby:2.3.5-node-browsers

ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
ENV M2_HOME /usr/local/apache-maven/apache-maven-3.1.1
ENV M2 /usr/local/apache-maven/apache-maven-3.1.1/bin

RUN sudo apt-get update \
    && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
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
         unzip \
    && sudo apt-get install -y mysql-client --no-install-recommends \
    && sudo apt-get install -y \
         libmysqld-dev \
         fonts-ipafont-gothic \
         software-properties-common \
         openjdk-7-jdk \
    && wget http://www.us.apache.org/dist/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.zip \
    && sudo mkdir -p /usr/local/apache-maven \
    && sudo unzip apache-maven-3.1.1-bin.zip -d /usr/local/apache-maven/ \
    && rm -rf /tmp/apache-maven-3.1.1-bin.zip \
    && wget http://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.54.zip \
    && sudo mkdir -p /usr/local/google/appengine-java-sdk \
    && sudo unzip appengine-java-sdk-1.9.54.zip -d /usr/local/google/appengine-java-sdks/ \
    && rm -rf appengine-java-sdk-1.9.54.zip \
    && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
         qt5-default \
         libqt5webkit5-dev \
         gstreamer1.0-plugins-base \
         gstreamer1.0-tools \
         gstreamer1.0-x\
    && sudo sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list \
    && sudo apt-get install -y tzdata tzdata-java \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo sh -c "echo Asia/Tokyo > /etc/timezone" \
    && sudo rm /etc/localtime \
    && sudo ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && sudo dpkg-reconfigure -f noninteractive tzdata \
    && sudo apt-get update && sudo apt-get install task-japanese \
    && sudo sh -c "echo ja_JP.UTF-8 UTF-8 > /etc/locale.gen" \
    && sudo locale-gen \
    && sudo update-locale LANG=ja_JP.UTF-8 \
    && curl -L git.io/nodebrew | perl - setup \
    && export PATH=$HOME/.nodebrew/current/bin:$PATH \
    && echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> $HOME/.bashrc \
    && nodebrew install-binary 0.10.31 \
    && nodebrew use 0.10.31 \
    && npm install -g phantomjs@2.1.1 --unsafe-perm

ENV PATH $M2:/usr/local/google/appengine-java-sdks/appengine-java-sdk-1.9.54/bin:$HOME/.nodebrew/current/bin:$PATH
