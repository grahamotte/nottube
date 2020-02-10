FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# common system deps
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y apt-transport-https
RUN apt-get install -y build-essential
RUN apt-get install -y ca-certificates
RUN apt-get install -y curl
RUN apt-get install -y dirmngr
RUN apt-get install -y gcc
RUN apt-get install -y git
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libpq-dev
RUN apt-get install -y libreadline-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y lsb-release
RUN apt-get install -y make
RUN apt-get install -y openssl
RUN apt-get install -y postgresql
RUN apt-get install -y postgresql-contrib
RUN apt-get install -y youtube-dl
RUN apt-get install -y zlib1g-dev

# ruby 2.6.3
WORKDIR /tmp
RUN curl http://ftp.ruby-lang.org/pub/ruby/2.6/ruby-2.6.3.tar.gz --output ruby-2.6.3.tar.gz
RUN tar -xzvf ruby-2.6.3.tar.gz
WORKDIR /tmp/ruby-2.6.3
RUN ./configure
RUN make
RUN make install
WORKDIR /tmp
RUN rm -r ruby-*

# node 12
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -E
RUN apt-get install -y nodejs

# bundle top
COPY .ruby-version /opt/.ruby-version
RUN true
COPY Gemfile* /opt/
WORKDIR /opt
RUN bundle

# bundle api
COPY api/.ruby-version /opt/api/.ruby-version
RUN true
COPY api/Gemfile* /opt/api/
WORKDIR /opt/api
RUN bundle

# pull client modules
COPY client/package* /opt/client/
WORKDIR /opt/client
RUN npm install

# app files
COPY Procfile /opt/Procfile
COPY api /opt/api
RUN true
COPY client /opt/client
RUN true
