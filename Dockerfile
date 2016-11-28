FROM debian:jessie-backports 

RUN \
  apt-get update && \
  apt-get install -y \
    libxt-dev zip pkg-config libX11-dev libxext-dev \
    libxrender-dev libxtst-dev libasound2-dev libcups2-dev libfreetype6-dev \
    mercurial ca-certificates-java build-essential wget openjdk-8-jdk && \ 
  rm -rf /var/lib/apt/lists/*

RUN \
  cd /tmp && \
  hg clone http://hg.openjdk.java.net/jdk9/jdk9 openjdk9 && \ 
  cd openjdk9 && \
  hg up jdk-9+146 && \
  sh ./get_source.sh 

RUN \
  cd /tmp/openjdk9 && \
  bash ./configure --with-cacerts-file=/etc/ssl/certs/java/cacerts --with-boot-jdk=/usr/lib/jvm/java-8-openjdk-amd64/

RUN \  
  cd /tmp/openjdk9 && \
  make clean images

RUN \  
  cd /tmp/openjdk9 && \
  cp -a build/linux-x86_64-normal-server-release/images/jdk \
    /opt/openjdk9 

RUN \  
  cd /tmp/openjdk9 && \
  find /opt/openjdk9 -type f -exec chmod a+r {} + && \
  find /opt/openjdk9 -type d -exec chmod a+rx {} +

ENV PATH /opt/openjdk9/bin:$PATH
ENV JAVA_HOME /opt/openjdk9 
