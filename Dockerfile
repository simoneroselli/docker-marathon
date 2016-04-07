# Marathon Docker image
#

FROM ubuntu:14.04

MAINTAINER Simone Roselli <simoneroselli78@gmail.com>

# Setup Mesosphere and Oracle Java repositories
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EEA14886 && \ 
    echo "deb http://repos.mesosphere.io/ubuntu trusty main" > /etc/apt/sources.list.d/mesosphere.list && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/oracle.list && \
    apt-get update

# Setup locale
RUN locale-gen en_US.UTF-8 && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales && \
    echo "LANG=en_US.UTF-8" > /etc/default/locale

# Accept the Oracle Java
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

# Install Java Oracle 8
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer

# Include Mesos master conf
COPY ./mesos /etc/mesos/

# Install Marathon
COPY ./marathon /etc/marathon/
RUN apt-get install -y marathon

# Marathon runs on :8080
EXPOSE 8080

ENTRYPOINT ["/usr/bin/marathon"]
